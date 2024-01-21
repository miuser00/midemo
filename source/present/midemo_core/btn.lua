    --------------------------------------------------------------------------------------------------------------------------------------- 
--版权声明：本demo集源于上海合宙官方技术团队的DEMO（MIT），并参考了合宙开源社区的众多大佬无私分享的代码，包括但不限于 稀饭放姜、Wendal、晨旭、陈夏等
-- 目前参考到的开源项目有： iRTU（MIT)、LuatOS(MIT)、LLCOM(Apache2)
-- 欲获取更多luat 代码请访问 doc.openluat.com
-- 如果您觉得本demo集包含了未经由您授权的代码，请联系 64034373@qq.com 
---------------------------------------------------------------------------------------------------------------------------------------

-- @模块功能：按钮按键模块
-- @author miuser
-- @module midemo.btn
-- @license MIT
-- @copyright miuser@luat
-- @release 2020-10-16
--------------------------------------------------------------------------
--帮助系统显示用的模块说明
HELP=[[btn模块]]
HELP=[[功能：将GPIO映射为一个按钮，需要映射的GPIO在miuser.bs中设置，默认是GPIO19]]
HELP=[[使用方法]]
HELP=[[按钮连接到对应的IO口和1.8V之间]]
HELP=[[当短按按钮时，串口收到BUTTON_SHORT_PRESSED,XX 消息]]
HELP=[[当长按按钮超过1.5S时，串口收到BUTTON_LONG_PRESSED,XX 消息]]
HELP=[[XX为映射的GPIO号]]
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


--按钮功能，需要使用空白的GPIO口
local BTNPins=midemo.BTNPins or {19}

for i=1,#BTNPins do
    pub("P"..BTNPins[i].. " was occupied by BTN")
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
    for i, v in ipairs(BTNPins) do
        if getGpioFnc[v]()~=pinLastStage[v] then
            trigerPin=v
            pinLastStage[v]=getGpioFnc[v]()
        end
    end
    if (trigerPin=="") then return end
    local level=getGpioFnc[trigerPin]()
    --上升沿中断
    if msg==cpu.INT_GPIO_POSEDGE then
        sys.publish("GPIO_LEVEL_CHANGE",trigerPin,0)
    else
     --下降沿中断       
        sys.publish("GPIO_LEVEL_CHANGE",trigerPin,1)
    end
end

for i=1,#BTNPins do
    pinLastStage[BTNPins[i]]=0
end

for i=1,#BTNPins do
    --设置中断函数和电平检测函数
    getGpioFnc[BTNPins[i]]=pins.setup(BTNPins[i],gpioIntFnc)
    --引脚均设为下拉
    pio.pin.setpull(pio.PULLDOWN,BTNPins[i])
    
end

---按钮事件
sta,longcb,shortcb,longtimercb={},{},{},{}

for i=1,#BTNPins do
    sta[i]= "IDLE"
    longtimercb[BTNPins[i]]=function() 
        --log.info("midemo.btn","pin.longtimercb "..BTNPins[i])
        sta[BTNPins[i]] = "LONGPRESSED"
        longcb[BTNPins[i]]()
    end
    shortcb[BTNPins[i]]=function()
        log.info("midemo.btn","pin.shortpress "..BTNPins[i])
        pub("BUTTON_SHORT_PRESSED,"..BTNPins[i].."\r\n")
        sys.publish("BTN_SHORT_PRESSED",BTNPins[i])
    end
    longcb[BTNPins[i]]=function()
        log.info("midemo.btn","pin.longpress "..BTNPins[i])
        pub("BUTTON_LONG_PRESSED,"..BTNPins[i].."\r\n")
        sys.publish("BTN_LONG_PRESSED",BTNPins[i])
    end
end

--响应对应pin的按钮，edge=0 上升沿， edge=1 下降沿
local function keyMsg(pin,edge)
    --没有接管的GPIO不进行响应
    if (longtimercb[pin])~=nil then 
        if edge==0 then
            sta[pin] = "PRESSED"
            sys.timerStart(longtimercb[pin],1500)
        else
            sys.timerStop(longtimercb[pin])
            if sta[pin]=="PRESSED" then
                if shortcb[pin] then shortcb[pin]() end
            end
            sta[pin] = "IDLE"
        end
    end
end
sys.subscribe("GPIO_LEVEL_CHANGE", keyMsg) 

sys.subscribe("SETBTN",function(...)

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
       if (level==0) then pub("BTNLEVEL,"..tostring(io)..",0".."\r\n") else pub("BTNLEVEL,"..tostring(io)..",1".."\r\n") end 
       sys.publish("BTN_LEVEL",io,level)
   end   
end)

sys.subscribe("GETBTN",function(...)

   io=tonumber(arg[1])
   level=getGpioFnc[io]()
   if (level==0) then pub("BTNLEVEL,"..tostring(io)..",0".."\r\n") else pub("BTNLEVEL,"..tostring(io)..",1".."\r\n") end 
   sys.publish("BTN_LEVEL",io,level)
end)


sys.subscribe("CLOSEBTN",function(...)
    for i=1,#BTNPins do
        --设置中断函数和电平检测函数
        pio.pin.close(BTNPins[i])       
    end

end)

sys.subscribe("OPENBTN",function(...)
    for i=1,#BTNPins do
        --设置中断函数和电平检测函数
        getGpioFnc[BTNPins[i]]=pins.setup(BTNPins[i],gpioIntFnc)
        --引脚均设为下拉
        pio.pin.setpull(pio.PULLDOWN,BTNPins[i])       
    end

end)

