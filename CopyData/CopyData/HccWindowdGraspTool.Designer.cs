namespace CopyData
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
            this.btnClearToken = new System.Windows.Forms.Button();
            this.richTextBoxFind = new System.Windows.Forms.RichTextBox();
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
            this.label2 = new System.Windows.Forms.Label();
            this.numUDGraspTime = new System.Windows.Forms.NumericUpDown();
            this.comboBoxActList = new System.Windows.Forms.ComboBox();
            this.label3 = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.numUDDelay)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.numUDGraspTime)).BeginInit();
            this.SuspendLayout();
            // 
            // btnClearToken
            // 
            this.btnClearToken.BackColor = System.Drawing.SystemColors.Control;
            this.btnClearToken.Font = new System.Drawing.Font("宋体", 10.5F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.btnClearToken.Location = new System.Drawing.Point(749, 2);
            this.btnClearToken.Name = "btnClearToken";
            this.btnClearToken.Size = new System.Drawing.Size(80, 22);
            this.btnClearToken.TabIndex = 2;
            this.btnClearToken.Text = "清理日志";
            this.btnClearToken.UseVisualStyleBackColor = false;
            this.btnClearToken.Click += new System.EventHandler(this.btnClearTokenClick);
            // 
            // richTextBoxFind
            // 
            this.richTextBoxFind.Location = new System.Drawing.Point(268, 25);
            this.richTextBoxFind.Name = "richTextBoxFind";
            this.richTextBoxFind.ReadOnly = true;
            this.richTextBoxFind.Size = new System.Drawing.Size(661, 398);
            this.richTextBoxFind.TabIndex = 4;
            this.richTextBoxFind.Text = "";
            this.richTextBoxFind.TextChanged += new System.EventHandler(this.richTextBoxFindTextChanged);
            // 
            // richTextBoxLog
            // 
            this.richTextBoxLog.BackColor = System.Drawing.SystemColors.WindowText;
            this.richTextBoxLog.ForeColor = System.Drawing.Color.Lime;
            this.richTextBoxLog.Location = new System.Drawing.Point(3, 429);
            this.richTextBoxLog.Name = "richTextBoxLog";
            this.richTextBoxLog.ReadOnly = true;
            this.richTextBoxLog.Size = new System.Drawing.Size(926, 383);
            this.richTextBoxLog.TabIndex = 5;
            this.richTextBoxLog.Text = "";
            this.richTextBoxLog.TextChanged += new System.EventHandler(this.richTextBoxLogTextChanged);
            // 
            // btnClearLog
            // 
            this.btnClearLog.Location = new System.Drawing.Point(3, 405);
            this.btnClearLog.Name = "btnClearLog";
            this.btnClearLog.Size = new System.Drawing.Size(80, 22);
            this.btnClearLog.TabIndex = 6;
            this.btnClearLog.Text = "清理日志";
            this.btnClearLog.UseVisualStyleBackColor = true;
            this.btnClearLog.Click += new System.EventHandler(this.buttonClearLogClick);
            // 
            // btnStartCatch
            // 
            this.btnStartCatch.Location = new System.Drawing.Point(-1, 125);
            this.btnStartCatch.Name = "btnStartCatch";
            this.btnStartCatch.Size = new System.Drawing.Size(100, 38);
            this.btnStartCatch.TabIndex = 7;
            this.btnStartCatch.Text = "开始做任务";
            this.btnStartCatch.UseVisualStyleBackColor = true;
            this.btnStartCatch.Click += new System.EventHandler(this.btnStartCatch_Click);
            // 
            // btnStopCatch
            // 
            this.btnStopCatch.Location = new System.Drawing.Point(162, 125);
            this.btnStopCatch.Name = "btnStopCatch";
            this.btnStopCatch.Size = new System.Drawing.Size(100, 38);
            this.btnStopCatch.TabIndex = 8;
            this.btnStopCatch.Text = "停止";
            this.btnStopCatch.UseVisualStyleBackColor = true;
            this.btnStopCatch.Click += new System.EventHandler(this.btnStopCatch_Click);
            // 
            // btnFinishCatch
            // 
            this.btnFinishCatch.Location = new System.Drawing.Point(-1, 169);
            this.btnFinishCatch.Name = "btnFinishCatch";
            this.btnFinishCatch.Size = new System.Drawing.Size(100, 38);
            this.btnFinishCatch.TabIndex = 9;
            this.btnFinishCatch.Text = "test";
            this.btnFinishCatch.UseVisualStyleBackColor = true;
            this.btnFinishCatch.Click += new System.EventHandler(this.btnFinishCatch_Click);
            // 
            // check_btn_log
            // 
            this.check_btn_log.AutoSize = true;
            this.check_btn_log.BackColor = System.Drawing.Color.LightGray;
            this.check_btn_log.Font = new System.Drawing.Font("宋体", 10.5F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.check_btn_log.Location = new System.Drawing.Point(835, 5);
            this.check_btn_log.Name = "check_btn_log";
            this.check_btn_log.Size = new System.Drawing.Size(96, 18);
            this.check_btn_log.TabIndex = 12;
            this.check_btn_log.Text = "显示FD日志";
            this.check_btn_log.UseVisualStyleBackColor = false;
            this.check_btn_log.CheckedChanged += new System.EventHandler(this.check_btn_log_CheckedChanged);
            // 
            // checkAutoGraspCk
            // 
            this.checkAutoGraspCk.AutoSize = true;
            this.checkAutoGraspCk.BackColor = System.Drawing.Color.LightGray;
            this.checkAutoGraspCk.Checked = true;
            this.checkAutoGraspCk.CheckState = System.Windows.Forms.CheckState.Checked;
            this.checkAutoGraspCk.Font = new System.Drawing.Font("宋体", 10.5F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.checkAutoGraspCk.Location = new System.Drawing.Point(3, 40);
            this.checkAutoGraspCk.Name = "checkAutoGraspCk";
            this.checkAutoGraspCk.Size = new System.Drawing.Size(82, 18);
            this.checkAutoGraspCk.TabIndex = 14;
            this.checkAutoGraspCk.Text = "自动抓CK";
            this.checkAutoGraspCk.UseVisualStyleBackColor = false;
            this.checkAutoGraspCk.CheckedChanged += new System.EventHandler(this.checkAutoGraspCk_CheckedChanged);
            // 
            // checkAutoDoAct
            // 
            this.checkAutoDoAct.AutoSize = true;
            this.checkAutoDoAct.BackColor = System.Drawing.Color.LightGray;
            this.checkAutoDoAct.Font = new System.Drawing.Font("宋体", 10.5F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.checkAutoDoAct.Location = new System.Drawing.Point(3, 73);
            this.checkAutoDoAct.Name = "checkAutoDoAct";
            this.checkAutoDoAct.Size = new System.Drawing.Size(96, 18);
            this.checkAutoDoAct.TabIndex = 15;
            this.checkAutoDoAct.Text = "自动做任务";
            this.checkAutoDoAct.UseVisualStyleBackColor = false;
            this.checkAutoDoAct.CheckedChanged += new System.EventHandler(this.checkAutoDoAct_CheckedChanged);
            // 
            // chckSound
            // 
            this.chckSound.AutoSize = true;
            this.chckSound.BackColor = System.Drawing.Color.LightGray;
            this.chckSound.Checked = true;
            this.chckSound.CheckState = System.Windows.Forms.CheckState.Checked;
            this.chckSound.Font = new System.Drawing.Font("宋体", 10.5F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.chckSound.Location = new System.Drawing.Point(194, 12);
            this.chckSound.Name = "chckSound";
            this.chckSound.Size = new System.Drawing.Size(68, 18);
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
            this.checkShowLog.Location = new System.Drawing.Point(89, 407);
            this.checkShowLog.Name = "checkShowLog";
            this.checkShowLog.Size = new System.Drawing.Size(110, 18);
            this.checkShowLog.TabIndex = 17;
            this.checkShowLog.Text = "显示输出日志";
            this.checkShowLog.UseVisualStyleBackColor = false;
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
            this.numUDDelay.Location = new System.Drawing.Point(212, 40);
            this.numUDDelay.Name = "numUDDelay";
            this.numUDDelay.Size = new System.Drawing.Size(50, 23);
            this.numUDDelay.TabIndex = 18;
            this.numUDDelay.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            this.numUDDelay.ValueChanged += new System.EventHandler(this.numUDDelay_ValueChanged);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("宋体", 10.5F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.label1.Location = new System.Drawing.Point(136, 45);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(70, 14);
            this.label1.TabIndex = 19;
            this.label1.Text = "延时(秒):";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("宋体", 10.5F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.label2.Location = new System.Drawing.Point(136, 77);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(70, 14);
            this.label2.TabIndex = 20;
            this.label2.Text = "卡包次数:";
            // 
            // numUDGraspTime
            // 
            this.numUDGraspTime.Font = new System.Drawing.Font("宋体", 10.5F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.numUDGraspTime.Location = new System.Drawing.Point(212, 75);
            this.numUDGraspTime.Name = "numUDGraspTime";
            this.numUDGraspTime.Size = new System.Drawing.Size(50, 23);
            this.numUDGraspTime.TabIndex = 21;
            this.numUDGraspTime.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            this.numUDGraspTime.Value = new decimal(new int[] {
            5,
            0,
            0,
            0});
            this.numUDGraspTime.ValueChanged += new System.EventHandler(this.numUDGraspTime_ValueChanged);
            // 
            // comboBoxActList
            // 
            this.comboBoxActList.AllowDrop = true;
            this.comboBoxActList.BackColor = System.Drawing.SystemColors.Control;
            this.comboBoxActList.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.comboBoxActList.FormattingEnabled = true;
            this.comboBoxActList.Location = new System.Drawing.Point(3, 10);
            this.comboBoxActList.Name = "comboBoxActList";
            this.comboBoxActList.Size = new System.Drawing.Size(100, 20);
            this.comboBoxActList.TabIndex = 22;
            this.comboBoxActList.TabStop = false;
            this.comboBoxActList.SelectedIndexChanged += new System.EventHandler(this.comboBoxActList_SelectedIndexChanged);
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("宋体", 10.5F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.label3.Location = new System.Drawing.Point(109, 13);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(35, 14);
            this.label3.TabIndex = 23;
            this.label3.Text = "活动";
            // 
            // HccWindowdGraspTool
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(935, 824);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.comboBoxActList);
            this.Controls.Add(this.numUDGraspTime);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.numUDDelay);
            this.Controls.Add(this.checkShowLog);
            this.Controls.Add(this.chckSound);
            this.Controls.Add(this.checkAutoDoAct);
            this.Controls.Add(this.checkAutoGraspCk);
            this.Controls.Add(this.check_btn_log);
            this.Controls.Add(this.btnFinishCatch);
            this.Controls.Add(this.btnStopCatch);
            this.Controls.Add(this.btnStartCatch);
            this.Controls.Add(this.btnClearLog);
            this.Controls.Add(this.richTextBoxLog);
            this.Controls.Add(this.richTextBoxFind);
            this.Controls.Add(this.btnClearToken);
            this.Name = "HccWindowdGraspTool";
            this.Text = "抓包工具";
            ((System.ComponentModel.ISupportInitialize)(this.numUDDelay)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.numUDGraspTime)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button btnClearToken;
        private System.Windows.Forms.RichTextBox richTextBoxFind;
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
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.NumericUpDown numUDGraspTime;
        private System.Windows.Forms.ComboBox comboBoxActList;
        private System.Windows.Forms.Label label3;
    }
}

