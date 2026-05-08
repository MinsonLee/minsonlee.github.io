# My VIM
[toc]


## NeoVim

- https://luyuhuang.tech/2023/03/21/nvim.html
- https://martinlwx.github.io/zh-cn/config-neovim-from-scratch/
- https://learnku.com/articles/75829
- https://github.com/neovim/neovim
- https://www.bilibili.com/video/BV1hP41117rt
- https://spacevim.org/
- 快捷键：which-key.nvim

-------------------

## VIM

`VIM` 是一个非常小巧、功能强大的文本编辑器，我非常喜欢使用 `VIM` 配合正则来处理大文本信息！

现在有非常多优秀的编辑器，例如： `sublime text` 、 `Notepad++` ，但是如果你用这些编辑器来处理上万行的文本查找、替换...如果电脑配置稍微低一点点，那是分分钟崩溃的节奏！

将 `VIM` 打造成 `IDE` 一样强大，至少目前对我来说是不必要的，市面的 `IDE` 工具已经很强大、很多，而且实际工作中也很少会在漆黑的命令行下长时间编码！

综上：能精通 `VIM` 那固然是极好的，但熟悉 `VIM` 的使用是必须的！

`VIM` 和 `VI` 编辑器的配置文件名称是：`vimrc` 或 `virc`。
一般来说：用户自定义的配置文件路径是： `/home/<user>/.vimrc` ，全局公共的配置文件路径是： `/etc/.vim/vimrc`。

不同的操作系统或不同发行版的 `Linux` 系统可能配置文件的路径不一致，可以通过 `vi` 或 `vim` 命令进入 `VI/VIM` 的 `GUI` 界面，按 `Esc` 切换为普通模式，输入 `:version` 查看具体信息，可快速定位配置文件的路径（对应路径文件没有可自行创建），如下：

