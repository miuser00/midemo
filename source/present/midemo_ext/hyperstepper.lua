--------------------------------------------------------------------------------------------------------------------------------------- 
--版权声明：本demo集源于上海合宙官方技术团队的DEMO（MIT），并参考了合宙开源社区的众多大佬无私分享的代码，包括但不限于 稀饭放姜、Wendal、晨旭等
-- 目前参考到的开源项目有： iRTU（MIT)、LuatOS(MIT)
-- 欲获取更多luat 代码请访问 doc.openluat.com
-- 如果您觉得本demo集包含了未经由您授权的代码，请联系 64034373@qq.com 
---------------------------------------------------------------------------------------------------------------------------------------

-- @模块功能：Hyperstepper简易步进电机驱动
-- @author miuser
-- @module midemo.hyperstepper
-- @license MIT
-- @copyright miuser@luat
-- @release 2021-02-18
--------------------------------------------------------------------------
--帮助系统显示用的模块说明
HELP=[[Hyperstepper步进电机驱动模块]]
HELP=[[连线方法：]]
HELP=[[VCC,驱动电源,+5~24V, 红]]
HELP=[[GND,地线,GND,黑]]
HELP=[[STEP,脉冲信号,P11,MOSI,白]] 
HELP=[[DIR,方向,P18,黄]]
HELP=[[ENA,使能,P19,橙]]
HELP=[[COM,数字电源,VLCD,绿]]
HELP=[[开关1,2,3,4设置为OFF，ON，ON，OFF]]
HELP=[[功能：使步进电机旋转指定角度,角度最小分度为1度]]
HELP=[[MOTOROLL,Degree Degree为要旋转的度数，取值范围1-3600]]
HELP=[[系统返回Forwarding:xxxdegree,或者Reversing:xxxdegree]]
HELP=[[旋转到位后返回MOTOROLL,Degree->Done]]
HELP=[[例子:]]
HELP=[[MOTOROLL,360]]
HELP=[[系统返回:Forwarding:360degree]]
HELP=[[旋转后返回MOTOROLL,360->DONE]]
--------------------------------------------------------------------------
-- VCC,电源,+5~24V, 红
-- GND,地线,GND,黑
-- STEP,脉冲信号,MOSI,白 
-- DIR,方向,P18,黄
-- ENA,使能,P19,橙
-- COM,VIO,VLCD,绿


--闭环模式
--1.8度步进角
--200步/圈
--16细分
--一圈为3200步 
--StepsPerRound
SPR=4096
--开关1,2,3,4设置为OFF，ON，ON，OFF

require "bit"
require"pins"

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


EN=pins.setup(19,level)
DIR=pins.setup(18,level)

pub("GPIO18 was occupied by hyperstepper DIR pin")
pub("GPIO19 was occupied by hyperstepper EN pin")

--以每秒rps的转速发送数据
function SendData(data,dir)
    EN(1)
    DIR(dir)
    spi.send(spi.SPI_1,data)
    EN(0)
end

--生成一个脉冲
function GeneratePalse()
    pulsedata=""
    pulsedata=pulsedata..string.char(0xFF)
    pulsedata=pulsedata..string.char(0x00)
    return pulsedata
end

--步进电机旋转指定步数
function RollStep(step,dir)
    data=""
    for i=1,step do
        data=data..GeneratePalse()
    end
    --log.info("hyperstepper","step="..step)
    SendData(data,dir)
end

--步进电机旋转指定步数
function RollDegree(degree,dir)
    step=SPR*degree/360
    --log.info("hyperstepper","step="..step)
    for i=1,step do
        RollStep(1,dir)
    end

end

--初始化电机总线
function init()
    log.info("midemo.hyperstepper","init",result)
    local result = spi.setup(spi.SPI_1,0,0,8,8000000,1)--初始化spi
end

function close()
    spi.close(spi.SPI_1)
end



--通过这个回调函数可以响应任意的串口或网络发布的命令
sys.subscribe("MOTOROLL",function(...)
    --通过arg可以从输入的命令行读入参数，并以逗号作为分隔符
    a=tonumber(arg[1])
    --b=arg[2]
    if a==nil then return end
    if (a>0) then degree=a else degree=-a end
    dir=0
    if (a>0) then 
        dir=0 
        --pub("Forwarding:"..degree.."degree")
    else 
        dir=1
        --pub("Reversing:"..degree.."degree")
    end
    init()
    RollDegree(degree,dir)
    close()
    pub("MOTOROLL,"..degree.."->DONE") 
end)



-----------
--[[
sta：按键状态，IDLE表示空闲状态，PRESSED表示已按下状态，LONGPRESSED表示已经长按下状态
longprd：长按键判断时长，默认3秒；按下大于等于3秒再弹起判定为长按键；按下后，在3秒内弹起，判定为短按键
longcb：长按键处理函数
shortcb：短按键处理函数
]]

local sta,longprd,longcb,shortcb = "IDLE",500

local function longtimercb()
    log.info("keypad.longtimercb")
    sta = "LONGPRESSED"	
    
end

local function shortcb()
    log.info("keypad.shortpress")
    init()
    for i=1,1 do
        RollDegree(90,0)
    end
    close()
end

local function longcb()
    log.info("keypad.longpress")
    init()
    for i=1,1 do
        RollDegree(90,1)
    end
    close()
end

local function keyMsg(msg)
    log.info("keyMsg",msg.key_matrix_row,msg.key_matrix_col,msg.pressed)
    if msg.pressed then
        sta = "PRESSED"
        sys.timerStart(longtimercb,longprd)
    else
        sys.timerStop(longtimercb)
        log.info("hyperstepper","sta="..sta)
        if sta=="PRESSED" then
            if shortcb then shortcb() end
        elseif sta=="LONGPRESSED" then
            (longcb or rtos.poweroff)()
		end
		sta = "IDLE"
	end
end

--- 配置开机键长按弹起和短按弹起的功能.
-- 如何定义长按键和短按键，例如长按键判断时长为3秒：
-- 按下大于等于3秒再弹起判定为长按键；
-- 按下后，在3秒内弹起，判定为短按键
-- @number[opt=3000] longPrd，长按键判断时长，单位毫秒
-- @function[opt=nil] longCb，长按弹起时的回调函数，如果为nil，使用默认的处理函数，会自动关机
-- @function[opt=nil] shortCb，短按弹起时的回调函数
-- @return nil
-- @usage
-- powerKey.setup(nil,longCb,shortCb)
-- powerKey.setup(5000,longCb)
-- powerKey.setup()
function setup(longPrd,longCb,shortCb)
    longprd,longcb,shortcb = longPrd or 3000,longCb,shortCb
end

rtos.on(rtos.MSG_KEYPAD,keyMsg)
rtos.init_module(rtos.MOD_KEYPAD,0,0,0)

