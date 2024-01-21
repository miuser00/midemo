--------------------------------------------------------------------------------------------------------------------------------------- 
--版权声明：本demo集源于上海合宙官方技术团队的DEMO（MIT），并参考了合宙开源社区的众多大佬无私分享的代码，包括但不限于 稀饭放姜、Wendal、晨旭、陈夏等
-- 目前参考到的开源项目有： iRTU（MIT)、LuatOS(MIT)、LLCOM
-- 欲获取更多luat 代码请访问 doc.openluat.com
-- 如果您觉得本demo集包含了未经由您授权的代码，请联系 64034373@qq.com，如有侵权嫌疑将立即纠正
---------------------------------------------------------------------------------------------------------------------------------------
--- 模块功能：系统指令模块
-- @author miuser
-- @module midemo.cmd
-- @license MIT
-- @copyright miuser@luat
-- @release 2020-09-17
--------------------------------------------------------------------------
HELP=[[cmd模块]]
HELP=[[功能：常用内部命令，包括查询ID、MM、SN、IMEI等]]
HELP=[[GETID 获取当前模块的ID]]
HELP=[[GETMM 获取当前模块的密码]]
HELP=[[GETIMEI 获取当前模块的IMEI]]
HELP=[[GETSN 获取当前模块的出厂序列号]]
HELP=[[例子:]]
HELP=[[GETID 系统返回ID=1234567890,ID为10位数字构成的模块识别码，每个模块此项都不相同]]
HELP=[[GETMM 系统返回ID=1234567890ABCDEF,ID为16位字符构成的模块密码，每个模块此项都不相同]]
HELP=[[GETIMEI 系统返回ID=1234567890ABCDE,IMEI为15数字构成的IMEI号，每个模块此项都不相同]]
HELP=[[GETSN 系统返回ID=1234567890ABCD,SN为14数字构成的模块出厂序列号，每个模块此项都不相同]]
HELP=[[GETICCID 系统返回ICCID=12345678901234567890,ICCID为20位数字构成的SIM卡识别码，这个值存在物联网SIM卡]]
--------------------------------------------------------------------------

require "lbsLoc"
require "misc"
require "nvm"
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


--标签打印
sys.subscribe("GETID",function(...)
    log.info("cmd","GETID")
    ret="ID="..status.ID.."\r\n"
    sys.publish("CON",ret)

    sys.publish("NET_CMD_MONI",ret)
end)
sys.subscribe("GETMM",function(...)
    log.info("cmd","GETMM")
    ret="MM="..status.MM.."\r\n"
    sys.publish("CON",ret)
    sys.publish("NET_CMD_MONI",ret)
end)

sys.subscribe("GETIMEI",function(...)
    log.info("cmd","GETIMEI")
    ret="IMEI="..status.IMEI.."\r\n"
    sys.publish("CON",ret)
    sys.publish("NET_CMD_MONI",ret)
end)

sys.subscribe("GETSN",function(...)
    log.info("cmd","GETSN")
    ret="SN="..status.SN.."\r\n"
    sys.publish("CON",ret)
    sys.publish("NET_CMD_MONI",ret)
end)

sys.subscribe("GETICCID",function(...)
    log.info("cmd","GETICCID")
    local ICCID=sim.getIccid()
    ret="ICCID="..ICCID.."\r\n"
    sys.publish("CON",ret)
    sys.publish("NET_CMD_MONI",ret)
end)