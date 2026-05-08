# YAML 简记

[TOC]

[YAML](https://yaml.org/)  是 `YAML Ain't Markup Language™`（YAML 不是一种标记语言） 的递归缩写，它是一种对人类友好的数据序列化语言，适用于所有编程语言。
  
YAML 的语法很简单，可以简单的表达：对象、数组、标量等数据结构，常常用来作为配置文件。YAML 的配置文件后缀为 `*.yml` 或 `*.yaml`。（[原文：YAML 入门教程](https://www.runoob.com/w3cnote/yaml-intro.html)）

- 工具：[YAML 在线验证](https://verytoolz.com/yaml-validator.html)
- 工具：[YAML 在线验证](https://codebeautify.org/yaml-validator)
- 工具：[YAML 在线解析](https://verytoolz.com/yaml-parser.html)

## 基础语法

- 大小写敏感
- 通过空格缩进表示层级关系（类似：Python）
- 不允许 `Tab` 进行缩进，只允许空格（很多编辑器可配置了将 `Tab` 转为 `2/4` 个空格）
- 缩进层级的空格数不重要，只要相同层级的缩进空格数是一致（即：左对齐）即可
- `#` 表示注释，`:` 和 `-` 后方必须要加一个空格，`---` 表示文档分隔符
- 支持 `JSON` 的对象、数组语法

## 数据类型

- 对象（Object）：键值对的无序集合（Key-Value），又称为映射（Mapping）/哈希（Hash）/字典（Dictionary）
- 数组（Array）：一组按次序排列的值，又称为序列（sequence）/列表（List）
- 标量（Scalars）:单个、不可再分的值

### 对象

- 格式：`key: value`
- 注意点：冒号 `: `后面必须要加一个空格

**1、在同一行表示对象**

```yml
key: {key1: value1, key2: value2[, ...]}
```

**2、使用缩进表示层级关系**

```yml
key:
    key1: value1
    key2: value2
```

**3、复杂的对象格式**

```yml
?
    - key1
    - key2
:
    - value1
    - value2
```

即对象的属性是一个数组 `[key,key2]`，其值也是一个数组 `[value1,value2]`


### 数组

- 格式：以 `-` 开头的行表示构成一个数组

**1、在同一行表示对象**

```yaml
key: [value1, value2, ...]
```

**2、使用缩进表示数组**

```yaml
key:
    - value1
    - value2
```

**3、复杂的数组格式**

```yaml
key:
    - 
        id: 1
        name: xxx
    -
        id: 2
        name: xxx
```

```yaml
key: [{id: 1, name: xxx}, {id: 2, name: xxx}]
```


### 标量

可以理解为常量。其支持的数据格式有：字符串、布尔值、整数、浮点数、Null、时间、日期


```yml
boolean: 
    - TRUE  #true,True都可以
    - FALSE  #false，False都可以
float:
    - 3.14
    - 6.8523015e+5  #可以使用科学计数法
int:
    - 123
    - 0b1010_0111_0100_1010_1110    #二进制表示
null:
    nodeName: 'node'
    parent: ~  #使用~表示null
string:
    - 哈哈
    - 'Hello world'  #可以使用双引号或者单引号包裹特殊字符
    - newline
      newline2    #字符串可以拆成多行，每一行会被转化成一个空格
date:
    - 2018-02-17    #日期必须使用ISO 8601格式，即yyyy-MM-dd
datetime: 
    -  2018-02-17T15:02:31+08:00    #时间使用ISO 8601格式，时间和日期之间使用T连接，最后使用+代表时区
```

## 设置变量（&）与读取变量（*）

YAML 中的变量叫做“锚点”。

- `&` 用来建立锚点（defaults）
- `<<` 表示合并到当前数据（实验了一下，只对于对象有效）
- `*` 用来引用锚点

1、获取锚点的值

```yml
showell: &showell Steve

test:
  - Clark 
  - Brian 
  - Oren 
  - *showell 
```

转为 JSON 即：`{"test": ["Clark", "Brian", "Oren", "Steve"]}`

2、对象变量的使用（key 覆盖）

```yml
defaults: &defaults
  adapter:  postgres
  host:     localhost

development:
  host: development
  <<: *defaults
  database: myapp_development
```

转为 JSON 即

```json
{
    "development":{
        "host":"development",
        "adapter":"postgres",
        "database":"myapp_development"
    }
}
```

3、数组变量的使用

```yml
x-extra_hosts:
  &default-hosts-list
  - "www.qeeq.test:172.17.0.1"
  - "m.qeeq.test:172.17.0.1"
  
services:
  nginx:
    extra_hosts: *default-hosts-list
```

转成 JSON 即

```json
{
    "services":{
        "nginx":{
            "extra_hosts":[
                "www.qeeq.test:172.17.0.1",
                "m.qeeq.test:172.17.0.1"
            ]
        }
    }
}
```

## YAML vs JSON vs XML 该怎么选？

1、YAML 的缺点：

- YAML 发展相对年轻，很多应用已经使用 JSON/XML 进行构建配置了
- YAML 中有很多方式来体系化数据层级，因此处理时会相对复杂些。性能上相对于 XML/JSON 会有差别。
- 用缩进方式进行格式化，对于复杂的数据格式不够形象化


2、JSON 的缺点

- JSON 比较直白 “JavaScript Object Notation“( JS 对象标记)，部分开发语言对 JSON 的支持不够好，譬如：Java 对 JSON 数据的解析就挺麻烦，因此 Java 开发者更偏向于 XML

3、XML 的缺点

- 个人感觉书写格式是三者中最为复杂的


该怎么选择？
1. 使用的开发语言中是否已经存在对应的 解析器 开源包？
2. 如果没有：YAML > JSON > XML。当然同时需要考虑接收方语言的解析工具

## Linux YAML 读取工具 - yq

- 笔记见：- [MinsonLee 的有道云笔记：Linux 工具](https://note.youdao.com/ynoteshare/index.html?id=6c7049ccb2dd7eeb2cbb66af09f1ae31)