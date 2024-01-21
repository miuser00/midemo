--------------------------------------------------------------------------------------------------------------------------------------- 
--版权声明：本demo集源于上海合宙官方技术团队的DEMO（MIT），并参考了合宙开源社区的众多大佬无私分享的代码，包括但不限于 稀饭放姜、Wendal、晨旭等
-- 目前参考到的开源项目有： iRTU（MIT)、LuatOS(MIT)
-- 欲获取更多luat 代码请访问 doc.openluat.com
-- 如果您觉得本demo集包含了未经由您授权的代码，请联系 64034373@qq.com 
---------------------------------------------------------------------------------------------------------------------------------------

-- @模块功能：ADC读取模块
-- @author 作者
-- @module midemo.madc
-- @license MIT
-- @copyright miuser@luat
-- @release 2021-08-08
--------------------------------------------------------------------------
--帮助系统显示用的模块说明
HELP=[[ADC读取模块]]
HELP=[[功能：从模块ADC读取电压值]]
HELP=[[使用方法]]
HELP=[[GETADC,adcport 获取ADC端口的值，端口为1,2,3，其中端口为VBAT电压，该输出有延迟效应]]
HELP=[[收到指令后，系统马上返回ADC端口的电压]]
HELP=[[ADC,1,3800mV ,代表ADC1端口电压为3.8V]]

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

--通过这个回调函数可以响应任意的串口或网络发布的命令
sys.subscribe("GETADC",function(...)
    --通过arg可以从输入的命令行读入参数，并以逗号作为分隔符
    adcport=tonumber(arg[1])
    if (adcport==1) then 
        local voltage=misc.getVbatt()
        pub("ADC,1,"..voltage.."mV".."\r\n")
    elseif (adcport==2 or adcport==3) then 
        local dac,voltage=adc.read(adcport)
        pub("ADC,"..adcport..","..voltage.."mV")
    end
end)
