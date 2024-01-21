--------------------------------------------------------------------------------------------------------------------------------------- 
--版权声明：本demo集源于上海合宙官方技术团队的DEMO（MIT），并参考了合宙开源社区的众多大佬无私分享的代码，包括但不限于 稀饭放姜、Wendal、晨旭等
-- 目前参考到的开源项目有： iRTU（MIT)、LuatOS(MIT)
-- 欲获取更多luat 代码请访问 doc.openluat.com
-- 如果您觉得本demo集包含了未经由您授权的代码，请联系 64034373@qq.com 
---------------------------------------------------------------------------------------------------------------------------------------

-- @模块功能：TTSPLUS补丁版播报
-- @author miuser
-- @module midemo.ttsplus
-- @license MIT
-- @copyright miuser@luat
-- @release 2020-09-30
--------------------------------------------------------------------------
--帮助系统显示用的模块说明
HELP=[[ttsplus模块]]
HELP=[[功能：文本朗读，在官方库基础上增加了几个符号的朗读]]
HELP=[[使用TTSPLUS,XXX 则朗读对应的XXX]]
HELP=[[朗读完成后，系统会收到TTSPLUS,XXX->DONE的消息]]
HELP=[[使用TTS,XXX 则使用原生库朗读对应的XXX]]
HELP=[[朗读完成后，系统会收到TTS,XXX->DONE的消息]]
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
    --
end)

--通过这个回调函数响应PLUS指令(英文字母补丁)
sys.subscribe("PLUS",function(...)
    --通过arg可以从输入的命令行读入参数，并以逗号作为分隔符
    doc=arg[1]
    if doc==nil then doc="朗读内容为空" end
    --b=arg[2]
    --c=arg[3]
    --单次播放，音量等级7
    audio.setStrategy(1)
    PLUS(doc)
    --write("PLUS:"..doc)
end)
--通过这个回调函数响应TTSPLUS指令
sys.subscribe("TTSPLUS",function(...)
    --通过arg可以从输入的命令行读入参数，并以逗号作为分隔符
    doc=arg[1]
    if doc==nil then doc="朗读内容为空" end
    sdoc,type=TTS_Split(doc)

    sys.taskInit(function()
        for i=1,#type do
            if (type[i]=="tts") then
                audio.play(1,"TTS",sdoc[i],7,function() sys.publish("PLAY_"..sdoc[i].."_DONE") end )
                result, data = sys.waitUntil("PLAY_"..sdoc[i].."_DONE", 30000)
            else
                PLUS(sdoc[i])
                result, data = sys.waitUntil("PLAY_"..sdoc[i].."_DONE", 30000)
            end
        end
        write("TTSPLUS,"..doc.."->DONE".."\r\n")
    end)   

end)


--通过消息发送调试信息到串口和网络客户端
function write(s)
    --log.info("testUartTask.write",s)
    sys.publish("CON",s)
    sys.publish("NET_CMD_MONI",s)
end


function TTS_Split(input)
    --按照TTS是否包含数字，字母符号等不可直接发音的元素进行分段
    local ttsdoc={}
    --和上面的数组对其，如果段落对应的字符串为"tts"，则TTS支持直接发音，如果为"mp3"则需要通过播放MP3文件实现
    local ttstype={}

    --读取到的内容
    part=""
    --当前状态
    curr="tts"
    for i=1,#input do
        letter=input:sub(i,i)
        --是需要mp3发音的字符
        if (letter:find("*")or letter:find("?")or letter:find("+")or letter:find("-")or letter:find("#")) then
            ----小写字母转大写字母
            --if (string.byte(letter)>96 and string.byte(letter)<123) then letter=string.char((string.byte(letter)-32)) end
            --模式切换，先保存切换前的文字到数组
            if (curr=="tts") then 
                table.insert(ttsdoc,part)
                table.insert(ttstype,"tts")
                log.info("midemo.tts","collected ",part)
                log.info("midemo.tts","type is ","tts")
                part=""
            end
            curr="mp3"
            part=part..letter
        else
            if (curr=="mp3") then 
                table.insert(ttsdoc,part)
                table.insert(ttstype,"mp3")
                log.info("midemo.tts","collected ",part)
                log.info("midemo.tts","type is ","mp3")
                part=""
            end
            curr="tts"
            part=part..letter
        end
    end
    table.insert(ttsdoc,part)
    table.insert(ttstype,curr)

    log.info("midemo.tts","ttsdoc",unpack(ttsdoc))
    log.info("midemo.tts","ttstype",unpack(ttstype))
    return ttsdoc,ttstype

end


function Play(filename)
    file,err=io.open("/lua/"..filename..(".mp3"))
    if (err~=nil) then 
        return
    else
        io.close(file)
    end
    audio.setStrategy(1)
    audio.play(1,"FILE","/lua/"..filename..(".mp3"),7,function() sys.publish("PLAY_"..filename.."_DONE") end)
end

--判断是否在播放中
playing=0
--是否中断当前播放
breakplay=0
function plusplay(s)
    result, data = sys.waitUntil("READY_TO_PLAY", 3000)
    playing=1
    for i=1,#s do
        filename=s:sub(i,i)
        if (filename=="*") then filename="Xing" end
        if (filename=="?") then filename="Wen" end
        if (filename=="+") then filename="Jia" end
        if (filename=="-") then filename="Jian" end
        if (filename=="#") then filename="Jing" end
        Play(filename)
        result, data = sys.waitUntil("PLAY_"..filename.."_DONE", 2000)
        if result == false then
            log.info("midemo.tts","ttsplus file play fail")
        end
        sys.wait(50)
        if (breakplay==1) then 
            log.info("midemo.tts","plusplay was broken") 
            sys.publish("READY_TO_PLAY")
            breakplay=0
            break
        end
    end
    playing=0
    sys.publish("PLAY_"..s.."_DONE")
end

function PLUS(s)
    sys.taskInit(plusplay,s)
    if (playing==0) then
        sys.publish("READY_TO_PLAY")
    else
        breakplay=1
    end
end
