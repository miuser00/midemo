--------------------------------------------------------------------------------------------------------------------------------------- 
--版权声明：本demo集源于上海合宙官方技术团队的DEMO（MIT），并参考了合宙开源社区的众多大佬无私分享的代码，包括但不限于 稀饭放姜、Wendal、晨旭、陈夏等
-- 目前参考到的开源项目有： iRTU（MIT)、LuatOS(MIT)、LLCOM
-- 欲获取更多luat 代码请访问 doc.openluat.com
-- 如果您觉得本demo集包含了未经由您授权的代码，请联系 64034373@qq.com，如有侵权嫌疑将立即纠正
---------------------------------------------------------------------------------------------------------------------------------------
--- 模块功能：SSD 1306驱动芯片 I2C屏幕显示128X32点阵英文字符
-- @original author CX
-- @release 2020.02.23
-- @modified by miuser
-- @release 2020.09.03
-- @module midemo.oled
-- @license MIT
--------------------------------------------------------------------------
--帮助系统显示用的模块说明
HELP=[[oled模块]]
HELP=[[功能：显示网络的连接质量，CPU占用情况与控制台输入的指令]]
HELP=[[当控制台收到DISPLAY的消息,则在屏幕第四行显示。比如消息为 DISPLAY,CMD，XXXX 则OLED将显示如下内容]]
HELP=[[************************]]
HELP=[[**  CPU: 60% RAM: 80% **]]
HELP=[[**  CSQ: 18  NET:UMA  **]]
HELP=[[**                    **]]
HELP=[[**  CMD，XXXXX        **]]
HELP=[[************************]]
HELP=[[网络连接状态U代表UPWS服务器，M代表MQTT服务器，A代表阿里云服务器，对应的网络连接成功，则对应的字符会显示出来]]
HELP=[[仅支持英文字符集，中文字符将以**替代]]
--------------------------------------------------------------------------




module(..., package.seeall)
require "bit"
require "create"

local modulename=...
--注册到全局状态表
table.insert(status.INSTALLED,modulename)
--通过消息发送调试信息到串口和网络
function pub(s)
    s="["..(modulename).."]"..s
    sys.publish("CON",s.."\r\n")
    sys.publish("NET_CMD_MONI",s.."\r\n")
end

local isLCDPresent=false
--CPU占用百分比
local CpuUsage=0
--RAM占用百分比
local RamUsage=0
--FLASH剩余空间（KB)
local FreeSpace=0


