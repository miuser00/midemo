using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO.Ports;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using ZXing.QrCode;
using ZXing;
using ZXing.Common;
using udp;
using System.Net;
using System.Text.RegularExpressions;

namespace MTJMCN_CS
{
    public partial class Form1 : Form
    {
        SerialPort sp = null;   //声明串口类
        bool isOpen = false;    //打开串口标志
        bool isSetProperty = false; //属性设置标志
        bool isHexRead = false;     //十六进制显示标志位
        bool isHexWrite = false;     //十六进制显示标志位
        public static List<package> packages = new List<package>();
        public static long sndcount, rsvcount, errcount = 0;
        public static long responsetime = 0;
        public int sleeptime;
        public int delaytime;


        public Form1()
        {
            InitializeComponent();
        }

        private void btnCheckCOM_Click(object sender, EventArgs e)  //检测有哪串口
        {
            bool comExistence = false;  //是否有可用的串口
            cbxCOMPort.Items.Clear();   //清除当前串口号中的所有串口名称
            for (int i = 0; i < 100; i++)
            {
                try
                {
                    SerialPort sp = new SerialPort("COM" + (i + 1).ToString());
                    sp.Open();
                    sp.Close();
                    cbxCOMPort.Items.Add("COM" + (i + 1).ToString());
                    comExistence = true;
                }
                catch (Exception)
                {
                    continue;
                }
            }
            if (comExistence)
            {
                cbxCOMPort.SelectedIndex = cbxCOMPort.Items.Count - 1;//使ListBox显示第一个添加的索引
            }
            else
            {
                //MessageBox.Show("没有找到可用串口！","错误提示");
            }
        }
        private void btnOpenCom_Click(object sender, EventArgs e)
        {
            if (isOpen == false)
            {
                if (!CheckPortSetting())        //检测串口设置
                {
                    //MessageBox.Show("串口未设置！", "错误提示");
                    return;
                }
                if (!isSetProperty)             //串口未设置则设置串口
                {
                    SetPortProPerty();
                    isSetProperty = true;
                }
                try
                {
                    sp.Open();
                    isOpen = true;
                    btnOpenCom.Text = "关闭串口";
                    //串口打开后则相关串口设置按钮便不可再用
                    cbxCOMPort.Enabled = false;
                    cbxBaudRate.Enabled = false;
                    cbxDataBits.Enabled = false;
                    cbxParitv.Enabled = false;
                    cbxStopBits.Enabled = false;
                    rbnChar.Enabled = false;
                    rbnHex.Enabled = false;
                }
                catch (Exception)
                {
                    //打开串口失败后，相应标志位取消
                    isSetProperty = false;
                    isOpen = false;
                    //MessageBox.Show("串口无效或已被占用！", "错误提示");
                }
            }
            else
            {
                try       //关闭串口       
                {
                    sp.Close();
                    isOpen = false;
                    btnOpenCom.Text = "打开串口";
                    //关闭串口后，串口设置选项可以继续使用
                    cbxCOMPort.Enabled = true;
                    cbxBaudRate.Enabled = true;
                    cbxDataBits.Enabled = true;
                    cbxParitv.Enabled = true;
                    cbxStopBits.Enabled = true;
                    rbnChar.Enabled = true;
                    rbnHex.Enabled = true;
                    isSetProperty = false;
                }
                catch (Exception)
                {
                    MessageBox.Show("关闭串口时发生错误！", "错误提示");
                }
            }

        }
        private void btn_CloseCOM_Click(object sender, EventArgs e)
        {
            try       //关闭串口       
            {
                sp.Close();
                isOpen = false;
                btnOpenCom.Text = "打开串口";
                //关闭串口后，串口设置选项可以继续使用
                cbxCOMPort.Enabled = true;
                cbxBaudRate.Enabled = true;
                cbxDataBits.Enabled = true;
                cbxParitv.Enabled = true;
                cbxStopBits.Enabled = true;
                rbnChar.Enabled = true;
                rbnHex.Enabled = true;
                isSetProperty = false;
            }
            catch (Exception)
            {
                // MessageBox.Show("关闭串口时发生错误！", "错误提示");
            }
        }
        private bool CheckPortSetting()     //串口是否设置
        {
            if (cbxCOMPort.Text.Trim() == "") return false;
            if (cbxBaudRate.Text.Trim() == "") return false;
            if (cbxDataBits.Text.Trim() == "") return false;
            if (cbxParitv.Text.Trim() == "") return false;
            if (cbxStopBits.Text.Trim() == "") return false;
            return true;
        }
        private bool CheckSendData()
        {
            if (txt_send.Text.Trim() == "") return false;
            return true;
        }
        private void SetPortProPerty()      //设置串口属性
        {
            sp = new SerialPort();
            
            sp.Encoding= Encoding.GetEncoding("GB2312");

            sp.PortName = cbxCOMPort.Text.Trim();       //串口名

            sp.BaudRate = Convert.ToInt32(cbxBaudRate.Text.Trim());//波特率

            float f = Convert.ToSingle(cbxStopBits.Text.Trim());//停止位
            if (f == 0)
            {
                sp.StopBits = StopBits.None;
            }
            else if (f == 1.5)
            {
                sp.StopBits = StopBits.OnePointFive;
            }
            else if (f == 1)
            {
                sp.StopBits = StopBits.One;
            }
            else if (f == 2)
            {
                sp.StopBits = StopBits.Two;
            }
            else
            {
                sp.StopBits = StopBits.One;
            }

            sp.DataBits = Convert.ToInt16(cbxDataBits.Text.Trim());//数据位

            string s = cbxParitv.Text.Trim();       //校验位
            if (s.CompareTo("无") == 0)
            {
                sp.Parity = Parity.None;
            }
            else if (s.CompareTo("奇校验") == 0)
            {
                sp.Parity = Parity.Odd;
            }
            else if (s.CompareTo("偶校验") == 0)
            {
                sp.Parity = Parity.Even;
            }
            else
            {
                sp.Parity = Parity.None;
            }

            sp.ReadTimeout = -1;         //设置超时读取时间
            sp.RtsEnable = true;

            //定义DataReceived事件，当串口收到数据后触发事件
            sp.DataReceived += new SerialDataReceivedEventHandler(sp_DataReceived);


        }
        void sp_DataReceived(object sender, SerialDataReceivedEventArgs e)
        {
            System.Threading.Thread.Sleep(100);     //延时100ms等待接收数据

            //this.Invoke  跨线程访问ui的方法
            this.Invoke((EventHandler)(delegate
            {
                if (isHexRead == false)
                {
                    
                    txt_rsv.Text += sp.ReadExisting();
                }
                else
                {
                    Byte[] ReceivedData = new Byte[sp.BytesToRead];
                    sp.Read(ReceivedData, 0, ReceivedData.Length);
                    String RecvDataText = null;
                    for (int i = 0; i < ReceivedData.Length ; i++)
                    {
                        RecvDataText += ( ReceivedData[i].ToString("X2") + " ");
                    }
                    RecvDataText += "\r\n";
                    txt_rsv.Text += RecvDataText;
                    txt_rsv.Select(txt_rsv.TextLength, 0);
                    txt_rsv.ScrollToCaret();
                }
                sp.DiscardInBuffer();       //丢弃接收缓冲区数据
            }));
        }

