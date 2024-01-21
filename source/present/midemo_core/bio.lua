--------------------------------------------------------------------------------------------------------------------------------------- 
--版权声明：本demo集源于上海合宙官方技术团队的DEMO（MIT），并参考了合宙开源社区的众多大佬无私分享的代码，包括但不限于 稀饭放姜、Wendal、晨旭、陈夏等
-- 目前参考到的开源项目有： iRTU（MIT)、LuatOS(MIT)、LLCOM(Apache2)
-- 欲获取更多luat 代码请访问 doc.openluat.com
-- 如果您觉得本demo集包含了未经由您授权的代码，请联系 64034373@qq.com 
---------------------------------------------------------------------------------------------------------------------------------------

-- @模块功能：GPIO双向控制
-- @author miuser
-- @module midemo.bio
-- @license MIT
-- @copyright miuser@luat
-- @release 2020-08-29
--------------------------------------------------------------------------
--帮助系统显示用的模块说明
HELP=[[bio模块]]
HELP=[[功能：设置或者查询GPIO的电平状态,GPIO在midemo.bs中设置，默认为GPIO13]]
HELP=[[SETGPIO,pio,level 对应的GPIO引脚设置为level状态]]
HELP=[[GETGPIO,pio 获取对应的GPIO的真实外部电平]]
HELP=[[例子:]]
HELP=[[SETGPIO,18,1 GPIO18引脚被设置为弱高电平]]
HELP=[[GETGPIO,18 假定外部GPIO18为高电平 则收到 GPIO_LEVEL,18,1]]
HELP=[[当对应的端口设置为GPIO端口时，还会自主上报电平发生变化的信息]]
HELP=[[GPIOEDGE,0/1的提示 (0为下降沿，1为上升沿)]]
HELP=[[GPIO_LEVEL_CHANGE,0/1的提示 (0为低电平，1为高电平)]]
--------------------------------------------------------------------------

require"pins"
require"utils"
require"pm"
require"common"

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

--GPIO13映射为双向IO端口
local BIOPins=midemo.BIOPins or {13}

for i=1,#BIOPins do
    pub("P"..BIOPins[i].. " was occupied by BIO")
end

--上一次的电平状态表，以管脚号为索引
 local pinLastStage={}
--获取GPIO状态的函数表，以管脚号为索引
local getGpioFnc={}
--当收到GPIO输入测试的时候执行回调函数


function gpioIntFnc(msg)
    local trigerPin=""
    local response=""
    --检测哪个IO口发生电平变化
    for i, v in ipairs(BIOPins) do
        if getGpioFnc[v]()~=pinLastStage[v] then
            trigerPin=v
            pinLastStage[v]=getGpioFnc[v]()
        end
    end
    if (trigerPin=="") then return end
    local level=getGpioFnc[trigerPin]()
    --if (level==0) then pub("GPIO"..tostring(trigerPin).."当前电平为低".."\r\n") else pub("GPIO"..tostring(trigerPin).."当前电平为高".."\r\n") end
    if msg==cpu.INT_GPIO_POSEDGE then
        response="GPIOEDGE,"..tostring(trigerPin)..",1".."\r\n"
        pub(response)
        --pub("GPIO"..tostring(trigerPin).." rising".."\r\n")
        sys.publish("GPIO_LEVEL_CHANGE",trigerPin,1)
    --下降沿中断
    else
        response="GPIOEDGE,"..tostring(trigerPin)..",0".."\r\n"
        pub(response)
        --pub("GPIO"..tostring(trigerPin).." falling".."\r\n")
        sys.publish("GPIO_LEVEL_CHANGE",trigerPin,0)
    end
end



for i=1,#BIOPins do
    pinLastStage[BIOPins[i]]=0
end
for i=1,#BIOPins do
    --设置中断函数和电平检测函数
    getGpioFnc[BIOPins[i]]=pins.setup(BIOPins[i],gpioIntFnc)
    --引脚均设为下拉
    pio.pin.setpull(pio.PULLDOWN,BIOPins[i])
end

sys.subscribe("SETGPIO",function(...)

     io=tonumber(arg[1])
     level=tonumber(arg[2])
     mute=tonumber(arg[3])
    if (level~=0) then 
        pio.pin.setpull(pio.PULLUP,io)                 
     else
        pio.pin.setpull(pio.PULLDOWN,io)
    end
    level=getGpioFnc[io]()
    if (mute~=1) then 
        if (level==0) then pub("GPIOLEVEL,"..tostring(io)..",0".."\r\n") else pub("GPIOLEVEL,"..tostring(io)..",1".."\r\n") end 
        sys.publish("GPIO_LEVEL",io,level)
    end   
end)

sys.subscribe("GETGPIO",function(...)

    io=tonumber(arg[1])
    level=getGpioFnc[io]()
    if (level==0) then pub("GPIOLEVEL,"..tostring(io)..",0".."\r\n") else pub("GPIOLEVEL,"..tostring(io)..",1".."\r\n") end 
    sys.publish("GPIO_LEVEL",io,level)
end)
