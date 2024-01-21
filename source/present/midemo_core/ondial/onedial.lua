--------------------------------------------------------------------------------------------------------------------------------------- 
-- 版权声明：本demo集源于上海合宙官方技术团队的DEMO（MIT），并参考了合宙开源社区的众多大佬无私分享的代码，包括但不限于 稀饭放姜、Wendal、晨旭，等
-- 项目源码重要贡献者：月落无声
-- 目前参考到的开源项目有： iRTU（MIT)、LuatOS(MIT)
-- 欲获取更多luat 代码请访问 doc.openluat.com
-- 如果您觉得本demo集包含了未经由您授权的代码，请联系 64034373@qq.com 
---------------------------------------------------------------------------------------------------------------------------------------
---模块功能 LTE语音通话
-- @author miuser
-- @module midemo.onedial
-- @license MIT
-- @copyright miuser
-- @release 2020-09-24
--------------------------------------------------------------------------
--帮助系统显示用的模块说明
HELP=[[onedial模块]]
HELP=[[功能：LTE语音通话]]
HELP=[[拨打电话]]
HELP=[[DIAL,13XXXXXXXXX,拨打指定号码]]
HELP=[[挂断当前通话]]
HELP=[[HUNGUP]]
HELP=[[接听当前电话]]
HELP=[[ANSWERCALL]]
HELP=[[设置默认拨打号码]]
HELP=[[SETCALLNUMBER,13XXXXXXXXX]]
HELP=[[一键拨打默认号码]]
HELP=[[ONEDIAL]]
HELP=[[当外部电话呼入，控制台会显示[onedial]INCOMING CALL,13XXXXXXXXX的消息, 13X..为呼入号码]]
HELP=[[当呼出电话时，控制台会显示[onedial]DIALING,13XXXXXXXXX的消息, 13X..为呼出号码]]
HELP=[[当有电话接通时，控制台会显示[onedial]CONNECTED]]
HELP=[[当有电话断开时，控制台会显示[onedial]DISCONNECTED]]
HELP=[[例子1:]]
HELP=[[DIAL,117]]
HELP=[[屏幕回显[onedial]DIALING,117]]
HELP=[[接通后屏幕回显[onedial]CONNECTED]]
HELP=[[HUNGUP]]
HELP=[[电话主动挂断并回显[onedial]DISCONNECTED]]
HELP=[[例子2:]]
HELP=[[外部电话主动呼入]]
HELP=[[屏幕显示[onedial]INCOMING CALL,138XXXXXXXXX]]
HELP=[[PICKUP]]
HELP=[[接听电话]]
HELP=[[接通后屏幕回显[onedial]CONNECTED]]
HELP=[[HUNGUP]]
HELP=[[拒接电话]]
HELP=[[电话主动挂断并回显[onedial]DISCONNECTED]]


--------------------------------------------------------------------------
require"pins"
require"common"
require "mcc"
require "audio"
module(...,package.seeall)


local modulename=...
--注册到全局状态表
table.insert(status.INSTALLED,modulename)
--通过消息发送调试信息到串口和网络
function pub(s,noheader)
    if (noheader~=true) then s="["..(modulename).."]"..s end
    sys.publish("CON",s.."\r\n")
    sys.publish("NET_CMD_MONI",s.."\r\n")
end


----用于屏蔽开机时的DISCONNECT 和 HUNG 消息
--local initalizing=1

--将GPIOX作为来电指示,nil为无来电指示灯
local PHONELED=midemo.PHONELED or 5

audio.setCallVolume(5)

--来电状态 0未通话，1来电中，2已接通 3呼出中
local call_status=0
local okToDial=0

local onTime,offTime=0,0
--默认呼出的号码
local defaultnumber=""
--当前号码
local cnumber=""
require "NVMPara"
nvm.init("NVMPara.lua")
defaultnumber=nvm.get("CALLNUMBER")

if (defaultnumber=="") then
    defaultnumber="117"
end