        private void btnCleanData_Click(object sender, EventArgs e)
        {
            txt_rsv.Text = "";
            txt_send.Text = "";
        }
        private void btnSend_Click(object sender, EventArgs e)      //发送数据
        {
            if (rad_AscSend.Checked) isHexWrite = false; else isHexWrite = true;

            if (isOpen)
            {
                try
                {
                    //字符串方式发送
                    if (!isHexWrite)
                    {
                        List<byte> lbuff = new List<byte>();
                        lbuff = StringToBytes(txt_send.Text).ToList();
                        //lbuff.Add((byte)(10));
                        sp.Write(lbuff.ToArray(), 0, lbuff.Count);
                    }
                    //二进制方式发送
                    else
                    {
                        List<byte> lbuff = new List<byte>();
                        lbuff = strToToHexByte(txt_send.Text).ToList();
                        sp.Write(lbuff.ToArray(), 0, lbuff.Count);
                    }
                }
                catch (Exception)
                {
                    MessageBox.Show("发送数据时发生错误！", "错误提示");
                    return;
                }
            }
            //UDP连接
            else if (isRunning)
            {
                //生成一个包
                if (!isHexWrite)
                {
                    List<byte> lbuff = new List<byte>();
                    lbuff = StringToBytes(txt_send.Text).ToList();

                    package pkg = new package(txt_ID.Text, txt_MM.Text, BytesToString(lbuff.ToArray()));
                    string s_out = pkg.str.ToString();
                    byte[] bt = Encoding.GetEncoding("GB2312").GetBytes(s_out);
                    client.Send(bt, client.ep);
                }else
                {
                    List<byte> lbuff = new List<byte>();
                    lbuff = strToToHexByte(txt_send.Text).ToList();
                    package pkg = new package(txt_ID.Text, txt_MM.Text, BytesToString(lbuff.ToArray()));
                    string s_out = pkg.str.ToString();
                    byte[] bt = Encoding.GetEncoding("GB2312").GetBytes(s_out);
                    client.Send(bt, client.ep);
                }
            }
            else
            {
                MessageBox.Show("数据传输端口未打开", "错误提示");
                return;
            }
            if (!CheckSendData())
            {
                MessageBox.Show("请输入要发送的数据!", "错误提示");
                return;
            }




        }
        private byte[] StringToBytes(string TheString)
        {
            Encoding FromEcoding = Encoding.GetEncoding("UTF-8");
            Encoding ToEcoding = Encoding.GetEncoding("GB2312");
            byte[] FromBytes = FromEcoding.GetBytes(TheString);
            byte[] ToBytes = Encoding.Convert(FromEcoding, ToEcoding, FromBytes);
            return ToBytes;
        }

