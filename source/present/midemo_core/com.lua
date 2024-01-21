--------------------------------------------------------------------------------------------------------------------------------------- 
--版权声明：本demo集源于上海合宙官方技术团队的DEMO（MIT），并参考了合宙开源社区的众多大佬无私分享的代码，包括但不限于 稀饭放姜、Wendal、晨旭等
-- 目前参考到的开源项目有： iRTU（MIT)、LuatOS(MIT)
-- 欲获取更多luat 代码请访问 doc.openluat.com
-- 如果您觉得本demo集包含了未经由您授权的代码，请联系 64034373@qq.com 
---------------------------------------------------------------------------------------------------------------------------------------

-- @模块功能：独立硬件串口模块
-- @author miuser
-- @module midemo.com
-- @license MIT
-- @copyright miuser@luat
-- @release 2020-08-28
--------------------------------------------------------------------------
--------------------------------------------------------------------------
--帮助系统显示用的模块说明
HELP=[[独立硬件串口模块]]
HELP=[[功能：ASCII模式的串口数据收发]]
HELP=[[COMSEND,uartport,text 向串口uartport发送text]]
HELP=[[例子:]]
HELP=[[COMSEND,1,AAA 向串口1发送AAA]]
HELP=[[当对应的串口收到数据时，还会自主上报收到的文本信息]]
HELP=[[COMRSV,1,BBB (串口1收到了字符串“BBB”)]]
--------------------------------------------------------------------------
-------------------------------------------- 配置串口 ---------------------
require "common"

module(...,package.seeall)

-- 将串口129及USB虚拟串口分配作为独立串口
local COM_UART_IDs=midemo.COM_UART_IDs or {129}
local RS485_OE=midemo.RS485_OE or {}

local modulename=...
--注册到全局状态表
table.insert(status.INSTALLED,modulename)
--通过消息发送调试信息到串口和网络
function pub(s)
    s="["..(modulename).."]"..s
    sys.publish("CON",s.."\r\n")
    sys.publish("NET_CMD_MONI",s.."\r\n")
end

local ports=""
for i=1,#COM_UART_IDs,1 do ports=ports.." "..tostring(COM_UART_IDs[i]) end
pub("COM" ..ports.." woking independently")

-- 串口ID,串口读缓冲区
local rsvQueues={}


-- 串口超时，串口准备好后发布的消息
-- 这个参数要根据波特率调整，波特率如果比较低，相应的timeout要延长，单位是ms
-- 一般来说115200bps建议用25, 9600bps建议调到100
local uartimeout= 25
--保持系统处于唤醒状态，不会休眠
pm.wake("COM")

-- 初始化所有被指派为独立串口
for i=1,#COM_UART_IDs do
    local rsvQueue={}
    rsvQueues[i]=rsvQueue
    uart.on(COM_UART_IDs[i], "receive", function(uid)
        table.insert(rsvQueues[i], uart.read(uid, 8192))
        sys.timerStart(sys.publish, uartimeout, "COMRSV_"..i)
    end)
    log.info("com","setupcom "..tostring(COM_UART_IDs[i]))
    uart.setup(COM_UART_IDs[i], 115200, 8, uart.PAR_NONE, uart.STOP_1, nil, 1)
    if (RS485_OE[COM_UART_IDs[i]]~=nil) then
        --引脚设置为输出
        log.info("com","COMID",tostring(COM_UART_IDs[i]),"RS485IO",tostring(RS485_OE[COM_UART_IDs[i]]))
        pins.setup(RS485_OE[COM_UART_IDs[i]],0)
        --设置RS485输出使能延迟为2000us
        uart.set_rs485_oe(COM_UART_IDs[i],RS485_OE[COM_UART_IDs[i]],1,2000)
    end

    sys.subscribe("COMRSV_"..i, function()
        local str = table.concat(rsvQueues[i])
        local str=common.gb2312ToUtf8(str)
        pub(tostring(COM_UART_IDs[i])..","..str)
        rsvQueues[i] = {}
        log.info("com",COM_UART_IDs[i].." read:", str)
    end)

end




--从系统消息接收主题为“COM”的消息，并转发到串口
local function uartsend(comno,msg)
    log.info("com","uartwrite ",comno,msg)
    uart.write(comno, common.utf8ToGb2312(msg))
end
sys.subscribe("COMSEND", uartsend)

