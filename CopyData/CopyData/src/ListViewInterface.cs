using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Drawing;
using System.Windows.Forms;
using System.Collections;
using LuaInterface;

namespace CopyData
{
    public partial class HccWindowdGraspTool
    {

        //注册ListView方法
        public void registLuaFuncListView() {
            _luaScript.RegisterFunction("ListView_add_columns", this, GetType().GetMethod("ListView_add_columns"));
            _luaScript.RegisterFunction("ListView_add_item", this, GetType().GetMethod("ListView_add_item"));
            _luaScript.RegisterFunction("ListView_set_height", this, GetType().GetMethod("ListView_set_height"));
            _luaScript.RegisterFunction("ListView_clear", this, GetType().GetMethod("ListView_clear"));
            _luaScript.RegisterFunction("ListView_get_itme_by_index", this, GetType().GetMethod("ListView_get_itme_by_index"));
            _luaScript.RegisterFunction("ListView_get_select_index", this, GetType().GetMethod("ListView_get_select_index"));
            _luaScript.RegisterFunction("ListView_set_checked", this, GetType().GetMethod("ListView_set_checked"));
        }

        //listView 初始化
        public void InitListView()
        {

            //初始化
            listViewToken.View = View.Details;
            listViewToken.FullRowSelect = true; //设置是否行选择模式, 可选中整个行
            listViewToken.GridLines = true; //设置行和列之间是否显示网格线。
            listViewToken.MultiSelect = true; //设置是否可以选择多个项
            listViewToken.HeaderStyle = ColumnHeaderStyle.Clickable; //设置列标头样式
            listViewToken.LabelEdit = true; //设置用户是否可以编辑控件中项的标签(没用)
            listViewToken.CheckBoxes = true; //设置控件中各项的旁边是否显示复选框
            //listViewToken.CheckedItems = null; //获取控件中当前复选框选中的项(有用)
            listViewToken.HideSelection = true; //设置选定项在控件没焦点时是否隐藏突出显示
            //listViewToken.TopItem = ;// 获取或设置控件中的第一个可见项，可用于定位。（效果类似于EnsureVisible方法）

            /*
            //列表头创建（记得，需要先创建列表头）
            listViewToken.Columns.Add("序号", 50, HorizontalAlignment.Left);
            listViewToken.Columns.Add("Cookies", 250, HorizontalAlignment.Left);
            listViewToken.Columns.Add("结果", 200, HorizontalAlignment.Left);
            listViewToken.Columns.Add("状态", 100, HorizontalAlignment.Left);

            //添加数据项    
            this.listViewToken.BeginUpdate();   //数据更新，UI暂时挂起，直到EndUpdate绘制控件，可以有效避免闪烁并大大提高加载速度
            for (int i = 0; i < 60; i++)   //添加10行数据
            {
                ListViewItem lvi = new ListViewItem();
                lvi.ImageIndex = i;     //通过与imageList绑定，显示imageList中第i项图标
                //lvi.Text = "" + i;
                lvi.SubItems.Add("第2列,第 " + i + " 行》》》》");
                lvi.SubItems.Add("第3列,第 " + i + " 行");
                lvi.SubItems.Add("第4列,第 " + i + " 行");
                lvi.SubItems.Add("第5列,第 " + i + " 行");
                this.listViewToken.Items.Add(lvi);
            }
            ////滚动到最后
            //listViewToken.Items[listViewToken.Items.Count - 1].EnsureVisible();
            //listViewToken.TopItem = listViewToken.Items[listViewToken.Items.Count - 1];
            this.listViewToken.EndUpdate();  //结束数据处理，UI界面一次性绘制。
            //访问数据
            foreach (ListViewItem item in this.listViewToken.Items)
            {
                //处理行
                for (int i = 0; i < item.SubItems.Count; i++)
                {
                    //处理列
                    //MessageBox.Show(item.SubItems[i].Text);
                }
            }

            //移除
            foreach (ListViewItem lvi in listViewToken.SelectedItems)  //选中项遍历
            {
                listViewToken.Items.RemoveAt(lvi.Index); // 按索引移除
                //listView1.Items.Remove(lvi);   //按项移除
            }

            //行高设置（利用imageList实现）
            ImageList imgList = new ImageList();
            imgList.ImageSize = new Size(1, 20);// 设置行高 20 //分别是宽和高
            listViewToken.SmallImageList = imgList; //这里设置listView的SmallImageList ,用imgList将其撑大

            //（6）清空
            //this.listViewToken.Clear();  //从控件中移除所有项和列（包括列表头）。
            //this.listViewToken.Items.Clear();  //只移除所有的项。
            */
        }

