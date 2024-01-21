
--------------------------------------------------------------------------------------------------------------------------------------- 
--版权声明：本demo集源于上海合宙官方技术团队的DEMO（MIT），并参考了合宙开源社区的众多大佬无私分享的代码，包括但不限于 稀饭放姜、Wendal、晨旭等
-- 目前参考到的开源项目有： iRTU（MIT)、LuatOS(MIT)
-- 欲获取更多luat 代码请访问 doc.openluat.com
-- 如果您觉得本demo集包含了未经由您授权的代码，请联系 64034373@qq.com 
---------------------------------------------------------------------------------------------------------------------------------------

-- @模块功能：三方编程接口DEMO
-- @author miuser
-- @module midemo.air153
-- @license MIT
-- @copyright miuser@luat
-- @release 2021-08-10
--------------------------------------------------------------------------
--帮助系统显示用的模块说明
HELP=[[Air153看门狗模块]]
HELP=[[每3S向看门狗IO口输出一个低电平脉冲]]
HELP=[[使用方法]]
HELP=[[默认的看门狗引脚为GPIO21]]
HELP=[[包含本文件，即可激活看门狗，否则每5分钟，看门狗会发出复位信号重启模块]]
--------------------------------------------------------------------------

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


--默认GPIO23为看门狗
local WDI=midemo.WDI or 23

pub("P"..WDI.. " was occupied by WATCHDOG input pin")


local wd=pins.setup(WDI,1)

sys.taskInit(function()
    while true do
        --拉低看门狗pin 2S
        wd(0)
        sys.wait(2000)
        log.info("air153","watchdog was feeded")
        wd(1)
        --看门狗pin高电平60s
        sys.wait(60000)
    end
end)

