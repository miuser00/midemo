--------------------------------------------------------------------------------------------------------------------------------------- 
--版权声明：本demo集源于上海合宙官方技术团队的DEMO（MIT），并参考了合宙开源社区的众多大佬无私分享的代码，包括但不限于 稀饭放姜、Wendal、晨旭等
-- 目前参考到的开源项目有： iRTU（MIT)、LuatOS(MIT)
-- 欲获取更多luat 代码请访问 doc.openluat.com
-- 如果您觉得本demo集包含了未经由您授权的代码，请联系 64034373@qq.com 
---------------------------------------------------------------------------------------------------------------------------------------

-- @模块功能：iRTU固件执行前适配
-- @author miuser
-- @module midemo.irtu_init
-- @license MIT
-- @copyright miuser@luat
-- @release 2020-09-08
--------------------------------------------------------------------------
------------------------iRTU配置信息---------------------------------
--通过修改当前目录的irtu.json，可以对iRTU模块初始状态进行配置
--通过create.getDatalink()函数获取iRTU服务器连接状态 true为已经连接
--通过sys.publish("NET_SENT_RDY_1",str)向服务器发送数据
--通过 sys.subscribe("NET_RECV_WAIT_1", function(msg) ...end) 接收服务器发送来的数据

--------------------------------------------------------------------------

require "bs"
--以下部分的代码无须用户修改
module(..., package.seeall)
--_G.PRODUCT_KEY = "DPVrZXiffhEUBeHOUwOKTlESam3aXvnR"
--iRTU的缺省配置文件，描述了首次烧写后的iRTU行为
CONFIG="irtuupws.json"

local modulename=...
--注册到全局状态表
table.insert(status.INSTALLED,"irtu")
--通过消息发送调试信息到串口和网络
function pub(s)
    s="["..(modulename).."]"..s
    sys.publish("CON",s.."\r\n")
    sys.publish("NET_CMD_MONI",s.."\r\n")
end

local function readfile(filename)--打开指定文件并输出内容
    
    local filehandle=io.open(filename,"r")--第一个参数是文件名，第二个是打开方式，'r'读模式,'w'写模式，对数据进行覆盖,'a'附加模式,'b'加在模式后面表示以二进制形式打开
    if filehandle then          --判断文件是否存在
        local fileval=filehandle:read("*all")--读出文件内容
      if  fileval  then
           print(fileval)  --如果文件存在，打印文件内容
           filehandle:close()--关闭文件
           return fileval
      else 
           print("The file is empty")--文件不存在
      end
    else 
        print("文件不存在或文件输入格式不正确") --打开失败  
    end    
end


local function writevalw(filename,value)--在指定文件中添加内容
    local filehandle = io.open(filename,"w")--第一个参数是文件名，后一个是打开模式'r'读模式,'w'写模式，对数据进行覆盖,'a'附加模式,'b'加在模式后面表示以二进制形式打开
    if filehandle then
        filehandle:write(value)--写入要写入的内容
        filehandle:close()
    else
        log.info("midemo.irtu_adapter","irtu适配文件不存在或文件输入格式不正确") 
    end
end
CONFIG="/lua/"..CONFIG

content=readfile(CONFIG)
config=json.decode(content)

--第一个通道的配置 （id=1）
--TCP协议或UDP协议
config["conf"][1][1]="udp"
--用户自定义的心跳包,只支持数字和字母,建议2-4个字节
config["conf"][1][2]=""
--链接超时最大时间单位秒,默认300秒
config["conf"][1][3]="0"
--socket的地址或域名
config["conf"][1][4]=midemo.UPWS_SERVER or "box.miuser.net"
--socket服务器的端口号
config["conf"][1][5]=midemo.UPWS_PORT or "7101"
--TCP通道捆绑的串口ID
config["conf"][1][6]=1
--自动采集间隔时长，单位秒。不用该功能填0或空
config["conf"][1][7]=""
--自动采集采样时长，单位秒。不用该功能填0或空
config["conf"][1][8]=""
--自动定时采集任务间隔时间,单位秒。不用就填空
config["conf"][1][9]=""
--启用填ssl，不启用留空
config["conf"][1][10]=""

