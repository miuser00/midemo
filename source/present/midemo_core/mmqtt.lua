--------------------------------------------------------------------------------------------------------------------------------------- 
--版权声明：本demo集源于上海合宙官方技术团队的DEMO（MIT），并参考了合宙开源社区的众多大佬无私分享的代码，包括但不限于 稀饭放姜、Wendal、晨旭等
-- 目前参考到的开源项目有： iRTU（MIT)、LuatOS(MIT)
-- 欲获取更多luat 代码请访问 doc.openluat.com
-- 如果您觉得本demo集包含了未经由您授权的代码，请联系 64034373@qq.com 
---------------------------------------------------------------------------------------------------------------------------------------

-- @模块功能：MQTT透传
-- @author miuser
-- @module midemo.mqtt
-- @license MIT
-- @copyright miuser@luat
-- @release 2020-10-29
--------------------------------------------------------------------------
HELP=[[标准MQTT模块]]
HELP=[[作用:负责通过匿名方式连接MQTT服务器，服务器地址为box.miuser.net，端口为TCP:1883，可以在midemo.bs中修改]]
HELP=[[该模块使用iRTU固件的通道2进行通讯，心跳包间隔为10S]]
HELP=[[心跳包是一个字符串，内容为"MQTT HEART BEAT"]]
HELP=[[通过订阅名为“MQTT_RECEIVE”的系统消息接收MQTT服务器下发的数据]]
HELP=[[通过发布名为“MQTT_SEND"的系统消息发送数据到MQTT服务器]]
--------------------------------------------------------------------------
-- @使用方法
-- @通过irtuupws.json配置，将2-8中的任意通道配置，配置为MQTT服务器连接，订阅服务端主题名为/server，设备端发布的主题名为 /device
-- @通过bs.lua配置，将前面配置的MQTT通道映射到硬件串口上 MQTT_CHANNEL=2，MQTT_COM=2
-- @通过订阅 名为“MQTT_RECEIVE”的系统消息接收MQTT服务器下发的数据
-- @通过发布 名为“MQTT_SEND"的系统消息发送数据到MQTT服务器

module(...,package.seeall)

local modulename=...
--注册到全局状态表
table.insert(status.INSTALLED,modulename)
--通过消息发送调试信息到串口和网络
function pub(s)
    s="["..(modulename).."]"..s
    sys.publish("CON",s.."\r\n")
    sys.publish("NET_CMD_MONI",s.."\r\n")
end

--MQTT映射到的硬件串口号
local MQTT_UART_IDs=midemo.MQTT_UART_IDs or {}
--MQTT映射到的iRTU虚拟通道号
local MQTT_CHANNEL=2


--自定义心跳包
local function HeartBeat()
    rssi=net.getRssi()
    tm = misc.getClock()

    sys.publish("MQTT_SEND","MQTT HEART BEAT")
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


--接受网络数据包进行处理
sys.subscribe("UART_SENT_RDY_"..MQTT_CHANNEL,function(uid,msg)
    log.info("midemo.mmqtt","mqtt received:"..msg)
    sys.publish("MQTT_RECEIVE",msg)
end)


sys.subscribe("MQTT_SEND", function(str)
    log.info("midemo.mqtt","sent:"..str)
    
end)

--对网络送出的内容进行缓冲，每隔10ms发送一次
local sendBuff={}
sys.subscribe("MQTT_SEND", function(str)
    table.insert(sendBuff, str )
end)

sys.timerLoopStart(function()
    if (#sendBuff>0) then
        str=table.remove(sendBuff,1)
        str=common.utf8ToGb2312(str)
        sys.publish("NET_SENT_RDY_"..MQTT_CHANNEL,str)
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
-- 初始化所有被指派为MQTT透传的串口
for i=1,#MQTT_UART_IDs do
    uart.setup(MQTT_UART_IDs[i], 115200, 8, uart.PAR_NONE, uart.STOP_1, nil, 1)

    uart.on(MQTT_UART_IDs[i], "receive", function(uid)
        table.insert(sendQueue, uart.read(uid, 8192))
        sys.timerStart(sys.publish, uartimeout, "MQTT_COMRSV")
    end)
end

-- 2 将串口收到的消息转发到MQTT端口
sys.subscribe("MQTT_COMRSV", function()
    local str = table.concat(sendQueue)
    str=common.gb2312ToUtf8(str)
    sys.publish("MQTT_SEND",str)
    sendQueue={}
end)

-- 向所有MQTT串口发送字符串
local function write(str)
    for i=1,#MQTT_UART_IDs do
        uart.write(MQTT_UART_IDs[i], common.utf8ToGb2312(str))
    end
end

--从系统消息接收主题为“MQTT_RECEIVE”的消息，并转发到串口
local function uartrsv(msg)
    log.info("midemo.mmqtt","received MQTT Message",msg)
    for i=1,#MQTT_UART_IDs do
        uart.write(MQTT_UART_IDs[i], common.utf8ToGb2312(msg))
    end
end
sys.subscribe("MQTT_RECEIVE", uartrsv)

--从midemo.bs读取是否映射控制台信息到MQTT服务器
local MTCP_OVER_MQTT=midemo.MTCP_OVER_MQTT or 2

if (MTCP_OVER_MQTT==1) then
    -- 将收到的控制台命令转发到MQTT端口
    sys.subscribe("NET_CMD_MONI", function(str)
        str=common.gb2312ToUtf8(str)
        sys.publish("MQTT_SEND",str)
        sendQueue={}
    end)
    --从系统消息接收主题为“MQTT_RECEIVE”的消息，并转发到控制台
    sys.subscribe("MQTT_RECEIVE", function(msg)
        log.info("midemo.mmqtt","received MQTT Message",msg)
        sys.publish("CON",msg)
    end)
elseif (MTCP_OVER_MQTT==2) then
        --从系统消息接收主题为“MQTT_RECEIVE”的消息，并转发到控制台
        sys.subscribe("MQTT_RECEIVE", function(msg)
            log.info("midemo.mmqtt","received MQTT Message",msg)
            sys.publish("CON","[MQTT_RECEIVE]"..msg)
        end)
end