function setcallnumber(num)
    defaultnumber=num
    s="CALL NUMBER="..num
    pub(s)
    log.info("onedial","saving call number is "..num)
    nvm.set("CALLNUMBER",num)
end
sys.subscribe("SETCALLNUMBER", setcallnumber)


--GPIO1，绿灯
local led_call
if (PHONELED~=nil) then 
    led_call = pins.setup(PHONELED,0)
end
-- 接收LED参数配置参数
local function mblink(ontime,offtime)
    if (led_call~=nil) then 
        led_call(1)
        onTime=ontime
        offTime=offtime
        if offTime==0 then
            led_call(0)
        elseif onTime==0 then
            led_call(1)
        end
    end
end

--指令拨号
local function mdial(num)
    if okToDial==1 then
        if (num==nil) then
            cnumber=defaultnumber
        else
            cnumber=num
            log.info("ondial","cnumber="..cnumber)
        end
        call_status=3
        sys.publish("CALL_STATUS",3)
        mcc.dial(cnumber)
        s="DIALING,"..cnumber
        pub(s)
    else
        s="NOT READY TO DIAL "
        pub(s)
    end
end
sys.subscribe("DIAL",mdial)

function answercall(msg)
    if (call_status==1) then 
        s="ANSWERING"..cnumber
        mcc.accept(cnumber)
        pub(s)

    else
        s="NO CALL TO ANSWER"
        pub(s)
    end  
end
sys.subscribe("ANSWERCALL", answercall)

function pickup()
    sys.publish("ANSWERCALL")
end
sys.subscribe("PICKUP", pickup)

--硬件按键拨号
function onedial()
    if (call_status==1) then
        pub("ANSWERCALL") 
        mcc.accept(cnumber)
    elseif (call_status==0) then
        if okToDial==1 then
            cnumber=defaultnumber
            pub("DIALING "..cnumber) 
            call_status=3
            sys.publish("CALL_STATUS",3)
            mcc.dial(cnumber)

        end
    else 
        mcc.hangUp(cnumber)
    end
end
sys.subscribe("ONEDIAL", onedial)

function hangup()
    log.info("hanging up "..cnumber)
    mcc.hangUp(cnumber)
    s="HUNGUP "..cnumber
    --if initalizing==0 then pub(s) end
    pub(s)
end
sys.subscribe("HUNGUP",hangup)

local function oktodial()
    sys.timerStart(function()
        okToDial=1
        mblink(0,1000)
    end,3000)
end
sys.subscribe("SMS_READY", oktodial)

local function cincoming(num)
    log.info("onedial","cincoming number is "..num)
    s="INCOMING CALL,"..num
    pub(s)
    cnumber=num
    call_status=1
    sys.publish("CALL_STATUS",1)
    mblink(100,100)
    audio.play(CALL,"FILE","/lua/mali.mp3",audiocore.VOL6,nil,true)
end
sys.subscribe("MCALL_INCOMING",cincoming)

local function connected(num)
    cnumber=num
    call_status=2
    sys.publish("CALL_STATUS",2)
    pub("CONNECTED")
    mblink(500,500)
end
sys.subscribe("MCALL_CONNECTED",connected)

local function disconnected()
    call_status=0
    sys.publish("CALL_STATUS",0)
    mblink(0,1000)
    audio.stop()
    s="DISCONNECTED"
    log.info("onedial","MCALL_DISCONECTED")
    --if initalizing==0 then pub(s) end
    --initalizing=0
    pub(s)
end
sys.subscribe("MCALL_DISCONNECTED",disconnected)






sys.taskInit(function()
    local oncount,offcount=0,0
    local stage="on"
    while true do
        if onTime~=0 and offTime~=0 then 
            if stage=="on" then
                if oncount<(onTime/100) then
                    led_call(0)
                    oncount=oncount+1
                else
                    oncount=0
                    stage="off"
                end
            end
            if stage=="off" then 
                if offcount<(offTime/100) then
                    led_call(1)         
                    offcount=offcount+1
                else
                    offcount=0
                    stage="on"

                end
            end
        end
        sys.wait(100)
    end
end
)