![vim show version info](https://minsonlee.github.io/images/article/vim-how-to-find-vimrc.png) 

### 自定义配置文件

> `vimrc` 配置文件通过英文状态的双引号 `"` 进行注释

```vim
set nocompatible " 关闭兼容模式 or set nocp
filetype off " 关闭文件自动识别
syntax on " 开启语法高亮

" 初始化插件管理:vim-plug
" https://github.com/junegunn/vim-plug
call plug#begin('~/.vim/plugged')

" 安装插件，在下方输入列表，然后通过 :PlugInstall 安装
Plug 'nathanaelkane/vim-indent-guides' " 对齐线
Plug 'preservim/nerdtree' " 树形目录
Plug 'hotoo/pangu.vim',{ 'for': ['markdown','vimwiki','text'] } " 中文排版优化
Plug 'mattn/emmet-vim'

" 所有插件都必须加在 #end() 这一行之前
call plug#end()
filetype plugin indent on " 重新开启文件类型识别



" ############ 插件配置 Start ############
" 配置 indent-guides 插件
let g:indent_guides_enable_on_vim_startup = 1 " VIM 启动时启用
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1

" 配置 NERDTree 插件
"autocmd vimenter * NERDTree  "自动开启Nerdtree
let g:nerdtree_tabs_open_on_console_startup = 1 " 配置 NERDTree Tabs 插件自动启动
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif " 当NERDTree为剩下的唯一窗口时自动关闭
" 定义快捷键 Ctrl + n
map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden = 1 " 开启默认显示隐藏文件 . 开头的文件

" 开启中文排版优化插件
let g:pangu_rule_date = 1
autocmd BufWritePre *.markdown,*.md,*.text,*.txt,*.wiki,*.cnx call PanGuSpacing('ALL')

" 开启 emmet-vim
let g:user_emmet_install_global = 0
"let g:user_emmet_mode='n'    "only enable normal mode functions.
"let g:user_emmet_mode='inv'  "enable all functions, which is equal to
"let g:user_emmet_mode='a'    "enable all function in all mode.
"let g:user_emmet_leader_key='<C-Z>' "通过 ctrl + z + , 键入模板
autocmd FileType html,css,xml EmmetInstall

" ############ 插件配置 End ############

set shortmess=atI " 不显示援助乌干达儿童提示
set scrolloff=3 " 距离顶部和底部3行
set mouse=a " 启动鼠标
set nu " 设置行号
set nowrap    "不自动折行
set paste " 解决粘贴乱序问题
set ignorecase " 不区分大小写
set cursorline "突出显示当前行
" highlight CursorLine guibg=lightblue ctermbg=lightgray " 修饰横线

set ts=4 " 设置 tab 键宽度是 4 个空格
set tabstop=4 " 设置指标符宽度
set softtabstop=4 " 设置软制表符宽度
set shiftwidth=4 " 设置缩进空格
set textwidth=79 " 设置行最大宽度
set cc=120 " 设置第120列高亮
set expandtab " 设置默认开启tab扩展-将tab转为空格


set encoding=utf-8 " 设置编码
set fenc=utf-8 " 设置默认编码
set fencs=utf-8,usc-bom,euc-jp,gb18030,gbk,gb2312,cp936
set fileencodings=utf-8,gbk,utf-16,big5

set history=100 " 设置history文件记录行数
set nobackup " 设置不需要备份文件
set noswapfile " 设置不需要临时交换文件
set nowritebackup " 设置编辑时不需要备份文件

set autoindent " 设置自动缩进
set wildmenu " 增强模式中命令行自动完成操作
set ruler " 设置状态行显示当前光标位置
"set rulerformat=%20(%2*%<%f%=\ %m%r\ %3l\ %c\ %p%%%)
set background=dark "设置背景
" colorscheme  molokai " 设置颜色主题
set fileformat=unix " 设置文件格式化为 unix 系统（主要涉及换行符问题）

"set cursorcolumn " 设置光标所在列
" 设置快捷键 ,ch 调用 SetColorColumn 函数
map ,ch :call SetColorColumn()<CR>
" 设置与关闭鼠标所在列高亮
function! SetColorColumn()
    let col_num = virtcol(".")
    let cc_list = split(&cc, ',')
    if count(cc_list, string(col_num)) <= 0
        execute "set cc+=".col_num
    else
        execute "set cc-=".col_num
    endif
endfunction


" ############ 注释配置 Start ############
" 如果新文件是 .sh 文件，自动执行 AddShellDoc 函数
autocmd BufNewFile *.sh exec ":call AddShellDoc()"
func AddShellDoc()
    if expand("%:e") == 'sh'
    call setline(1, "#!/bin/bash")
    call setline(2, "")
    call setline(3, "#*********************************************")
    call setline(4, "# Description: The Test Script")
    call setline(5, "# Author: limingshuang")
    call setline(6, "# Date: " . strftime("%Y/%m/%d %H:%i%s"))
    call setline(7, "# HomePage: https://minsonlee.github.io/")
    call setline(8, "# Copyright © ".strftime("%Y")." All rights reserved")
    call setline(9, "#*********************************************")
    call setline(10, "")
    endif
endfunc

" 自动将光标设置到末尾
autocmd BufNewFile * normal G
" ############ 注释配置 End   ############
 ```
 
 ```vim
:set nu 开启行号
:set nonu 关闭行号
:syntax enable 高亮语法显示
:syntax clear 关闭高亮
```

### Vim 常用命令

#### 1. 批量替换

```sh
:2,31s/old/new/g " 从2-32行，批量替换old为new信息
:%s/old/new/g " 全文替换

:3,2138920s/  \(WHERE `id` = \d\{1,\},\)\(.*\));/\2\1;/g 利用正则进行替换
# 案例：替换90w+数据
:1,909149s/INSERT INTO `<table_name>`(`id`, `dealer_logo`) VALUES (\(\d\{1,}\), \(.*\)easyrentcars\(.*\))/UPDATE `zuzuche_world_db`.`seo_one_way_car_price` SET `dealer_logo` = \2qeeq\3 WHERE
 `id` = \1/g
```

#### 2. 批量注释

```vim
"  所有行首插入注释符号 # 
:1,$s/^/#/g

" 去除所有注释符号
:1,$s/^#*//g
```

#### 3. 批量删除

```vim
:2,31 d " 删除2-31 行

" 普通模式
dd " 删除光标到下一行起始处（不保留当前行）
d^ " 删除光标到行首
d$ " 删除光标到行末尾（保留当前行为空行）
dw " 删除光标到下一个单词起始处
de " 删除光标到当前单词末尾
x  " 删除当前光标所在字符
```

#### 4. 快速查找

```vim
/xxx   " 全局查找xxx[n--自上而下寻找;N--自下而上寻找]
```

#### 5. 批量在每行行首添加内容

```vim
:%s/^/要添加的内容  
# 指定行首批量添加内容
:4,18s/^/要添加的内容
```

#### 6. 批量在每行行尾添加相同的内容

```vim
:%s/$/要添加的内容  
```

#### 7. 批量删除每行开头的行号

```vim
:%s/^\s*[0-9]*\s*//gc
```

#### 8. 批量删除奇数行/偶数行

```vim
# 删除奇数行
%normal jkdd

# 删除偶数行
%normal jdd
```

#### 9. 其余常用命令

```vim
" 普通模式下
u " 撤销操作
CTRL-R " 反撤销
CTRL-G " 查看文件信息
```

#### 10. 折叠代码

```vim
zf10G " 折叠当前行到第10行的代码并设置折叠点
za " 打开折叠
zc " 收起折叠
```

 - [通过 `VIM` + `FreePic2Pdf` + `PdgCntEditor` 为 `PDF` 生成目录](http://www.codebelief.com/article/2018/01/generate-pdf-bookmark-entry-in-five-minutes/)
 - [VIM折叠代码](https://www.cnblogs.com/abeen/archive/2010/08/06/1794197.html)

#### 11. 分割窗口

- `:vs` 或者 `:vsplit`  将当前窗口竖直分割，并在上面新窗口中显示当前文件
- `:vs filename` 将当前窗口竖直分割，新文件在新窗口中显示
- `:sp` 或者 `:sv` 或者 `:split`  将当前窗口水平分割，并在左边新窗口中显示当前文件
- `:sp filename` 将当前窗口竖直分割，新文件在左边新窗口中显示
- `:new` 新建文件并竖直分割
- `:vnew` 新建文件并水平分割

分割窗口移动

- `Ctrl-w-j` 切换到下方的分割窗口
- `Ctrl-w-k` 切换到上方的分割窗口
- `Ctrl-w-l` 切换到右侧的分割窗口
- `Ctrl-w-h` 切换到左侧的分割窗口
- **`Ctrl-ww` 自动来回分割切换窗口**

#### 12. 一些会用到的小技巧

- `:e /mnt/d/xxx` 打开指定路径的文件夹/文件
- https://os.51cto.com/article/650915.html

#### 13. 插件管理 [vim-plug](https://github.com/junegunn/vim-plug)

```sh
curl -fLo ~/.vim/autoload/plug.vim --create-dirs     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

Reload .vimrc and :PlugInstall to install plugins.

Command	| Description
----|----
PlugInstall [name ...] [#threads] | Install plugins
PlugUpdate [name ...] [#threads] | Install or update plugins
PlugClean[!] | Remove unlisted plugins (bang version will clean without prompt)
PlugUpgrade	| Upgrade vim-plug itself
PlugStatus |Check the status of plugins
PlugDiff |Examine changes from the previous update and the pending changes
PlugSnapshot[!] [output path] |Generate script for restoring the current snapshot of the plugins


或直接执行下方 git 命令，自动拉取配置及插件（对齐线、树形目录）

```sh
git clone git@github.com:MinsonLee/vim.git ~/.vim --recurse-submodules --remote-submodules
```

NERDTree 快捷键

```
t   # 於新頁籤中呈現所選檔案
gt  # 切換至下一個頁籤
gT  # 切換至上一個頁籤
:q  # 關閉目前頁籤
Ctrl + ww  # 於目前頁籤中切換操作區塊
shift + i # 切换显示隐藏文件
```