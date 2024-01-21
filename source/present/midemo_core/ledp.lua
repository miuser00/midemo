--------------------------------------------------------------------------------------------------------------------------------------- 
--版权声明：本demo集源于上海合宙官方技术团队的DEMO（MIT），并参考了合宙开源社区的众多大佬无私分享的代码，包括但不限于 稀饭放姜、Wendal、晨旭、陈夏等
-- 目前参考到的开源项目有： iRTU（MIT)、LuatOS(MIT)、LLCOM
-- 欲获取更多luat 代码请访问 doc.openluat.com
-- 如果您觉得本demo集包含了未经由您授权的代码，请联系 64034373@qq.com，如有侵权嫌疑将立即纠正
---------------------------------------------------------------------------------------------------------------------------------------
--- 模块功能：LED状态灯控制增强模块
-- @author by miuser
-- @release 2021.08.09
-- @module midemo.ledp
-- @license MIT
--------------------------------------------------------------------------
--帮助系统显示用的模块说明
HELP=[[LED状态灯控制增强模块]]
HELP=[[功能：控制两个LED，SIM卡状态，云服务状态]]
HELP=[[当模块SIM卡注册成功，SIM卡状态灯点亮，如果SIM卡识别正常不联网则，SIM卡灯0.5S等长闪烁]]
HELP=[[当UPWS云服务器连接成功，云服务状态灯短闪，连接失败则0.5S等长闪烁]]
--------------------------------------------------------------------------


module(..., package.seeall)
require "sim"
require "net"

local modulename=...
--注册到全局状态表
table.insert(status.INSTALLED,modulename)
--通过消息发送调试信息到串口和网络
function pub(s)
    s="["..(modulename).."]"..s
    sys.publish("CON",s.."\r\n")
    sys.publish("NET_CMD_MONI",s.."\r\n")
end

--设置LED使用的GPIO
local POWERLED=midemo.POWERLED or 5
local STATUSLED=midemo.STATUSLED or 1
local SIMLED=midemo.SIMLED or 4

if POWERLED then pub("P"..POWERLED.. " was occupied by POWERLED") end
if STATUSLED then pub("P"..STATUSLED.. " was occupied by STATUSLED") end
if SIMLED then pub("P"..SIMLED.. " was occupied by SIMLED") end

--闪烁指定led，gpio，参数为闪烁的序列，单位为ms，
--使用例子
--led=m_blink(1)
--led(500,500,100)
--指定gpio1按照500ms亮，500ms灭，100ms亮这个次序循环
local function create_blinkLED(gpo)
    if (gpo~=nil) then
        local seq={}

        local gpo=pins.setup(gpo,0)
        --建立LED维持函数
        sys.taskInit(function()
            while (true) do
                if (next(seq)~=nil) then
                    --log.info("ledp",#seq,unpack(seq))
                    local level=0
                    for i=1,#seq,1 do
                        level = level==0 and 1 or 0
                        --当序列时间为0则跳过，防止误闪烁
                        if(seq[i]~=0 and seq[i]~=nil) then
                            gpo(level)
                            --log.info("ledp","wait "..tostring(seq[i]))
                            sys.wait(seq[i])
                        end
                    end
                else
                    sys.wait(100)
                    --log.info("ledp","wait "..100)
                end
            end
        end)        
        return function(...)
            seq=arg
        end
        
    end
end

local net_blink=create_blinkLED(STATUSLED)
local sim_blink=create_blinkLED(SIMLED)
local power_blink=create_blinkLED(POWERLED)

--网络灯连接状态 （1 upws 2 mqtt 4 aliyun） 1+2+4=7
status=0

--用显示网络状态的错误码
--7 连接正常,闪烁1下 ,8-7=1
--6 upws连接失败闪烁2下 ,8-6=2
--5 mqtt连接失败闪烁3下,8-5=3
--3 aliyun连接失败闪烁5下,8-3=5
--0 全部连接失败闪烁8下,8-0=8
local function shownetstatus(errcode)
    log.info("ledp","errorcode="..errcode)
    local seq={}
    local bktime=8-errcode
    --报错闪烁
    for i=1,bktime,1 do
        table.insert(seq,100)
        table.insert(seq,100)
    end
    table.insert(seq,0)
    table.insert(seq,2000)
    net_blink(unpack(seq))
end
sys.subscribe("UPWS_CONNECTED",function(stat)
    if (stat==1) then 
        status=bit.bor(status,1)
    else
        status=bit.band(status,0)
    end
    shownetstatus(status)
end)

sys.subscribe("MQTT_CONNECTED",function(stat)
    if (stat==1) then 
        status=bit.bor(status,2)
    else
        status=bit.band(status,2)
    end
    shownetstatus(status)
end)


sys.subscribe("ALIYUN_CONNECTED",function(stat)
    if (stat==1) then 
        status=bit.bor(status,4)
    else
        status=bit.band(status,4)
    end
    shownetstatus(status)
end)



--刷新sim卡灯
sys.taskInit(function()
    while true do
        --不识卡
        if (sim.getStatus()==false) then
            --常灭
            sim_blink(0,1000)
        else
            --log.info("mled","netState",net.getState())
            --网络注册成功
            if (net.getState()=="REGISTERED") then
                --常亮
                sim_blink(1000,0)
            else
            --网络未注册，可能是卡欠费
                --闪烁
                sim_blink(500,500)
            end
        end 
        sys.wait(500)
    end
end)
--电源指示灯常亮
power_blink(1000,0)