--第二个通道的配置 （id=2）
--MQTT协议
config["conf"][2][1]="mqtt"
--MQTT心跳包的间隔单位秒,默认300
config["conf"][2][2]="300"
--自动定时采集任务间隔时间,单位秒。,默认1800秒
config["conf"][2][3]="1800"
--MQTT的地址或域名
config["conf"][2][4]=midemo.MQTT_SERVER or "box.miuser.net"
--socket服务器的端口号
config["conf"][2][5]=midemo.MQTT_PORT or "1883"
--MQTT的登陆账号默认""
config["conf"][2][6]=""
--MQTT的登陆密码默认""
config["conf"][2][7]=""
--MQTT是否保存会话标志位,0持久会话,1离线自动销毁
config["conf"][2][8]=1
--订阅消息主题
config["conf"][2][9]=midemo.MQTT_subTopic or "/server/"
--发布消息主题
config["conf"][2][10]=midemo.MQTT_pubTopic or "/device/"
--MQTT的QOS级别,默认0
config["conf"][2][11]=0
--MQTT的publish参数retain，默认0
config["conf"][2][12]=0
--MQTT通道捆绑的串口ID
config["conf"][2][13]=2
--自定义客户端ID，使用IMEI做客户端ID此处留空
config["conf"][2][14]=""
--留空主题自动添加IMEI, 1为不添加IMEI
config["conf"][2][15]=""
--传输模式，可选tcp或者tcp_ssl
config["conf"][2][16]="tcp"
--遗嘱的主题
config["conf"][2][17]=""

--第三个通道阿里云（id=3)
--阿里云IOT的名称
config["conf"][3][1]="aliyun"
--自动注册，自动登陆，自动激活设备(一键阿里云)
config["conf"][3][2]="auto"
--链接超时最大时间单位秒,默认300秒
config["conf"][3][3]="300"
--自动定时采集任务间隔时间,单位秒。默认1800秒
config["conf"][3][4]="1800"
--RegionID,阿里云提供的地域代码值
config["conf"][3][5]=midemo.RegionID or "cn-shanghai"
--阿里云产品项目ID
config["conf"][3][6]=midemo.ProductKey or "a18AEOym3ET"
--阿里云API安全密钥ID（可用子密钥）
config["conf"][3][7]=midemo.AccessKey or "LTAI4GBhk4Wb2C71wwjgtcve"
--阿里云API安全密钥Secret（可用子密钥）
config["conf"][3][8]=midemo.AccessKeySecret or "IrVCeGi9hXnQCNIeNUr0HRBrGuSBfV"
--可选basic(基础班),plus(高级版)
config["conf"][3][9]="basic"
--MQTT 保存会话标志位
config["conf"][3][10]=1
--MQTT 的 QOS 级别
config["conf"][3][11]=0
--MQTT 通道捆绑的串口 ID:
config["conf"][3][12]=3
--订阅主题或订阅多个主题;qos
config["conf"][3][13]=midemo.ALIYUN_subTopic or "/sys/a18AEOym3ET/${deviceName}/thing/service/property/set"
--发布的主题
config["conf"][3][14]=midemo.ALIYUN_pubTopic or "/sys/a18AEOym3ET/${deviceName}/thing/event/property/post"

--网络灯设置
config["pins"][1]=""
--网络准备好
config["pins"][2]=""
--iRTU复位
config["pins"][3]=""
--声明端口占用
--pub("P4 was occupied by irtu netled")
--pub("P28 was occupied by irtu reset pin")

-- --如果指定串口2则，描述占用
-- if (config["conf"][1][6]==2 or config["conf"][2][13]==2 or config["conf"][3][12]==2) then 
--     pub("P20 was occupied by COM2_Rx")
--     pub("P21 was occupied by COM2_Tx")
-- end
-- if config["conf"][1][6] then pub("CON"..config["conf"][1][6].." was occupied by upws net interface") end
-- if config["conf"][2][13] then pub("CON"..config["conf"][2][13].." was occupied by MQTT net interface") end
-- if config["conf"][3][12] then pub("CON"..config["conf"][3][12].." was occupied by ALIYUN net interface") end

local content_modified=json.encode(config)
log.info("irtu_init","updated json",content_modified)
writevalw("/CONFIG.cnf",content_modified)

