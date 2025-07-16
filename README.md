# MinsonLee

本博客使用`leopard`的博客模板,以下为该模板简介

> [leopard](https://github.com/leopardpan/leopardpan.github.io) 是一个简洁的博客模板，如果你也喜欢请 Star ，你的 Star 是我持续更新的动力, 谢谢 😄.

### 使用手册

[Jekyll搭建个人博客](https://leopardpan.github.io/2016/10/jekyll_tutorials1/)  :  使用Jekyll搭建个人博客的教程，以及如果把博客模板修改成你自己的博客，里面也有大量的评论，及 Jekyll 搭建博客出现过的问题。


### 使用条件

Jekyll 支持 Mac 、Windows、ubuntu 、Linux 操作系统                     
Jekyll 需要依赖：Ruby、bundler


#### 安装Jekyll

[Jekyll中文官方文档](http://jekyll.bootcss.com/) ， 如果你已经安装过了 Jekyll，可以忽略此处。

> $ gem install jekyll

#### 获取博客模板

> $ git clone https://github.com/leopardpan/leopardpan.github.io.git

或者直接[下载博客](https://github.com/leopardpan/leopardpan.github.io/archive/master.zip)   

进leopardpan.github.io/ 目录下， 开启本地服务 

> $ jekyll server

在浏览器输入 [127.0.0.1:4000](127.0.0.1:4000) ， 就可以看到博客效果了。


### 提示

>* 如果你想使用我的模板，请把 _posts/ 目录下的文章都去掉。
>* 修改 _config.yml 文件里面的内容为你自己的个人信息。

如果在部署博客的时候发现问题，可以直接在[Issues](https://github.com/leopardpan/leopardpan.github.io/issues)里面提问。        


### 把这个博客变成你自己的博客

根据上面【提示】修改过后，在你的github里创建一个username.github.io的仓库，username指的值你的github的用户名。      
创建完成后，把我的这个模板使用git push到你的username.github.io仓库下就行了。
搭建博客如果遇到问题可以看看我教程[Jekyll搭建个人博客](https://leopardpan.github.io/2016/10/jekyll_tutorials1/)。


### 评论系统搭建

评论系统是参照 https://zzy979.github.io/posts/creating-personal-blog-site/ 通过 `GitHub Discussions + giscus` 完成的！个人觉得比较这个是比较简单的。

#### 感谢   

本博客在[Vno Jekyll](https://github.com/onevcat/vno-jekyll)基础上修改的。  