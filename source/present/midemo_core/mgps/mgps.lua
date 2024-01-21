--------------------------------------------------------------------------------------------------------------------------------------- 
--版权声明：本demo集源于上海合宙官方技术团队的DEMO（MIT），并参考了合宙开源社区的众多大佬无私分享的代码，包括但不限于 稀饭放姜、Wendal、晨旭等
-- 目前参考到的开源项目有： iRTU（MIT)、LuatOS(MIT)
-- 欲获取更多luat 代码请访问 doc.openluat.com
-- 如果您觉得本demo集包含了未经由您授权的代码，请联系 64034373@qq.com 
---------------------------------------------------------------------------------------------------------------------------------------

-- @模块功能：GPS查询功能
-- @author miuser
-- @module midemo.mgps
-- @license MIT
-- @copyright miuser@luat
-- @release 2020-10-05
--------------------------------------------------------------------------
HELP=[[GPS定位模块]]
HELP=[[作用:通过外部连接Air530GPS模块实现GPS定位，GPS端口号和波特率可以在midemo.bs中设置，默认为COM1]]
HELP=[[使用方法]]
HELP=[[通过GETGPS命令查询GPS状态"]]
HELP=[[返回如下格式数据:Satellite Located:TRUE/FALSE,Longitude:XX.XXXXX,Latitude:XX.XXXXX,Altitude:XX.XXXXX,Speed:xx.xxxxx,Course,XX.XXXXX,ViewedSatelliteCount:XX,UsedSatelliteCount:XX]]
--------------------------------------------------------------------------

module(...,package.seeall)
--适用于合宙air530z模块
local gps = require"mgpsZkw"

local modulename=...
--注册到全局状态表
table.insert(status.INSTALLED,modulename)

--通过消息发送调试信息到串口和网络
function pub(s)
    s="["..(modulename).."]"..s
    sys.publish("CON",s.."\r\n")
    sys.publish("NET_CMD_MONI",s.."\r\n")
end

--通过消息发送调试信息到串口和网络
function write(s)
    sys.publish("CON",s.."\r\n")
    sys.publish("NET_CMD_MONI",s.."\r\n")
end



--GPS功能使用的COM口号
local GPSCOM=midemo.GPSCOM or 1
local GPSBaudRate=midemo.GPSBaudRate or 9600

pub("CON"..GPSCOM.." was occupied by GPS")


FIXED=0
Longitude=0
Latitude=0
Altitude=0
Speed=0
Course=0
ViewedSatelliteCount=0
UsedSatelliteCount=0

local function printGps()
    if gps.isOpen() then
        local tLocation = gps.getLocation()
        local speed = gps.getSpeed()
        --保存GPS参数
        FIXED=gps.isFix()
        Longitude=tLocation.lngType..tLocation.lng
        Latitude=tLocation.latType..tLocation.lat
        Altitude=gps.getAltitude()
        Speed= gps.getSpeed()
        Course=gps.getCourse()
        ViewedSatelliteCount=gps.getViewedSateCnt()
        UsedSatelliteCount=gps.getUsedSateCnt()     

        log.info("midemo.mgps","satllite information",
            FIXED,
            Longitude,Latitude,
            Altitude,
            Speed,
            Course,
            ViewedSatelliteCount,
            UsedSatelliteCount)


    end
end


local function gpsCb(tag)
    log.info("midemo.mgps","gps status changed",tag)
    if (string.find(tag,"OPENED")) then write ("GPS Connected") end
    if (string.find(tag,"CLOSED")) then write ("GPS Disconnected") end
end

--gps.setPowerCbFnc，设置串口通信参数，Air530z的波特率为9600
gps.setUart(GPSCOM,GPSBaudRate,8,uart.PAR_NONE,uart.STOP_1)
--GPS就会一直开启，永远不会关闭
gps.open(gps.DEFAULT,{tag="OPENGPS",cb=gpsCb})
sys.timerLoopStart(printGps,3000)


--通过这个回调函数可以响应任意的串口或网络发布的命令
sys.subscribe("GETGPS",function(...)
    --通过arg可以从输入的命令行读入参数，并以逗号作为分隔符
    --a=arg[1]
    --b=arg[2]
    --c=arg[3]
    --通过write函数可以向串口和网络上报您的信息
    pub("GPSLocated:"..tostring(FIXED)..",Longitude:"..tostring(Longitude)..",Latitude:"..tostring(Latitude)..",Altitude:"..tostring(Altitude)..",Speed:"..tostring(Speed)..",Course:"..tostring(Course)..",ViewedSatelliteCount:"..tostring(ViewedSatelliteCount)..",UsedSatelliteCount:"..tostring(UsedSatelliteCount).."\r\n")
end)
