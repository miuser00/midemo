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
using MSerialization;

namespace Air208Reader
{
    public partial class Form1 : Form
    {
        SerialPort sp = null;   //声明串口类
        bool isOpen = false;    //打开串口标志
        bool isSetProperty = false; //属性设置标志
        bool isHex = false;     //十六进制显示标志位

        int XMargin=0, YMargin = 0;
        float XRatio=1, YRatio = 1;


        public Form1()
        {
            InitializeComponent();
            MSerialization.MSaveControl.Load_All_SupportedControls(this.Controls);
            XMargin = (int)Convert.ToDouble(txt_XMargin.Text);
            YMargin=(int)Convert.ToDouble(txt_YMargin.Text);

            XRatio = (float)Convert.ToDouble(txt_XRatio.Text);
            YRatio = (float)Convert.ToDouble(txt_YRatio.Text);
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            //this.MaximumSize = this.Size;
            //this.MinimumSize = this.Size;
            //this.MaximizeBox = false;
            for (int i=0;i<10;i++)
            {
                cbxCOMPort.Items.Add("COM" + (i + 1).ToString());
            }
        }

        private void btnCheckCOM_Click(object sender, EventArgs e)  //检测有哪串口
        {
            bool comExistence = false;  //是否有可用的串口
            cbxCOMPort.Items.Clear();   //清除当前串口号中的所有串口名称
            for(int i=0;i<99;i++)
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
                cbxCOMPort.SelectedIndex = cbxCOMPort.Items.Count-1;//使ListBox显示第一个添加的索引
            }
            else
            {
                //MessageBox.Show("没有找到可用串口！","错误提示");
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
            if (rbnHex.Checked)
            {
                isHex = true;
            }
            else
            {
                isHex = false;
            }


        }
        void sp_DataReceived(object sender, SerialDataReceivedEventArgs e)
        {
            System.Threading.Thread.Sleep(100);     //延时100ms等待接收数据

            //this.Invoke  跨线程访问ui的方法
            this.Invoke((EventHandler)(delegate
            {
                if (isHex == false)
                {
                    txt_rsv.Text += sp.ReadExisting();
                }
                else
                {
                    Byte[] ReceivedData = new Byte[sp.BytesToRead];
                    sp.Read(ReceivedData, 0, ReceivedData.Length);
                    String RecvDataText = null;
                    for (int i = 0; i < ReceivedData.Length - 1; i++)
                    {
                        RecvDataText += ("0x" + ReceivedData[i].ToString("X2") + "");
                    }
                    txt_rsv.Text += RecvDataText;
                }
                sp.DiscardInBuffer();       //丢弃接收缓冲区数据
            }));
        }
        private void btnSend_Click(object sender, EventArgs e)      //发送数据
        {
            if (isOpen)
            {
                try
                {
                    char[] buff = txt_send.Text.ToCharArray();
                    List<byte> lbuff=new List<byte>();
                    foreach (char c in buff)
                    {
                        lbuff.Add((byte)c);
                    }
                    //lbuff.Add((byte)(10));
                    sp.Write(lbuff.ToArray(),0,lbuff.Count);
                }
                catch(Exception)
                {
                    MessageBox.Show("发送数据时发生错误！", "错误提示");
                    return;
                }
            }
            else
            {
                MessageBox.Show("串口未打开", "错误提示");
                return;
            }
            if (!CheckSendData())
            {
                MessageBox.Show("请输入要发送的数据!", "错误提示");
                return;
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
                }
                catch (Exception)
                {
                    MessageBox.Show("关闭串口时发生错误！", "错误提示");
                }
            }
            
        }
        private void btnCleanData_Click(object sender, EventArgs e)
        {
            txt_rsv.Text = "";
            txt_send.Text = "";
        }

        private void btn_ReadIDMM_Click(object sender, EventArgs e)
        {
            btn_CloseCOM_Click(sender, e);
            cbxBaudRate.Text = "115200";
            btnCheckCOM_Click(sender, e);
            Application.DoEvents();
            btnOpenCom_Click(sender, e);

            if (isOpen)
            {
                txt_rsv.Text = "";
                txt_MM.Text = RunCMD("GETID").Replace("ID=","");
                txt_ID.Text = RunCMD("GETMM").Replace("MM=","");
            }else
            {
                txt_MM.Text = "";
                txt_ID.Text = "";
            }
        }
        string RunCMD(string cmd)
        {
            //Get Imei
            txt_send.Text = cmd;
            btnSend_Click(null, null);
            string ret = "";
            //3s 内收到消息，否则为超时
            for (int i = 0; i < 10; i++)
            {
                System.Threading.Thread.Sleep(100);
                Application.DoEvents();
                try
                {
                    if (txt_rsv.Text != "")
                    {
                        string rsv = txt_rsv.Text;
                        int start = rsv.IndexOf(cmd.Trim(), 0);
                        if (start == -1 ) continue;
                        int end = rsv.IndexOf("\r\n", start);
                        if (end == -1) continue;
                        ret = rsv.Substring(start + cmd.Length+4, end - start - cmd.Length-4).Trim();
                        break;
                    }

                }
                catch { }
            }
            return ret;
        }

        private void btn_CloseCOM_Click(object sender, EventArgs e)
        {
            try       //关闭串口       
            {
                if (sp!=null) sp.Close();
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
            }
            catch (Exception)
            {
               // MessageBox.Show("关闭串口时发生错误！", "错误提示");
            }
        }

