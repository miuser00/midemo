--------------------------------------------------------------------------------------------------------------------------------------- 
-- 版权声明：本demo集源于上海合宙官方技术团队的DEMO（MIT），并参考了合宙开源社区的众多大佬无私分享的代码，包括但不限于 稀饭放姜、Wendal、晨旭，等
-- 目前参考到的开源项目有： iRTU（MIT)、LuatOS(MIT)
-- 欲获取更多luat 代码请访问 doc.openluat.com
-- 如果您觉得本demo集包含了未经由您授权的代码，请联系 64034373@qq.com 
---------------------------------------------------------------------------------------------------------------------------------------
-- @模块功能：短信收发
-- @author miuser
-- @module midemo.trsms
-- @license MIT
-- @copyright miuser@luat
-- @release 2020-10-04
--------------------------------------------------------------------------
--帮助系统显示用的模块说明
HELP=[[trsms模块]]
HELP=[[功能：短信收发]]
HELP=[[发送短信]]
HELP=[[SMS,13XXXXXXXXX,发送的内容]]
HELP=[[发送完成后，控制台收到完成短信SENDING TO 13XXXXXXXXX 发送的内容]]
HELP=[[接收短信]]
HELP=[[当模块收到短信后控制台显示 [SMS]收到的内容@发送的手机号码]]
HELP=[[例子]]
HELP=[[SMS,13000000000,这是发送给老米的一条骚扰短信，号码被隐去]]
HELP=[[发送成功后控制台回显 SMS,13XXXXXXXXX,这是发送给老米的一条骚扰短信->DONE]]
--------------------------------------------------------------------------
-- @使用方法
-- @发送短信 SMS,13XXXXXXXXX,发送的内容
-- @收到短信 [RECEIVED FROM 13XXXXXXXXX]SMS 收到的内容 @收到的时间
require "sms"
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

--短信发送
sys.subscribe("SMS",function(...)
    --通过arg可以从输入的命令行读入参数，并以逗号作为分隔符
    tel=arg[1]
	content=common.utf8ToGb2312(arg[2])
    log.info("trsms","sending sms",content)
	sms.send(tel,content,function() write("SMS,"..tel.." "..arg[2].."->DONE\r\n") end)

end)

--通过消息发送调试信息到串口和网络客户端
function write(s)
    --log.info("testUartTask.write",s)
    sys.publish("CON",s)
    sys.publish("NET_CMD_MONI",s)
end


--短信接收
local function procnewsms(num,data,datetime)
	log.info("testSms.procnewsms",num,data,datetime)
	write("[SMS]"..common.gb2312ToUtf8(data) .."@"..num)
end
sms.setNewSmsCb(procnewsms)
