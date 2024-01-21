--------------------------------------------------------------------------------------------------------------------------------------- 
--版权声明：本demo集源于上海合宙官方技术团队的DEMO（MIT），并参考了合宙开源社区的众多大佬无私分享的代码，包括但不限于 稀饭放姜、Wendal、晨旭等
-- 目前参考到的开源项目有： iRTU（MIT)、LuatOS(MIT)
-- 欲获取更多luat 代码请访问 doc.openluat.com
-- 如果您觉得本demo集包含了未经由您授权的代码，请联系 64034373@qq.com 
---------------------------------------------------------------------------------------------------------------------------------------

-- @模块功能：控制台模块
-- @author miuser
-- @module midemo.mconsole
-- @license MIT
-- @copyright miuser@luat
-- @release 2021-06-26
--------------------------------------------------------------------------
--帮助系统显示用的模块说明
HELP=[[控制台模块]]
HELP=[[功能：负责控制台命令的收发]]
HELP=[[映射为控制台的UART口接收形式为COMMAND,PARA1,PARA2,PARA3.... 参数中不可以有英文逗号]]
HELP=[[控制台收到指令后通过sys.publish(COMMAND,PARA1,PARA2,PARA3....)的形式转化为系统消息，发布出去]]
HELP=[[当接收其他模块发送的任何主题为“CON”的消息,则转发到串口出来。比如消息为 CON,"AA","1",则控制台将对外发送AA,1]]

--------------------------------------------------------------------------

-------------------------------------------- 配置串口 ---------------------
require "common"

module(...,package.seeall)

-- 将串口129及USB虚拟串口分配作为命令控制接口
local CONSOLE_UART_IDs=midemo.CONSOLE_UART_IDs or {129}

log.info("consolesetup",CONSOLE_UART_IDs[1])

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


-- 串口ID,串口读缓冲区
local rsvQueue= {}
-- 串口超时，串口准备好后发布的消息
-- 这个参数要根据波特率调整，波特率如果比较低，相应的timeout要延长，单位是ms
-- 一般来说115200bps建议用25, 9600bps建议调到100
local uartimeout= 25
--保持系统处于唤醒状态，不会休眠
pm.wake("CON")


-- 初始化所有被指派为控制台的串口
for i=1,#CONSOLE_UART_IDs do
    uart.setup(CONSOLE_UART_IDs[i], 115200, 8, uart.PAR_NONE, uart.STOP_1, nil, 1)

    uart.on(CONSOLE_UART_IDs[i], "receive", function(uid)
        table.insert(rsvQueue, uart.read(uid, 8192))
        sys.timerStart(sys.publish, uartimeout, "COMRSV")
    end)
end

-- 1 向串口发送收到的字符串加上->OK，并回送到串口
-- 2 将串口收到的消息转发成luatask系统消息
sys.subscribe("COMRSV", function()
    local str = table.concat(rsvQueue)
    str=common.gb2312ToUtf8(str)
    sys.publish("NET_CMD_MONI",str)
    sys.publish("DISPLAY",str)
    -- 串口的数据读完后清空缓冲区
    local splitlist = {}
    string.gsub(str, '[^,]+', function(w) table.insert(splitlist, w) end)
    local count=table.getn(splitlist)
    --sys.publish("UARTIN",str)
    for i=1,#splitlist do 
        splitlist[i]=PIN_MAP(splitlist[i])
        splitlist[i]=Trim_CMD(splitlist[i])
        --log.info("com.command is",splitlist[i],#splitlist[i])
    end
    if (splitlist[1]~=nil) then splitlist[1]=string.upper(splitlist[1]) end
    sys.publish(unpack(splitlist))
    rsvQueue = {}
    log.info("uart read:", str)
    write(Trim_CMD(str).."->OK".."\n\r")
end)

-- 向所有串口发送字符串
function write(str)
    for i=1,#CONSOLE_UART_IDs do
        uart.write(CONSOLE_UART_IDs[i], common.utf8ToGb2312(str))
    end
end

--从系统消息接收主题为“COM”的消息，并转发到串口
local function uartrsv(msg)
    for i=1,#CONSOLE_UART_IDs do
        uart.write(CONSOLE_UART_IDs[i], common.utf8ToGb2312(msg))
    end
end
sys.subscribe("CON", uartrsv)

pub("CONSOLE is started")