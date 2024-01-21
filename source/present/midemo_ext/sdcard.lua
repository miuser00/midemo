
--------------------------------------------------------------------------------------------------------------------------------------- 
--版权声明：本demo集源于上海合宙官方技术团队的DEMO（MIT），并参考了合宙开源社区的众多大佬无私分享的代码，包括但不限于 稀饭放姜、Wendal、晨旭等
-- 目前参考到的开源项目有： iRTU（MIT)、LuatOS(MIT)
-- 欲获取更多luat 代码请访问 doc.openluat.com
-- 如果您觉得本demo集包含了未经由您授权的代码，请联系 64034373@qq.com
---------------------------------------------------------------------------------------------------------------------------------------

-- @模块功能：SD卡读写模块
-- @author miuser
-- @module midemo.sdcard
-- @license MIT
-- @copyright miuser@luat
-- @release 2021-08-10
--------------------------------------------------------------------------
--帮助系统显示用的模块说明
HELP=[[SD卡读写模块]]
HELP=[[本模块可以从SD卡将文件读入字符串，将字符串保存到文件，或者播放特定MP3文件]]
HELP=[[使用方法]]
HELP=[[DIR]]
HELP=[[列出当前SD卡中的文件]]
HELP=[[SAVESD,filename,str]]
HELP=[[把字符串str中存放的内容保存在filename里]]
HELP=[[LOADSD,filename,str]]
HELP=[[打开并显示SD卡根目录的文件filename中的内容]]
HELP=[[PLAYSD,filename]]
HELP=[[播放SD卡中的名字为filename的MP3文件]]
HELP=[[PLAYSDSTOP]]
HELP=[[停止播放当前正在播放的音乐文件]]
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

--sys.timerStart(function() 
    --挂载SD卡,返回值0表示失败，1表示成功
    io.mount(io.SDCARD)
        --第一个参数1表示sd卡
        --第二个参数1表示返回的总空间单位为KB
    local sdCardTotalSize = rtos.get_fs_total_size(1,1)
    log.info("sdcard","sd card total size "..sdCardTotalSize.." KB")
    --第一个参数1表示sd卡
    --第二个参数1表示返回的总空间单位为KB
    local sdCardFreeSize = rtos.get_fs_free_size(1,1)
    log.info("sdcard","sd card free size "..sdCardFreeSize.." KB")
    
--end,5000)


--通过这个回调函数可以响应任意的串口或网络发布的命令
sys.subscribe("DIR",function(...)
    --通过arg可以从输入的命令行读入参数，并以逗号作为分隔符
    --a=arg[1]
    --b=arg[2]
    --c=arg[3]
    --遍历读取sd卡根目录下的最多10个文件或者文件夹
    if io.opendir("/sdcard0") then
        pub("Files on SD Card was listed".."\r\n")
        for i=1,100 do
            local fType,fName,fSize = io.readdir()
            if fType~=nil then
                log.info("sd card file",fName,fSize)
                --列出文件内容
                sfType="---"
                if(fType==32) then sfType="FILE" end
                if(fType==16) then sfType="DIR " end
                local headstr="<"..tostring(sfType)..">".."   "..fName
                local fill=""
                local filllen=0
                filllen=32-#headstr
                if filllen<=0 then filllen=4 end
                for j=0,filllen,1 do fill=fill.." " end
                if fSize==-1 then fSize="0" end
                pub(headstr..fill..fSize.."kB   ".."\r\n")
                elseif fType == nil then
                break
            end
        end        
        io.closedir("/sdcard0")
    end    
end)

--把字符串保存在SD卡中
sys.subscribe("SAVESD",function(...)
    --通过arg可以从输入的命令行读入参数，并以逗号作为分隔符
    local filename=arg[1]
    local str=arg[2]
    --c=arg[3]
    --遍历读取sd卡根目录下的最多10个文件或者文件夹
    --向sd卡根目录下写入一个pwron.mp3
    io.writeFile("/sdcard0/"..filename,str)
    pub("String saved")
end)

--从SD卡文件中读取字符串
sys.subscribe("LOADSD",function(...)
    --通过arg可以从输入的命令行读入参数，并以逗号作为分隔符
    local filename=arg[1]
    --遍历读取sd卡根目录下的最多10个文件或者文件夹
    --向sd卡根目录下写入一个pwron.mp3
    local str=io.readFile("/sdcard0/"..filename)
    pub(str)
end)


--播放一个SD卡的MP3文件
sys.subscribe("PLAYSD",function(...)
    --通过arg可以从输入的命令行读入参数，并以逗号作为分隔符
    local filename=arg[1]
    --播放MP3文件
    if audio.play(0,"FILE","/sdcard0/"..filename,audiocore.VOL7,function() sys.publish("AUDIO_PLAY_END") end) then
        pub("PLAYSD started")
    end

end)


--从耳机输出
sys.subscribe("USESPEAKER",function(...)

    audio.setChannel(0)

end)

--从耳机输出
sys.subscribe("USEPHONE",function(...)

    audio.setChannel(0)

end)


sys.subscribe("AUDIO_PLAY_END",function(...)
    pub("PLAYSD ended")
end)

--播放一个SD卡的MP3文件
sys.subscribe("PLAYSDSTOP",function(...)
    audio.stop()
end)
