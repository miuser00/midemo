PROJECT = "midemo"
VERSION = "0.4.0"
AUTHOR = "Miuser"
PRODUCT_KEY = "6MfofZKoOrx5YShU9F2lpT8FSOTKNCF2"


require "sys"
require "net"
require "utils"
require "patch"

--加载日志功能模块，并且设置日志输出等级
--如果关闭调用log模块接口输出的日志，等级设置为log.LOG_SILENT即可
require "log"
LOG_LEVEL = log.LOGLEVEL_TRACE

--每8S查询一次GSM信号强度
--每1分钟查询一次基站信息
net.startQueryAll(8000, 60000)

--上传错误日志
require "errDump"
errDump.request("udp://ota.airm2m.com:9072")

--NTP时间同步
require "ntp"
ntp.timeSync(24, function()log.info(" AutoTimeSync is Done!") end)

--加载控制台调试功能模块（此处代码配置的是uart2，波特率115200）
--require "console"
--console.setup(2, 115200)

require "lbsLoc"
require "sms"
require "mcc"

--加载核心板全局配置
local midemo="/lua/midemo.bs"
dofile(midemo)

--声明全局状态
local status="/lua/status.bs"
dofile(status)

--加载并启动核心板模块
require "bs"


--启动系统框架
sys.init(0, 0)
sys.run()

