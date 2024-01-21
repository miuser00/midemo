--------------------------------------------------------------------------------------------------------------------------------------- 
--版权声明：本demo集源于上海合宙官方技术团队的DEMO（MIT），并参考了合宙开源社区的众多大佬无私分享的代码，包括但不限于 稀饭放姜、Wendal、晨旭等
-- 目前参考到的开源项目有： iRTU（MIT)、LuatOS(MIT)
-- 欲获取更多luat 代码请访问 doc.openluat.com
-- 如果您觉得本demo集包含了未经由您授权的代码，请联系 64034373@qq.com 
---------------------------------------------------------------------------------------------------------------------------------------

-- @模块功能：ws2812b 8X8矩阵屏幕字符驱动
-- @author miuser
-- @module midemo.ws2812b
-- @license MIT
-- @copyright miuser@luat
-- @release 2020-10-10
--------------------------------------------------------------------------
--帮助系统显示用的模块说明
HELP=[[8X8方形ws2812b全彩LED阵列驱动模块]]
HELP=[[连线方法：MOSI/P11<->DIN,VLCD<->VCC,GND<->GND]]
HELP=[[使用方法：]]
HELP=[[2812DISPLAY,str str为英文字符串]]
HELP=[[显示完毕后回显2812DISPLAY,str->DONE]]
HELP=[[例子：]]
HELP=[[2812DISPLAY,HELLO LUAT]]
HELP=[[显示完毕后回显2812DISPLAY,HELLO LUAT->DONE]]

-- @使用方法 2812DISPLAY,str 显示一个字符
-- @显示完成后，系统收到消息 WS2812B_TRANSMIT_DONE XXXXX
-- @显示完成后，终端收到消息 XXXXX transmited to WSMatrix 

require "bit"

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

pub("P11 was occupied by SPI_DO")
pub("P12 was occupied by SPI_DI")

