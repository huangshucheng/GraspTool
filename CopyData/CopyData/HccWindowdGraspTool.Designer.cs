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
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // btnClearToken
            // 
            this.btnClearToken.Location = new System.Drawing.Point(162, 25);
            this.btnClearToken.Name = "btnClearToken";
            this.btnClearToken.Size = new System.Drawing.Size(100, 38);
            this.btnClearToken.TabIndex = 2;
            this.btnClearToken.Text = "清理";
            this.btnClearToken.UseVisualStyleBackColor = true;
            this.btnClearToken.Click += new System.EventHandler(this.btnClearTokenClick);
            // 
            // richTextBoxFind
            // 
            this.richTextBoxFind.Location = new System.Drawing.Point(268, 25);
            this.richTextBoxFind.Name = "richTextBoxFind";
            this.richTextBoxFind.ReadOnly = true;
            this.richTextBoxFind.Size = new System.Drawing.Size(661, 387);
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
            this.btnClearLog.Location = new System.Drawing.Point(3, 389);
            this.btnClearLog.Name = "btnClearLog";
            this.btnClearLog.Size = new System.Drawing.Size(100, 38);
            this.btnClearLog.TabIndex = 6;
            this.btnClearLog.Text = "清理";
            this.btnClearLog.UseVisualStyleBackColor = true;
            this.btnClearLog.Click += new System.EventHandler(this.buttonClearLogClick);
            // 
            // btnStartCatch
            // 
            this.btnStartCatch.Location = new System.Drawing.Point(3, 25);
            this.btnStartCatch.Name = "btnStartCatch";
            this.btnStartCatch.Size = new System.Drawing.Size(100, 38);
            this.btnStartCatch.TabIndex = 7;
            this.btnStartCatch.Text = "开始抓包";
            this.btnStartCatch.UseVisualStyleBackColor = true;
            this.btnStartCatch.Click += new System.EventHandler(this.btnStartCatch_Click);
            // 
            // btnStopCatch
            // 
            this.btnStopCatch.Location = new System.Drawing.Point(3, 69);
            this.btnStopCatch.Name = "btnStopCatch";
            this.btnStopCatch.Size = new System.Drawing.Size(100, 38);
            this.btnStopCatch.TabIndex = 8;
            this.btnStopCatch.Text = "停止";
            this.btnStopCatch.UseVisualStyleBackColor = true;
            this.btnStopCatch.Click += new System.EventHandler(this.btnStopCatch_Click);
            // 
            // btnFinishCatch
            // 
            this.btnFinishCatch.Location = new System.Drawing.Point(3, 113);
            this.btnFinishCatch.Name = "btnFinishCatch";
            this.btnFinishCatch.Size = new System.Drawing.Size(100, 38);
            this.btnFinishCatch.TabIndex = 9;
            this.btnFinishCatch.Text = "test";
            this.btnFinishCatch.UseVisualStyleBackColor = true;
            this.btnFinishCatch.Click += new System.EventHandler(this.btnFinishCatch_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(269, 7);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(35, 12);
            this.label1.TabIndex = 10;
            this.label1.Text = "token";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(109, 414);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(53, 12);
            this.label2.TabIndex = 11;
            this.label2.Text = "日志返回";
            // 
            // HccWindowdGraspTool
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(935, 824);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.btnFinishCatch);
            this.Controls.Add(this.btnStopCatch);
            this.Controls.Add(this.btnStartCatch);
            this.Controls.Add(this.btnClearLog);
            this.Controls.Add(this.richTextBoxLog);
            this.Controls.Add(this.richTextBoxFind);
            this.Controls.Add(this.btnClearToken);
            this.Name = "HccWindowdGraspTool";
            this.Text = "抓包工具";
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
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;

    }
}

