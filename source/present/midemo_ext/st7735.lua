--------------------------------------------------------------------------------------------------------------------------------------- 
--版权声明：本demo集源于上海合宙官方技术团队的DEMO（MIT），并参考了合宙开源社区的众多大佬无私分享的代码，包括但不限于 稀饭放姜、Wendal、晨旭等
-- 目前参考到的开源项目有： iRTU（MIT)、LuatOS(MIT)
-- 欲获取更多luat 代码请访问 doc.openluat.com
-- 如果您觉得本demo集包含了未经由您授权的代码，请联系 64034373@qq.com 
---------------------------------------------------------------------------------------------------------------------------------------

-- @模块功能：st7735显示屏简易驱动
-- @author miuser
-- @module midemo.st7735
-- @license MIT
-- @copyright miuser@luat
-- @release 2021-01-24
--------------------------------------------------------------------------
--帮助系统显示用的模块说明
HELP=[[st7735模块]]
HELP=[[连线方式：CK<->CLK,DA<->DATA,RST<->RESET,DC<->Data/Command,CS<->CS,VLCD<->VDD_LCD,GND<->GND]]
HELP=[[功能：驱动160X128分辨率的st7735显示屏幕]]
HELP=[[在屏幕上显示文本]]
HELP=[[7735DISPLAY,Text]]
HELP=[[显示完成后，回显7735DISPLAY,Text->DONE]]
HELP=[[例子:]]
HELP=[[775DISPLAY,你好]]
HELP=[[屏幕从起始位置显示“你好”]]
HELP=[[显示完毕后，控制台回显7735DISPLAY,你好->DONE]]
--------------------------------------------------------------------------
-- @使用方法
-- @7735DISPLAY,ABC ABC是您要输入的文字，支持中英文
-- @占用资源P0,P1,P2,P3

module(...,package.seeall)



--通过这个回调函数可以响应任意的串口或网络发布的命令
sys.subscribe("7735DISPLAY",function(...)
    --通过arg可以从输入的命令行读入参数，并以逗号作为分隔符
    a=arg[1]
    --通过write函数可以向串口和网络上报您的信息
    showText(a)
    pub("ST7735DISPLAY,"..a.."->DONE")
end)

local modulename=...
--注册到全局状态表
table.insert(status.INSTALLED,modulename)
--通过消息发送调试信息到串口和网络
function pub(s)
    s="["..(modulename).."]"..s
    sys.publish("CON",s.."\r\n")
    sys.publish("NET_CMD_MONI",s.."\r\n")
end

pub("P2 was occupied by DISPLAY_CK")
pub("P0 was occupied by DISPLAY_DA")
pub("P1 was occupied by DISPLAY_DC")
pub("P3 was occupied by DISPLAY_CS")

function showText(text,line)
    disp.clear()
    disp.setcolor(0x001F)
    disp.puttext("---- MIDEMO ----",0,0)
    disp.setcolor(0xFFFF)
    local gbtext=common.utf8ToGb2312(text)
    if (line==nil) then
        --横向容纳的英文文字数，中文算两个字符
        local horizonletter=16
        local linecount=(#gbtext/horizonletter)+1
        for i=1,linecount do
            local linestr=string.sub(gbtext,(i-1)*horizonletter+1,(i-1)*horizonletter+horizonletter)
            log.info("st7735","linstr="..linestr)
            disp.puttext(linestr,2,16+i*16)
        end        
        --disp.puttext(gbtext,2,32)
    else
        disp.puttext(gbtext,2,(line+1)*16)
    end
    disp.update()
end



--[[
函数名：init
功能  ：初始化LCD参数
参数  ：无
返回值：无
]]
local function init()
    local para =
    {
        width = 132, --分辨率宽度，128像素；用户根据屏的参数自行修改
        height = 161, --分辨率高度，160像素；用户根据屏的参数自行修改
        bpp = 16, --位深度，彩屏仅支持16位
        bus = disp.BUS_SPI4LINE, --LCD专用SPI引脚接口，不可修改
        xoffset = 0, --X轴偏移
        yoffset = 0, --Y轴偏移
        freq = 13000000, --spi时钟频率，支持110K到13M（即110000到13000000）之间的整数（包含110000和13000000）
        pinrst = pio.P0_6, --reset，复位引脚
        pinrs = pio.P0_1, --rs，命令/数据选择引脚
        --初始化命令
        --前两个字节表示类型：0001表示延时，0000或者0002表示命令，0003表示数据
        --延时类型：后两个字节表示延时时间（单位毫秒）
        --命令类型：后两个字节命令的值
        --数据类型：后两个字节数据的值
        initcmd =
        {
            0x00020011,
            0x00010078,
            0x000200B1,
            0x00030002,
            0x00030035,
            0x00030036,
            0x000200B2,
            0x00030002,
            0x00030035,
            0x00030036,
            0x000200B3,
            0x00030002,
            0x00030035,
            0x00030036,
            0x00030002,
            0x00030035,
            0x00030036,
            0x000200B4,
            0x00030007,
            0x000200C0,
            0x000300A2,
            0x00030002,
            0x00030084,
            0x000200C1,
            0x000300C5,
            0x000200C2,
            0x0003000A,
            0x00030000,
            0x000200C3,
            0x0003008A,
            0x0003002A,
            0x000200C4,
            0x0003008A,
            0x000300EE,
            0x000200C5,
            0x0003000E,
            0x00020036,
            0x000300C0,
            0x000200E0,
            0x00030012,
            0x0003001C,
            0x00030010,
            0x00030018,
            0x00030033,
            0x0003002C,
            0x00030025,
            0x00030028,
            0x00030028,
            0x00030027,
            0x0003002F,
            0x0003003C,
            0x00030000,
            0x00030003,
            0x00030003,
            0x00030010,
            0x000200E1,
            0x00030012,
            0x0003001C,
            0x00030010,
            0x00030018,
            0x0003002D,
            0x00030028,
            0x00030023,
            0x00030028,
            0x00030028,
            0x00030026,
            0x0003002F,
            0x0003003B,
            0x00030000,
            0x00030003,
            0x00030003,
            0x00030010,
            0x0002003A,
            0x00030005,
            0x00020029,
        },
        --休眠命令
        sleepcmd = {
            0x00020010,
        },
        --唤醒命令
        wakecmd = {
            0x00020011,
        }
    }
    disp.init(para)
    disp.setbkcolor(0x0000)
    disp.clear()
    disp.update()
end

--初始化
init()
--显示标题
showText("UART DISPLAY")