local i2cid = 2
local lib_5X7={0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x5F,0x00,0x00,0x00,0x07,0x00,0x07,0x00,0x14,0x7F,0x14,0x7F,0x14,0x24,0x2A,0x07,0x2A,0x12,0x23,0x13,0x08,0x64,0x62,0x37,0x49,0x55,0x22,0x50,0x00,0x05,0x03,0x00,0x00,0x00,0x1C,0x22,0x41,0x00,0x00,0x41,0x22,0x1C,0x00,0x08,0x2A,0x1C,0x2A,0x08,0x08,0x08,0x3E,0x08,0x08,0x00,0x50,0x30,0x00,0x00,0x08,0x08,0x08,0x08,0x08,0x00,0x60,0x60,0x00,0x00,0x20,0x10,0x08,0x04,0x02,0x3E,0x51,0x49,0x45,0x3E,0x00,0x42,0x7F,0x40,0x00,0x42,0x61,0x51,0x49,0x46,0x21,0x41,0x45,0x4B,0x31,0x18,0x14,0x12,0x7F,0x10,0x27,0x45,0x45,0x45,0x39,0x3C,0x4A,0x49,0x49,0x30,0x01,0x71,0x09,0x05,0x03,0x36,0x49,0x49,0x49,0x36,0x06,0x49,0x49,0x29,0x1E,0x00,0x36,0x36,0x00,0x00,0x00,0x56,0x36,0x00,0x00,0x00,0x08,0x14,0x22,0x41,0x14,0x14,0x14,0x14,0x14,0x41,0x22,0x14,0x08,0x00,0x02,0x01,0x51,0x09,0x06,0x32,0x49,0x79,0x41,0x3E,0x7E,0x11,0x11,0x11,0x7E,0x7F,0x49,0x49,0x49,0x36,0x3E,0x41,0x41,0x41,0x22,0x7F,0x41,0x41,0x22,0x1C,0x7F,0x49,0x49,0x49,0x41,0x7F,0x09,0x09,0x01,0x01,0x3E,0x41,0x41,0x51,0x32,0x7F,0x08,0x08,0x08,0x7F,0x00,0x41,0x7F,0x41,0x00,0x20,0x40,0x41,0x3F,0x01,0x7F,0x08,0x14,0x22,0x41,0x7F,0x40,0x40,0x40,0x40,0x7F,0x02,0x04,0x02,0x7F,0x7F,0x04,0x08,0x10,0x7F,0x3E,0x41,0x41,0x41,0x3E,0x7F,0x09,0x09,0x09,0x06,0x3E,0x41,0x51,0x21,0x5E,0x7F,0x09,0x19,0x29,0x46,0x46,0x49,0x49,0x49,0x31,0x01,0x01,0x7F,0x01,0x01,0x3F,0x40,0x40,0x40,0x3F,0x1F,0x20,0x40,0x20,0x1F,0x7F,0x20,0x18,0x20,0x7F,0x63,0x14,0x08,0x14,0x63,0x03,0x04,0x78,0x04,0x03,0x61,0x51,0x49,0x45,0x43,0x00,0x00,0x7F,0x41,0x41,0x02,0x04,0x08,0x10,0x20,0x41,0x41,0x7F,0x00,0x00,0x04,0x02,0x01,0x02,0x04,0x40,0x40,0x40,0x40,0x40,0x00,0x01,0x02,0x04,0x00,0x20,0x54,0x54,0x54,0x78,0x7F,0x48,0x44,0x44,0x38,0x38,0x44,0x44,0x44,0x20,0x38,0x44,0x44,0x48,0x7F,0x38,0x54,0x54,0x54,0x18,0x08,0x7E,0x09,0x01,0x02,0x08,0x14,0x54,0x54,0x3C,0x7F,0x08,0x04,0x04,0x78,0x00,0x44,0x7D,0x40,0x00,0x20,0x40,0x44,0x3D,0x00,0x00,0x7F,0x10,0x28,0x44,0x00,0x41,0x7F,0x40,0x00,0x7C,0x04,0x18,0x04,0x78,0x7C,0x08,0x04,0x04,0x78,0x38,0x44,0x44,0x44,0x38,0x7C,0x14,0x14,0x14,0x08,0x08,0x14,0x14,0x18,0x7C,0x7C,0x08,0x04,0x04,0x08,0x48,0x54,0x54,0x54,0x20,0x04,0x3F,0x44,0x40,0x20,0x3C,0x40,0x40,0x20,0x7C,0x1C,0x20,0x40,0x20,0x1C,0x3C,0x40,0x30,0x40,0x3C,0x44,0x28,0x10,0x28,0x44,0x0C,0x50,0x50,0x50,0x3C,0x44,0x64,0x54,0x4C,0x44,0x00,0x08,0x36,0x41,0x00,0x00,0x00,0x7F,0x00,0x00,0x00,0x41,0x36,0x08,0x00,0x02,0x01,0x02,0x04,0x02,0xff,0xff,0xff,0xff,0xff}
local i2cslaveaddr = 0x3c
-- 宏定义
local OLED_CMD = 0 -- 命令
local OLED_DATA = 1 -- 数据
local SIZE = 16 --显示字符的大小
local Max_Column = 128 --最大列数
local Max_Row = 64 --最大行数
local X_WIDTH = 128 --X轴的宽度
local Y_WIDTH = 64 --Y轴的宽度

-- 向OLED写入指令字节
function OLED_Write_Command(OLED_Byte)
    local count=i2c.send(i2cid, i2cslaveaddr, {0x00, OLED_Byte})
    return count
end

-- 向OLED写入数据字节
function OLED_Write_Data(OLED_Byte)
    local count=i2c.send(i2cid, i2cslaveaddr, {0x40, OLED_Byte})
    return count
end


-- 向OLED写入一字节数据/指令
function OLED_WR_Byte(OLED_Byte, OLED_Type)
    if OLED_Type == OLED_DATA then
        return OLED_Write_Data(OLED_Byte)--写入数据
    else
        return OLED_Write_Command(OLED_Byte)--写入指令
    end
end

-- 整屏写入某值
function OLED_Clear()
    if isLCDPresent==false then return end
    local N_Page, N_row = 0, 0
    for N_Page = 1, 8 do
        OLED_WR_Byte(0xb0 + N_Page - 1, OLED_CMD)-- 从0～7页依次写入
        OLED_WR_Byte(0x00, OLED_CMD)-- 列低地址
        OLED_WR_Byte(0x10, OLED_CMD)-- 列高地址
        for N_row = 1, 128 do
            OLED_WR_Byte(0x00, OLED_DATA)
        end
    end
