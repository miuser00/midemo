--------------------------------------------------------------------------------------------------------------------------------------- 
--版权声明：本demo集源于上海合宙官方技术团队的DEMO（MIT），并参考了合宙开源社区的众多大佬无私分享的代码，包括但不限于 稀饭放姜、Wendal、晨旭等
-- 目前参考到的开源项目有： iRTU（MIT)、LuatOS(MIT)
-- 欲获取更多luat 代码请访问 doc.openluat.com
-- 如果您觉得本demo集包含了未经由您授权的代码，请联系 64034373@qq.com 
---------------------------------------------------------------------------------------------------------------------------------------

-- @模块功能：TTS语音播报
-- @author miuser
-- @module midemo.tts
-- @license MIT
-- @copyright miuser@luat
-- @release 2020-09-30
--------------------------------------------------------------------------
--帮助系统显示用的模块说明
HELP=[[tts模块]]
HELP=[[功能：文本朗读]]
HELP=[[使用TTS,XXX 则朗读对应的XXX]]
HELP=[[朗读完成后，系统会收到TTS,XXX->DONE的消息]]
--------------------------------------------------------------------------

module(...,package.seeall)
require"audio"

local modulename=...
--注册到全局状态表
table.insert(status.INSTALLED,modulename)
--通过消息发送调试信息到串口和网络
function pub(s)
    s="["..(modulename).."]"..s
    sys.publish("CON",s.."\r\n")
    sys.publish("NET_CMD_MONI",s.."\r\n")
end
--通过这个回调函数响应TTS指令
sys.subscribe("TTS",function(...)
    --通过arg可以从输入的命令行读入参数，并以逗号作为分隔符
    doc=arg[1]
    if doc==nil then doc="朗读内容为空" end
    --b=arg[2]
    --c=arg[3]
    --单次播放，音量等级7
    audio.setStrategy(1)
    audio.play(1,"TTS",doc,7,function() write("TTS,"..doc.."->DONE".."\r\n") end )
end)


--通过消息发送调试信息到串口和网络客户端
function write(s)
    --log.info("testUartTask.write",s)
    sys.publish("CON",s)
    sys.publish("NET_CMD_MONI",s)
end
