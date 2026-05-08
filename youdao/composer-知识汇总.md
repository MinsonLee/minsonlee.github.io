## 参考资料
- [Composer中文文档：https://docs.phpcomposer.com/](https://docs.phpcomposer.com/)

## 查看 composer 配置

```sh
composer config -gl
```

## 修改镜像地址，加速访问

- [Packagist / Composer 中国全量镜像](https://pkg.phpcomposer.com/)
- [Composer 阿里云](https://developer.aliyun.com/composer)
```sh
composer config -g repo.packagist composer https://packagist.phpcomposer.com
# http://admin:admin@10.4.133.206:8081/repository/erc-composer
```
解除镜像
```sh
composer config -g --unset repos.packagist
```

composer 升级

```sh
composer self-update --2|1(目前1、2两个主版本)
```

Failed to update xxx package information from this repository may be outdated

查看 composer 全局安装路径

```
composer global config bin-dir --absolute
```


## 兴趣点
1. 如何使用 composer 将自己写的 markdown 文件自动生成书籍？