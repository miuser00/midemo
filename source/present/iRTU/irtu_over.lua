--------------------------------------------------------------------------------------------------------------------------------------- 
--版权声明：本demo集源于上海合宙官方技术团队的DEMO（MIT），并参考了合宙开源社区的众多大佬无私分享的代码，包括但不限于 稀饭放姜、Wendal、晨旭等
-- 目前参考到的开源项目有： iRTU（MIT)、LuatOS(MIT)
-- 欲获取更多luat 代码请访问 doc.openluat.com
-- 如果您觉得本demo集包含了未经由您授权的代码，请联系 64034373@qq.com 
---------------------------------------------------------------------------------------------------------------------------------------

-- @模块功能：iRTU固件执行后清理资源占用
-- @author miuser
-- @module midemo.irtu_over
-- @license MIT
-- @copyright miuser@luat
-- @release 2020-09-08
--------------------------------------------------------------------------
------------------------iRTU占用的硬件资源---------------------------------
--GPIO4 用于服务器连接显示
--其余GPIO引脚全部清理释放
--------------------------------------------------------------------------



--以下部分的代码无须用户修改
require "pins"
require "socket"

module(..., package.seeall)

local modulename=...
--通过消息发送调试信息到串口和网络
function pub(s)
    s="["..(modulename).."]"..s
    sys.publish("CON",s.."\r\n")
    sys.publish("NET_CMD_MONI",s.."\r\n")
end


pins.close(0)
pins.close(1)
pins.close(2)
pins.close(3)
--网络灯
pins.close(4)
pins.close(7)
pins.close(9)
pins.close(10)
--pins.close(11)
pins.close(12)
pins.close(14)
pins.close(15)
pins.close(16)
pins.close(17)
pins.close(18)
pins.close(19)
--SD卡(为了保证SD卡正常读写，修改了irtu源码，去掉了此处的初始化代码)
--pins.close(24)
--pins.close(25)
--pins.close(26)
--pins.close(27)
--iRTU硬件复位占用
--pins.close(28)

--释放所有串口
-- uart.close(1)
-- uart.close(2)
-- uart.close(3)