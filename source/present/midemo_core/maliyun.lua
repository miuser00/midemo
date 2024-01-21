--------------------------------------------------------------------------------------------------------------------------------------- 
--版权声明：本demo集源于上海合宙官方技术团队的DEMO（MIT），并参考了合宙开源社区的众多大佬无私分享的代码，包括但不限于 稀饭放姜、Wendal、晨旭等
-- 目前参考到的开源项目有： iRTU（MIT)、LuatOS(MIT)
-- 欲获取更多luat 代码请访问 doc.openluat.com
-- 如果您觉得本demo集包含了未经由您授权的代码，请联系 64034373@qq.com 
---------------------------------------------------------------------------------------------------------------------------------------

-- @模块功能：ALIYUN_RECEIVE透传
-- @author miuser
-- @module midemo.aliyun
-- @license MIT
-- @copyright miuser@luat
-- @release 2020-10-29
--------------------------------------------------------------------------
HELP=[[阿里云模块]]
HELP=[[负责和阿里云服务器进行通讯，采用自注册方式，其中三元组信息可以在midemo.bs中修改]]
HELP=[[该模块使用iRTU固件的通道3进行通讯，心跳包间隔为10S]]
HELP=[[心跳包是一个字符串，内容为"ALIYUN HEART BEAT"]]
HELP=[[共用三种用法]]
HELP=[[1、可以在midemo.bs将任一空闲串口映射为阿里云的透传端口]]
HELP=[[2、可以在midemo.bs将命令通讯接口映射为阿里云的透传端口]]
HELP=[[3、可以在midemo.bs将命令通讯接口配置为阿里云的路由端口]]
HELP=[[在第3种方式下]]
HELP=[[通过发布名为"ALIYUN_SEND"的系统消息发送数据到阿里云服务器]]
HELP=[[通过订阅名为“ALIYUN_RECEIVE”的系统消息接收阿里云服务器下发的数据]]
--------------------------------------------------------------------------


module(...,package.seeall)

--阿里云映射到的硬件串口号
local ALIYUN_UART_IDs=midemo.ALIYUN_UART_IDs or {}
--阿里云映射到的iRTU虚拟通道号
local ALIYUN_CHANNEL=3

local modulename=...
--注册到全局状态表
table.insert(status.INSTALLED,modulename)
--通过消息发送调试信息到串口和网络
function pub(s)
    s="["..(modulename).."]"..s
    sys.publish("CON",s.."\r\n")
    sys.publish("NET_CMD_MONI",s.."\r\n")
end


--自定义心跳包
local function HeartBeat()
    rssi=net.getRssi()
    tm = misc.getClock()
    -- ret=
    -- {
    --     --核心板IMEI
    --     ID=status.IMEI,
    --     --核心板SN
    --     SN=status.SN,
    --     --核心板ID
    --     ID=status.ID,
    --     --核心板MM
    --     MM=status.MM,
    --     --网络状态
    --     NETSTATUS=create.getDatalink(),
    --     --基站定位成功
    --     isLocated=status.isLocated,   
    --     --经度
    --     LONGITUDE=status.LONGITUDE,
    --     --维度
    --     LATITUDE=status.LATITUDE,      
    --     --设备端时间戳
    --     TIME=tm,
    --     --信号强度
    --     RSSI=rssi,
    -- }
    -- dat=json.encode(ret)
    --sys.publish("ALIYUN_SEND",dat)
    sys.publish("ALIYUN_SEND","ALIYUN HEART BEAT")
    
end

--服务器连接成功后定时发送心跳数据包
sys.taskInit(function()
    while (NETSTATUS==false) do 
        sys.wait(1000)
    end
    while true do      
        HeartBeat()  
        --每10S发送一次心跳
        sys.wait(10000)
    end
end)


--接受irtu收到的网络数据包进行处理
sys.subscribe("UART_SENT_RDY_"..ALIYUN_CHANNEL,function(uid,msg)
    log.info("midemo.aliyun","received:"..msg)
    sys.publish("ALIYUN_RECEIVE",msg)
end)


--对网络送出的内容进行缓冲，每隔10ms发送一次
local sendBuff={}
sys.subscribe("ALIYUN_SEND", function(str)
    table.insert(sendBuff, str )
end)

sys.timerLoopStart(function()
    if (#sendBuff>0) then
        str=table.remove(sendBuff,1)
        str=common.utf8ToGb2312(str)
        sys.publish("NET_SENT_RDY_"..ALIYUN_CHANNEL,str)
    end
end,10)


-- 串口ID,串口读缓冲区
local sendQueue= {}
-- 串口超时，串口准备好后发布的消息
-- 这个参数要根据波特率调整，波特率如果比较低，相应的timeout要延长，单位是ms
-- 一般来说115200bps建议用25, 9600bps建议调到100
local uartimeout= 25
--保持系统处于唤醒状态，不会休眠
pm.wake("CON")
-- 初始化所有被指派为阿里云透传的串口
log.info("maliyun",#ALIYUN_UART_IDs)
for i=1,#ALIYUN_UART_IDs do
    uart.setup(ALIYUN_UART_IDs[i], 115200, 8, uart.PAR_NONE, uart.STOP_1, nil, 1)
    uart.on(ALIYUN_UART_IDs[i], "receive", function(uid)
        table.insert(sendQueue, uart.read(uid, 8192))
        sys.timerStart(sys.publish, uartimeout, "ALIYUNCOMRSV")
    end)
end

-- 2 将串口收到的消息转发到阿里云端口
sys.subscribe("ALIYUNCOMRSV", function()
    local str = table.concat(sendQueue)
    str=common.gb2312ToUtf8(str)
    sys.publish("ALIYUN_SEND",str)
    sendQueue={}
end)

--从系统消息接收主题为“ALIYUN_RECEIVE”的消息，并转发到串口
local function uartrsv(msg)
    log.info("midemo.maliyun","received ALIYUN Message",msg)
    log.info("midemo.maliyun","SENDOUT COM is ",ALIYUN_UART_IDs[1])
    for i=1,#ALIYUN_UART_IDs do
        uart.write(ALIYUN_UART_IDs[i], common.utf8ToGb2312(msg))
    end
end
sys.subscribe("ALIYUN_RECEIVE", uartrsv)

--从midemo.bs读取是否映射控制台信息到MQTT服务器
local MTCP_OVER_ALIYUN=midemo.MTCP_OVER_ALIYUN or 2

if (MTCP_OVER_ALIYUN==1) then
    -- 将收到的控制台命令转发到阿里云端口
    sys.subscribe("NET_CMD_MONI", function(str)
        str=common.gb2312ToUtf8(str)
        sys.publish("ALIYUN_SEND",str)
        sendQueue={}
    end)
    --从系统消息接收主题为“ALIYUN_RECEIVE”的消息，并转发到控制台
    sys.subscribe("ALIYUN_RECEIVE", function(msg)
        log.info("midemo.maliyun","received aliyun Message",msg)
        sys.publish("CON",msg)
    end)
elseif (MTCP_OVER_ALIYUN==2) then
        --从系统消息接收主题为“ALIYUN_RECEIVE”的消息，并转发到控制台
        sys.subscribe("ALIYUN_RECEIVE", function(msg)
            log.info("midemo.maliyun","received aliyun Message",msg)
            sys.publish("CON","[ALIYUN_RECEIVE]"..msg)
        end)
end