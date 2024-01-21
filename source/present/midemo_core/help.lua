--------------------------------------------------------------------------------------------------------------------------------------- 
-- 版权声明：本demo集源于上海合宙官方技术团队的DEMO（MIT），并参考了合宙开源社区的众多大佬无私分享的代码，包括但不限于 稀饭放姜、Wendal、晨旭等
-- 目前参考到的开源项目有： iRTU（MIT)、LuatOS(MIT)
-- 欲获取更多luat 代码请访问 doc.openluat.com
-- 如果您觉得本demo集包含了未经由您授权的代码，请联系 64034373@qq.com 
---------------------------------------------------------------------------------------------------------------------------------------

-- @模块功能：帮助模块
-- @author 作者
-- @module midemo.help
-- @license MIT
-- @copyright miuser@luat
-- @release 2021-02-09
----------------------------------
--帮助系统显示用的模块说明
HELP=[[欢迎使用midemo物联网开源框架]]
HELP=[[输入HELP,<模块名> 可以查询对应模块的功能]]
HELP=[[例子:]]
HELP=[[输入：HELP,BIO 可以查询双向IO模块使用方法]]
HELP=[[命令和模块名不用区分大小写]]
HELP=[[输入：HELPALL 可以查询所有模块的使用方法]]
module(...,package.seeall)

sys.subscribe("HELPALL",function(...)
    sys.taskInit(function() 
        for index, value in ipairs(midemo.LOAD_MODULE) do
            sys.publish("HELP",value)
            pub("---------------")
            sys.wait(500)
        end
    end) 
end)
--通过这个回调函数可以响应任意的串口或网络发布的命令
sys.subscribe("HELP",function(...)
    --得到要查询的模块名
    local modulename=""
    if (arg[1]==nil) then 
        modulename="help" 
    else
        modulename=string.gsub(arg[1]," ","")
        modulename=string.lower(modulename)
    end
    if (modulename=="") then modulename="help" end
    local filename="/lua/"..modulename..".lua"
    --log.info("help","opening lua file ",filename)

    local filehandle=io.open(filename,"r")--第一个参数是文件名，第二个是打开方式，'r'读模式,'w'写模式，对数据进行覆盖,'a'附加模式,'b'加在模式后面表示以二进制形式打开
    if filehandle then          --判断文件是否存在
        --只读取最前面的100行帮助信息
        for i=1,100 do
            local fileval=filehandle:read("*l")--读出文件内容
            if  fileval then
                --log.info("help","proceeding help line ",fileval)
                local trimline=string.gsub(fileval," ","")
                local header=string.sub(trimline,1,5)
                --帮助信息被定义为一个字符串，形如HELP="ABC"，其中ABC为真实的帮助内容。
                --之所以如此定义，是因为非运行类代码会被luatool丢弃掉
                if (header=="HELP=") then
                    local head,tail=string.find(fileval,"HELP=")
                    local helpcontent=string.sub(fileval,tail+3,#fileval-2)
                    pub(helpcontent)
                end
            else
                filehandle:close()--关闭文件
                break
            end            
        end

    else 
        pub("指定模块不存在") --打开失败
    end 

end)


local modulename=...
--注册到全局状态表
table.insert(status.INSTALLED,modulename)
--通过消息发送调试信息到串口和网络
function pub(s)
    --s="["..(modulename).."]"..s
    sys.publish("CON",s.."\r\n")
    sys.publish("NET_CMD_MONI",s.."\r\n")
end



function split( str,reps )
    local resultStrList = {}
    string.gsub(str,'[^'..reps..']+',function ( w )
        table.insert(resultStrList,w)
    end)
    return resultStrList
end