        private void btn_MakeLabel_Click(object sender, EventArgs e)
        {
            Font titleFont = new Font("新宋体", 24, System.Drawing.FontStyle.Bold);//标题字体           
            //Font fntTxt = new Font("宋体", 13, System.Drawing.FontStyle.Bold);//正文文字         
            //Font fntTxt1 = new Font("宋体", 9, System.Drawing.FontStyle.Bold);//正文文字         
            System.Drawing.Brush brush = new SolidBrush(System.Drawing.Color.Black);//画刷           
            System.Drawing.Pen pen = new System.Drawing.Pen(System.Drawing.Color.Black);//线条颜色      
            StringFormat sf = new StringFormat();
            sf.Alignment = StringAlignment.Near;
            sf.LineAlignment = StringAlignment.Near;

            string ID = txt_MM.Text;
            string MM = txt_ID.Text;


            try
            {
                //生成控制路径
                txt_url.Text = txt_source.Text+ "?ID=" + ID + "&" + "MM=" + MM;

                Bitmap bitmap = CreateQRCode(txt_url.Text);
                pic_label.Image = new Bitmap(pic_label.Width, pic_label.Height);
                Graphics g = Graphics.FromImage(pic_label.Image);
                Bitmap logo = new Bitmap(Application.StartupPath + "\\"+"logo.png");


                g.DrawImage(bitmap, (0+XMargin)*XRatio, (35+YMargin)*YRatio,bitmap.Width*XRatio,bitmap.Height*YRatio);
                //g.DrawImage(logo, (20+XMargin)*XRatio,(240+YMargin)*YRatio,200 * XRatio, 50 * YRatio);
                g.DrawString("PBV2b Control", titleFont, brush, new Rectangle((int)((34+XMargin)*XRatio), (int)((300+YMargin)*YRatio), (int)(300 * XRatio), (int)(40 * YRatio)), sf);


                Bitmap bmp = new Bitmap(pic_label.Image);
                bmp.RotateFlip(RotateFlipType.Rotate90FlipNone);
                bmp.Save(Application.StartupPath + "\\" + txt_ID.Text + ".png");

            }
            catch (Exception ee)
            {
            }
        }
        public static Bitmap CreateQRCode(string asset)
        {
            EncodingOptions options = new QrCodeEncodingOptions
            {
                DisableECI = true,
                CharacterSet = "UTF-8", //编码
                Width = 300,             //宽度
                Height = 300             //高度
            };
            BarcodeWriter writer = new BarcodeWriter();
            writer.Format = BarcodeFormat.QR_CODE;
            writer.Options = options;
            return writer.Write(asset);
        }

        private void btn_print_Click(object sender, EventArgs e)
        {
            //有图像被打印
            if (System.IO.File.Exists(Application.StartupPath+"\\"+txt_ID.Text+".png"))
            {
                System.Diagnostics.Process.Start("LabelPrinter.exe", txt_ID.Text + ".png" + " " + "Gprinter");
            }
        }

        private void btn_Genlabel_Click(object sender, EventArgs e)
        {
            pic_label.Image = null; 
            txt_MM.Text = "";
            txt_ID.Text = "";
            btn_ReadIDMM_Click(sender, e);
           if ((txt_ID.Text != "") && (txt_MM.Text != ""))
           {
                btn_MakeLabel_Click(sender, e);
            }

        }

        private void btn_AddLabel_Click(object sender, EventArgs e)
        {
        }

        private void btn_ReadIMEISN2_Click(object sender, EventArgs e)
        {

        }

        private void txt_IMEI_TextChanged(object sender, EventArgs e)
        {

        }

        private void btn_down_Click(object sender, EventArgs e)
        {
            YMargin = YMargin + 1;
            btn_Save_Click(sender, e);
            btn_MakeLabel_Click(sender, e);
        }

        private void btn_left_Click(object sender, EventArgs e)
        {
            XMargin = XMargin - 1;
            btn_Save_Click(sender, e);
            btn_MakeLabel_Click(sender, e);
        }

        private void btn_longer_Click(object sender, EventArgs e)
        {
            YRatio = YRatio +(float)0.01;
            btn_Save_Click(sender, e);
            btn_MakeLabel_Click(sender, e);
        }

        private void btn_shorter_Click(object sender, EventArgs e)
        {
            YRatio = YRatio - (float)0.01;
            btn_Save_Click(sender, e);
            btn_MakeLabel_Click(sender, e);
        }

        private void btn_narrower_Click(object sender, EventArgs e)
        {
            XRatio = XRatio - (float)0.01;
            btn_Save_Click(sender, e);
            btn_MakeLabel_Click(sender, e);
        }

        private void btn_wider_Click(object sender, EventArgs e)
        {
            XRatio = XRatio + (float)0.01;
            btn_Save_Click(sender, e);
            btn_MakeLabel_Click(sender, e);
        }

        private void btn_Reset_Click(object sender, EventArgs e)
        {
            XRatio = 1;YRatio = 1;
            XMargin = 0;YMargin = 0;
            btn_Save_Click(sender, e);
            btn_MakeLabel_Click(sender, e);
        }

        private void btn_Save_Click(object sender, EventArgs e)
        {
            txt_XMargin.Text = XMargin.ToString();
            txt_YMargin.Text = YMargin.ToString();
            txt_XRatio.Text = XRatio.ToString();
            txt_YRatio.Text = YRatio.ToString();
            MSerialization.MSaveControl.Save_All_SupportedControls(this.Controls);
        }

        private void btn_right_Click(object sender, EventArgs e)
        {
            XMargin = XMargin + 1;
            btn_Save_Click(sender, e);
            btn_MakeLabel_Click(sender, e);
        }

        private void btn_up_Click(object sender, EventArgs e)
        {
            YMargin = YMargin - 1;
            btn_Save_Click(sender, e);
            btn_MakeLabel_Click(sender, e);

        }
    }
}
