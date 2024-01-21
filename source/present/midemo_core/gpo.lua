--------------------------------------------------------------------------------------------------------------------------------------- 
--版权声明：本demo集源于上海合宙官方技术团队的DEMO（MIT），并参考了合宙开源社区的众多大佬无私分享的代码，包括但不限于 稀饭放姜、Wendal、晨旭、陈夏等
-- 目前参考到的开源项目有： iRTU（MIT)、LuatOS(MIT)、LLCOM(Apache2)
-- 欲获取更多luat 代码请访问 doc.openluat.com
-- 如果您觉得本demo集包含了未经由您授权的代码，请联系 64034373@qq.com 
---------------------------------------------------------------------------------------------------------------------------------------

-- @模块功能：GPIO引脚输出控制
-- @author miuser
-- @module midemo.gpo
-- @license MIT
-- @copyright miuser@luat
-- @release 2020-10-07
--------------------------------------------------------------------------
--帮助系统显示用的模块说明
HELP=[[gpo模块]]
HELP=[[功能：强制设置GPIO的电平状态,GPIO在midemo.bs中设置]]
HELP=[[SETGPO,pio,level 对应的GPIO引脚设置为level状态]]
HELP=[[例子:]]
HELP=[[SETGPO,18,1 GPIO18引脚被设置为高电平]]
HELP=[[当对应的端口设置为GPO端口时，会上报当前设置的电平]]
HELP=[[GPIO_LEVEL,GPO,0/1的提示 (GPO,为设置的电平的GPIO口，0为下降沿，1为上升沿)]]
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

--GPIOX为输出IO端口
local OUTPins=midemo.OUTPins or {}

for i=1,#OUTPins do
    pub("P"..OUTPins[i].. " was occupied by GPO")
end


--上一次的电平状态表，以管脚号为索引
local pinLastStage={}

sys.subscribe("SETGPO",function(...)

    io=tonumber(arg[1])
    level=tonumber(arg[2])
    mute=tonumber(arg[3])
    --保存对应IO口状态，备查
    pinLastStage[io]=level
    pins.setup(io,level)              
    if (mute~=1) then 
        if (level==0) then pub("GPOLEVEL,"..tostring(io)..",0".."\r\n") else pub("GPOLEVEL,"..tostring(io)..",1".."\r\n") end 
        sys.publish("GPO_LEVEL",io,level)
    end   
end)

sys.subscribe("GETGPO",function(...)

    io=tonumber(arg[1])
    level=pinLastStage[io]
    if (level==0) then pub("GPOLEVEL,"..tostring(io)..",0".."\r\n") else pub("GPOLEVEL,"..tostring(io)..",1".."\r\n") end 
    sys.publish("GPIO_LEVEL",io,level)
end)
