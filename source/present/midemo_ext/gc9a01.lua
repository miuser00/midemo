--------------------------------------------------------------------------------------------------------------------------------------- 
--版权声明：本demo集源于上海合宙官方技术团队的DEMO（MIT），并参考了合宙开源社区的众多大佬无私分享的代码，包括但不限于 稀饭放姜、Wendal、晨旭等
-- 目前参考到的开源项目有： iRTU（MIT)、LuatOS(MIT)
-- 欲获取更多luat 代码请访问 doc.openluat.com
-- 如果您觉得本demo集包含了未经由您授权的代码，请联系 64034373@qq.com 
---------------------------------------------------------------------------------------------------------------------------------------

-- @模块功能：gc9a01显示屏简易驱动
-- @driver author Dozingfiretruck(打盹的消防车)
-- @author miuser
-- @module midemo.st7735
-- @license MIT
-- @copyright Dozingfiretruck&miuser@luat
-- @release 2021-01-24
--------------------------------------------------------------------------
--帮助系统显示用的模块说明
HELP=[[gc0a01模块]]
HELP=[[连线方式：CK<->CLK,DA<->DATA,RST<->RESET,DC<->Data/Command,CS<->CS,VLCD<->VDD_LCD,GND<->GND]]
HELP=[[功能：驱动240X240分辨率的gc0a01圆形显示屏幕]]
HELP=[[在屏幕上指定行显示文本,文本自动居中]]
HELP=[[9A01DISPLAY,Xline,Text]]
HELP=[[显示完成后，回显9A01DISPLAY,Xline,Text->DONE]]
HELP=[[Xline参数可以省略，则在屏幕中间显示一行文本]]
HELP=[[例子:]]
HELP=[[9A01DISPLAY,你好]]
HELP=[[屏幕中间显示“你好”]]
HELP=[[显示完毕后，控制台回显9A01DISPLAY,你好->DONE]]
--------------------------------------------------------------------------
-- @使用方法
-- @9A01DISPLAY,ABC ABC是您要输入的文字，支持中英文
-- @占用资源P0,P1,P2,P3

module(...,package.seeall)