        private string BytesToString(byte[] Bytes)
        {
            string Mystring;
            Encoding FromEcoding = Encoding.GetEncoding("GB2312");
            Encoding ToEcoding = Encoding.GetEncoding("UTF-8");

            byte[] ToBytes = Encoding.Convert(FromEcoding, ToEcoding, Bytes);
            Mystring = ToEcoding.GetString(ToBytes);
            return Mystring;
        }
        private static byte[] strToToHexByte(string hexString)
        {
            hexString = hexString.Replace(" ", "");
            if ((hexString.Length % 2) != 0)
                hexString += " ";
            byte[] returnBytes = new byte[hexString.Length / 2];
            for (int i = 0; i < returnBytes.Length; i++)
                returnBytes[i] = Convert.ToByte(hexString.Substring(i * 2, 2), 16);
            return returnBytes;
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }


        bool isRunning;
        string s_server, s_port;
        public class Client : Udp
        {
            public EndPoint ep;
            public Client()
            {

            }
        }

        private void btn_DisconnectUDP_Click(object sender, EventArgs e)
        {
            isRunning = false;
            client.Dispose();
        }

        Client client = new Client();

        private void groupBox4_Enter(object sender, EventArgs e)
        {

        }

        private void rbnChar_CheckedChanged(object sender, EventArgs e)
        {
            if (rbnHex.Checked)
            {
                isHexRead = true;
            }
            else
            {
                isHexRead = false;
            }

        }

        private void rbnHex_CheckedChanged(object sender, EventArgs e)
        {
            if (rbnHex.Checked)
            {
                isHexRead = true;
            }
            else
            {
                isHexRead = false;
            }

        }

        private void tmr_heartbeat_Tick(object sender, EventArgs e)
        {
            if (isRunning)
            {
                package pkg = new package(txt_ID.Text, txt_MM.Text,"C# Controll V0.1","B");
                string s_out = pkg.str.ToString();
                byte[] bt = Encoding.GetEncoding("GB2312").GetBytes(s_out);
                client.Send(bt, client.ep);
            }
        }

        private void btn_GetIDMM_Click(object sender, EventArgs e)
        {
            string url= Clipboard.GetText();
            string regID = @"ID=(.*)&";
            MatchCollection matches = Regex.Matches(url, regID);
            if (matches.Count > 0)
            {
                foreach (Match match in matches)
                {
                    GroupCollection groups = match.Groups;
                    txt_ID.Text = groups[1].Value;
                 }
             }
            string regMM = @"MM=(.*)";
            MatchCollection matches2 = Regex.Matches(url, regMM);
            if (matches2.Count > 0)
            {
                foreach (Match match in matches2)
                {
                    GroupCollection groups = match.Groups;
                    txt_MM.Text = groups[1].Value;
                }
            }
        }

        private void checkBox1_CheckedChanged(object sender, EventArgs e)
        {

        }

