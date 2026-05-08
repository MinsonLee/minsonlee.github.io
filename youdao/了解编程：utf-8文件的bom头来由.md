## 什么是BOM头

BOM头是放在UTF-8编码的文件的头部的三个字符（`0xEF` `0xBB` `0xBF`，即BOM）占用三个字节，用来标识该文件属于UTF-8编码。

现在已经有很多软件识别BOM头，但是还有些不能识别BOM头，比如PHP就不能识别BOM头，所以PHP编码规范PSR-4：“无BOM的UTF-8格式”，比如Navicat导入SQL文件执行SQL的时候也不能识别BOM，所以会报错。

同时这也是用Windows记事本编辑UTF-8编码后执行就会出错的原因了（Windows记事本生成文件自带BOM）。

## BOM头文件的产生

在windows环境下，用记事本打开任何一个文本文件，另存为utf-8格式后，这样文件就自动被加上了BOM头信息。
<br/>
比较：

utf-8（含BOM头）<br/>
![使用VIM打开UTF-8含BOM文件](https://images.cnblogs.com/cnblogs_com/lfire/201211/201211201411068371.png) 

utf-8（不含BOM头）<br/>
![使用VIM打开UTF-8无BOM编码文件](https://images.cnblogs.com/cnblogs_com/lfire/201211/201211201411073105.png)


从上图的比较中，可以很明显的看出，含BOM头的文件多出三个字节 efbbbf。

## BOM头信息的去除方法

用Notepad++打开文件，选择 格式 -> 以UTF-8无BOM格式编码，再保存就行。如下图：
![Notepad++去除BOM头](https://images.cnblogs.com/cnblogs_com/lfire/201211/201211201411079027.png)

在PHP类的项目中，自动处理BOM头信息（只需要将此文件放在项目根目录下，从浏览器访问即可）
```
<?php

if (isset($_GET['dir'])) { //设置文件目录   
    $basedir = $_GET['dir'];
} else {
    $basedir = '.';
}

checkdir($basedir);

/**
* 遍历目录
* @param string $basedir 基础目录
*/
function checkdir($basedir) {
    if ($dh = opendir($basedir)) {
        while (($file = readdir($dh)) !== false) {
            if ($file != '.' && $file != '..') {
                if (!is_dir($basedir . "/" . $file)) {
                    echo "filename: $basedir/$file " . checkBOM("$basedir/$file") . " <br>";
                } else {
                    $dirname = $basedir . "/" . $file;
                    checkdir($dirname);
                }
            }
        }
        closedir($dh);
    }
}

/**
* 检查BOM头
* @param string $filename 文件名
* @param int $auto 是否自动处理，默认自动处理
*/
function checkBOM($filename, $auto = 1) {
    $contents = file_get_contents($filename);
    $charset[1] = substr($contents, 0, 1);
    $charset[2] = substr($contents, 1, 1);
    $charset[3] = substr($contents, 2, 1);
    if (ord($charset[1]) == 239 && ord($charset[2]) == 187 && ord($charset[3]) == 191) {
        if ($auto == 1) {
            $rest = substr($contents, 3);
            rewrite($filename, $rest);
            return ("<font color=red>BOM found, automatically removed.  <a href=http://www.cnblogs.com/lfire/archive/2012/11/20/2778939.html>lfire博客</a></font>");
        } else {
            return ("<font color=red>BOM found.</font>");
        }
    }
    else
        return ("BOM Not Found.");
}

/**
* 重写文件
* @param string $filename 需要重写的文件
* @param mixed $data 要重写的数据
*/
function rewrite($filename, $data) {
    $filenum = fopen($filename, "w");
    flock($filenum, LOCK_EX);
    fwrite($filenum, $data);
    fclose($filenum);
}

?>
```
 
 ## 附录
 > 文章绝大部分转载于：博客园lfire的博文
 
 - [字符编解码的故事（ASCII，ANSI，Unicode，Utf-8区别）](https://www.cnblogs.com/wfwenchao/p/4795268.html)
 - [lfire的博客：UTF-8文件的BOM头来由](http://www.cnblogs.com/lfire/archive/2012/11/20/2778939.html)
 - [知乎-「带 BOM 的 UTF-8」和「无 BOM 的 UTF-8」有什么区别？网页代码一般使用哪个？](https://www.zhihu.com/question/20167122)