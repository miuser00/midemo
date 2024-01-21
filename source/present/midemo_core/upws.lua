--------------------------------------------------------------------------------------------------------------------------------------- 
--版权声明：本demo集源于上海合宙官方技术团队的DEMO（MIT），并参考了合宙开源社区的众多大佬无私分享的代码，包括但不限于 稀饭放姜、Wendal、晨旭、陈夏等
-- 目前参考到的开源项目有： iRTU（MIT)、LuatOS(MIT)、LLCOM
-- 欲获取更多luat 代码请访问 doc.openluat.com
-- 如果您觉得本demo集包含了未经由您授权的代码，请联系 64034373@qq.com，如有侵权嫌疑将立即纠正
---------------------------------------------------------------------------------------------------------------------------------------
--- 模块功能：upws服务器适配
-- @author miuser
-- @module midemo.upws
-- @license MIT
-- @copyright miuser@luat
-- @release 2020-09-14
--------------------------------------------------------------------------
HELP=[[upws模块]]
HELP=[[作用:负责和upws服务器进行通讯]]
HELP=[[upws服务器采用内置的服务器，默认地址为box.miuser.net UDP: 7101，也可以在midemo.bs中修改]]
HELP=[[该模块使用iRTU固件的通道1进行通讯，心跳包间隔为10S]]
HELP=[[心跳包是一个JSON格式的字符串，包含了模块当前的运行状态]]
HELP=[[发送网络消息采用 NET_CMD_MONI消息、例如：sys.publish("NET_CMD_MONI",str) str是网络上行的字符串消息]]
HELP=[[接收网络消息采用 NET_CMD_MINO消息、通过：sys.subscribe("NET_CMD_MINO", function(str) ... end) 可以收到服务器下行的字符串消息]]
--------------------------------------------------------------------------
require "net"
require "misc"
require "common"
module(...,package.seeall)

P13Level=0
sendPool={}

local modulename=...
--注册到全局状态表
table.insert(status.INSTALLED,modulename)
--通过消息发送调试信息到串口和网络
function pub(s)
    s="["..(modulename).."]"..s
    sys.publish("CON",s.."\r\n")
    sys.publish("NET_CMD_MONI",s.."\r\n")
end

