--------------------------------------------------------------------------------------------------------------------------------------- 
--版权声明：本demo集源于上海合宙官方技术团队的DEMO（MIT），并参考了合宙开源社区的众多大佬无私分享的代码，包括但不限于 稀饭放姜、Wendal、晨旭、陈夏等
-- 目前参考到的开源项目有： iRTU（MIT)、LuatOS(MIT)、LLCOM
-- 欲获取更多luat 代码请访问 doc.openluat.com
-- 如果您觉得本demo集包含了未经由您授权的代码，请联系 64034373@qq.com，如有侵权嫌疑将立即纠正
---------------------------------------------------------------------------------------------------------------------------------------
--- 模块功能：核心板适配文件，适配硬件版本Cat1 Phone Core V2b
-- @author miuser
-- @module midemo.bs
-- @license MIT
-- @copyright miuser@luat
-- @release 2021-01-27
--------------------------------------------------------------------------
module(...,package.seeall)

require "pins"

--等待系统初始化完成后加载功能模块，此处不要删除
sys.timerStart(function()
--------------------------------------------------------------------
--                                                                 -
--                           生成模块识别信息                        -
--                                                                 -
--------------------------------------------------------------------
--模块IMEI号
status.IMEI= misc.getImei()
--模块ID
status.ID=string.sub(status.IMEI,-10)
--模块出厂序列号
status.SN = misc.getSn()
--模块密码
status.MM="00"..status.SN
--基站定位
reqLbsLoc()
--定位状态，0表示成功，其他表示失败
status.isLocated=isLocated
--string类型，经度
status.LONGITUDE=LONGITUDE
--string类型，纬度
status.LATITUDE=LATITUDE

--------------------------------------------------------------------
--                                                                 -
--                           核心模块加载表                         -
--                                                                 -
--------------------------------------------------------------------
function table.contains(table, element)
    for _, value in pairs(table) do
      if value == element then
        return true
      end
    end
    return false
  end

--加载air153看门狗模块
if table.contains(midemo.LOAD_MODULE,"air153") then require "air153" end
--加载控制台映射模块
if table.contains(midemo.LOAD_MODULE,"mconsole") then require "mconsole" end
--加载LED灯模块
if table.contains(midemo.LOAD_MODULE,"ledp") then require "ledp" end
--加载独立硬件串口模块
if table.contains(midemo.LOAD_MODULE,"com") then require "com" end
--加载iRTU适配器
if table.contains(midemo.LOAD_MODULE,"irtu_init") then require "irtu_init" end
--iRTU核心
if table.contains(midemo.LOAD_MODULE,"default") then require "default" end
--加载后清理工作
if table.contains(midemo.LOAD_MODULE,"irtu_over") then require "irtu_over" end
--加载upws服务连接程序
if table.contains(midemo.LOAD_MODULE,"upws") then require "upws" end
--加载阿里云服务连接程序
if table.contains(midemo.LOAD_MODULE,"maliyun") then require "maliyun" end
--加载mqtt服务连接程序
if table.contains(midemo.LOAD_MODULE,"mmqtt") then require "mmqtt" end
--根据bs设置，决定是否加载OLED显示屏驱动
if table.contains(midemo.LOAD_MODULE,"oled") then require "oled" end
--加载IO输出驱动
if table.contains(midemo.LOAD_MODULE,"gpo") then require "gpo" end
--加载双向IO驱动
if table.contains(midemo.LOAD_MODULE,"bio") then require "bio" end
--加载按钮模块
if table.contains(midemo.LOAD_MODULE,"btn") then require "btn" end
--加载命令解释模块
if table.contains(midemo.LOAD_MODULE,"cmd") then require "cmd" end
--加载电源按键模块
if table.contains(midemo.LOAD_MODULE,"mkey") then require "mkey" end
--加载打电话模块
if table.contains(midemo.LOAD_MODULE,"onedial") then require "onedial" end
--打补丁后的语音朗读模块（占用100kflash）
if table.contains(midemo.LOAD_MODULE,"ttsplus") then require "ttsplus" end
--原生语音朗读模块，与 TTSPLUS二选一加载即可
if table.contains(midemo.LOAD_MODULE,"tts") then require "tts" end
--短信收发
if table.contains(midemo.LOAD_MODULE,"trsms") then require "trsms" end
--根据bs设置，决定是否加载WS2812Matrix显示屏驱动
if table.contains(midemo.LOAD_MODULE,"ws2812bmatrix") then require "ws2812bmatrix" end
--根据bs设置，决定是否加载Hyperstepper开源电机驱动
if table.contains(midemo.LOAD_MODULE,"hyperstepper") then require "hyperstepper" end
--加载GPS模块
if table.contains(midemo.LOAD_MODULE,"mgps") then require "mgps" end
--加载st7735显示屏
if table.contains(midemo.LOAD_MODULE,"st7735") then require "st7735" end
--加载gc9a01显示屏
if table.contains(midemo.LOAD_MODULE,"gc9a01") then require "gc9a01" end
--SHT30读取模块
if table.contains(midemo.LOAD_MODULE,"sht30") then require "sht30" end
--ADC读取模块
if table.contains(midemo.LOAD_MODULE,"madc") then require "madc" end
--SD读取模块
if table.contains(midemo.LOAD_MODULE,"sdcard") then require "sdcard" end
-- 加载帮助模块
if table.contains(midemo.LOAD_MODULE,"help") then require "help" end
-- 加载计划任务模块
if table.contains(midemo.LOAD_MODULE,"timedtask") then require "timedtask" end
--------------------------------------------------------------------
--                                                                 -
--                           三方模块加载表                         -
--                                                                 -
--------------------------------------------------------------------
--外部模块DEMO
require "demo"
--------------------------------------------------------------------
--                                                                 -
--                           开机提示信息                           -
--                                                                 -
--------------------------------------------------------------------

local installedpackages=""
for i=1,#status.INSTALLED do
    installedpackages=installedpackages.."|"..status.INSTALLED[i]
end
pub("Loaded modules...")
pub(installedpackages.."|")
pub("------------------------------------------------------")
pub("-                   midemo was running...            -")
pub("------------------------------------------------------")

pub("-  ID="..status.ID.."                                     -")
--pub("-  IMEI="..status.IMEI.."                              -")
pub("-  MM="..status.MM.."                               -")
pub("------------------------------------------------------")
--此处不要删除
end , 3000)


