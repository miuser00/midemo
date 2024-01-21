--------------------------------------------------------------------------------------------------------------------------------------- 
--版权声明：本demo集源于上海合宙官方技术团队的DEMO（MIT），并参考了合宙开源社区的众多大佬无私分享的代码，包括但不限于 稀饭放姜、Wendal、晨旭、陈夏等
-- 目前参考到的开源项目有： iRTU（MIT)、LuatOS(MIT)、LLCOM(Apache2)
-- 欲获取更多luat 代码请访问 doc.openluat.com
-- 如果您觉得本demo集包含了未经由您授权的代码，请联系 64034373@qq.com 
---------------------------------------------------------------------------------------------------------------------------------------
-- @模块功能：计划任务
-- @author miuser
-- @module midemo.timedtask
-- @license MIT
-- @copyright miuser@luat
-- @release 2021-01-13
--------------------------------------------------------------------------
--帮助系统显示用的模块说明
HELP=[[计划任务]]
HELP=[[功能：在约定的时间执行相应的指令]]
HELP=[[DAYLYRUN,<HOUR>,<MINUTE>,<SECOND>,<COMMAND>,<PARAMETERS>... 在每天特定时间执行一个指令]]
HELP=[[WEEKLYRUN,<WEEKDAY>,<HOUR>,<MINUTE>,<SECOND>,<COMMAND>,<PARAMETERS>... 在每周特定日子和时间执行一个指令,星期一~六是1~6，星期日是0]]
HELP=[[MONTHLYRUN,<MONTHDAY>,<HOUR>,<MINUTE>,<SECOND>,<COMMAND>,<PARAMETERS>... 在每月特定日子和时间执行一个指令]]
HELP=[[YEARLYRUN,<YEARMONTH>,<MONTHDAY>,<HOUR>,<MINUTE>,<SECOND>,<COMMAND>,<PARAMETERS>... 在每年特定日子和时间执行一个指令]]
HELP=[[TIMEDRUN,<YEAR>,<MONTH>,<DAY>,<HOUR>,<MINUTE>,<SECOND>,<COMMAND>,<PARAMETERS>... 在指定日期时间执行一个指令]]
HELP=[[[DELAYEDRUN,<DELAY>,<COMMAND>,<PARAMETERS>... 延迟<DELAY>秒钟后执行一个指令]]
HELP=[[例子:]]
HELP=[[DAYLYRUN,0,40,00,SETGPIO,18,1]]
HELP=[[在每天0:40分整，将GPIO18设置为高电平]]
HELP=[[WEEKLYRUN,1,0,40,00,SETGPIO,18,1]]
HELP=[[在每周一00:40分整，将GPIO18设置为高电平]]
HELP=[[MONTHLYRUN,13,22,40,00,SETGPIO,18,1]]
HELP=[[在每月13号，22:40分整，将GPIO18设置为高电平]]
HELP=[[YEARLYRUN,5,1,08,10,00,SETGPIO,18,1]]
HELP=[[在每年5月1号08:00分零10秒，将GPIO18设置为高电平]]
HELP=[[TIMEDRUN,2022,3,1,13,00,00,SETGPIO,18,1]]
HELP=[[在2022年3月1日13:00:00，将GPIO18设置为高电平]]
HELP=[[DELAYEDRUN,120,SETGPIO,18,1]]
HELP=[[当前时间延迟120秒钟后将GPIO18设置为高电平]]
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

--定时任务表
timedtask={}

--通过这个回调函数可以响应任意的串口或网络发布的命令
sys.subscribe("DAYLYRUN",function(...)
    --将计划任务插入队列
    table.insert(arg,1,"DAYLYRUN")
    table.insert(timedtask,{unpack(arg)})
    --获取时间
    hour=arg[2]
    minute=arg[3]
    second=arg[4]
    cmd=arg[5]

    log.info("timedtask",hour,minute,second,cmd)

    --获取命令的执行参数
    for i=1,5 do
        table.remove(arg,1)
    end
    --将参数转换为字符串
    parastr=""
    for i=1,#arg do
        parastr=parastr..","..arg[i]
    end
    --通过write函数可以向串口和网络上报您的信息
    pub("Planing daily task cmd@"..hour..":"..minute..":"..second.." "..cmd..parastr.."\r\n")
end)

--通过这个回调函数可以响应任意的串口或网络发布的命令
sys.subscribe("WEEKLYRUN",function(...)
    --将计划任务插入队列
    table.insert(arg,1,"WEEKLYRUN")
    table.insert(timedtask,{unpack(arg)})
    --获取时间
    week=tonumber(arg[2])+1
    hour=arg[3]
    minute=arg[4]
    second=arg[5]
    cmd=arg[6]

    log.info("timedtask",week,hour,minute,second,cmd)

    --获取命令的执行参数
    for i=1,6 do
        table.remove(arg,1)
    end
    --将参数转换为字符串
    parastr=""
    for i=1,#arg do
        parastr=parastr..","..arg[i]
    end
    --通过write函数可以向串口和网络上报您的信息
    pub("Planing weekly task cmd@weekday:"..(week-1).." "..hour..":"..minute..":"..second.." "..cmd..parastr.."\r\n")
end)

--通过这个回调函数可以响应任意的串口或网络发布的命令
sys.subscribe("MONTHLYRUN",function(...)
    --将计划任务插入队列
    table.insert(arg,1,"MONTHLYRUN")
    table.insert(timedtask,{unpack(arg)})
    --获取时间
    day=arg[2]
    hour=arg[3]
    minute=arg[4]
    second=arg[5]
    cmd=arg[6]

    log.info("timedtask",day,hour,minute,second,cmd)

    --获取命令的执行参数
    for i=1,6 do
        table.remove(arg,1)
    end
    --将参数转换为字符串
    parastr=""
    for i=1,#arg do
        parastr=parastr..","..arg[i]
    end
    --通过write函数可以向串口和网络上报您的信息
    pub("Planing monthly task cmd@monthday:"..day.." "..hour..":"..minute..":"..second.." "..cmd..parastr.."\r\n")
end)

--通过这个回调函数可以响应任意的串口或网络发布的命令
sys.subscribe("YEARLYRUN",function(...)
    --将计划任务插入队列
    table.insert(arg,1,"YEARLYRUN")
    table.insert(timedtask,{unpack(arg)})
    --获取时间
    month=arg[2]
    day=arg[3]
    hour=arg[4]
    minute=arg[5]
    second=arg[6]
    cmd=arg[7]

    log.info("timedtask",month,day,hour,minute,second,cmd)

    --获取命令的执行参数
    for i=1,7 do
        table.remove(arg,1)
    end
    --将参数转换为字符串
    parastr=""
    for i=1,#arg do
        parastr=parastr..","..arg[i]
    end
    --通过write函数可以向串口和网络上报您的信息
    pub("Planing yearly task cmd@yearday:"..month.."-"..day.." "..hour..":"..minute..":"..second.." "..cmd..parastr.."\r\n")
end)

--通过这个回调函数可以响应任意的串口或网络发布的命令
sys.subscribe("TIMEDRUN",function(...)
    --将计划任务插入队列
    table.insert(arg,1,"TIMEDRUN")
    table.insert(timedtask,{unpack(arg)})
    --获取时间
    year=arg[2]
    month=arg[3]
    day=arg[4]
    hour=arg[5]
    minute=arg[6]
    second=arg[7]
    cmd=arg[8]

    log.info("timedtask",year,month,day,hour,minute,second,cmd)

    --获取命令的执行参数
    for i=1,8 do
        table.remove(arg,1)
    end
    --将参数转换为字符串
    parastr=""
    for i=1,#arg do
        parastr=parastr..","..arg[i]
    end
    --通过write函数可以向串口和网络上报您的信息
    pub("Planing task cmd@datetime:"..year.."-"..month.."-"..day.." "..hour..":"..minute..":"..second.." "..cmd..parastr.."\r\n")
end)


--每秒钟从时钟队列中查询一次是否有任务需要执行
sys.taskInit(function() 
    currsec=nil
    --执行程序的旗标
    togo=false
    while true do
        --获取系统时间
        time=misc.getClock()
        --获取日期
        date=os.date("*t")
        --初始化时间变量
        year,month,day,hour,minute,second=nil,nil,nil,nil,nil,nil
        --log.info("timedtask","0 currsec="..tostring(currsec).." togo="..tostring(togo))
        --设置当前被判断的秒值
        if (currsec~=time["sec"]) then 
            currsec=time["sec"]
            togo=false
        end
        if (togo==false) then 
            --依次判断计划任务表项
            for k, v in ipairs(timedtask) do
                taskitem=v
                log.info("timedtask","determining".."command".."="..taskitem[1])
                if (taskitem[1]=="DAYLYRUN") then
                    hour=tonumber(taskitem[2])
                    minute=tonumber(taskitem[3])
                    second=tonumber(taskitem[4])
                    log.info("timedtask","determining "..hour.."="..time["hour"]..","..minute.."="..time["min"]..","..second.."="..time["sec"])
                    --判断执行时间是否满足
                    if (hour==time["hour"] and minute==time["min"] and second==time["sec"])then 
                        --当前秒程序已经被执行过一次了，防止重复触发
                        togo=true                        
                        --执行指令
                        log.info("timedtask","executing command "..unpack(taskitem,5))
                        pub("Daily task executing@"..hour..":"..minute..":"..second)
                        sys.publish(unpack(taskitem,5))
                        --log.info("timedtask","2 currsec="..tostring(currsec).." togo="..tostring(togo))
                    end
                end
                if (taskitem[1]=="WEEKLYRUN") then
                    week=tonumber(taskitem[2])+1
                    hour=tonumber(taskitem[3])
                    minute=tonumber(taskitem[4])
                    second=tonumber(taskitem[5])
                    log.info("timedtask","determining "..week.."="..date["wday"]..","..hour.."="..time["hour"]..","..minute.."="..time["min"]..","..second.."="..time["sec"])
                    --判断执行时间是否满足
                    if (week==date["wday"] and hour==time["hour"] and minute==time["min"] and second==time["sec"])then 
                        --当前秒程序已经被执行过一次了，防止重复触发                    
                        togo=true 
                        --执行指令
                        log.info("timedtask","executing command "..unpack(taskitem,6))
                        pub("Weekly task executing@weekday:"..(week-1).." "..hour..":"..minute..":"..second)
                        sys.publish(unpack(taskitem,6))
                        --log.info("timedtask","1 currsec="..tostring(currsec).." togo="..tostring(togo))                                          
                    end
                end
                if (taskitem[1]=="MONTHLYRUN") then
                    day=tonumber(taskitem[2])
                    hour=tonumber(taskitem[3])
                    minute=tonumber(taskitem[4])
                    second=tonumber(taskitem[5])
                    log.info("timedtask","determining "..day.."="..time["day"]..","..hour.."="..time["hour"]..","..minute.."="..time["min"]..","..second.."="..time["sec"])
                    --判断执行时间是否满足
                    if (day==date["day"] and hour==time["hour"] and minute==time["min"] and second==time["sec"])then 
                        --当前秒程序已经被执行过一次了，防止重复触发                    
                        togo=true 
                        --执行指令
                        log.info("timedtask","executing command "..unpack(taskitem,6))
                        pub("Monthly task executing@monthday:"..day.." "..hour..":"..minute..":"..second)
                        sys.publish(unpack(taskitem,6))
                        --log.info("timedtask","1 currsec="..tostring(currsec).." togo="..tostring(togo))                                          
                    end
                end
                if (taskitem[1]=="YEARLYRUN") then
                    month=tonumber(taskitem[2])
                    day=tonumber(taskitem[3])
                    hour=tonumber(taskitem[4])
                    minute=tonumber(taskitem[5])
                    second=tonumber(taskitem[6])
                    log.info("timedtask","determining "..month.."="..time["month"]..","..day.."="..time["day"]..","..hour.."="..time["hour"]..","..minute.."="..time["min"]..","..second.."="..time["sec"])
                    --判断执行时间是否满足
                    if (month==date["month"] and day==date["day"] and hour==time["hour"] and minute==time["min"] and second==time["sec"])then 
                        --当前秒程序已经被执行过一次了，防止重复触发                    
                        togo=true 
                        --执行指令
                        log.info("timedtask","executing command "..unpack(taskitem,6))
                        pub("Yearly task executing@monthday:"..month.."-"..day.." "..hour..":"..minute..":"..second)
                        sys.publish(unpack(taskitem,7))
                        --log.info("timedtask","1 currsec="..tostring(currsec).." togo="..tostring(togo))                                          
                    end
                end
                if (taskitem[1]=="TIMEDRUN") then
                    year=tonumber(taskitem[2])
                    month=tonumber(taskitem[3])
                    day=tonumber(taskitem[4])
                    hour=tonumber(taskitem[5])
                    minute=tonumber(taskitem[6])
                    second=tonumber(taskitem[7])
                    log.info("timedtask","determining "..year.."="..time["year"]..","..month.."="..time["month"]..","..day.."="..time["day"]..","..hour.."="..time["hour"]..","..minute.."="..time["min"]..","..second.."="..time["sec"])
                    --判断执行时间是否满足
                    if (year==date["year"] and month==date["month"] and day==date["day"] and hour==time["hour"] and minute==time["min"] and second==time["sec"])then 
                        --当前秒程序已经被执行过一次了，防止重复触发                    
                        togo=true 
                        --执行指令
                        log.info("timedtask","executing command "..unpack(taskitem,6))
                        pub("Timed task executing@datetime:"..year.."-"..month.."-"..day.." "..hour..":"..minute..":"..second)
                        sys.publish(unpack(taskitem,8))
                        --log.info("timedtask","1 currsec="..tostring(currsec).." togo="..tostring(togo))                                          
                    end
                end
            end
        end
        sys.wait(500)
    end
    
end)


--延迟任务
--通过这个回调函数可以响应任意的串口或网络发布的命令
sys.subscribe("DELAYEDRUN",function(...)

    --获取延迟的时间
    second=tonumber(arg[1])
    cmd=arg[2]
    log.info("delayedtask",second)
    table.remove(arg,1)
    table.remove(arg,1)
    --将参数转换为字符串
    parastr=""
    for i=1,#arg do
        parastr=parastr..","..arg[i]
    end
    --通过write函数可以向串口和网络上报您的信息
    pub("Planing delayed task cmd after "..second.."s: "..cmd..parastr.."\r\n")

    sys.timerStart(function(second) 
        pub("Delayed task executing after "..second.."s: "..cmd..parastr.."\r\n")        
        sys.publish(cmd,unpack(arg))
    end,second*1000,second)

end)