--英文字符集
local lib_5X7={0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x5F,0x00,0x00,0x00,0x07,0x00,0x07,0x00,0x14,0x7F,0x14,0x7F,0x14,0x24,0x2A,0x07,0x2A,0x12,0x23,0x13,0x08,0x64,0x62,0x37,0x49,0x55,0x22,0x50,0x00,0x05,0x03,0x00,0x00,0x00,0x1C,0x22,0x41,0x00,0x00,0x41,0x22,0x1C,0x00,0x08,0x2A,0x1C,0x2A,0x08,0x08,0x08,0x3E,0x08,0x08,0x00,0x50,0x30,0x00,0x00,0x08,0x08,0x08,0x08,0x08,0x00,0x60,0x60,0x00,0x00,0x20,0x10,0x08,0x04,0x02,0x3E,0x51,0x49,0x45,0x3E,0x00,0x42,0x7F,0x40,0x00,0x42,0x61,0x51,0x49,0x46,0x21,0x41,0x45,0x4B,0x31,0x18,0x14,0x12,0x7F,0x10,0x27,0x45,0x45,0x45,0x39,0x3C,0x4A,0x49,0x49,0x30,0x01,0x71,0x09,0x05,0x03,0x36,0x49,0x49,0x49,0x36,0x06,0x49,0x49,0x29,0x1E,0x00,0x36,0x36,0x00,0x00,0x00,0x56,0x36,0x00,0x00,0x00,0x08,0x14,0x22,0x41,0x14,0x14,0x14,0x14,0x14,0x41,0x22,0x14,0x08,0x00,0x02,0x01,0x51,0x09,0x06,0x32,0x49,0x79,0x41,0x3E,0x7E,0x11,0x11,0x11,0x7E,0x7F,0x49,0x49,0x49,0x36,0x3E,0x41,0x41,0x41,0x22,0x7F,0x41,0x41,0x22,0x1C,0x7F,0x49,0x49,0x49,0x41,0x7F,0x09,0x09,0x01,0x01,0x3E,0x41,0x41,0x51,0x32,0x7F,0x08,0x08,0x08,0x7F,0x00,0x41,0x7F,0x41,0x00,0x20,0x40,0x41,0x3F,0x01,0x7F,0x08,0x14,0x22,0x41,0x7F,0x40,0x40,0x40,0x40,0x7F,0x02,0x04,0x02,0x7F,0x7F,0x04,0x08,0x10,0x7F,0x3E,0x41,0x41,0x41,0x3E,0x7F,0x09,0x09,0x09,0x06,0x3E,0x41,0x51,0x21,0x5E,0x7F,0x09,0x19,0x29,0x46,0x46,0x49,0x49,0x49,0x31,0x01,0x01,0x7F,0x01,0x01,0x3F,0x40,0x40,0x40,0x3F,0x1F,0x20,0x40,0x20,0x1F,0x7F,0x20,0x18,0x20,0x7F,0x63,0x14,0x08,0x14,0x63,0x03,0x04,0x78,0x04,0x03,0x61,0x51,0x49,0x45,0x43,0x00,0x00,0x7F,0x41,0x41,0x02,0x04,0x08,0x10,0x20,0x41,0x41,0x7F,0x00,0x00,0x04,0x02,0x01,0x02,0x04,0x40,0x40,0x40,0x40,0x40,0x00,0x01,0x02,0x04,0x00,0x20,0x54,0x54,0x54,0x78,0x7F,0x48,0x44,0x44,0x38,0x38,0x44,0x44,0x44,0x20,0x38,0x44,0x44,0x48,0x7F,0x38,0x54,0x54,0x54,0x18,0x08,0x7E,0x09,0x01,0x02,0x08,0x14,0x54,0x54,0x3C,0x7F,0x08,0x04,0x04,0x78,0x00,0x44,0x7D,0x40,0x00,0x20,0x40,0x44,0x3D,0x00,0x00,0x7F,0x10,0x28,0x44,0x00,0x41,0x7F,0x40,0x00,0x7C,0x04,0x18,0x04,0x78,0x7C,0x08,0x04,0x04,0x78,0x38,0x44,0x44,0x44,0x38,0x7C,0x14,0x14,0x14,0x08,0x08,0x14,0x14,0x18,0x7C,0x7C,0x08,0x04,0x04,0x08,0x48,0x54,0x54,0x54,0x20,0x04,0x3F,0x44,0x40,0x20,0x3C,0x40,0x40,0x20,0x7C,0x1C,0x20,0x40,0x20,0x1C,0x3C,0x40,0x30,0x40,0x3C,0x44,0x28,0x10,0x28,0x44,0x0C,0x50,0x50,0x50,0x3C,0x44,0x64,0x54,0x4C,0x44,0x00,0x08,0x36,0x41,0x00,0x00,0x00,0x7F,0x00,0x00,0x00,0x41,0x36,0x08,0x00,0x02,0x01,0x02,0x04,0x02,0xff,0xff,0xff,0xff,0xff}
Xmax=8
Ymax=8
--8X8二维数组存储点阵信息
local Screen_R={}
local Screen_G={}
local Screen_B={}
--前景笔刷颜色 R，G，B
local FrontColor={255,255,255}

--产生一个字节的发送码
local function genByte2(databyte)
    --按硬件编码送出的字节
    local ret=""
    local zero=0xC0
    local one=0xF8
    --每个section由6位构成，用8位字节表示
    local section={}
    for i=1,8 do
        section[i]= (bit.band(databyte,bit.lshift(0x01,8-i))==0) and zero or one
        ret=ret..string.char(section[i])
    end
    return ret