--------------------------------------------------------------
---------以下内容为内部函数，不需要用户修改--------------------
--------------------------------------------------------------



--isLocated：number类型，0表示成功，1表示网络环境尚未就绪，2表示连接服务器失败，3表示发送数据失败，4表示接收服务器应答超时，5表示服务器返回查询失败；为0时，后面的3个参数才有意义
--LATITUDE：string类型，纬度，整数部分3位，小数部分7位，例如031.2425864
--LONGITUDE：string类型，经度，整数部分3位，小数部分7位，例如121.4736522
LONGITUDE=0
LATITUDE=0
isLocated=0

--基站定位
function reqLbsLoc()   
    lbsLoc.request(getLocCb)
end
--获取基站对应的经纬度后的回调函数
function getLocCb(result,lat,lng)
    log.info("bs.getLocCb",result,lat,lng)
    isLocated=result
    LATITUDE=lat
    LONGITUDE=lng

    --获取经纬度成功
    if result==0 then
    --失败
    else
    end
    sys.timerStart(reqLbsLoc,20000)
end


VLCD=midemo.VLCD or 16
VMMC=midemo.VMMC or 2

--电压域设定
pmd.ldoset(VLCD,pmd.LDO_VLCD)
pmd.ldoset(VMMC,pmd.LDO_VMMC)


--通过消息发送调试信息到串口和网络
function pub(s)
    sys.publish("CON",s.."\r\n")
    sys.publish("NET_CMD_MONI",s.."\r\n")
end

--根据irtu里的socket通讯信号获取连接状态
sys.subscribe("CHANNEL_STATUS",function(channel,stat)
    log.info("bs","CHANNEL_STATUS",channel,stat)
    if (channel==1) then
        if (stat==1) then 
            log.info("bs","Reset timer counter to 60s")
            upwstimeout=60
        end
        if (stat==1 and status.UPWS_CONNECTION==false) then
            status.UPWS_CONNECTION=true
            log.info("bs","Upws Connected")
            pub("Upws Connected")
            sys.publish("UPWS_CONNECTED",1)
        elseif (stat==0 and status.UPWS_CONNECTION==true) then
            status.UPWS_CONNECTION=false
            log.info("bs","Upws Disconnected")
            pub("Upws Disconnected")
            sys.publish("UPWS_CONNECTED",0)
        end
    elseif  (channel==2) then
        if (stat==1 and status.MQTT_CONNECTION==false) then
            status.MQTT_CONNECTION=true
            log.info("bs","Mqtt Connected")
            pub("Mqtt Connected")
            sys.publish("MQTT_CONNECTED",1)
        elseif (stat==0 and status.MQTT_CONNECTION==true) then
            status.MQTT_CONNECTION=false
            log.info("bs","Mqtt Disconnected")
            pub("Mqtt Disconnected")
            sys.publish("MQTT_CONNECTED",0)
        end
    elseif  (channel==3) then
        if (stat==1 and status.ALIYUN_CONECTION==false) then
            status.ALIYUN_CONECTION=true
            log.info("bs","Aliyun Connected")
            pub("Aliyun Connected")
            sys.publish("ALIYUN_CONNECTED",1)
        elseif (stat==0 and status.ALIYUN_CONECTION==true) then
            status.ALIYUN_CONECTION=false
            log.info("bs","Aliyun Disconnected")
            pub("Aliyun Disconnected")
            sys.publish("ALIYUN_CONNECTED",0)
        end
    end
end)

--由于UPWS是面向无连接的，所以只能靠检测心跳来判断是否掉线
upwstimeout=0
sys.timerLoopStart(function()
    upwstimeout=upwstimeout-1 
    if (upwstimeout<0 and status.UPWS_CONNECTION==true) then
        status.UPWS_CONNECTION=false
        log.info("bs","Upws connection timeout",upwstimeout)
        pub("Upws Disconnected")
        sys.publish("UPWS_CONNECTED",0)
    end
end, 1000)


--根据onedial里的电话通讯信号获取连接状态
sys.subscribe("CALL_STATUS",function(stat)
    status.CALL_STATUS=stat
end)