        //增加列
        public void ListView_add_columns(string columnsName, int width) {
            this.listViewToken.Columns.Add(columnsName, width, HorizontalAlignment.Left);
        }

        //增加显示对象
        public void ListView_add_item(LuaTable table = null) {
            if (table == null){
                return;
            }
            if (table.Keys.Count > 0){
                this.listViewToken.BeginUpdate();   //数据更新，UI暂时挂起，直到EndUpdate绘制控件，可以有效避免闪烁并大大提高加载速度
                ListViewItem item = new ListViewItem();
                foreach (DictionaryEntry v in table){
                    var index = v.Key.ToString();
                    var value = v.Value.ToString();
                    if (index.Equals("1")){
                        item.Text = value;
                    }else {
                        item.SubItems.Add(value);
                    }
                }
                this.listViewToken.Items.Add(item);
                this.listViewToken.TopItem = listViewToken.Items[listViewToken.Items.Count - 1];//show last itme
                this.listViewToken.EndUpdate();  //结束数据处理，UI界面一次性绘制。
            }
        }

        //根据下标获取节点数组
        public LuaTable ListView_get_itme_by_index(int index = 0) {
            if (index == 0) {
                return null;
            }
            var items = this.listViewToken.Items;
            foreach (ListViewItem item in items)
            {
                //Console.WriteLine("xuhao: " + item.Text);
                if (item.Text.Equals(index.ToString())) {
                    LuaTable tb = new LuaTable(1, _luaScript);
                    var subItems = item.SubItems;
                    for (int idx = 0; idx < subItems.Count; idx++){
                        ListViewItem.ListViewSubItem subItem = subItems[idx];
                        var text = subItem.Text;
                        //Console.WriteLine("sub: " + text);
                        tb[idx+1] = text;
                    }
                    return tb;
                } 
            }
            return null;
        }

        //获取所有选中节点下标
        public string ListView_get_select_index()
        {
            var items = this.listViewToken.CheckedItems;
            if (items.Count <= 0)
            {
                return string.Empty;
            }

            var retString = "{";
            for (int idx_all = 0; idx_all < items.Count; idx_all++)
            {
                var item = items[idx_all];
                var index = item.Text;
                retString = retString + index + ",";
            }
            retString = retString + "}";
            return retString;
        }

        //行高设置（利用imageList实现）
        public void ListView_set_height(int height = 0) {
            
            ImageList imgList = new ImageList();
            imgList.ImageSize = new Size(1, height);// 设置行高 20 //分别是宽和高
            listViewToken.SmallImageList = imgList; //这里设置listView的SmallImageList ,用imgList将其撑大
        }

        //设置某个节点是否选中
        public void ListView_set_checked(int index = 0, bool isCheck = false, bool isAll = false) {
            var items = this.listViewToken.Items;
            if (items.Count <= 0) {
                return;
            }
            var item = items[index - 1];
            if (item != null) {
                item.Checked = isCheck;
            }
        }

        //移除所有的项
        public void ListView_clear() {
            this.listViewToken.Items.Clear();  
        }

        //点击listView
        private void listViewToken_SelectedIndexChanged(object sender, EventArgs e)
        {
            //Console.WriteLine("cccc");
        }
    }
}
