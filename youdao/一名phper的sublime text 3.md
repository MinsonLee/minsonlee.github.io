# 一名PHPer的Sublime Text 3 (Build 3143)

[TOC]

## 安装

- 官网：[https://www.sublimetext.com/](https://www.sublimetext.com/)
- API文档：[https://www.sublimetext.com/docs/3/api_reference.html](https://www.sublimetext.com/docs/3/api_reference.html)
- 非官方文档：[http://feliving.github.io/Sublime-Text-3-Documentation/index.html](http://feliving.github.io/Sublime-Text-3-Documentation/index.html)

**注意：** 如果想安装绿色免安装版可以点击[官网Download](https://www.sublimetext.com/3)

## 注册码

```
—– BEGIN LICENSE —–
TwitterInc
200 User License
EA7E-890007
1D77F72E 390CDD93 4DCBA022 FAF60790
61AA12C0 A37081C5 D0316412 4584D136
94D7F7D4 95BC8C1C 527DA828 560BB037
D1EDDD8C AE7B379F 50C9D69D B35179EF
2FE898C4 8E4277A8 555CE714 E1FB0E43
D5D52613 C3D12E98 BC49967F 7652EED2
9D2D2E61 67610860 6D338B72 5CF95C69
E36B85CC 84991F19 7575D828 470A92AB
—— END LICENSE ——

作者：晚晴幽草
链接：http://www.jianshu.com/p/04e1b65dd2c0
來源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
```

## 插件

### 1. 插件管理 `PackageControl`

不多说该插件！详情及安装请点击查看[官网](https://packagecontrol.io/installation)

安装插件：安装完之后：`Ctrl+Shift+p`，输入选择 `Inpackage Control: Install Package`，搜索安装需要的插件

卸载插件：安装完之后：`Ctrl+Shift+p`，输入选择 `Inpackage Control: Remove Package`，选择卸载已安装插件

### 2.颜色方案：`Monokai - Spacegray`

安装插件：`Ctrl+Shift+p`，输入选择 `Inpackage Control: Install Package`，搜索 `Monokai - Spacegray` 安装插件

使用插件：`Preferences` > `Color Scheme` > 选择对应方案

### 3.编辑器主题：`Material-Theme`

安装插件：`Ctrl+Shift+p`，输入选择 `Inpackage Control: Install Package`，搜索 `Material-Theme` 安装插件

使用插件：`Preferences` > `Theme` > 选择对应方案

### 4.文件 `Icon` 插件--`A File icons`
安装插件：`Ctrl+Shift+p`，输入选择 `Inpackage Control: Install Package`，搜索 `A File Icon` 安装插件

使用插件：`Preferences` > `Theme` > 选择`Material`方案，自动使用

### 5.编辑器字体及设置

```
{
	"caret_style": "phase",
	"color_scheme": "Packages/Monokai - Spacegray/Monokai - Spacegray Eighties.tmTheme",
	"ignored_packages":
	[
		"Vintage"
	],
	"theme": "Material-Theme.sublime-theme",
	"fade_fold_buttons": false,
	"fold_buttons": true,
	"font_face": "Courier New",
	"font_options":
	[
		"no_bold",
		"no_italic",
		"antialias",
		"antialias"
	],
	"font_size": 11,
	"gutter": true,
	"highlight_line": true,
	"highlight_modified_tabs": true,
	"hot_exit": true,
	
	"line_padding_bottom": 1,
	"line_padding_top": 1,
	"tab_size": 4,
	"translate_tabs_to_spaces": true
}
```


### 6.前端插件--`Emmet`
作为PHPer，写部分前端代码，必不可少，这个插件也不多说！详情请见[中文官网](http://yanxyz.github.io/emmet-docs/)或[此处](http://bubkoo.com/2014/01/04/emmet-a-toolkit-for-improving-html-css-workflow/)

安装插件：`Ctrl+Shift+p`，输入选择 `Inpackage Control: Install Package`，搜索 `Emmet` 安装插件

### 7.文件插件--`AdvancedNewFile`

安装以后：
1. 不需要再担心创建不了 `Windows` 不支持的文件名规则【例如:`.gitignore`,`.hosts`...】
2. 不需要递归先创建目录再来 `touch <file>`

安装插件：`Ctrl+Shift+p`，输入选择 `Inpackage Control: Install Package`，搜索 `AdvancedNewFile` 安装插件

使用插件：`Ctrl+Alt+n`

- [Sublime Text怎么快速建立一个html5页面模板-百度经验](https://jingyan.baidu.com/article/fec7a1e5c7f11b1190b4e7a4.html)

### 8.右键菜单增强术-- `SideBarEnhancements`

安装以后，右键看一下自己的侧边栏吧！

**侧边栏开关`Ctrl+K+B`**

安装插件：`Ctrl+Shift+p`，输入选择 `Inpackage Control: Install Package`，搜索 `SideBarEnhancements` 安装插件

### 9.代码提示-- `SublimeCodeIntel`
详情请见[此处](https://www.liudon.org/1337.html)

安装插件：`Ctrl+Shift+p`，输入选择 `Inpackage Control: Install Package`，搜索 `SublimeCodeIntel` 安装插件

配置插件：

1. 依次点击 `Preferences` > `Package Settings` > `SublimeCodeIntel` > `Settings - User`，从 `Default` 下拷贝配置文件，依次点击 `Preferences` > `Package Settings` > `SublimeCodeIntel` > `Settings - Default`
2. 配置PHP路径

```
"PHP": {
    "php": "xxx/php.exe",
    "codeintel_scan_extra_dir": [],
    "codeintel_scan_files_in_project": true,
    "codeintel_max_recursive_dir_depth": 15,
    "codeintel_scan_exclude_dir":["C:/xxx/www"]
}
```

`SublimeCodeIntel` 和 `codeintel_scan_exclude_dir` 有疑问！！！

使用：`Alt`+鼠标左键==>函数跳转


### 10.语法检查插件--SublimeLinter && SublimeLinter-php

详情点击[此处](https://www.liudon.org/1335.html)

安装插件：
1. 安装插件：`Ctrl+Shift+p`，输入选择`Inpackage Control: Install Package`，搜索`SublimeLinter`安装插件
2. 安装插件：`Ctrl+Shift+p`，输入选择`Inpackage Control: Install Package`，搜索`SublimeLinter-php`安装插件

配置插件：
1. `Preferences`->`Package Settings`->`SublimeLinter`->`Settings - User`
2. 搜索`paths`，找到下面的`windows`，配置`php.exe`所在的目录的绝对路径

如果User是空白，则复制一份default的值进行修改即可！

### 11. Git插件-GitGutter
安装插件：`Ctrl+Shift+p`，输入选择`Inpackage Control: Install Package`，搜索`GitGutter`安装插件

安装后，在git版本控制的目录下，所有的修改都可以在侧边栏看见！

### 12. JQuery提示插件--JQuery
详情见[官网](https://packagecontrol.io/packages/jQuery)

### 13. JSON美化--Pretty JSON
详情见[官网](https://packagecontrol.io/packages/Pretty%20JSON)

使用插件：

格式化JSON:`Ctrl+Alt+J`

不格式化JSON:`Ctrl+Alt+M`


### 14. 实时刷新插件--LiveReload

详情见[此处](http://www.jianshu.com/p/f4ec41257206)

### 15.代码格式化插件--Alignment

详情见[此处](https://sublime.wbond.net/packages/Alignment)

### 16.代码格式化插件--CodeFormatter

详情见[官网](https://packagecontrol.io/packages/CodeFormatter)

### 16. PHP手册插件--DocphpManualer

详情见[官网](https://packagecontrol.io/packages/DocPHPManualer)

使用： `ctrl + alt + d` for Show Definition and `ctrl + alt + s` for Search Manual

### 17.PHP注释插件--DocBlockr

详情见[官网-DocBlockr](https://packagecontrol.io/packages/DocBlockr)

### 18.文件编码插件--ConvertToUTF8


### 19.Open in Browser

详见[`此处`](https://www.granneman.com/webdev/editors/sublime-text/set-up-sublime-text-to-preview-your-code-in-a-web-browser/)

简易方法：`Tools` > `Build System` > `New Build System` Save AS `Chrome.sublime-build`, with the following text in it
 
```
{
    "cmd": ["C:\\Users\\user\\AppData\\Local\\Google\\Chrome\\Application\\chrome.exe","$file"]
}
```


## Sublime Text 3快捷键

### 精华版

- Ctrl+Shift+P：打开命令面板
- Ctrl+P：搜索项目中的文件
- Ctrl+G：跳转到第几行
- Ctrl+W：关闭当前打开文件
- Ctrl+Shift+W：关闭所有打开文件
- Ctrl+Shift+V：粘贴并格式化
- Ctrl+D：选择单词，重复可增加选择下一个相同的单词
- Ctrl+L：选择行，重复可依次增加选择下一行
- Ctrl+Shift+L：选择多行
- Ctrl+Shift+Enter：在当前行前插入新行
- Ctrl+X：删除当前行
- Ctrl+M：跳转到对应括号
- Ctrl+U：软撤销，撤销光标位置
- Ctrl+J：选择标签内容
- Ctrl+F：查找内容
- Ctrl+Shift+F：查找并替换
- Ctrl+H：替换
- Ctrl+R：前往 method
- Ctrl+N：新建窗口
- Ctrl+K+B：开关侧栏
- Ctrl+Shift+M：选中当前括号内容，重复可选着括号本身
- Ctrl+F2：设置/删除标记
- Ctrl+/：注释当前行
- Ctrl+Shift+/：当前位置插入注释
- Ctrl+Alt+/：块注释，并Focus到首行，写注释说明用的
- Ctrl+Shift+A：选择当前标签前后，修改标签用的
- F11：全屏
- Shift+F11：全屏免打扰模式，只编辑当前文件
- Alt+F3：选择所有相同的词
- Alt+.：闭合标签
- Alt+Shift+数字：分屏显示
- Alt+数字：切换打开第N个文件
- Shift+右键拖动：光标多不，用来更改或插入列内容
- 鼠标的前进后退键可切换Tab文件
- 按Ctrl，依次点击或选取，可需要编辑的多个位置
- 按Ctrl+Shift+上下键，可替换行


### 选择类

- Ctrl+D 选中光标所占的文本，继续操作则会选中下一个相同的文本。
- Alt+F3 选中文本按下快捷键，即可一次性选择全部的相同文本进行同时编辑。举个栗子：快速选中并更改所有相同的变量名、函数名等。
- Ctrl+L 选中整行，继续操作则继续选择下一行，效果和 Shift+↓ 效果一样。
- Ctrl+Shift+L 先选中多行，再按下快捷键，会在每行行尾插入光标，即可同时编辑这些行。
- Ctrl+Shift+M 选择括号内的内容（继续选择父括号）。举个栗子：快速选中删除函数中的代码，重写函数体代码或重写括号内里的内容。
- Ctrl+M 光标移动至括号内结束或开始的位置。
- Ctrl+Enter 在下一行插入新行。举个栗子：即使光标不在行尾，也能快速向下插入一行。
- Ctrl+Shift+Enter 在上一行插入新行。举个栗子：即使光标不在行首，也能快速向上插入一行。
- Ctrl+Shift+[ 选中代码，按下快捷键，折叠代码。
- Ctrl+Shift+] 选中代码，按下快捷键，展开代码。
- Ctrl+K+0 展开所有折叠代码。
- Ctrl+← 向左单位性地移动光标，快速移动光标。
- Ctrl+→ 向右单位性地移动光标，快速移动光标。
- shift+↑ 向上选中多行。
- shift+↓ 向下选中多行。
- Shift+← 向左选中文本。
- Shift+→ 向右选中文本。
- Ctrl+Shift+← 向左单位性地选中文本。
- Ctrl+Shift+→ 向右单位性地选中文本。
- Ctrl+Shift+↑ 将光标所在行和上一行代码互换（将光标所在行插入到上一行之前）。
- Ctrl+Shift+↓ 将光标所在行和下一行代码互换（将光标所在行插入到下一行之后）。
- Ctrl+Alt+↑ 向上添加多行光标，可同时编辑多行。
- Ctrl+Alt+↓ 向下添加多行光标，可同时编辑多行。

### 编辑类

- Ctrl+J 合并选中的多行代码为一行。举个栗子：将多行格式的CSS属性合并为一行。
- Ctrl+Shift+D 复制光标所在整行，插入到下一行。
- Tab 向右缩进。
- Shift+Tab 向左缩进。
- Ctrl+K+K 从光标处开始删除代码至行尾。
- Ctrl+Shift+K 删除整行。
- Ctrl+/ 注释单行。
- Ctrl+Shift+/ 注释多行。
- Ctrl+K+U 转换大写。
- Ctrl+K+L 转换小写。
- Ctrl+Z 撤销。
- Ctrl+Y 恢复撤销。
- Ctrl+U 软撤销，感觉和 Gtrl+Z 一样。
- Ctrl+F2 设置书签
- Ctrl+T 左右字母互换
- F6 单词检测拼写

### 搜索类

- Ctrl+F 打开底部搜索框，查找关键字。
- Ctrl+shift+F 在文件夹内查找，与普通编辑器不同的地方是sublime允许添加多个文件夹进行查找，略高端，未研究。
- Ctrl+P 打开搜索框。举个栗子：1、输入当前项目中的文件名，快速搜索文件，2、输入@和关键字，查找文件中函数名，3、输入：和数字，跳转到文件中该行代码，4、输入#和关键字，查找变量名。
- Ctrl+G 打开搜索框，自动带：，输入数字跳转到该行代码。举个栗子：在页面代码比较长的文件中快速定位。
- Ctrl+R 打开搜索框，自动带@，输入关键字，查找文件中的函数名。举个栗子：在函数较多的页面快速查找某个函数。
- Ctrl+： 打开搜索框，自动带#，输入关键字，查找文件中的变量名、属性名等。
- Ctrl+Shift+P 打开命令框。场景栗子：打开命名框，输入关键字，调用sublime text或插件的功能，例如使用package安装插件。
- Esc 退出光标多行选择，退出搜索框，命令框等

### 显示类

- Ctrl+Tab 按文件浏览过的顺序，切换当前窗口的标签页。
- Ctrl+PageDown 向左切换当前窗口的标签页。
- Ctrl+PageUp 向右切换当前窗口的标签页。
- Alt+Shift+1 窗口分屏，恢复默认1屏（非小键盘的数字）
- Alt+Shift+2 左右分屏-2列
- Alt+Shift+3 左右分屏-3列
- Alt+Shift+4 左右分屏-4列
- Alt+Shift+5 等分4屏
- Alt+Shift+8 垂直分屏-2屏
- Alt+Shift+9 垂直分屏-3屏
- Ctrl+K+B 开启/关闭侧边栏。
- F11 全屏模式
- Shift+F11 免打扰模式
- Ctrl+k+2 折叠注释和方法
- Ctrl+k+3 折叠if
- Ctrl+k+4 折叠switch