end
local function genByte3(databyte)
    --按硬件编码送出的字节
    local hwdatabyte=""
    local zero=0x04
    local one=0x06
    --每个section由3位构成，用8位字节表示，但仅前三位有效
    local section={}
    for i=1,8 do
        section[i]= (bit.band(databyte,bit.lshift(0x01,8-i))==0) and zero or one
    end
    local byte1=bit.bor(bit.lshift(section[1],5),bit.lshift(section[2],2),bit.rshift(section[3],1))
    local byte2=bit.band(bit.bor(bit.lshift(section[3],7),bit.lshift(section[4],4),bit.lshift(section[5],1),bit.rshift(section[6],2)),0xff)
    local byte3=bit.band(bit.bor(bit.lshift(section[6],6),bit.lshift(section[7],3),section[8]),0xff)
    --log.info("midemo.ws2812b","byte1="..byte1.." byte2="..byte2.." byte3="..byte3)
    local ret=string.char(byte1)..string.char(byte2)..string.char(byte3)
    --log.info("midemo.ws2812b","bytes="..string.toHex(ret))
    return ret
end

--产生一个字节的发送码
local function genByte(databyte)
    --按硬件编码送出的字节

    local zero=0x20
    local one=0x3E
    --每个section由6位构成，用8位字节表示，但仅前6位有效
    local section={}
    for i=1,8 do
        section[i]= (bit.band(databyte,bit.lshift(0x01,8-i))==0) and zero or one
        --log.info("midemo.ws2812b","section"..i.."="..section[i])
    end
    local byte1=bit.bor(bit.lshift(section[1],2),bit.rshift(section[2],4))
    local byte2=bit.band(bit.bor(bit.lshift(section[2],4),bit.rshift(section[3],2)),0xff)
    local byte3=bit.band(bit.bor(bit.lshift(section[3],6),section[4]),0xff)
    local byte4=bit.bor(bit.lshift(section[5],2),bit.rshift(section[4],4))
    local byte5=bit.band(bit.bor(bit.lshift(section[6],4),bit.rshift(section[7],2)),0xff)
    local byte6=bit.band(bit.bor(bit.lshift(section[7],6),section[8]),0xff)
    --log.info("midemo.ws2812b","byte1="..byte1.." byte2="..byte2.." byte3="..byte3)
    local ret=string.char(byte1)..string.char(byte2)..string.char(byte3)..string.char(byte4)..string.char(byte5)..string.char(byte6)
    --log.info("midemo.ws2812b","bytes="..string.toHex(ret))
    return ret
end

local function genDot(R,G,B)
    --log.info("midemo.ws2812b","R="..R.." G="..G.." B="..B)
    return genByte(G)..genByte(R)..genByte(B)

end

--初始化屏幕
function init()
    for i=1,8 do
        Screen_R[i]={}
        Screen_G[i]={}
        Screen_B[i]={}
    end
    local result = spi.setup(spi.SPI_1,0,0,8,4000000,0)--初始化spi，
    log.info("midemo.ws2812b","init",result)
    local PanelMatrix=""
    for y=1,Ymax do
        for x=1,Xmax do
            Screen_R[x][y]=0
            Screen_G[x][y]=0
            Screen_B[x][y]=0
            PanelMatrix=PanelMatrix..genDot(Screen_R[x][y],Screen_G[x][y],Screen_B[x][y])
        end
    end
end

--刷新屏幕
function update()
    local PanelMatrix=""
    for y=1,Ymax do
        for x=1,Xmax do
            local dot=""
            if (y%2==0) then 
                dot=genDot(Screen_R[8-x+1][y],Screen_G[8-x+1][y],Screen_B[8-x+1][y])
                
            else
                dot=genDot(Screen_R[x][y],Screen_G[x][y],Screen_B[x][y])
            end
            PanelMatrix=PanelMatrix..dot
        end
    end
    spi.send(spi.SPI_1,PanelMatrix)
end

--清屏
function clr()
    for y=1,Ymax do
        for x=1,Xmax do
            Screen_R[x][y]=0
            Screen_G[x][y]=0
            Screen_B[x][y]=0
        end
    end
end

--画点
function DrawDot(x,y)
    --log.info("midemo.ws2812b","x="..x.." y="..y)
    Screen_R[x][y]=FrontColor[1]
    Screen_G[x][y]=FrontColor[2]
    Screen_B[x][y]=FrontColor[3]
