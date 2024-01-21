namespace MTJMCN_CS
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
            this.groupBox3 = new System.Windows.Forms.GroupBox();
            this.rad_HexSend = new System.Windows.Forms.RadioButton();
            this.rad_AscSend = new System.Windows.Forms.RadioButton();
            this.txt_send = new System.Windows.Forms.TextBox();
            this.btnCleanData = new System.Windows.Forms.Button();
            this.btnSend = new System.Windows.Forms.Button();
            this.groupBox2 = new System.Windows.Forms.GroupBox();
            this.txt_rsv = new System.Windows.Forms.TextBox();
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
            this.label5 = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.groupBox4 = new System.Windows.Forms.GroupBox();
            this.btn_GetIDMM = new System.Windows.Forms.Button();
            this.label15 = new System.Windows.Forms.Label();
            this.txt_MM = new System.Windows.Forms.TextBox();
            this.label14 = new System.Windows.Forms.Label();
            this.txt_ID = new System.Windows.Forms.TextBox();
            this.label8 = new System.Windows.Forms.Label();
            this.txt_server = new System.Windows.Forms.TextBox();
            this.label9 = new System.Windows.Forms.Label();
            this.txt_port = new System.Windows.Forms.TextBox();
            this.btn_DisconnectUDP = new System.Windows.Forms.Button();
            this.btn_ConnectUDP = new System.Windows.Forms.Button();
            this.rtb_rsv = new System.Windows.Forms.RichTextBox();
            this.groupBox5 = new System.Windows.Forms.GroupBox();
            this.label6 = new System.Windows.Forms.Label();
            this.chb_A = new System.Windows.Forms.CheckBox();
            this.chb_B = new System.Windows.Forms.CheckBox();
            this.chb_C = new System.Windows.Forms.CheckBox();
            this.tmr_heartbeat = new System.Windows.Forms.Timer(this.components);
            this.groupBox3.SuspendLayout();
            this.groupBox2.SuspendLayout();
            this.groupBox1.SuspendLayout();
            this.groupBox4.SuspendLayout();
            this.groupBox5.SuspendLayout();
            this.SuspendLayout();
            // 
            // groupBox3
            // 
            this.groupBox3.Controls.Add(this.rad_HexSend);
            this.groupBox3.Controls.Add(this.rad_AscSend);
            this.groupBox3.Controls.Add(this.txt_send);
            this.groupBox3.Controls.Add(this.btnCleanData);
            this.groupBox3.Controls.Add(this.btnSend);
            this.groupBox3.Location = new System.Drawing.Point(345, 232);
            this.groupBox3.Margin = new System.Windows.Forms.Padding(2);
            this.groupBox3.Name = "groupBox3";
            this.groupBox3.Padding = new System.Windows.Forms.Padding(2);
            this.groupBox3.Size = new System.Drawing.Size(458, 136);
            this.groupBox3.TabIndex = 21;
            this.groupBox3.TabStop = false;
            this.groupBox3.Text = "数据发送";
            // 
            // rad_HexSend
            // 
            this.rad_HexSend.AutoSize = true;
            this.rad_HexSend.Location = new System.Drawing.Point(94, 93);
            this.rad_HexSend.Margin = new System.Windows.Forms.Padding(2);
            this.rad_HexSend.Name = "rad_HexSend";
            this.rad_HexSend.Size = new System.Drawing.Size(65, 16);
            this.rad_HexSend.TabIndex = 25;
            this.rad_HexSend.Text = "Hex发送";
            this.rad_HexSend.UseVisualStyleBackColor = true;
            // 
            // rad_AscSend
            // 
            this.rad_AscSend.AutoSize = true;
            this.rad_AscSend.Checked = true;
            this.rad_AscSend.Location = new System.Drawing.Point(26, 93);
            this.rad_AscSend.Margin = new System.Windows.Forms.Padding(2);
            this.rad_AscSend.Name = "rad_AscSend";
            this.rad_AscSend.Size = new System.Drawing.Size(71, 16);
            this.rad_AscSend.TabIndex = 24;
            this.rad_AscSend.TabStop = true;
            this.rad_AscSend.Text = "字符发送";
            this.rad_AscSend.UseVisualStyleBackColor = true;
            // 
            // txt_send
            // 
            this.txt_send.AcceptsReturn = true;
            this.txt_send.Location = new System.Drawing.Point(25, 18);
            this.txt_send.Margin = new System.Windows.Forms.Padding(2);
            this.txt_send.Multiline = true;
            this.txt_send.Name = "txt_send";
            this.txt_send.Size = new System.Drawing.Size(418, 64);
            this.txt_send.TabIndex = 1;
            // 
            // btnCleanData
            // 
            this.btnCleanData.Location = new System.Drawing.Point(305, 89);
            this.btnCleanData.Margin = new System.Windows.Forms.Padding(2);
            this.btnCleanData.Name = "btnCleanData";
            this.btnCleanData.Size = new System.Drawing.Size(67, 25);
            this.btnCleanData.TabIndex = 22;
            this.btnCleanData.Text = "清空数据";
            this.btnCleanData.UseVisualStyleBackColor = true;
            this.btnCleanData.Click += new System.EventHandler(this.btnCleanData_Click);
            // 
            // btnSend
            // 
            this.btnSend.Location = new System.Drawing.Point(376, 89);
            this.btnSend.Margin = new System.Windows.Forms.Padding(2);
            this.btnSend.Name = "btnSend";
            this.btnSend.Size = new System.Drawing.Size(67, 25);
            this.btnSend.TabIndex = 23;
            this.btnSend.Text = "发送数据";
            this.btnSend.UseVisualStyleBackColor = true;
            this.btnSend.Click += new System.EventHandler(this.btnSend_Click);
            // 
            // groupBox2
            // 
            this.groupBox2.Controls.Add(this.txt_rsv);
            this.groupBox2.Location = new System.Drawing.Point(345, 100);
            this.groupBox2.Margin = new System.Windows.Forms.Padding(2);
            this.groupBox2.Name = "groupBox2";
            this.groupBox2.Padding = new System.Windows.Forms.Padding(2);
            this.groupBox2.Size = new System.Drawing.Size(458, 127);
            this.groupBox2.TabIndex = 20;
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
            this.txt_rsv.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.txt_rsv.Size = new System.Drawing.Size(419, 90);
            this.txt_rsv.TabIndex = 0;
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
            this.groupBox1.Location = new System.Drawing.Point(345, 12);
            this.groupBox1.Margin = new System.Windows.Forms.Padding(2);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Padding = new System.Windows.Forms.Padding(2);
            this.groupBox1.Size = new System.Drawing.Size(458, 84);
            this.groupBox1.TabIndex = 19;
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
            this.rbnHex.CheckedChanged += new System.EventHandler(this.rbnHex_CheckedChanged);
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
            this.rbnChar.CheckedChanged += new System.EventHandler(this.rbnChar_CheckedChanged);
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
            // groupBox4
            // 
            this.groupBox4.Controls.Add(this.btn_GetIDMM);
            this.groupBox4.Controls.Add(this.label15);
            this.groupBox4.Controls.Add(this.txt_MM);
            this.groupBox4.Controls.Add(this.label14);
            this.groupBox4.Controls.Add(this.txt_ID);
            this.groupBox4.Controls.Add(this.label8);
            this.groupBox4.Controls.Add(this.txt_server);
            this.groupBox4.Controls.Add(this.label9);
            this.groupBox4.Controls.Add(this.txt_port);
            this.groupBox4.Controls.Add(this.btn_DisconnectUDP);
            this.groupBox4.Controls.Add(this.btn_ConnectUDP);
            this.groupBox4.Location = new System.Drawing.Point(12, 12);
            this.groupBox4.Name = "groupBox4";
            this.groupBox4.Size = new System.Drawing.Size(318, 134);
            this.groupBox4.TabIndex = 22;
            this.groupBox4.TabStop = false;
            this.groupBox4.Text = "UDP 设置";
            this.groupBox4.Enter += new System.EventHandler(this.groupBox4_Enter);
            // 
            // btn_GetIDMM
            // 
            this.btn_GetIDMM.Location = new System.Drawing.Point(232, 19);
            this.btn_GetIDMM.Margin = new System.Windows.Forms.Padding(2);
            this.btn_GetIDMM.Name = "btn_GetIDMM";
            this.btn_GetIDMM.Size = new System.Drawing.Size(67, 47);
            this.btn_GetIDMM.TabIndex = 41;
            this.btn_GetIDMM.Text = "获取IDMM";
            this.btn_GetIDMM.UseVisualStyleBackColor = true;
            this.btn_GetIDMM.Click += new System.EventHandler(this.btn_GetIDMM_Click);
            // 
            // label15
            // 
            this.label15.AutoSize = true;
            this.label15.Location = new System.Drawing.Point(30, 107);
            this.label15.Name = "label15";
            this.label15.Size = new System.Drawing.Size(17, 12);
            this.label15.TabIndex = 40;
            this.label15.Text = "MM";
            // 
            // txt_MM
            // 
            this.txt_MM.Location = new System.Drawing.Point(58, 104);
            this.txt_MM.Name = "txt_MM";
            this.txt_MM.Size = new System.Drawing.Size(139, 21);
            this.txt_MM.TabIndex = 39;
            this.txt_MM.Text = "0082111207169233";
            // 
            // label14
            // 
            this.label14.AutoSize = true;
            this.label14.Location = new System.Drawing.Point(30, 80);
            this.label14.Name = "label14";
            this.label14.Size = new System.Drawing.Size(17, 12);
            this.label14.TabIndex = 38;
            this.label14.Text = "ID";
            // 
            // txt_ID
            // 
            this.txt_ID.Location = new System.Drawing.Point(58, 77);
            this.txt_ID.Name = "txt_ID";
            this.txt_ID.Size = new System.Drawing.Size(139, 21);
            this.txt_ID.TabIndex = 37;
            this.txt_ID.Text = "4049331431";
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Location = new System.Drawing.Point(11, 21);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(41, 12);
            this.label8.TabIndex = 25;
            this.label8.Text = "Server";
            // 
            // txt_server
            // 
            this.txt_server.Location = new System.Drawing.Point(58, 18);
            this.txt_server.Name = "txt_server";
            this.txt_server.Size = new System.Drawing.Size(139, 21);
            this.txt_server.TabIndex = 26;
            this.txt_server.Text = "box.miuser.net";
            // 
            // label9
            // 
            this.label9.AutoSize = true;
            this.label9.Location = new System.Drawing.Point(23, 49);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(29, 12);
            this.label9.TabIndex = 27;
            this.label9.Text = "Port";
            // 
            // txt_port
            // 
            this.txt_port.Location = new System.Drawing.Point(58, 45);
            this.txt_port.Name = "txt_port";
            this.txt_port.Size = new System.Drawing.Size(58, 21);
            this.txt_port.TabIndex = 28;
            this.txt_port.Text = "7101";
            // 
            // btn_DisconnectUDP
            // 
            this.btn_DisconnectUDP.Location = new System.Drawing.Point(232, 103);
            this.btn_DisconnectUDP.Margin = new System.Windows.Forms.Padding(2);
            this.btn_DisconnectUDP.Name = "btn_DisconnectUDP";
            this.btn_DisconnectUDP.Size = new System.Drawing.Size(67, 21);
            this.btn_DisconnectUDP.TabIndex = 24;
            this.btn_DisconnectUDP.Text = "关闭连接";
            this.btn_DisconnectUDP.UseVisualStyleBackColor = true;
            this.btn_DisconnectUDP.Click += new System.EventHandler(this.btn_DisconnectUDP_Click);
            // 
            // btn_ConnectUDP
            // 
            this.btn_ConnectUDP.Location = new System.Drawing.Point(232, 78);
            this.btn_ConnectUDP.Margin = new System.Windows.Forms.Padding(2);
            this.btn_ConnectUDP.Name = "btn_ConnectUDP";
            this.btn_ConnectUDP.Size = new System.Drawing.Size(67, 21);
            this.btn_ConnectUDP.TabIndex = 23;
            this.btn_ConnectUDP.Text = "打开连接";
            this.btn_ConnectUDP.UseVisualStyleBackColor = true;
            this.btn_ConnectUDP.Click += new System.EventHandler(this.btn_ConnectUDP_Click);
            // 
            // rtb_rsv
            // 
            this.rtb_rsv.Location = new System.Drawing.Point(5, 20);
            this.rtb_rsv.Name = "rtb_rsv";
            this.rtb_rsv.ReadOnly = true;
            this.rtb_rsv.Size = new System.Drawing.Size(299, 151);
            this.rtb_rsv.TabIndex = 31;
            this.rtb_rsv.Text = "";
            // 
            // groupBox5
            // 
            this.groupBox5.Controls.Add(this.label6);
            this.groupBox5.Controls.Add(this.chb_A);
            this.groupBox5.Controls.Add(this.chb_B);
            this.groupBox5.Controls.Add(this.chb_C);
            this.groupBox5.Controls.Add(this.rtb_rsv);
            this.groupBox5.Location = new System.Drawing.Point(12, 152);
            this.groupBox5.Name = "groupBox5";
            this.groupBox5.Size = new System.Drawing.Size(318, 215);
            this.groupBox5.TabIndex = 32;
            this.groupBox5.TabStop = false;
            this.groupBox5.Text = "数据传输";
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(11, 184);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(65, 12);
            this.label6.TabIndex = 35;
            this.label6.Text = "数据解析：";
            // 
            // chb_A
            // 
            this.chb_A.AutoSize = true;
            this.chb_A.Location = new System.Drawing.Point(214, 183);
            this.chb_A.Name = "chb_A";
            this.chb_A.Size = new System.Drawing.Size(48, 16);
            this.chb_A.TabIndex = 34;
            this.chb_A.Text = "命令";
            this.chb_A.UseVisualStyleBackColor = true;
            // 
            // chb_B
            // 
            this.chb_B.AutoSize = true;
            this.chb_B.Location = new System.Drawing.Point(160, 183);
            this.chb_B.Name = "chb_B";
            this.chb_B.Size = new System.Drawing.Size(48, 16);
            this.chb_B.TabIndex = 33;
            this.chb_B.Text = "心跳";
            this.chb_B.UseVisualStyleBackColor = true;
            // 
            // chb_C
            // 
            this.chb_C.AutoSize = true;
            this.chb_C.Location = new System.Drawing.Point(106, 183);
            this.chb_C.Name = "chb_C";
            this.chb_C.Size = new System.Drawing.Size(48, 16);
            this.chb_C.TabIndex = 32;
            this.chb_C.Text = "透传";
            this.chb_C.UseVisualStyleBackColor = true;
            this.chb_C.CheckedChanged += new System.EventHandler(this.checkBox1_CheckedChanged);
            // 
            // tmr_heartbeat
            // 
            this.tmr_heartbeat.Enabled = true;
            this.tmr_heartbeat.Interval = 10000;
            this.tmr_heartbeat.Tick += new System.EventHandler(this.tmr_heartbeat_Tick);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(324, 377);
            this.Controls.Add(this.groupBox5);
            this.Controls.Add(this.groupBox4);
            this.Controls.Add(this.groupBox3);
            this.Controls.Add(this.groupBox2);
            this.Controls.Add(this.groupBox1);
            this.Name = "Form1";
            this.Text = "CS UDP Demo 1.0";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.groupBox3.ResumeLayout(false);
            this.groupBox3.PerformLayout();
            this.groupBox2.ResumeLayout(false);
            this.groupBox2.PerformLayout();
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.groupBox4.ResumeLayout(false);
            this.groupBox4.PerformLayout();
            this.groupBox5.ResumeLayout(false);
            this.groupBox5.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.GroupBox groupBox3;
        private System.Windows.Forms.TextBox txt_send;
        private System.Windows.Forms.Button btnCleanData;
        private System.Windows.Forms.Button btnSend;
        private System.Windows.Forms.GroupBox groupBox2;
        private System.Windows.Forms.TextBox txt_rsv;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.Button btn_CloseCOM;
        private System.Windows.Forms.Button btnOpenCom;
        private System.Windows.Forms.RadioButton rbnHex;
        private System.Windows.Forms.RadioButton rbnChar;
        private System.Windows.Forms.Button btnCheckCOM;
        private System.Windows.Forms.ComboBox cbxDataBits;
        private System.Windows.Forms.ComboBox cbxStopBits;
        private System.Windows.Forms.ComboBox cbxParitv;
        private System.Windows.Forms.ComboBox cbxBaudRate;
        private System.Windows.Forms.ComboBox cbxCOMPort;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.RadioButton rad_HexSend;
        private System.Windows.Forms.RadioButton rad_AscSend;
        private System.Windows.Forms.GroupBox groupBox4;
        private System.Windows.Forms.Button btn_DisconnectUDP;
        private System.Windows.Forms.Button btn_ConnectUDP;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.TextBox txt_server;
        private System.Windows.Forms.Label label9;
        private System.Windows.Forms.TextBox txt_port;
        private System.Windows.Forms.RichTextBox rtb_rsv;
        private System.Windows.Forms.Label label15;
        private System.Windows.Forms.TextBox txt_MM;
        private System.Windows.Forms.Label label14;
        private System.Windows.Forms.TextBox txt_ID;
        private System.Windows.Forms.GroupBox groupBox5;
        private System.Windows.Forms.Timer tmr_heartbeat;
        private System.Windows.Forms.Button btn_GetIDMM;
        private System.Windows.Forms.CheckBox chb_C;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.CheckBox chb_A;
        private System.Windows.Forms.CheckBox chb_B;
    }
}

