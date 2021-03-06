﻿namespace CopyData
{
    partial class HccWindowdGraspTool
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
        /// 设计器支持所需的方法 - 不要
        /// 使用代码编辑器修改此方法的内容。
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(HccWindowdGraspTool));
            this.richTextBoxLog = new System.Windows.Forms.RichTextBox();
            this.btnClearLog = new System.Windows.Forms.Button();
            this.btnStartCatch = new System.Windows.Forms.Button();
            this.btnStopCatch = new System.Windows.Forms.Button();
            this.btnFinishCatch = new System.Windows.Forms.Button();
            this.check_btn_log = new System.Windows.Forms.CheckBox();
            this.checkAutoGraspCk = new System.Windows.Forms.CheckBox();
            this.checkAutoDoAct = new System.Windows.Forms.CheckBox();
            this.chckSound = new System.Windows.Forms.CheckBox();
            this.checkShowLog = new System.Windows.Forms.CheckBox();
            this.numUDDelay = new System.Windows.Forms.NumericUpDown();
            this.label1 = new System.Windows.Forms.Label();
            this.comboBoxActList = new System.Windows.Forms.ComboBox();
            this.label3 = new System.Windows.Forms.Label();
            this.pictureBoxUrl = new System.Windows.Forms.PictureBox();
            this.btnGenQRCode = new System.Windows.Forms.Button();
            this.richTextQRCode = new System.Windows.Forms.RichTextBox();
            this.listViewToken = new System.Windows.Forms.ListView();
            this.btnCatchSel = new System.Windows.Forms.Button();
            this.tab_proxy_ip = new System.Windows.Forms.TabPage();
            this.text_box_proxy_ip = new System.Windows.Forms.TextBox();
            this.label5 = new System.Windows.Forms.Label();
            this.btn_use_proxy = new System.Windows.Forms.CheckBox();
            this.btn_proxy_check = new System.Windows.Forms.Button();
            this.label4 = new System.Windows.Forms.Label();
            this.tab_control = new System.Windows.Forms.TabControl();
            this.tab_qr_code = new System.Windows.Forms.TabPage();
            this.btnCopyLink = new System.Windows.Forms.Button();
            this.richTextLink = new System.Windows.Forms.RichTextBox();
            this.text_box_ip_info = new System.Windows.Forms.RichTextBox();
            this.text_link_label = new System.Windows.Forms.LinkLabel();
            this.context_menu_strip_list = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.strip_menu_item_sel_all = new System.Windows.Forms.ToolStripMenuItem();
            this.strip_menu_item_copy = new System.Windows.Forms.ToolStripMenuItem();
            this.strip_menu_item_paste = new System.Windows.Forms.ToolStripMenuItem();
            this.strip_menu_item_delete = new System.Windows.Forms.ToolStripMenuItem();
            this.label6 = new System.Windows.Forms.Label();
            this.numeric_kabao_count = new System.Windows.Forms.NumericUpDown();
            this.panel1 = new System.Windows.Forms.Panel();
            this.panel2 = new System.Windows.Forms.Panel();
            this.label7 = new System.Windows.Forms.Label();
            this.richTextInput = new System.Windows.Forms.RichTextBox();
            this.panel3 = new System.Windows.Forms.Panel();
            this.richTextDesc = new System.Windows.Forms.RichTextBox();
            ((System.ComponentModel.ISupportInitialize)(this.numUDDelay)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBoxUrl)).BeginInit();
            this.tab_proxy_ip.SuspendLayout();
            this.tab_control.SuspendLayout();
            this.tab_qr_code.SuspendLayout();
            this.context_menu_strip_list.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.numeric_kabao_count)).BeginInit();
            this.panel1.SuspendLayout();
            this.panel2.SuspendLayout();
            this.panel3.SuspendLayout();
            this.SuspendLayout();
            // 
            // richTextBoxLog
            // 
            this.richTextBoxLog.BackColor = System.Drawing.Color.Black;
            this.richTextBoxLog.CausesValidation = false;
            this.richTextBoxLog.DetectUrls = false;
            this.richTextBoxLog.Font = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.richTextBoxLog.ForeColor = System.Drawing.Color.Lime;
            this.richTextBoxLog.Location = new System.Drawing.Point(3, 328);
            this.richTextBoxLog.Name = "richTextBoxLog";
            this.richTextBoxLog.ReadOnly = true;
            this.richTextBoxLog.Size = new System.Drawing.Size(644, 310);
            this.richTextBoxLog.TabIndex = 5;
            this.richTextBoxLog.Text = "";
            this.richTextBoxLog.TextChanged += new System.EventHandler(this.richTextBoxLogTextChanged);
            // 
            // btnClearLog
            // 
            this.btnClearLog.Location = new System.Drawing.Point(191, 4);
            this.btnClearLog.Name = "btnClearLog";
            this.btnClearLog.Size = new System.Drawing.Size(80, 22);
            this.btnClearLog.TabIndex = 6;
            this.btnClearLog.Text = "清理日志";
            this.btnClearLog.UseVisualStyleBackColor = true;
            this.btnClearLog.Click += new System.EventHandler(this.buttonClearLogClick);
            // 
            // btnStartCatch
            // 
            this.btnStartCatch.Font = new System.Drawing.Font("宋体", 12.5F);
            this.btnStartCatch.Location = new System.Drawing.Point(12, 9);
            this.btnStartCatch.Name = "btnStartCatch";
            this.btnStartCatch.Size = new System.Drawing.Size(100, 35);
            this.btnStartCatch.TabIndex = 7;
            this.btnStartCatch.Text = "全部执行";
            this.btnStartCatch.UseVisualStyleBackColor = true;
            this.btnStartCatch.Click += new System.EventHandler(this.btnStartCatch_Click);
            // 
            // btnStopCatch
            // 
            this.btnStopCatch.Font = new System.Drawing.Font("宋体", 10.5F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.btnStopCatch.Location = new System.Drawing.Point(92, -24);
            this.btnStopCatch.Name = "btnStopCatch";
            this.btnStopCatch.Size = new System.Drawing.Size(80, 35);
            this.btnStopCatch.TabIndex = 8;
            this.btnStopCatch.Text = "停止";
            this.btnStopCatch.UseVisualStyleBackColor = true;
            this.btnStopCatch.Visible = false;
            this.btnStopCatch.Click += new System.EventHandler(this.btnStopCatch_Click);
            // 
            // btnFinishCatch
            // 
            this.btnFinishCatch.Location = new System.Drawing.Point(570, 6);
            this.btnFinishCatch.Name = "btnFinishCatch";
            this.btnFinishCatch.Size = new System.Drawing.Size(50, 20);
            this.btnFinishCatch.TabIndex = 9;
            this.btnFinishCatch.Text = "测试";
            this.btnFinishCatch.UseVisualStyleBackColor = true;
            this.btnFinishCatch.Click += new System.EventHandler(this.btnFinishCatch_Click);
            // 
            // check_btn_log
            // 
            this.check_btn_log.AutoSize = true;
            this.check_btn_log.BackColor = System.Drawing.Color.LightGray;
            this.check_btn_log.Font = new System.Drawing.Font("宋体", 10.5F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.check_btn_log.Location = new System.Drawing.Point(103, 6);
            this.check_btn_log.Name = "check_btn_log";
            this.check_btn_log.Size = new System.Drawing.Size(82, 18);
            this.check_btn_log.TabIndex = 12;
            this.check_btn_log.Text = "网络日志";
            this.check_btn_log.UseVisualStyleBackColor = false;
            this.check_btn_log.CheckedChanged += new System.EventHandler(this.check_btn_log_CheckedChanged);
            // 
            // checkAutoGraspCk
            // 
            this.checkAutoGraspCk.AutoSize = true;
            this.checkAutoGraspCk.BackColor = System.Drawing.Color.LightGray;
            this.checkAutoGraspCk.Checked = true;
            this.checkAutoGraspCk.CheckState = System.Windows.Forms.CheckState.Checked;
            this.checkAutoGraspCk.Font = new System.Drawing.Font("宋体", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.checkAutoGraspCk.Location = new System.Drawing.Point(3, 53);
            this.checkAutoGraspCk.Name = "checkAutoGraspCk";
            this.checkAutoGraspCk.Size = new System.Drawing.Size(91, 20);
            this.checkAutoGraspCk.TabIndex = 14;
            this.checkAutoGraspCk.Text = "自动抓CK";
            this.checkAutoGraspCk.UseVisualStyleBackColor = false;
            this.checkAutoGraspCk.CheckedChanged += new System.EventHandler(this.checkAutoGraspCk_CheckedChanged);
            // 
            // checkAutoDoAct
            // 
            this.checkAutoDoAct.AutoSize = true;
            this.checkAutoDoAct.BackColor = System.Drawing.Color.LightGray;
            this.checkAutoDoAct.Font = new System.Drawing.Font("宋体", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.checkAutoDoAct.Location = new System.Drawing.Point(3, 89);
            this.checkAutoDoAct.Name = "checkAutoDoAct";
            this.checkAutoDoAct.Size = new System.Drawing.Size(91, 20);
            this.checkAutoDoAct.TabIndex = 15;
            this.checkAutoDoAct.Text = "自动执行";
            this.checkAutoDoAct.UseVisualStyleBackColor = false;
            this.checkAutoDoAct.CheckedChanged += new System.EventHandler(this.checkAutoDoAct_CheckedChanged);
            // 
            // chckSound
            // 
            this.chckSound.AutoSize = true;
            this.chckSound.BackColor = System.Drawing.Color.LightGray;
            this.chckSound.Checked = true;
            this.chckSound.CheckState = System.Windows.Forms.CheckState.Checked;
            this.chckSound.Font = new System.Drawing.Font("宋体", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.chckSound.Location = new System.Drawing.Point(3, 12);
            this.chckSound.Name = "chckSound";
            this.chckSound.Size = new System.Drawing.Size(75, 20);
            this.chckSound.TabIndex = 16;
            this.chckSound.Text = "提示音";
            this.chckSound.UseVisualStyleBackColor = false;
            this.chckSound.CheckedChanged += new System.EventHandler(this.chckSound_CheckedChanged);
            // 
            // checkShowLog
            // 
            this.checkShowLog.AutoSize = true;
            this.checkShowLog.BackColor = System.Drawing.Color.LightGray;
            this.checkShowLog.Checked = true;
            this.checkShowLog.CheckState = System.Windows.Forms.CheckState.Checked;
            this.checkShowLog.Font = new System.Drawing.Font("宋体", 10.5F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.checkShowLog.Location = new System.Drawing.Point(6, 6);
            this.checkShowLog.Name = "checkShowLog";
            this.checkShowLog.Size = new System.Drawing.Size(82, 18);
            this.checkShowLog.TabIndex = 17;
            this.checkShowLog.Text = "输出日志";
            this.checkShowLog.UseVisualStyleBackColor = false;
            this.checkShowLog.CheckedChanged += new System.EventHandler(this.checkShowLog_CheckedChanged);
            // 
            // numUDDelay
            // 
            this.numUDDelay.DecimalPlaces = 1;
            this.numUDDelay.Font = new System.Drawing.Font("宋体", 10.5F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.numUDDelay.Increment = new decimal(new int[] {
            1,
            0,
            0,
            65536});
            this.numUDDelay.Location = new System.Drawing.Point(201, 51);
            this.numUDDelay.Name = "numUDDelay";
            this.numUDDelay.Size = new System.Drawing.Size(70, 23);
            this.numUDDelay.TabIndex = 18;
            this.numUDDelay.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            this.numUDDelay.ValueChanged += new System.EventHandler(this.numUDDelay_ValueChanged);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("宋体", 12F);
            this.label1.Location = new System.Drawing.Point(151, 54);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(40, 16);
            this.label1.TabIndex = 19;
            this.label1.Text = "延时";
            // 
            // comboBoxActList
            // 
            this.comboBoxActList.AllowDrop = true;
            this.comboBoxActList.BackColor = System.Drawing.SystemColors.Control;
            this.comboBoxActList.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.comboBoxActList.Font = new System.Drawing.Font("宋体", 14.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.comboBoxActList.FormattingEnabled = true;
            this.comboBoxActList.Location = new System.Drawing.Point(128, 11);
            this.comboBoxActList.Name = "comboBoxActList";
            this.comboBoxActList.Size = new System.Drawing.Size(145, 27);
            this.comboBoxActList.TabIndex = 22;
            this.comboBoxActList.TabStop = false;
            this.comboBoxActList.SelectedIndexChanged += new System.EventHandler(this.comboBoxActList_SelectedIndexChanged);
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("宋体", 10.5F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.label3.Location = new System.Drawing.Point(90, 9);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(35, 28);
            this.label3.TabIndex = 23;
            this.label3.Text = "活动\r\n列表";
            // 
            // pictureBoxUrl
            // 
            this.pictureBoxUrl.BackColor = System.Drawing.SystemColors.ButtonHighlight;
            this.pictureBoxUrl.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.pictureBoxUrl.Location = new System.Drawing.Point(20, 3);
            this.pictureBoxUrl.Name = "pictureBoxUrl";
            this.pictureBoxUrl.Size = new System.Drawing.Size(213, 189);
            this.pictureBoxUrl.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.pictureBoxUrl.TabIndex = 24;
            this.pictureBoxUrl.TabStop = false;
            this.pictureBoxUrl.WaitOnLoad = true;
            // 
            // btnGenQRCode
            // 
            this.btnGenQRCode.Font = new System.Drawing.Font("宋体", 8.5F);
            this.btnGenQRCode.Location = new System.Drawing.Point(176, 250);
            this.btnGenQRCode.Name = "btnGenQRCode";
            this.btnGenQRCode.Size = new System.Drawing.Size(73, 30);
            this.btnGenQRCode.TabIndex = 25;
            this.btnGenQRCode.Text = "生成二维码";
            this.btnGenQRCode.UseVisualStyleBackColor = true;
            this.btnGenQRCode.Visible = false;
            this.btnGenQRCode.Click += new System.EventHandler(this.btnGenQRCode_Click);
            // 
            // richTextQRCode
            // 
            this.richTextQRCode.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.richTextQRCode.DetectUrls = false;
            this.richTextQRCode.Font = new System.Drawing.Font("宋体", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.richTextQRCode.ForeColor = System.Drawing.Color.Red;
            this.richTextQRCode.Location = new System.Drawing.Point(4, 249);
            this.richTextQRCode.Multiline = false;
            this.richTextQRCode.Name = "richTextQRCode";
            this.richTextQRCode.ScrollBars = System.Windows.Forms.RichTextBoxScrollBars.Horizontal;
            this.richTextQRCode.Size = new System.Drawing.Size(167, 32);
            this.richTextQRCode.TabIndex = 26;
            this.richTextQRCode.Text = "";
            this.richTextQRCode.Visible = false;
            // 
            // listViewToken
            // 
            this.listViewToken.AllowDrop = true;
            this.listViewToken.BackColor = System.Drawing.Color.LightGray;
            this.listViewToken.CheckBoxes = true;
            this.listViewToken.Font = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.listViewToken.ForeColor = System.Drawing.Color.Blue;
            this.listViewToken.Location = new System.Drawing.Point(4, 3);
            this.listViewToken.Name = "listViewToken";
            this.listViewToken.Size = new System.Drawing.Size(638, 284);
            this.listViewToken.TabIndex = 27;
            this.listViewToken.TabStop = false;
            this.listViewToken.UseCompatibleStateImageBehavior = false;
            this.listViewToken.SelectedIndexChanged += new System.EventHandler(this.listViewToken_SelectedIndexChanged);
            // 
            // btnCatchSel
            // 
            this.btnCatchSel.Font = new System.Drawing.Font("宋体", 12.5F);
            this.btnCatchSel.Location = new System.Drawing.Point(164, 9);
            this.btnCatchSel.Name = "btnCatchSel";
            this.btnCatchSel.Size = new System.Drawing.Size(100, 35);
            this.btnCatchSel.TabIndex = 28;
            this.btnCatchSel.Text = "选中执行";
            this.btnCatchSel.UseVisualStyleBackColor = true;
            this.btnCatchSel.Click += new System.EventHandler(this.btnCatchSel_Click);
            // 
            // tab_proxy_ip
            // 
            this.tab_proxy_ip.BackColor = System.Drawing.SystemColors.Control;
            this.tab_proxy_ip.Controls.Add(this.text_box_proxy_ip);
            this.tab_proxy_ip.Controls.Add(this.label5);
            this.tab_proxy_ip.Controls.Add(this.btn_use_proxy);
            this.tab_proxy_ip.Controls.Add(this.btn_proxy_check);
            this.tab_proxy_ip.Controls.Add(this.label4);
            this.tab_proxy_ip.Font = new System.Drawing.Font("宋体", 10.5F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.tab_proxy_ip.Location = new System.Drawing.Point(4, 22);
            this.tab_proxy_ip.Name = "tab_proxy_ip";
            this.tab_proxy_ip.Padding = new System.Windows.Forms.Padding(3);
            this.tab_proxy_ip.Size = new System.Drawing.Size(252, 239);
            this.tab_proxy_ip.TabIndex = 0;
            this.tab_proxy_ip.Text = "代理IP";
            this.tab_proxy_ip.Click += new System.EventHandler(this.tab_proxy_ip_Click);
            // 
            // text_box_proxy_ip
            // 
            this.text_box_proxy_ip.Font = new System.Drawing.Font("宋体", 15F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.text_box_proxy_ip.ForeColor = System.Drawing.Color.Red;
            this.text_box_proxy_ip.Location = new System.Drawing.Point(18, 68);
            this.text_box_proxy_ip.Name = "text_box_proxy_ip";
            this.text_box_proxy_ip.Size = new System.Drawing.Size(214, 30);
            this.text_box_proxy_ip.TabIndex = 34;
            this.text_box_proxy_ip.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Font = new System.Drawing.Font("宋体", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.label5.ForeColor = System.Drawing.Color.Gray;
            this.label5.Location = new System.Drawing.Point(48, 118);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(144, 16);
            this.label5.TabIndex = 33;
            this.label5.Text = "例:127.0.0.1:8001";
            // 
            // btn_use_proxy
            // 
            this.btn_use_proxy.AutoSize = true;
            this.btn_use_proxy.BackColor = System.Drawing.Color.LightGray;
            this.btn_use_proxy.Font = new System.Drawing.Font("宋体", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.btn_use_proxy.Location = new System.Drawing.Point(74, 205);
            this.btn_use_proxy.Name = "btn_use_proxy";
            this.btn_use_proxy.Size = new System.Drawing.Size(107, 20);
            this.btn_use_proxy.TabIndex = 31;
            this.btn_use_proxy.Text = "使用代理IP";
            this.btn_use_proxy.UseVisualStyleBackColor = false;
            this.btn_use_proxy.CheckedChanged += new System.EventHandler(this.btn_use_proxy_CheckedChanged);
            // 
            // btn_proxy_check
            // 
            this.btn_proxy_check.Font = new System.Drawing.Font("宋体", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.btn_proxy_check.Location = new System.Drawing.Point(70, 155);
            this.btn_proxy_check.Name = "btn_proxy_check";
            this.btn_proxy_check.Size = new System.Drawing.Size(115, 30);
            this.btn_proxy_check.TabIndex = 2;
            this.btn_proxy_check.Text = "验证是否可用";
            this.btn_proxy_check.UseVisualStyleBackColor = true;
            this.btn_proxy_check.Click += new System.EventHandler(this.btn_proxy_check_Click);
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Font = new System.Drawing.Font("宋体", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.label4.ForeColor = System.Drawing.Color.Red;
            this.label4.Location = new System.Drawing.Point(72, 27);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(96, 16);
            this.label4.TabIndex = 0;
            this.label4.Text = "输入代理IP:";
            // 
            // tab_control
            // 
            this.tab_control.Controls.Add(this.tab_qr_code);
            this.tab_control.Controls.Add(this.tab_proxy_ip);
            this.tab_control.Location = new System.Drawing.Point(661, 232);
            this.tab_control.Name = "tab_control";
            this.tab_control.SelectedIndex = 0;
            this.tab_control.Size = new System.Drawing.Size(260, 265);
            this.tab_control.TabIndex = 30;
            // 
            // tab_qr_code
            // 
            this.tab_qr_code.BackColor = System.Drawing.SystemColors.Control;
            this.tab_qr_code.Controls.Add(this.btnCopyLink);
            this.tab_qr_code.Controls.Add(this.richTextLink);
            this.tab_qr_code.Controls.Add(this.pictureBoxUrl);
            this.tab_qr_code.Controls.Add(this.richTextQRCode);
            this.tab_qr_code.Controls.Add(this.btnGenQRCode);
            this.tab_qr_code.Location = new System.Drawing.Point(4, 22);
            this.tab_qr_code.Name = "tab_qr_code";
            this.tab_qr_code.Size = new System.Drawing.Size(252, 239);
            this.tab_qr_code.TabIndex = 2;
            this.tab_qr_code.Text = "活动信息";
            // 
            // btnCopyLink
            // 
            this.btnCopyLink.Font = new System.Drawing.Font("宋体", 8F);
            this.btnCopyLink.Location = new System.Drawing.Point(189, 203);
            this.btnCopyLink.Name = "btnCopyLink";
            this.btnCopyLink.Size = new System.Drawing.Size(60, 30);
            this.btnCopyLink.TabIndex = 28;
            this.btnCopyLink.Text = "复制链接";
            this.btnCopyLink.UseVisualStyleBackColor = true;
            this.btnCopyLink.Click += new System.EventHandler(this.btnCopyLink_Click);
            // 
            // richTextLink
            // 
            this.richTextLink.BackColor = System.Drawing.SystemColors.Control;
            this.richTextLink.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.richTextLink.DetectUrls = false;
            this.richTextLink.Font = new System.Drawing.Font("宋体", 8.5F);
            this.richTextLink.ForeColor = System.Drawing.Color.Blue;
            this.richTextLink.Location = new System.Drawing.Point(4, 200);
            this.richTextLink.Name = "richTextLink";
            this.richTextLink.ReadOnly = true;
            this.richTextLink.Size = new System.Drawing.Size(187, 35);
            this.richTextLink.TabIndex = 27;
            this.richTextLink.Text = "";
            // 
            // text_box_ip_info
            // 
            this.text_box_ip_info.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.text_box_ip_info.DetectUrls = false;
            this.text_box_ip_info.Font = new System.Drawing.Font("宋体", 10.5F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.text_box_ip_info.ForeColor = System.Drawing.Color.Red;
            this.text_box_ip_info.Location = new System.Drawing.Point(653, 596);
            this.text_box_ip_info.Name = "text_box_ip_info";
            this.text_box_ip_info.ReadOnly = true;
            this.text_box_ip_info.ScrollBars = System.Windows.Forms.RichTextBoxScrollBars.Horizontal;
            this.text_box_ip_info.Size = new System.Drawing.Size(274, 42);
            this.text_box_ip_info.TabIndex = 31;
            this.text_box_ip_info.Text = "";
            // 
            // text_link_label
            // 
            this.text_link_label.AutoSize = true;
            this.text_link_label.Location = new System.Drawing.Point(511, 10);
            this.text_link_label.Name = "text_link_label";
            this.text_link_label.Size = new System.Drawing.Size(53, 12);
            this.text_link_label.TabIndex = 32;
            this.text_link_label.TabStop = true;
            this.text_link_label.Text = "网页日志";
            this.text_link_label.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.text_link_label_LinkClicked);
            // 
            // context_menu_strip_list
            // 
            this.context_menu_strip_list.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.strip_menu_item_sel_all,
            this.strip_menu_item_copy,
            this.strip_menu_item_paste,
            this.strip_menu_item_delete});
            this.context_menu_strip_list.Name = "context_menu_strip_list";
            this.context_menu_strip_list.Size = new System.Drawing.Size(101, 92);
            this.context_menu_strip_list.Opening += new System.ComponentModel.CancelEventHandler(this.context_menu_strip_list_Opening);
            // 
            // strip_menu_item_sel_all
            // 
            this.strip_menu_item_sel_all.Name = "strip_menu_item_sel_all";
            this.strip_menu_item_sel_all.Size = new System.Drawing.Size(100, 22);
            this.strip_menu_item_sel_all.Text = "全选";
            this.strip_menu_item_sel_all.Click += new System.EventHandler(this.ToolStripMenuItem_all_sel_Click);
            // 
            // strip_menu_item_copy
            // 
            this.strip_menu_item_copy.Enabled = false;
            this.strip_menu_item_copy.Name = "strip_menu_item_copy";
            this.strip_menu_item_copy.Size = new System.Drawing.Size(100, 22);
            this.strip_menu_item_copy.Text = "复制";
            this.strip_menu_item_copy.Click += new System.EventHandler(this.ToolStripMenuItem_copy_Click);
            // 
            // strip_menu_item_paste
            // 
            this.strip_menu_item_paste.Enabled = false;
            this.strip_menu_item_paste.Name = "strip_menu_item_paste";
            this.strip_menu_item_paste.Size = new System.Drawing.Size(100, 22);
            this.strip_menu_item_paste.Text = "粘贴";
            this.strip_menu_item_paste.Click += new System.EventHandler(this.ToolStripMenuItem_paste_Click);
            // 
            // strip_menu_item_delete
            // 
            this.strip_menu_item_delete.Enabled = false;
            this.strip_menu_item_delete.Name = "strip_menu_item_delete";
            this.strip_menu_item_delete.Size = new System.Drawing.Size(100, 22);
            this.strip_menu_item_delete.Text = "删除";
            this.strip_menu_item_delete.Click += new System.EventHandler(this.ToolStripMenuItem_delete_Click);
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Font = new System.Drawing.Font("宋体", 12F);
            this.label6.Location = new System.Drawing.Point(151, 93);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(40, 16);
            this.label6.TabIndex = 33;
            this.label6.Text = "次数";
            // 
            // numeric_kabao_count
            // 
            this.numeric_kabao_count.Font = new System.Drawing.Font("宋体", 11F, System.Drawing.FontStyle.Bold);
            this.numeric_kabao_count.Location = new System.Drawing.Point(201, 88);
            this.numeric_kabao_count.Maximum = new decimal(new int[] {
            100000,
            0,
            0,
            0});
            this.numeric_kabao_count.Name = "numeric_kabao_count";
            this.numeric_kabao_count.Size = new System.Drawing.Size(70, 24);
            this.numeric_kabao_count.TabIndex = 34;
            this.numeric_kabao_count.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            this.numeric_kabao_count.Value = new decimal(new int[] {
            1,
            0,
            0,
            0});
            // 
            // panel1
            // 
            this.panel1.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.panel1.Controls.Add(this.btnStopCatch);
            this.panel1.Controls.Add(this.btnCatchSel);
            this.panel1.Controls.Add(this.btnStartCatch);
            this.panel1.Location = new System.Drawing.Point(649, 173);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(280, 53);
            this.panel1.TabIndex = 35;
            // 
            // panel2
            // 
            this.panel2.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.panel2.Controls.Add(this.label7);
            this.panel2.Controls.Add(this.richTextInput);
            this.panel2.Controls.Add(this.chckSound);
            this.panel2.Controls.Add(this.checkAutoGraspCk);
            this.panel2.Controls.Add(this.checkAutoDoAct);
            this.panel2.Controls.Add(this.numeric_kabao_count);
            this.panel2.Controls.Add(this.numUDDelay);
            this.panel2.Controls.Add(this.label6);
            this.panel2.Controls.Add(this.label1);
            this.panel2.Controls.Add(this.comboBoxActList);
            this.panel2.Controls.Add(this.label3);
            this.panel2.Location = new System.Drawing.Point(648, 4);
            this.panel2.Name = "panel2";
            this.panel2.Size = new System.Drawing.Size(281, 163);
            this.panel2.TabIndex = 36;
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Font = new System.Drawing.Font("宋体", 12F);
            this.label7.Location = new System.Drawing.Point(5, 131);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(56, 16);
            this.label7.TabIndex = 35;
            this.label7.Text = "输入框";
            // 
            // richTextInput
            // 
            this.richTextInput.BackColor = System.Drawing.SystemColors.Window;
            this.richTextInput.DetectUrls = false;
            this.richTextInput.Font = new System.Drawing.Font("宋体", 14F);
            this.richTextInput.ForeColor = System.Drawing.Color.Blue;
            this.richTextInput.Location = new System.Drawing.Point(63, 125);
            this.richTextInput.Multiline = false;
            this.richTextInput.Name = "richTextInput";
            this.richTextInput.Size = new System.Drawing.Size(209, 30);
            this.richTextInput.TabIndex = 29;
            this.richTextInput.Text = "";
            // 
            // panel3
            // 
            this.panel3.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.panel3.Controls.Add(this.checkShowLog);
            this.panel3.Controls.Add(this.check_btn_log);
            this.panel3.Controls.Add(this.btnClearLog);
            this.panel3.Controls.Add(this.text_link_label);
            this.panel3.Controls.Add(this.btnFinishCatch);
            this.panel3.Location = new System.Drawing.Point(4, 292);
            this.panel3.Name = "panel3";
            this.panel3.Size = new System.Drawing.Size(638, 32);
            this.panel3.TabIndex = 37;
            // 
            // richTextDesc
            // 
            this.richTextDesc.BackColor = System.Drawing.SystemColors.Control;
            this.richTextDesc.ForeColor = System.Drawing.SystemColors.HotTrack;
            this.richTextDesc.Location = new System.Drawing.Point(655, 503);
            this.richTextDesc.Name = "richTextDesc";
            this.richTextDesc.ReadOnly = true;
            this.richTextDesc.Size = new System.Drawing.Size(268, 87);
            this.richTextDesc.TabIndex = 0;
            this.richTextDesc.Text = "活动操作简介";
            // 
            // HccWindowdGraspTool
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(935, 650);
            this.Controls.Add(this.richTextDesc);
            this.Controls.Add(this.panel3);
            this.Controls.Add(this.panel2);
            this.Controls.Add(this.panel1);
            this.Controls.Add(this.text_box_ip_info);
            this.Controls.Add(this.tab_control);
            this.Controls.Add(this.listViewToken);
            this.Controls.Add(this.richTextBoxLog);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "HccWindowdGraspTool";
            this.Text = "活动大师 by-hcc";
            ((System.ComponentModel.ISupportInitialize)(this.numUDDelay)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBoxUrl)).EndInit();
            this.tab_proxy_ip.ResumeLayout(false);
            this.tab_proxy_ip.PerformLayout();
            this.tab_control.ResumeLayout(false);
            this.tab_qr_code.ResumeLayout(false);
            this.context_menu_strip_list.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.numeric_kabao_count)).EndInit();
            this.panel1.ResumeLayout(false);
            this.panel2.ResumeLayout(false);
            this.panel2.PerformLayout();
            this.panel3.ResumeLayout(false);
            this.panel3.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion
        private System.Windows.Forms.RichTextBox richTextBoxLog;
        private System.Windows.Forms.Button btnClearLog;
        private System.Windows.Forms.Button btnStartCatch;
        private System.Windows.Forms.Button btnStopCatch;
        private System.Windows.Forms.Button btnFinishCatch;
        private System.Windows.Forms.CheckBox check_btn_log;
        private System.Windows.Forms.CheckBox checkAutoGraspCk;
        private System.Windows.Forms.CheckBox checkAutoDoAct;
        private System.Windows.Forms.CheckBox chckSound;
        private System.Windows.Forms.CheckBox checkShowLog;
        private System.Windows.Forms.NumericUpDown numUDDelay;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.ComboBox comboBoxActList;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.PictureBox pictureBoxUrl;
        private System.Windows.Forms.Button btnGenQRCode;
        private System.Windows.Forms.RichTextBox richTextQRCode;
        private System.Windows.Forms.ListView listViewToken;
        private System.Windows.Forms.Button btnCatchSel;
        private System.Windows.Forms.TabPage tab_proxy_ip;
        private System.Windows.Forms.TabControl tab_control;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.CheckBox btn_use_proxy;
        private System.Windows.Forms.Button btn_proxy_check;
        private System.Windows.Forms.RichTextBox text_box_ip_info;
        private System.Windows.Forms.LinkLabel text_link_label;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.TextBox text_box_proxy_ip;
        private System.Windows.Forms.TabPage tab_qr_code;
        private System.Windows.Forms.ContextMenuStrip context_menu_strip_list;
        private System.Windows.Forms.ToolStripMenuItem strip_menu_item_sel_all;
        private System.Windows.Forms.ToolStripMenuItem strip_menu_item_copy;
        private System.Windows.Forms.ToolStripMenuItem strip_menu_item_paste;
        private System.Windows.Forms.ToolStripMenuItem strip_menu_item_delete;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.NumericUpDown numeric_kabao_count;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Panel panel2;
        private System.Windows.Forms.Panel panel3;
        private System.Windows.Forms.Button btnCopyLink;
        private System.Windows.Forms.RichTextBox richTextLink;
        private System.Windows.Forms.RichTextBox richTextDesc;
        private System.Windows.Forms.RichTextBox richTextInput;
        private System.Windows.Forms.Label label7;
    }
}