end

-- 设置数据写入的起始行、列
function OLED_Set_Pos(x, y)
    OLED_WR_Byte(0xb0 + y, OLED_CMD)-- 写入页地址
    OLED_WR_Byte(bit.band(x, 0x0f), OLED_CMD)-- 写入列的地址(低半字节)
    OLED_WR_Byte(bit.bor(bit.rshift(bit.band(x, 0xf0), 4), 0x10), OLED_CMD)-- 写入列的地址(高半字节)
end

pub("P14 was occupied by I2C SCL (shared)")
pub("P15 was occupied by I2C SDA (shared)")

--初始化OLED
-------------------------------------------------------------------------------
function OLED_Init()
    --i2c.set_id_dup(0)
    i2c.close(i2cid)
    if i2c.setup(i2cid, i2c.SLOW) ~= i2c.SLOW then
        isLCDPresent=false
        pub("OLED Panel not found")
        log.info("oled","OLED Panel not found")
        i2c.close(i2cid)
        return
    end
    --I2C显示屏初始化正常
    local count =OLED_WR_Byte(0xAE, OLED_CMD)-- 关闭显示
    if count==0 then 
        isLCDPresent=false
        log.info("oled","OLED Panel not found")
        pub("OLED Panel not found")
        return
    else
        isLCDPresent=true
        --log.info("oled","OLED.init OK")
    end
    
    OLED_WR_Byte(0x00, OLED_CMD)-- 设置低列地址
    OLED_WR_Byte(0x10, OLED_CMD)-- 设置高列地址
    OLED_WR_Byte(0x40, OLED_CMD)-- 设置起始行地址
    OLED_WR_Byte(0xB0, OLED_CMD)-- 设置页地址
    
    OLED_WR_Byte(0x81, OLED_CMD)-- 对比度设置，可设置亮度
    OLED_WR_Byte(0xFF, OLED_CMD)-- 265
    
    OLED_WR_Byte(0xA1, OLED_CMD)-- 设置段(SEG)的起始映射地址
    OLED_WR_Byte(0xA6, OLED_CMD)-- 正常显示；0xa7逆显示
    
    OLED_WR_Byte(0xA8, OLED_CMD)-- 设置驱动路数（16~64）
    OLED_WR_Byte(0x1F, OLED_CMD)-- 64duty
    
    OLED_WR_Byte(0xC8, OLED_CMD)-- 重映射模式，COM[N-1]~COM0扫描
    
    OLED_WR_Byte(0xD3, OLED_CMD)-- 设置显示偏移
    OLED_WR_Byte(0x00, OLED_CMD)-- 无偏移
    
    OLED_WR_Byte(0xD5, OLED_CMD)-- 设置震荡器分频
    OLED_WR_Byte(0x80, OLED_CMD)-- 使用默认值
    
    OLED_WR_Byte(0xD9, OLED_CMD)-- 设置 Pre-Charge Period
    OLED_WR_Byte(0xF1, OLED_CMD)-- 使用官方推荐值
    
    OLED_WR_Byte(0xDA, OLED_CMD)-- 设置 com pin configuartion
    OLED_WR_Byte(0x02, OLED_CMD)-- 使用默认值
    
    OLED_WR_Byte(0xDB, OLED_CMD)-- 设置 Vcomh，可调节亮度（默认）
    OLED_WR_Byte(0x40, OLED_CMD)-- 使用官方推荐值
    
    OLED_WR_Byte(0x8D, OLED_CMD)-- 设置OLED电荷泵
    OLED_WR_Byte(0x14, OLED_CMD)-- 开显示
    
    OLED_WR_Byte(0xAF, OLED_CMD)-- 开启OLED面板显示
    
    --OLED_Clear()-- 清屏
    
    count=OLED_Set_Pos(0, 0)-- 设置数据写入的起始行、列
    if count==0 then 
        isLCDPresent=false
        return
    else
        isLCDPresent=true
        pub("OLED Panel OK")
        log.info("oled","OLED Panel OK")
    end
end

--在指定坐标处显示一个字符
-------------------------------------------------------------------------------
function OLED_ShowChar(x, y, Show_char)
    local c, i = 0, 0
    --如果屏幕不存在就啥也不做，直接返回
    if isLCDPresent==false then return end
    if x > Max_Column - 1 then
        x = 0
        y = y + 2
    end -- 当列数超出范围，则另起2页

    c = string.byte(Show_char) - 0x20 -- 获取字符的偏移量
    if c<0 then c=0 end
    -- 画第一页
    OLED_Set_Pos(x, y)-- 设置画点起始处
    for i = 1, 5 do -- 循环5次(5列)
        OLED_WR_Byte(lib_5X7[5*c+i], OLED_DATA)-- 找到字模
    end
    