        private void btn_ConnectUDP_Click(object sender, EventArgs e)
        {
            if (!isRunning)
            {
                isRunning = true;
                s_server = txt_server.Text;
                s_port = txt_port.Text;
                client = new Client();
                IPHostEntry hostEntry = Dns.GetHostEntry((s_server));
                client.ep = new IPEndPoint(hostEntry.AddressList[hostEntry.AddressList.Length - 1], Convert.ToInt32(s_port));
                client.Listening();
                client.Received += new UdpEventHandler(client_Received);

                if (rbnHex.Checked)
                {
                    isHexRead = true;
                }
                else
                {
                    isHexRead = false;
                }
                tmr_heartbeat_Tick(sender,e);

            }

        }
        void client_Received(object sender, UdpEventArgs e)
        {

            IPEndPoint ep = e.Remote as IPEndPoint;
            string tmpReceived = Encoding.Default.GetString(e.Received);
            this.BeginInvoke(new Action(() =>
            {
                rtb_rsv.Text = tmpReceived;
                if ((tmpReceived.Substring(6,1)=="C")&&(chb_C.Checked==true))
                {
                    string content = tmpReceived.Substring(39, tmpReceived.Length - 41);
                    if (isHexRead == false)
                    {
                        txt_rsv.Text += content + "\r\n";
                        txt_rsv.Select(txt_rsv.TextLength, 0);
                        txt_rsv.ScrollToCaret();
                    }
                    else
                    {
                        string RecvDataText = "";
                        Byte[] ReceivedData = StringToBytes(content);

                        for (int i = 0; i < ReceivedData.Length; i++)
                        {
                            RecvDataText += (ReceivedData[i].ToString("X2") + " ");
                        }
                        RecvDataText += "\r\n";
                        txt_rsv.Text += RecvDataText;
                        txt_rsv.Select(txt_rsv.TextLength, 0);
                        txt_rsv.ScrollToCaret();
                    }



                }
                if ((tmpReceived.Substring(6, 1) == "B") && (chb_B.Checked == true))
                {
                    string content = tmpReceived.Substring(39, tmpReceived.Length - 41);
                    if (isHexRead == false)
                    {
                        txt_rsv.Text += content + "\r\n";
                        txt_rsv.Select(txt_rsv.TextLength, 0);
                        txt_rsv.ScrollToCaret();
                    }
                    else
                    {
                        string RecvDataText = "";
                        Byte[] ReceivedData = StringToBytes(content);

                        for (int i = 0; i < ReceivedData.Length; i++)
                        {
                            RecvDataText += (ReceivedData[i].ToString("X2") + " ");
                        }
                        RecvDataText += "\r\n";
                        txt_rsv.Text += RecvDataText;
                        txt_rsv.Select(txt_rsv.TextLength, 0);
                        txt_rsv.ScrollToCaret();
                    }



                }
                if ((tmpReceived.Substring(6, 1) == "A") && (chb_A.Checked == true))
                {
                    string content = tmpReceived.Substring(39, tmpReceived.Length - 41);
                    if (isHexRead == false)
                    {
                        txt_rsv.Text += content + "\r\n";
                        txt_rsv.Select(txt_rsv.TextLength, 0);
                        txt_rsv.ScrollToCaret();
                    }
                    else
                    {
                        string RecvDataText = "";
                        Byte[] ReceivedData = StringToBytes(content);

                        for (int i = 0; i < ReceivedData.Length; i++)
                        {
                            RecvDataText += (ReceivedData[i].ToString("X2") + " ");
                        }
                        RecvDataText += "\r\n";
                        txt_rsv.Text += RecvDataText;
                        txt_rsv.Select(txt_rsv.TextLength, 0);
                        txt_rsv.ScrollToCaret();
                    }



                }
            }));

        }
        public class package
        {
            public string str;
            //确认收到
            public bool Confirmed;
            public DateTime timestamp = DateTime.Now;
            public package(string ID = "0000000000", string MM = "0000000000000000",string content="",string type="")
            {
                Random ran = new Random((int)DateTime.Now.Ticks);
                if (type == "")
                {
                    str = "004932A08";
                }else
                {
                    str = "004932" + type + "08";
                }
                str = str + ID;
                str = str + MM;
                str = str + "1234";
                if (content == "")
                {
                    str = str + "a" + ran.Next().ToString("D9");
                }else
                {
                    str = str + content;
                }
                str = str + "05";
                int len = str.Length;
                string s_len = ("00" + len.ToString()).Substring(0, 4);
                str = s_len + str.Substring(4, str.Length - 4);
            }
        }


    }
}