--查找输入的参数是否存在映射替换
function PIN_MAP(boardpin)
    if (midemo.MAP~=nil and midemo.MAP[boardpin]~=nil) then 
         return midemo.MAP[boardpin]
    else
         return boardpin
    end
 end
 
 function Trim_CMD(cmd)
     for i=1,#cmd do
         if (cmd:sub(#cmd,#cmd)=="\n") or (cmd:sub(#cmd,#cmd)=="\r") then 
             cmd=string.sub(cmd,1,#cmd-1) 
             --log.info("bs","TrimedCMD is "..cmd.." Len is "..#cmd)
         end
     end
     return cmd
 end

 
--回报状态信息
function ReportStatus()
    rssi=net.getRssi()
    tm = misc.getClock()
    ret=
    {
        --核心板IMEI
        ID=status.IMEI,
        --核心板SN
        SN=status.SN,
        --核心板ID
        ID=status.ID,
        --核心板MM
        MM=status.MM,
        --网络状态
        NETSTATUS=create.getDatalink(),
        --基站定位成功
        isLocated=status.isLocated,   
        --经度
        LONGITUDE=status.LONGITUDE,
        --维度
        LATITUDE=status.LATITUDE,      
        --设备端时间戳
        TIME=tm,
        --信号强度
        RSSI=rssi,
        --P13
        P13=P13Level    
    }
    dat=json.encode(ret)
    sys.publish("NET_HEART_MONI",dat)
end

--服务器连接成功后定时发送心跳数据包
sys.taskInit(function()
    while (NETSTATUS==false) do 
        sys.wait(1000)
    end
    while true do      
        ReportStatus()  
        --每10S发送一次心跳
        sys.wait(10000)
    end
end)

function GPIOChange(pin,level)
    log.info("upws","GPIOChange",pin,level)
    if pin==13 then P13Level=level end
end
sys.subscribe("GPIO_LEVEL_CHANGE",GPIOChange)


--接受网络数据包进行处理
sys.subscribe("NET_RECV_WAIT_1",function(uid,msg)
    local echo=0
    log.info("upws","socket received:"..msg)
    msg=common.gb2312ToUtf8(msg)
    --消除服务器抄送的发送数据
    table.foreach(sendPool,function(i,v) 
        if echo==1 then return end
        if v==msg then
            log.info("upws","cancelling message:"..v) 
            log.info("upws","left message count:"..#sendPool)
            table.remove(sendPool,i)
            echo=1
        end 
    end)
    --服务器会将收到的报文进行抄送回报给UDP发送端，此处进行处理滤除掉
    --设置最多50个缓冲，超出则保留最后的50个消息
    log.info("upws","sendPool len:"..#sendPool)
    todelete=#sendPool-50
    for i=1,todelete do
        table.remove(sendPool,i)
    end
    if (echo==1) then return end
    local str=msg:sub(40,-3)
    log.info("upws","received:"..str) 
    --透传
    if (msg:sub(7,7)=="C") then 
        sys.publish("NET_RAW_MINO",str)
        log.info("upws","Received in RAW "..str)
    --心跳包
    elseif (msg:sub(7,7)=="B") then 
        sys.publish("NET_BEAT_MINO",str) 
        log.info("upws","Received in BEAT "..str)
    --命令
    elseif (msg:sub(7,7)=="A") then 
        sys.publish("NET_CMD_MINO",str)
        log.info("upws","Received in CMD "..str)
         -- 串口的数据读完后清空缓冲区
        local splitlist = {}
        string.gsub(str, '[^,]+', function(w) table.insert(splitlist, w) end)
        local count=table.getn(splitlist)
        --sys.publish("UARTIN",str)
        for i=2,#splitlist do 
            splitlist[i]=Trim_CMD(splitlist[i])
        end
        splitlist[1]=Trim_CMD(splitlist[1]) 
        sys.publish(unpack(splitlist))
        sendQueue = {}
    else       
        return
    end

end)

sys.subscribe("NET_RAW_MONI", function(str)
    totallen=41+str:len()
    local ret=string.format("%04d",totallen).."01".."C".."01"..""..status.ID..""..""..status.MM.."".."1234"..str.."05"
    sys.publish("NET_SENT",ret)
    table.insert(sendPool,ret)
    log.info("upws","NET_RAW_MONI:"..str)
    log.info("upws","content net len is :"..#str)
    log.info("upws","sendPool len:"..#sendPool)
    --rtos.sleep(100) 
end)

sys.subscribe("NET_HEART_MONI", function(str)
    totallen=41+str:len()
    local ret=string.format("%04d",totallen).."01".."B".."01"..""..status.ID..""..""..status.MM.."".."1234"..str.."05"
    sys.publish("NET_SENT",ret)
    table.insert(sendPool,ret)
    log.info("upws","NET_HEART_MONI:"..str)
    log.info("upws","content net len is :"..#str)
    log.info("upws","sendPool len:"..#sendPool)
    --rtos.sleep(100) 
end)

sys.subscribe("NET_CMD_MONI", function(str)
    totallen=41+str:len()
    local ret=string.format("%04d",totallen).."01".."A".."01"..""..status.ID..""..""..status.MM.."".."1234"..str.."05"
    sys.publish("NET_SENT",ret)
    table.insert(sendPool,ret)
    log.info("upws","NET_CMD_MONI:"..str) 
    log.info("upws","content net len is :"..#str)
    log.info("upws","sendPool len:"..#sendPool)
    --rtos.sleep(100) 
end)

sys.subscribe("NET_RAW_MINO", function(str)
    sys.publish("DISPLAY",str)
    sys.publish("NET_RAW_MONI",Trim_CMD(str).."->OK".."\r\n")
    sys.publish("CON",str.."\n\r")
end)

sys.subscribe("NET_CMD_MINO", function(str)
    sys.publish("DISPLAY",str)
    sys.publish("NET_CMD_MONI",Trim_CMD(str).."->OK".."\r\n")
    sys.publish("CON",str.."\n\r")
end)



--对网络送出的内容进行缓冲，每隔10ms发送一次
local sendBuff={}
sys.subscribe("NET_SENT", function(str)
    table.insert(sendBuff, str )
end)

sys.timerLoopStart(function()
    if (#sendBuff>0) then
        str=table.remove(sendBuff,1)
        str=common.utf8ToGb2312(str)
        log.info("upws","raw sending str count"..#str)
        log.info("upws","raw sending buffer count"..#sendBuff)
        sys.publish("NET_SENT_RDY_1",str)
    end
end,10)