end

-- 在指定坐标起始处显示字符串
function OLED_ShowString(x, y, ShowStr)
    
    local len = #ShowStr
    local N_Char=1

    while N_Char <= len do
        local char_l=string.char(string.byte(ShowStr, N_Char))
        local char_r=""
        if (N_Char<len) then
            char_r=string.char(string.byte(ShowStr, N_Char+1))
        else
            char_r=" "
        end

        --log.info("OLED_ShowChar",len,char_l:toHex().." "..char_r:toHex())

        if (char_l:byte()<0xA1) then
            OLED_ShowChar(x, y,char_l)-- 显示一个英文字符
        else
            OLED_ShowChar(x, y,"*")-- 显示一个英文字符
        end
        x = x + 6 -- 列数加6，一个字符占6列
        if x >= 126 then
            x = 0
            y = y + 1
        end -- 当x>=128，另起一页

        N_Char=N_Char+1
    
    end
end



--OLED_ShowString(0, 2, "---------------------")
sys.timerLoopStart(function()
    OLED_ShowString(26, 0,string.format("%3d",CpuUsage))
    OLED_ShowString(80, 0,string.format("%3d",RamUsage))
    --oled.OLED_Init()
    --log.info("Displaying")
    if (status.UPWS_CONNECTION==true) then 
        OLED_ShowString(90, 1,s)
        if (s=="-") then s="U" end
    else
        s="-"
        OLED_ShowString(90, 1,s)
    end
    if (status.MQTT_CONNECTION==true) then 
        OLED_ShowString(96, 1,ss)
        if (ss=="-") then ss="M" end
    else
        ss="-"
        OLED_ShowString(96, 1,ss)    
    end
    if (status.ALIYUN_CONECTION==true) then 
        OLED_ShowString(102, 1,sss)
        if (sss=="-") then sss="A" end
    else
        sss="-"
        OLED_ShowString(102, 1,sss)  
    end
    if registered then
        OLED_ShowString(54, 1, " NET: ")
        rssi=net.getRssi()
        OLED_ShowString(32, 1,tostring(rssi))
    else
        OLED_ShowString(54, 1, " OFFLINE ") 
    end
    --i2c.close(0)
 end,500)

 registered=false

 sys.subscribe("NET_STATE_REGISTERED", function() registered=true end)

laststr=" "
--从系统消息接收主题为“DISPLAY”的消息
local function disprsv(msg)
    blankcount=21-#msg
    for i=1,blankcount do
        msg=msg.." "
    end
    --oled.OLED_ShowString(0,2," "..laststr)
    oled.OLED_ShowString(0,3,">"..msg)
    laststr=msg
    -- sys.timerStart(function()
    --     oled.OLED_ShowString(0,3,">                      ")
    -- end, 3000)
end
sys.subscribe("DISPLAY", disprsv)


--系统资源检测
sys.timerLoopStart(function()
    --collectgarbage("collect")
    local used=_G.collectgarbage("count")
    local free=1000-used
    local usedpercent=used/10
    if (free<0) then 
        free=0
        usedpercent=100 
    end
    --log.info("RAM可用空间:", free.."KB")-- 打印占用的RAM
    --log.info("RAM占用率:", usedpercent.."%")-- 打印占用的RAM
    RamUsage=usedpercent
    sys.publish("RAM_USAGE",RamUsage)
end, 1000)

sys.taskInit(function()
    while true do
        tick1=rtos.tick()
        for i=1,10 do
            sys.wait(100)
        end 
        tick2=rtos.tick()
        elapsed=tick2-tick1
        local usedpercent=(elapsed-200)/2
        if usedpercent>100 then usedpercent=100 end
        --log.info("CPU占用率:",usedpercent.."%")-- 打印CPU占用率
        CpuUsage=usedpercent
        sys.publish("CPU_USAGE",CpuUsage)
        -- sys.wait(100)
    end
end)

-- 显示模块的测试
s='-'
ss='-'
sss='-'
OLED_Init()
OLED_Clear()
OLED_ShowString(0, 0, " CPU:   % RAM:   %")
OLED_ShowString(0, 1, " CSQ:             ")
