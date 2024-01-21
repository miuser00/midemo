--- 模块功能：开机键功能配置
-- @module powerKey
-- @author openLuat
-- @license MIT
-- @copyright openLuat
-- @release 2018.06.13
--------------------------------------------------------------------------
--帮助系统显示用的模块说明
HELP=[[mkey模块]]
HELP=[[功能：配置开机键的功能]]
HELP=[[使用方法]]
HELP=[[按钮连接到POWERKEY和GND]]
HELP=[[当电源按钮短按就松开，控制台收到POWERKEY_SHORT_PRESSED,XX 消息]]
HELP=[[当长按按钮超过1.5S时，控制台收到POWERKEY_LONG_PRESSED,XX 消息]]
--------------------------------------------------------------------------
require"sys"
module(..., package.seeall)

local modulename=...
--注册到全局状态表
table.insert(status.INSTALLED,modulename)
--通过消息发送调试信息到串口和网络
function pub(s)
    s="["..(modulename).."]"..s
    sys.publish("CON",s.."\r\n")
    sys.publish("NET_CMD_MONI",s.."\r\n")
end

pub("Powerkey was occupied by MKEY")

--[[
sta：按键状态，IDLE表示空闲状态，PRESSED表示已按下状态，LONGPRESSED表示已经长按下状态
longprd：长按键判断时长，默认3秒；按下大于等于3秒再弹起判定为长按键；按下后，在3秒内弹起，判定为短按键
longcb：长按键处理函数
shortcb：短按键处理函数
]]
local sta,longprd,longcb,shortcb = "IDLE",1500

function longcb()
    log.info("keypad.longpress")
    pub("POWERKEY_LONG_PRESSED")
    sys.publish("POWERKEY_LONG_PRESSED")
end

local function longtimercb()
    log.info("keypad.longtimercb")
    sta = "LONGPRESSED"	
    longcb()
end

local function shortcb()
    log.info("keypad.shortpress")
    pub("POWERKEY_SHORT_PRESSED")
    sys.publish("POWERKEY_SHORT_PRESSED")
end



local function keyMsg(msg)
    log.info("keyMsg",msg.key_matrix_row,msg.key_matrix_col,msg.pressed)
    if msg.pressed then
        sta = "PRESSED"
        sys.timerStart(longtimercb,longprd)
    else
        sys.timerStop(longtimercb)
        if sta=="PRESSED" then
            if shortcb then shortcb() end
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
