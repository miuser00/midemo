--------------------------------------------------------------------------------------------------------------------------------------- 
-- 版权声明：本demo集源于上海合宙官方技术团队的DEMO（MIT），并参考了合宙开源社区的众多大佬无私分享的代码，包括但不限于 稀饭放姜、Wendal、晨旭，等
-- 本模块源码贡献者：月落无声
-- 目前参考到的开源项目有： iRTU（MIT)、LuatOS(MIT)
-- 欲获取更多luat 代码请访问 doc.openluat.com
-- 如果您觉得本demo集包含了未经由您授权的代码，请联系 64034373@qq.com 
---------------------------------------------------------------------------------------------------------------------------------------

-- @模块功能：STH30温湿度传感器读取
-- @driver author 月落无声
-- @modified by miuser
-- @module midemo.sht30
-- @license MIT
-- @copyright 月落无声&miuser@luat
-- @release 2021-02018
--------------------------------------------------------------------------
--帮助系统显示用的模块说明
HELP=[[SHT30温湿度读取模块]]
HELP=[[连线方法：SCL<->SCL,SDA<->SDA,VLCD<-VCC,GND<->GND]]
HELP=[[使用方法]]
HELP=[[SHT30]]
HELP=[[返回当前的温湿度]]
HELP=[[格式为 Temperature:XX.XX ,Humudity:XX.XX]]
HELP=[[例子：]]
HELP=[[SHT30]]
HELP=[[Temperature:27.20 ,Humudity:52.10]]
--------------------------------------------------------------------------
-- @使用方法
-- @发送SHT30，返回当前的温湿度，格式为 Temperature read is XX.XX ,Humudity read is XX.XX
module(..., package.seeall)

local modulename=...
--注册到全局状态表
table.insert(status.INSTALLED,modulename)
--通过消息发送调试信息到串口和网络
function pub(s)
    s="["..(modulename).."]"..s
    sys.publish("CON",s.."\r\n")
    sys.publish("NET_CMD_MONI",s.."\r\n")
end

local function i2c_open(id)
    if i2c.setup(id, i2c.SLOW) ~= i2c.SLOW then
        log.error("I2C.init is: ", "fail")
        log.error("I2C.init plis: ", i2c.setup(id, i2c.SLOW))
        i2c.close(id)
        return
    end
    return i2c.SLOW
end

function sht30read(id)
    local   temp,hum
    i2c.send(id,0x44,{0x2c,0x06})
    local sht30_data = i2c.recv(id,0x44,6)
    if sht30_data == nil then sht30_data = 0 end
    log.info("SHT30 HEX DATA:",string.toHex(sht30_data," "))
    if sht30_data ~= 0 then
    local _,h_H,h_L,h_crc,t_H,t_L,t_crc = pack.unpack(sht30_data,'b6')
    if h_H == nil then return end
        temp = ((1750*(h_H*256+h_L)/65535-450))*10
        hum = ((1000*(t_H*256+t_L)/65535))*10
        temp=tostring(temp/100).."." ..tostring(temp%100)
        hum=tostring(hum/100).."." ..tostring(hum%100)
        log.warn("SHT30 temp,humi:",temp,hum)
        return  temp,hum
    end
end

--通过这个回调函数可以响应任意的串口或网络发布的命令
sys.subscribe("SHT30",function(...)
    --通过arg可以从输入的命令行读入参数，并以逗号作为分隔符
    --a=arg[1]
    --b=arg[2]
    --c=arg[3]
    temp,hum=sht30read(2)
    pub("Temperature:"..temp..",Humudity:"..hum)
end)