end

--在指定坐标处显示一个字符
function ShowChar(xpos, Show_char)
    c = string.byte(Show_char) - 0x20 -- 获取字符的偏移量
    for x = 1, 5 do -- 循环5次(5列)
        line=lib_5X7[5*c+x]
        if ((x+xpos)>8 or (x+xpos)<1)then 
              --log.info("midemo.ws2812b","jump line because x+pos=",tostring(x+xpos))
        else
            for y = 1, 8 do
                if (line~=nil) then 
                    if (bit.band(line,bit.lshift(0x01,8-y))~=0) then Screen_R[x+xpos][y]=FrontColor[1] end
                    if (bit.band(line,bit.lshift(0x01,8-y))~=0) then Screen_G[x+xpos][y]=FrontColor[2] end
                    if (bit.band(line,bit.lshift(0x01,8-y))~=0) then Screen_B[x+xpos][y]=FrontColor[3] end
                    --log.info("midemo.ws2812b","Screen_R"..x+xpos.."="..FrontColor[1])
                    -- log.info("midemo.ws2812b","Screen_G"..x+xpos.."="..FrontColor[1])
                    -- log.info("midemo.ws2812b","Screen_B"..x+xpos.."="..FrontColor[2])
                end
            end
        end
    end   
end

--显示背景花纹
function DrawRandBackground(i)
    for yy=1,Ymax do
        for xx=1,Xmax do
            if (i%6)==0 then val1=1 val2=0 val3=1 end
            if (i%6)==1 then val1=2 val2=0 val3=0 end
            if (i%6)==2 then val1=1 val2=1 val3=0 end
            if (i%6)==3 then val1=0 val2=2 val3=0 end
            if (i%6)==4 then val1=0 val2=1 val3=1 end
            if (i%6)==5 then val1=0 val2=0 val3=2 end
            --log.info("midemo.ws2812b","rand="..val1)
            Screen_R[xx][yy]=0
            Screen_G[xx][yy]=0
            Screen_B[xx][yy]=0
        end
    end
end



--显示一个字符串
function ShowString(ShowStr)
    running=1
    i=0
    sys.taskInit(function()
        --ShowStr=" HELLO LUAT!"
        log.info("midemo.ws2812b","restarting w2812b")
        while running==1 do
            --log.info("midemo.ws2812b","refreshing w2812b")
            DrawRandBackground(i)
            FrontColor={255,0,0}
            for ii=1,#ShowStr do
                str=string.sub(ShowStr,ii,ii)
                pos=(ii-1)*6-i
                --log.info("midemo.ws2812b","showing str "..str.." at pos "..pos)
                if (ii%6==0) then FrontColor={255,255,255} end
                if (ii%6==1) then FrontColor={255,0,255} end
                if (ii%6==2) then FrontColor={0,255,255} end
                if (ii%6==3) then FrontColor={255,0,255} end
                if (ii%6==4) then FrontColor={255,255,0} end
                if (ii%6==5) then FrontColor={0,255,255} end
                ShowChar(pos,str)
            end
            update()
            --collectgarbage("collect")
            sys.wait(100) 
            i=i+1
            if i>=#ShowStr*6 then 
                i=0
                running=0
                sys.publish("WS2812B_TRANSMIT_DONE",ShowStr)
                pub("2812DISPLAY,"..ShowStr.."->DONE")
            end
        end
    end)

end

--通过这个回调函数可以响应任意的串口或网络发布的命令
sys.subscribe("2812DISPLAY",function(...)
    --通过arg可以从输入的命令行读入参数，并以逗号作为分隔符
    str=" "..arg[1]
    --b=arg[2]
    --c=arg[3]
    --通过write函数可以向串口和网络上报您的信息
    --初始化WS2812b
    init()
    ShowString(str)

end)

sys.subscribe("WS2812B_TRANSMIT_DONE",function(...)
    spi.close(0)
end)

