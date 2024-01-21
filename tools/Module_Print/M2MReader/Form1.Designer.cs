namespace Air208Reader
{
    partial class Form1
    {
        /// <summary>
        /// 必需的设计器变量。
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// 清理所有正在使用的资源。
        /// </summary>
        /// <param name="disposing">如果应释放托管资源，为 true；否则为 false。</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows 窗体设计器生成的代码

        /// <summary>
        /// 设计器支持所需的方法 - 不要修改
        /// 使用代码编辑器修改此方法的内容。
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.label5 = new System.Windows.Forms.Label();
            this.serialPort1 = new System.IO.Ports.SerialPort(this.components);
            this.serialPort2 = new System.IO.Ports.SerialPort(this.components);
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.btn_CloseCOM = new System.Windows.Forms.Button();
            this.btnOpenCom = new System.Windows.Forms.Button();
            this.rbnHex = new System.Windows.Forms.RadioButton();
            this.rbnChar = new System.Windows.Forms.RadioButton();
            this.btnCheckCOM = new System.Windows.Forms.Button();
            this.cbxDataBits = new System.Windows.Forms.ComboBox();
            this.cbxStopBits = new System.Windows.Forms.ComboBox();
            this.cbxParitv = new System.Windows.Forms.ComboBox();
            this.cbxBaudRate = new System.Windows.Forms.ComboBox();
            this.cbxCOMPort = new System.Windows.Forms.ComboBox();
            this.groupBox2 = new System.Windows.Forms.GroupBox();
            this.txt_rsv = new System.Windows.Forms.TextBox();
            this.groupBox3 = new System.Windows.Forms.GroupBox();
            this.txt_send = new System.Windows.Forms.TextBox();
            this.btnCleanData = new System.Windows.Forms.Button();
            this.btnSend = new System.Windows.Forms.Button();
            this.btn_ReadIDMM = new System.Windows.Forms.Button();
            this.txt_MM = new System.Windows.Forms.TextBox();
            this.txt_ID = new System.Windows.Forms.TextBox();
            this.label6 = new System.Windows.Forms.Label();
            this.label7 = new System.Windows.Forms.Label();
            this.btn_MakeLabel = new System.Windows.Forms.Button();
            this.txt_url = new System.Windows.Forms.TextBox();
            this.btn_print = new System.Windows.Forms.Button();
            this.btn_Genlabel = new System.Windows.Forms.Button();
            this.pic_label = new System.Windows.Forms.PictureBox();
            this.txt_source = new System.Windows.Forms.TextBox();
            this.label8 = new System.Windows.Forms.Label();
            this.btn_up = new System.Windows.Forms.Button();
            this.btn_down = new System.Windows.Forms.Button();
            this.btn_left = new System.Windows.Forms.Button();
            this.btn_right = new System.Windows.Forms.Button();
            this.btn_wider = new System.Windows.Forms.Button();
            this.btn_narrower = new System.Windows.Forms.Button();
            this.btn_shorter = new System.Windows.Forms.Button();
            this.btn_longer = new System.Windows.Forms.Button();
            this.btn_Reset = new System.Windows.Forms.Button();
            this.label9 = new System.Windows.Forms.Label();
            this.txt_XMargin = new System.Windows.Forms.TextBox();
            this.txt_YMargin = new System.Windows.Forms.TextBox();
            this.txt_YRatio = new System.Windows.Forms.TextBox();
            this.txt_XRatio = new System.Windows.Forms.TextBox();
            this.label10 = new System.Windows.Forms.Label();
            this.label11 = new System.Windows.Forms.Label();
            this.label12 = new System.Windows.Forms.Label();
            this.label13 = new System.Windows.Forms.Label();
            this.btn_Save = new System.Windows.Forms.Button();
            this.groupBox1.SuspendLayout();
            this.groupBox2.SuspendLayout();
            this.groupBox3.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pic_label)).BeginInit();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(12, 40);
            this.label1.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(41, 12);
            this.label1.TabIndex = 8;
            this.label1.Text = "波特率";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(151, 40);
            this.label2.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(41, 12);
            this.label2.TabIndex = 9;
            this.label2.Text = "数据位";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(12, 65);
            this.label3.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(41, 12);
            this.label3.TabIndex = 10;
            this.label3.Text = "停止位";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(158, 17);
            this.label4.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(29, 12);
            this.label4.TabIndex = 11;
            this.label4.Text = "校验";
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(12, 17);
            this.label5.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(41, 12);
            this.label5.TabIndex = 12;
            this.label5.Text = "通讯口";
            // 
            // serialPort2
            // 
            this.serialPort2.PortName = "COM2";
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.btn_CloseCOM);
            this.groupBox1.Controls.Add(this.btnOpenCom);
            this.groupBox1.Controls.Add(this.rbnHex);
            this.groupBox1.Controls.Add(this.rbnChar);
            this.groupBox1.Controls.Add(this.btnCheckCOM);
            this.groupBox1.Controls.Add(this.cbxDataBits);
            this.groupBox1.Controls.Add(this.cbxStopBits);
            this.groupBox1.Controls.Add(this.cbxParitv);
            this.groupBox1.Controls.Add(this.cbxBaudRate);
            this.groupBox1.Controls.Add(this.cbxCOMPort);
            this.groupBox1.Controls.Add(this.label5);
            this.groupBox1.Controls.Add(this.label1);
            this.groupBox1.Controls.Add(this.label3);
            this.groupBox1.Controls.Add(this.label4);
            this.groupBox1.Controls.Add(this.label2);
            this.groupBox1.Location = new System.Drawing.Point(488, 10);
            this.groupBox1.Margin = new System.Windows.Forms.Padding(2);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Padding = new System.Windows.Forms.Padding(2);
            this.groupBox1.Size = new System.Drawing.Size(459, 84);
            this.groupBox1.TabIndex = 16;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "串口设置";
            // 
            // btn_CloseCOM
            // 
            this.btn_CloseCOM.Location = new System.Drawing.Point(376, 40);
            this.btn_CloseCOM.Margin = new System.Windows.Forms.Padding(2);
            this.btn_CloseCOM.Name = "btn_CloseCOM";
            this.btn_CloseCOM.Size = new System.Drawing.Size(67, 21);
            this.btn_CloseCOM.TabIndex = 22;
            this.btn_CloseCOM.Text = "关闭串口";
            this.btn_CloseCOM.UseVisualStyleBackColor = true;
            this.btn_CloseCOM.Click += new System.EventHandler(this.btn_CloseCOM_Click);
            // 
            // btnOpenCom
            // 
            this.btnOpenCom.Location = new System.Drawing.Point(376, 18);
            this.btnOpenCom.Margin = new System.Windows.Forms.Padding(2);
            this.btnOpenCom.Name = "btnOpenCom";
            this.btnOpenCom.Size = new System.Drawing.Size(67, 21);
            this.btnOpenCom.TabIndex = 21;
            this.btnOpenCom.Text = "打开串口";
            this.btnOpenCom.UseVisualStyleBackColor = true;
            this.btnOpenCom.Click += new System.EventHandler(this.btnOpenCom_Click);
            // 
            // rbnHex
            // 
            this.rbnHex.AutoSize = true;
            this.rbnHex.Location = new System.Drawing.Point(256, 63);
            this.rbnHex.Margin = new System.Windows.Forms.Padding(2);
            this.rbnHex.Name = "rbnHex";
            this.rbnHex.Size = new System.Drawing.Size(65, 16);
            this.rbnHex.TabIndex = 20;
            this.rbnHex.Text = "Hex显示";
            this.rbnHex.UseVisualStyleBackColor = true;
            // 
            // rbnChar
            // 
            this.rbnChar.AutoSize = true;
            this.rbnChar.Checked = true;
            this.rbnChar.Location = new System.Drawing.Point(188, 63);
            this.rbnChar.Margin = new System.Windows.Forms.Padding(2);
            this.rbnChar.Name = "rbnChar";
            this.rbnChar.Size = new System.Drawing.Size(71, 16);
            this.rbnChar.TabIndex = 19;
            this.rbnChar.TabStop = true;
            this.rbnChar.Text = "字符显示";
            this.rbnChar.UseVisualStyleBackColor = true;
            // 
            // btnCheckCOM
            // 
            this.btnCheckCOM.Location = new System.Drawing.Point(312, 19);
            this.btnCheckCOM.Margin = new System.Windows.Forms.Padding(2);
            this.btnCheckCOM.Name = "btnCheckCOM";
            this.btnCheckCOM.Size = new System.Drawing.Size(61, 36);
            this.btnCheckCOM.TabIndex = 18;
            this.btnCheckCOM.Text = "串口检测";
            this.btnCheckCOM.UseVisualStyleBackColor = true;
            this.btnCheckCOM.Click += new System.EventHandler(this.btnCheckCOM_Click);
            // 
            // cbxDataBits
            // 
            this.cbxDataBits.FormattingEnabled = true;
            this.cbxDataBits.Items.AddRange(new object[] {
            "8",
            "7",
            "6",
            "5"});
            this.cbxDataBits.Location = new System.Drawing.Point(207, 38);
            this.cbxDataBits.Margin = new System.Windows.Forms.Padding(2);
            this.cbxDataBits.Name = "cbxDataBits";
            this.cbxDataBits.Size = new System.Drawing.Size(92, 20);
            this.cbxDataBits.TabIndex = 17;
            this.cbxDataBits.Text = "8";
            // 
            // cbxStopBits
            // 
            this.cbxStopBits.FormattingEnabled = true;
            this.cbxStopBits.Items.AddRange(new object[] {
            "0",
            "1",
            "1.5",
            "2"});
            this.cbxStopBits.Location = new System.Drawing.Point(56, 61);
            this.cbxStopBits.Margin = new System.Windows.Forms.Padding(2);
            this.cbxStopBits.Name = "cbxStopBits";
            this.cbxStopBits.Size = new System.Drawing.Size(92, 20);
            this.cbxStopBits.TabIndex = 16;
            this.cbxStopBits.Text = "1";
            // 
            // cbxParitv
            // 
            this.cbxParitv.FormattingEnabled = true;
            this.cbxParitv.Items.AddRange(new object[] {
            "无",
            "奇校验",
            "偶校验"});
            this.cbxParitv.Location = new System.Drawing.Point(207, 14);
            this.cbxParitv.Margin = new System.Windows.Forms.Padding(2);
            this.cbxParitv.Name = "cbxParitv";
            this.cbxParitv.Size = new System.Drawing.Size(92, 20);
            this.cbxParitv.TabIndex = 15;
            this.cbxParitv.Text = "无";
            // 
            // cbxBaudRate
            // 
            this.cbxBaudRate.FormattingEnabled = true;
            this.cbxBaudRate.Items.AddRange(new object[] {
            "1200",
            "2400",
            "4800",
            "9600",
            "19200",
            "38400",
            "43000",
            "56000",
            "57600",
            "115200"});
            this.cbxBaudRate.Location = new System.Drawing.Point(56, 38);
            this.cbxBaudRate.Margin = new System.Windows.Forms.Padding(2);
            this.cbxBaudRate.Name = "cbxBaudRate";
            this.cbxBaudRate.Size = new System.Drawing.Size(92, 20);
            this.cbxBaudRate.TabIndex = 14;
            this.cbxBaudRate.Text = "115200";
            // 
            // cbxCOMPort
            // 
            this.cbxCOMPort.FormattingEnabled = true;
            this.cbxCOMPort.Location = new System.Drawing.Point(56, 14);
            this.cbxCOMPort.Margin = new System.Windows.Forms.Padding(2);
            this.cbxCOMPort.Name = "cbxCOMPort";
            this.cbxCOMPort.Size = new System.Drawing.Size(92, 20);
            this.cbxCOMPort.TabIndex = 13;
            // 
            // groupBox2
            // 
            this.groupBox2.Controls.Add(this.txt_rsv);
            this.groupBox2.Location = new System.Drawing.Point(488, 98);
            this.groupBox2.Margin = new System.Windows.Forms.Padding(2);
            this.groupBox2.Name = "groupBox2";
            this.groupBox2.Padding = new System.Windows.Forms.Padding(2);
            this.groupBox2.Size = new System.Drawing.Size(459, 127);
            this.groupBox2.TabIndex = 17;
            this.groupBox2.TabStop = false;
            this.groupBox2.Text = "数据接收";
            // 
            // txt_rsv
            // 
            this.txt_rsv.Location = new System.Drawing.Point(26, 19);
            this.txt_rsv.Margin = new System.Windows.Forms.Padding(2);
            this.txt_rsv.Multiline = true;
            this.txt_rsv.Name = "txt_rsv";
            this.txt_rsv.ReadOnly = true;
            this.txt_rsv.Size = new System.Drawing.Size(419, 104);
            this.txt_rsv.TabIndex = 0;
            // 
            // groupBox3
            // 
            this.groupBox3.Controls.Add(this.txt_send);
            this.groupBox3.Controls.Add(this.btnCleanData);
            this.groupBox3.Controls.Add(this.btnSend);
            this.groupBox3.Location = new System.Drawing.Point(488, 230);
            this.groupBox3.Margin = new System.Windows.Forms.Padding(2);
            this.groupBox3.Name = "groupBox3";
            this.groupBox3.Padding = new System.Windows.Forms.Padding(2);
            this.groupBox3.Size = new System.Drawing.Size(459, 98);
            this.groupBox3.TabIndex = 18;
            this.groupBox3.TabStop = false;
            this.groupBox3.Text = "数据发送";
            // 
            // txt_send
            // 
            this.txt_send.Location = new System.Drawing.Point(26, 19);
            this.txt_send.Margin = new System.Windows.Forms.Padding(2);
            this.txt_send.Multiline = true;
            this.txt_send.Name = "txt_send";
            this.txt_send.Size = new System.Drawing.Size(348, 64);
            this.txt_send.TabIndex = 1;
            // 
            // btnCleanData
            // 
            this.btnCleanData.Location = new System.Drawing.Point(387, 18);
            this.btnCleanData.Margin = new System.Windows.Forms.Padding(2);
            this.btnCleanData.Name = "btnCleanData";
            this.btnCleanData.Size = new System.Drawing.Size(56, 25);
            this.btnCleanData.TabIndex = 22;
            this.btnCleanData.Text = "清空数据";
            this.btnCleanData.UseVisualStyleBackColor = true;
            this.btnCleanData.Click += new System.EventHandler(this.btnCleanData_Click);
            // 
            // btnSend
            // 
            this.btnSend.Location = new System.Drawing.Point(387, 58);
            this.btnSend.Margin = new System.Windows.Forms.Padding(2);
            this.btnSend.Name = "btnSend";
            this.btnSend.Size = new System.Drawing.Size(56, 25);
            this.btnSend.TabIndex = 23;
            this.btnSend.Text = "发送数据";
            this.btnSend.UseVisualStyleBackColor = true;
            this.btnSend.Click += new System.EventHandler(this.btnSend_Click);
            // 
            // btn_ReadIDMM
            // 
            this.btn_ReadIDMM.Location = new System.Drawing.Point(502, 339);
            this.btn_ReadIDMM.Name = "btn_ReadIDMM";
            this.btn_ReadIDMM.Size = new System.Drawing.Size(151, 32);
            this.btn_ReadIDMM.TabIndex = 19;
            this.btn_ReadIDMM.Text = "读取ID,MM（量产）";
            this.btn_ReadIDMM.UseVisualStyleBackColor = true;
            this.btn_ReadIDMM.Click += new System.EventHandler(this.btn_ReadIDMM_Click);
            // 
            // txt_MM
            // 
            this.txt_MM.Location = new System.Drawing.Point(716, 388);
            this.txt_MM.Name = "txt_MM";
            this.txt_MM.Size = new System.Drawing.Size(196, 21);
            this.txt_MM.TabIndex = 20;
            this.txt_MM.TextChanged += new System.EventHandler(this.txt_IMEI_TextChanged);
            // 
            // txt_ID
            // 
            this.txt_ID.Location = new System.Drawing.Point(716, 346);
            this.txt_ID.Name = "txt_ID";
            this.txt_ID.Size = new System.Drawing.Size(196, 21);
            this.txt_ID.TabIndex = 21;
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(688, 391);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(17, 12);
            this.label6.TabIndex = 22;
            this.label6.Text = "MM";
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(688, 349);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(17, 12);
            this.label7.TabIndex = 23;
            this.label7.Text = "ID";
            // 
            // btn_MakeLabel
            // 
            this.btn_MakeLabel.Location = new System.Drawing.Point(12, 440);
            this.btn_MakeLabel.Name = "btn_MakeLabel";
            this.btn_MakeLabel.Size = new System.Drawing.Size(170, 43);
            this.btn_MakeLabel.TabIndex = 24;
            this.btn_MakeLabel.Text = "制作条码";
            this.btn_MakeLabel.UseVisualStyleBackColor = true;
            this.btn_MakeLabel.Click += new System.EventHandler(this.btn_MakeLabel_Click);
            // 
            // txt_url
            // 
            this.txt_url.Location = new System.Drawing.Point(12, 357);
            this.txt_url.Multiline = true;
            this.txt_url.Name = "txt_url";
            this.txt_url.Size = new System.Drawing.Size(260, 63);
            this.txt_url.TabIndex = 26;
            // 
            // btn_print
            // 
            this.btn_print.Location = new System.Drawing.Point(281, 306);
            this.btn_print.Name = "btn_print";
            this.btn_print.Size = new System.Drawing.Size(170, 33);
            this.btn_print.TabIndex = 27;
            this.btn_print.Text = "打印条码";
            this.btn_print.UseVisualStyleBackColor = true;
            this.btn_print.Click += new System.EventHandler(this.btn_print_Click);
            // 
            // btn_Genlabel
            // 
            this.btn_Genlabel.Location = new System.Drawing.Point(281, 45);
            this.btn_Genlabel.Name = "btn_Genlabel";
            this.btn_Genlabel.Size = new System.Drawing.Size(170, 35);
            this.btn_Genlabel.TabIndex = 28;
            this.btn_Genlabel.Text = "生成条码（生产）";
            this.btn_Genlabel.UseVisualStyleBackColor = true;
            this.btn_Genlabel.Click += new System.EventHandler(this.btn_Genlabel_Click);
            // 
            // pic_label
            // 
            this.pic_label.BackColor = System.Drawing.Color.White;
            this.pic_label.Location = new System.Drawing.Point(12, 42);
            this.pic_label.Name = "pic_label";
            this.pic_label.Size = new System.Drawing.Size(260, 300);
            this.pic_label.TabIndex = 29;
            this.pic_label.TabStop = false;
            // 
            // txt_source
            // 
            this.txt_source.Location = new System.Drawing.Point(79, 12);
            this.txt_source.Multiline = true;
            this.txt_source.Name = "txt_source";
            this.txt_source.Size = new System.Drawing.Size(330, 23);
            this.txt_source.TabIndex = 30;
            this.txt_source.Text = "http://box.miuser.net/MTJMCN/MTJMCN_V1.htm";
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Location = new System.Drawing.Point(21, 15);
            this.label8.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(53, 12);
            this.label8.TabIndex = 31;
            this.label8.Text = "控制页面";
            // 
            // btn_up
            // 
            this.btn_up.Location = new System.Drawing.Point(349, 123);
            this.btn_up.Name = "btn_up";
            this.btn_up.Size = new System.Drawing.Size(38, 33);
            this.btn_up.TabIndex = 34;
            this.btn_up.Text = "上";
            this.btn_up.UseVisualStyleBackColor = true;
            this.btn_up.Click += new System.EventHandler(this.btn_up_Click);
            // 
            // btn_down
            // 
            this.btn_down.Location = new System.Drawing.Point(349, 162);
            this.btn_down.Name = "btn_down";
            this.btn_down.Size = new System.Drawing.Size(38, 33);
            this.btn_down.TabIndex = 35;
            this.btn_down.Text = "下";
            this.btn_down.UseVisualStyleBackColor = true;
            this.btn_down.Click += new System.EventHandler(this.btn_down_Click);
            // 
            // btn_left
            // 
            this.btn_left.Location = new System.Drawing.Point(305, 162);
            this.btn_left.Name = "btn_left";
            this.btn_left.Size = new System.Drawing.Size(38, 33);
            this.btn_left.TabIndex = 36;
            this.btn_left.Text = "左";
            this.btn_left.UseVisualStyleBackColor = true;
            this.btn_left.Click += new System.EventHandler(this.btn_left_Click);
            // 
            // btn_right
            // 
            this.btn_right.Location = new System.Drawing.Point(393, 162);
            this.btn_right.Name = "btn_right";
            this.btn_right.Size = new System.Drawing.Size(38, 33);
            this.btn_right.TabIndex = 37;
            this.btn_right.Text = "右";
            this.btn_right.UseVisualStyleBackColor = true;
            this.btn_right.Click += new System.EventHandler(this.btn_right_Click);
            // 
            // btn_wider
            // 
            this.btn_wider.Location = new System.Drawing.Point(393, 238);
            this.btn_wider.Name = "btn_wider";
            this.btn_wider.Size = new System.Drawing.Size(38, 33);
            this.btn_wider.TabIndex = 41;
            this.btn_wider.Text = "宽";
            this.btn_wider.UseVisualStyleBackColor = true;
            this.btn_wider.Click += new System.EventHandler(this.btn_wider_Click);
            // 
            // btn_narrower
            // 
            this.btn_narrower.Location = new System.Drawing.Point(305, 238);
            this.btn_narrower.Name = "btn_narrower";
            this.btn_narrower.Size = new System.Drawing.Size(38, 33);
            this.btn_narrower.TabIndex = 40;
            this.btn_narrower.Text = "窄";
            this.btn_narrower.UseVisualStyleBackColor = true;
            this.btn_narrower.Click += new System.EventHandler(this.btn_narrower_Click);
            // 
            // btn_shorter
            // 
            this.btn_shorter.Location = new System.Drawing.Point(349, 238);
            this.btn_shorter.Name = "btn_shorter";
            this.btn_shorter.Size = new System.Drawing.Size(38, 33);
            this.btn_shorter.TabIndex = 39;
            this.btn_shorter.Text = "短";
            this.btn_shorter.UseVisualStyleBackColor = true;
            this.btn_shorter.Click += new System.EventHandler(this.btn_shorter_Click);
            // 
            // btn_longer
            // 
            this.btn_longer.Location = new System.Drawing.Point(349, 199);
            this.btn_longer.Name = "btn_longer";
            this.btn_longer.Size = new System.Drawing.Size(38, 33);
            this.btn_longer.TabIndex = 38;
            this.btn_longer.Text = "长";
            this.btn_longer.UseVisualStyleBackColor = true;
            this.btn_longer.Click += new System.EventHandler(this.btn_longer_Click);
            // 
            // btn_Reset
            // 
            this.btn_Reset.Location = new System.Drawing.Point(393, 122);
            this.btn_Reset.Name = "btn_Reset";
            this.btn_Reset.Size = new System.Drawing.Size(38, 33);
            this.btn_Reset.TabIndex = 42;
            this.btn_Reset.Text = "复";
            this.btn_Reset.UseVisualStyleBackColor = true;
            this.btn_Reset.Click += new System.EventHandler(this.btn_Reset_Click);
            // 
            // label9
            // 
            this.label9.AutoSize = true;
            this.label9.Location = new System.Drawing.Point(344, 288);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(107, 12);
            this.label9.TabIndex = 43;
            this.label9.Text = "条码长宽：1.2X1.5";
            // 
            // txt_XMargin
            // 
            this.txt_XMargin.Location = new System.Drawing.Point(329, 364);
            this.txt_XMargin.Name = "txt_XMargin";
            this.txt_XMargin.Size = new System.Drawing.Size(37, 21);
            this.txt_XMargin.TabIndex = 44;
            // 
            // txt_YMargin
            // 
            this.txt_YMargin.Location = new System.Drawing.Point(329, 391);
            this.txt_YMargin.Name = "txt_YMargin";
            this.txt_YMargin.Size = new System.Drawing.Size(37, 21);
            this.txt_YMargin.TabIndex = 45;
            // 
            // txt_YRatio
            // 
            this.txt_YRatio.Location = new System.Drawing.Point(414, 391);
            this.txt_YRatio.Name = "txt_YRatio";
            this.txt_YRatio.Size = new System.Drawing.Size(37, 21);
            this.txt_YRatio.TabIndex = 47;
            // 
            // txt_XRatio
            // 
            this.txt_XRatio.Location = new System.Drawing.Point(414, 364);
            this.txt_XRatio.Name = "txt_XRatio";
            this.txt_XRatio.Size = new System.Drawing.Size(37, 21);
            this.txt_XRatio.TabIndex = 46;
            // 
            // label10
            // 
            this.label10.AutoSize = true;
            this.label10.Location = new System.Drawing.Point(283, 367);
            this.label10.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.label10.Name = "label10";
            this.label10.Size = new System.Drawing.Size(47, 12);
            this.label10.TabIndex = 48;
            this.label10.Text = "XMargin";
            // 
            // label11
            // 
            this.label11.AutoSize = true;
            this.label11.Location = new System.Drawing.Point(283, 395);
            this.label11.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.label11.Name = "label11";
            this.label11.Size = new System.Drawing.Size(47, 12);
            this.label11.TabIndex = 49;
            this.label11.Text = "YMargin";
            // 
            // label12
            // 
            this.label12.AutoSize = true;
            this.label12.Location = new System.Drawing.Point(374, 395);
            this.label12.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.label12.Name = "label12";
            this.label12.Size = new System.Drawing.Size(41, 12);
            this.label12.TabIndex = 51;
            this.label12.Text = "YRatio";
            // 
            // label13
            // 
            this.label13.AutoSize = true;
            this.label13.Location = new System.Drawing.Point(374, 369);
            this.label13.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.label13.Name = "label13";
            this.label13.Size = new System.Drawing.Size(41, 12);
            this.label13.TabIndex = 50;
            this.label13.Text = "XRatio";
            // 
            // btn_Save
            // 
            this.btn_Save.Location = new System.Drawing.Point(393, 201);
            this.btn_Save.Name = "btn_Save";
            this.btn_Save.Size = new System.Drawing.Size(38, 32);
            this.btn_Save.TabIndex = 52;
            this.btn_Save.Text = "存";
            this.btn_Save.UseVisualStyleBackColor = true;
            this.btn_Save.Click += new System.EventHandler(this.btn_Save_Click);
            // 
            // Form1
            // 
            this.AcceptButton = this.btnSend;
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(960, 431);
            this.Controls.Add(this.btn_Save);
            this.Controls.Add(this.txt_YRatio);
            this.Controls.Add(this.txt_XRatio);
            this.Controls.Add(this.label12);
            this.Controls.Add(this.label13);
            this.Controls.Add(this.txt_YMargin);
            this.Controls.Add(this.label11);
            this.Controls.Add(this.txt_XMargin);
            this.Controls.Add(this.label10);
            this.Controls.Add(this.label9);
            this.Controls.Add(this.btn_Reset);
            this.Controls.Add(this.btn_wider);
            this.Controls.Add(this.btn_narrower);
            this.Controls.Add(this.btn_shorter);
            this.Controls.Add(this.btn_longer);
            this.Controls.Add(this.btn_right);
            this.Controls.Add(this.btn_left);
            this.Controls.Add(this.btn_down);
            this.Controls.Add(this.btn_up);
            this.Controls.Add(this.label8);
            this.Controls.Add(this.txt_source);
            this.Controls.Add(this.btn_Genlabel);
            this.Controls.Add(this.btn_print);
            this.Controls.Add(this.txt_url);
            this.Controls.Add(this.btn_MakeLabel);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.txt_ID);
            this.Controls.Add(this.txt_MM);
            this.Controls.Add(this.btn_ReadIDMM);
            this.Controls.Add(this.groupBox3);
            this.Controls.Add(this.groupBox2);
            this.Controls.Add(this.groupBox1);
            this.Controls.Add(this.pic_label);
            this.Margin = new System.Windows.Forms.Padding(2);
            this.Name = "Form1";
            this.Text = "M2M Reader V0.33";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.groupBox2.ResumeLayout(false);
            this.groupBox2.PerformLayout();
            this.groupBox3.ResumeLayout(false);
            this.groupBox3.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pic_label)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label label5;
        private System.IO.Ports.SerialPort serialPort1;
        private System.IO.Ports.SerialPort serialPort2;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.Button btnOpenCom;
        private System.Windows.Forms.RadioButton rbnHex;
        private System.Windows.Forms.RadioButton rbnChar;
        private System.Windows.Forms.Button btnCheckCOM;
        private System.Windows.Forms.ComboBox cbxDataBits;
        private System.Windows.Forms.ComboBox cbxStopBits;
        private System.Windows.Forms.ComboBox cbxParitv;
        private System.Windows.Forms.ComboBox cbxBaudRate;
        private System.Windows.Forms.ComboBox cbxCOMPort;
        private System.Windows.Forms.GroupBox groupBox2;
        private System.Windows.Forms.TextBox txt_rsv;
        private System.Windows.Forms.GroupBox groupBox3;
        private System.Windows.Forms.TextBox txt_send;
        private System.Windows.Forms.Button btnCleanData;
        private System.Windows.Forms.Button btnSend;
        private System.Windows.Forms.Button btn_ReadIDMM;
        private System.Windows.Forms.TextBox txt_MM;
        private System.Windows.Forms.TextBox txt_ID;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.Button btn_CloseCOM;
        private System.Windows.Forms.Button btn_MakeLabel;
        private System.Windows.Forms.TextBox txt_url;
        private System.Windows.Forms.Button btn_print;
        private System.Windows.Forms.Button btn_Genlabel;
        private System.Windows.Forms.PictureBox pic_label;
        private System.Windows.Forms.TextBox txt_source;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.Button btn_up;
        private System.Windows.Forms.Button btn_down;
        private System.Windows.Forms.Button btn_left;
        private System.Windows.Forms.Button btn_right;
        private System.Windows.Forms.Button btn_wider;
        private System.Windows.Forms.Button btn_narrower;
        private System.Windows.Forms.Button btn_shorter;
        private System.Windows.Forms.Button btn_longer;
        private System.Windows.Forms.Button btn_Reset;
        private System.Windows.Forms.Label label9;
        private System.Windows.Forms.TextBox txt_XMargin;
        private System.Windows.Forms.TextBox txt_YMargin;
        private System.Windows.Forms.TextBox txt_YRatio;
        private System.Windows.Forms.TextBox txt_XRatio;
        private System.Windows.Forms.Label label10;
        private System.Windows.Forms.Label label11;
        private System.Windows.Forms.Label label12;
        private System.Windows.Forms.Label label13;
        private System.Windows.Forms.Button btn_Save;
    }
}