--通过这个回调函数可以响应任意的串口或网络发布的命令
sys.subscribe("9A01DISPLAY",function(...)
    --通过arg可以从输入的命令行读入参数，并以逗号作为分隔符
    a=arg[1]
    b=arg[2]
    --通过write函数可以向串口和网络上报您的信息
    if (b==nil) then
        showText(a)
        pub("9A01DISPLAY,"..a.."->DONE")
    else
        showText(b,a)
        pub("9A01DISPLAY,"..a..","..b.."->DONE")
    end
    
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
    --disp.puttext("---- MIDEMO ----",0,0)
    disp.setcolor(0x0000)
    disp.putimage("/lua/bg_round.jpg",0,0)
    local gbtext=common.utf8ToGb2312(text)
    --总共可以容纳13行，其中每行的字符数如下
    local xspace={10,16,20,24,24,26,26,26,24,24,20,16,10}
    --总共可以容纳13行，其中每行的起始位置如下
    local xstart={76,54,39,27,19,15,14,16,18,24,36,55,76}
    local listed=0
    local lineno=tonumber(line)
    if (lineno==nil) then lineno=6 end
    if (lineno<1 or lineno>13) then lineno=13 end
    for i=lineno,13 do
        --已经显示的文字个数
        local lineend=((listed+xspace[i])<#gbtext) and (listed+xspace[i]) or #gbtext
        log.info("gc0a01","lineend="..lineend)
        log.info("gc0a01","#gbtext="..#gbtext)
        --行尾字符横跨了一个汉字，则末尾半个汉字移到下一行
        if (lineend<#gbtext) then
            for j=1,lineend-1 do
                local endchar=string.sub(gbtext,lineend,lineend)
                --endbegin 是完整的中文字符开头
                local endbegin=string.sub(gbtext,lineend-j,lineend-j)
                log.info("gc9a01","j="..j)
                log.info("gc9a01","endchar="..string.byte(endchar))
                log.info("gc9a01","endbegin="..string.byte(endbegin))
                --到首位
                if (endbegin==nil) then break end
                if (string.byte(endchar)>=128) then
                    if (string.byte(endbegin)<128) then
                        if((j-j/2*2)==1) then
                            log.info("gc9a01","lineend=lineend-1")
                            lineend=lineend-1
                            break
                        end
                    end
                end
            end
        end
        local linestr=string.sub(gbtext,listed+1,lineend)
        log.info("gc9a01","linstr="..linestr)
        log.info("gc9a01","xspace[i]="..xspace[i])
        log.info("gc9a01","#linestr="..#linestr)
        local blankcount=(xspace[i]-#linestr)/2
        log.info("gc9a01","blankcount="..blankcount)
        disp.puttext(linestr,xstart[i]+blankcount*8,i*16)
        if (listed>=#gbtext) then break end
        listed=lineend
    end
    disp.update()
end


local function init()
    local para =
    {
        width = 240, --分辨率宽度，240像素；用户根据屏的参数自行修改
        height = 240, --分辨率高度，240像素；用户根据屏的参数自行修改
        bpp = 16, --位深度，彩屏仅支持16位
        bus = disp.BUS_SPI4LINE, --LCD专用SPI引脚接口，不可修改
        xoffset = 0, --X轴偏移
        yoffset = 0, --Y轴偏移
        freq = 13000000, --spi时钟频率，支持110K到13M（即110000到13000000）之间的整数（包含110000和13000000）
        hwfillcolor = 0xFFFFFF, --填充色，黑色
        pinrst = pio.P0_6, --reset，复位引脚
        pinrs = pio.P0_1, --rs，命令/数据选择引脚
        --初始化命令
        --前两个字节表示类型：0001表示延时，0000或者0002表示命令，0003表示数据
        --延时类型：后两个字节表示延时时间（单位毫秒）
        --命令类型：后两个字节命令的值
        --数据类型：后两个字节数据的值
        initcmd =
        {
            0x000200EF,
            0x000200EB,
            0x00030014,

            0x000200FE,
            0x000200EF,

            0x000200EB,
            0x00030014,

            0x00020084,
            0x00030040,

            0x00020085,
            0x000300FF,

            0x00020086,
            0x000300FF,

            0x00020087,
            0x000300FF,

            0x00020088,
            0x0003000A,

            0x00020089,
            0x00030021,

            0x0002008A,
            0x00030000,

            0x0002008B,
            0x00030080,

            0x0002008C,
            0x00030001,

            0x0002008D,
            0x00030001,

            0x0002008E,
            0x000300FF,

            0x0002008F,
            0x000300FF,

            0x000200B6,
            0x00030000,
            0x00030020,

            0x00020036,
            0x00030008,
            --0x000300C8,
            --0x00030068,
            --0x000300A8,

            0x0002003A,
            0x00030005,

            0x00020090,
            0x00030008,
            0x00030008,
            0x00030008,
            0x00030008,

            0x000200BD,
            0x00030006,

            0x000200BC,
            0x00030000,

            0x000200FF,
            0x00030060,
            0x00030001,
            0x00030004,

            0x000200C3,
            0x00030013,
            0x000200C4,
            0x00030013,

            0x000200C9,
            0x00030022,

            0x000200BE,
            0x00030011,

            0x000200E1,
            0x00030010,
            0x0003000E,

            0x000200DF,
            0x00030021,
            0x0003000C,
            0x00030002,

            0x000200F0,
            0x00030045,
            0x00030009,
            0x00030008,
            0x00030008,
            0x00030026,
            0x0003002A,

            0x000200F1,
            0x00030043,
            0x00030070,
            0x00030072,
            0x00030036,
            0x00030037,
            0x0003006F,

            0x000200F2,
            0x00030045,
            0x00030009,
            0x00030008,
            0x00030008,
            0x00030026,
            0x0003002A,

            0x000200F3,
            0x00030043,
            0x00030070,
            0x00030072,
            0x00030036,
            0x00030037,
            0x0003006F,

            0x000200ED,
            0x0003001B,
            0x0003000B,

            0x000200AE,
            0x00030077,

            0x000200CD,
            0x00030063,

            0x00020070,
            0x00030007,
            0x00030007,
            0x00030004,
            0x0003000E,
            0x0003000F,
            0x00030009,
            0x00030007,
            0x00030008,
            0x00030003,

            0x000200E8,
            0x00030034,

            0x00020062,
            0x00030018,
            0x0003000D,
            0x00030071,
            0x000300ED,
            0x00030070,
            0x00030070,
            0x00030018,
            0x0003000F,
            0x00030071,
            0x000300EF,
            0x00030070,
            0x00030070,

            0x00020063,
            0x00030018,
            0x00030011,
            0x00030071,
            0x000300F1,
            0x00030070,
            0x00030070,
            0x00030018,
            0x00030013,
            0x00030071,
            0x000300F3,
            0x00030070,
            0x00030070,

            0x00020064,
            0x00030028,
            0x00030029,
            0x000300F1,
            0x00030001,
            0x000300F1,
            0x00030000,
            0x00030007,

            0x00020066,
            0x0003003C,
            0x00030000,
            0x000300CD,
            0x00030067,
            0x00030045,
            0x00030045,
            0x00030010,
            0x00030000,
            0x00030000,
            0x00030000,

            0x00020067,
            0x00030000,
            0x0003003C,
            0x00030000,
            0x00030000,
            0x00030000,
            0x00030001,
            0x00030054,
            0x00030010,
            0x00030032,
            0x00030098,

            0x00020074,
            0x00030010,
            0x00030085,
            0x00030080,
            0x00030000,
            0x00030000,
            0x0003004E,
            0x00030000,

            0x00020098,
            0x0003003E,
            0x00030007,

            0x00020035,
            0x00020021,

            0x00020011,
            0x00010060,
            0x00010060,
            0x00020029,
            0x00010020,
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
    disp.clear()
    disp.putimage("/lua/bg_round.jpg",0,0)
    disp.update()
end

--初始化
init()
--显示标题
--showText("UART DISPLAY")