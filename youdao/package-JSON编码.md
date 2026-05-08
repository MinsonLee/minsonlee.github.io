## JSON

JSON（JavaScript Object Notation - JavaScript 对象表示法），一种轻量级的数据交换格式。

- 数据格式简单、易于读写、格式都是压缩的、占用带宽小
- 便于客户端的解析，JavaScript 可以轻松进行 JSON 数据的读取
- 支持当前主流的所有编程语言，便于服务端的解析

Go 语言中通过 [`encoding/json`](https://pkg.go.dev/encoding/json) 包进行 JSON 的解析与转换。

- `func Marshal(v interface{}) ([]byte, error)` 得到压缩后 JSON -便于传输
- `func MarshalIndent(v interface{}, "prve", "\t") ([]byte, error)` 返回格式化后 JSON 字符串-便于浏览
- `func Unmarshal(data []byte, v interface{}) error` 将 data 转化为 v，注意函数返回值为 error，因此 v 请传递指针


## JSON 序列化/反序列化

- 数据类型 转 JSON
    - 简单数据类型 ==> 依然是简单数据类型
        - 数字
            - int8、int16、int32、int64、int
            - uint8、uint16、uint32、uint64、uint、uintptr(4或8字节，取决于平台-用于存放一个指针)
            - float32(`1.4*10^-45 `-`3.4*10^38`)、float64(`4.9*10^-324`-`1.8*10^108`)
        - 字符
            - byte(uint8)、rune(int32)
            - string
        - 布尔类型-bool
    - 复合数据类型
        - 数组-array ==> 数组 [xxx, xxxx]
        - 切片-slice ==> 数组 [xxx, xxxx]
        - 集合-map  ==> 对象 {"key": "value"}
        - 指针-pointer ==> 输出指针指向的内容，空指针会输出 null
        - 结构体-struct ==> 对象 {"key": "value"}
        - 接口-interface ==> 依赖结构体实现，单纯接口无法调用
        - 通道-channle ==> 无法转 JSON
        - 函数-func ==> 无法转 JSON：`json: unsupported type: func()`

```golang
package main

import (
    "encoding/json"
    "fmt"
)

type ErrorLever struct {
    Lever []string
    Message []string
}

type Say interface {
    Say() string
}
type User struct {
    Name string `json:"姓名"` // 字段标签：通过`json:"key"`方式改变 JSON 解析规则
    Age uint8 `json:"年龄"` // 注意 `json:"` 之间不能有空格
    Sex uint8 `json:"-"` // `json:"-"` 表示不解析该字段
    Address string
}
func (u User) Say()  {
    fmt.Println("My Name Is：", u.Name)
}

type Point struct {
    X,Y int
}
type Circle struct {
    Point
    Radius int
}

func main() {
    // map 转 JSON
    m := map[string][]string {
        "lever": {"debug"},
        "message": {"File not found", "Stack overflow"},
    }
    mint := map[int]string {
        1 : "Golang",
        2 : "PHP",
    }
    mint[4] = "Java"
    ToJson(m) // {"lever":["debug"],"message":["File not found","Stack overflow"]}
    ToJson(mint) // {"1":"Golang","2":"PHP","4":"Java"}

    // 结构体转JSON
    s := ErrorLever{[]string{"debug"},[]string{"File not found", "Stack overflow"}}
    ToJson(s) // {"Lever":["debug"],"Message":["File not found","Stack overflow"]}

    // 结构体转 JSON 是通过反射机制来实现编码的，因此只有可访问的结构体字段才能被导出解析
    s1 := struct {
        name string // 小写：表示只有当前包自己才能访问
        age uint8
    }{"lms", 3}
    ToJson(s1) // {}

    // 字段标签：通过`json:"key"`方式改变 JSON 解析规则
    // 注意 `json:"` 之间不能有空格
    // `json:"-"` 表示不解析该字段
    s2 := User{"lms", 26, 0, "广东-广州"}
    ToJson(s2) // {"姓名":"lms","年龄":26,"Address":"广东-广州"}
    s2.Say() // My Name Is： lms

    // 匿名字段转JSON
    ToJson(Circle{Radius: 25, Point:Point{50, 50}}) // {"X":50,"Y":50,"Radius":25}

    // 数组、切片转JSON
    arr := [3]int{1,2,3}
    ToJson(arr) // [1,2,3]
    slice1 := []string{"hello", "golang"}
    ToJson(slice1) // ["hello","golang"]

    // 指针转JSON：输出指针指向的内容，空指针会输出 null
    var ip *[3]int // *<T> *用于声明指定一个变量是一个指针变量
    var nullPoint *[3]int
    ip = &arr // &-取地址符：用于获取一个普通变量；*<p>-获取一个指针变量对应
    ToJson(ip) // [1,2,3]
    returnData := ToJson(nullPoint) // null
    fmt.Printf("returnData Type：%T，value：%v\n", returnData, returnData) // returnData Type：[]uint8，value：[110 117 108 108]

    // 基本类型转 JSON
    a := 1
    returnData1 := ToJson(a) // 1
    fmt.Printf("returnData1 Type：%T，value：%v\n", returnData1, returnData1) // returnData1 Type：[]uint8，value：[49]

    var b byte = 'a'
    returnData2 := ToJson(b) // 97
    fmt.Printf("returnData2 Type：%T，value：%v\n", returnData2, returnData2) // returnData2 Type：[]uint8，value：[57 55]

    var c rune = '中'
    returnData3 := ToJson(c) // 20013
    fmt.Printf("returnData3 Type：%T，value：%v\n", returnData3, returnData3) // returnData3 Type：[]uint8，value：[50 48 48 49 51]

    var d bool = true
    returnData4 := ToJson(d) // true
    fmt.Printf("returnData4 Type：%T，value：%v\n", returnData4, returnData4) // returnData4 Type：[]uint8，value：[116 114 117 101]

    var e string = "中国"
    returnData5 := ToJson(e) // "中国"
    fmt.Printf("returnData5 Type：%T，value：%v\n", returnData5, returnData5) // returnData5 Type：[]uint8，value：[34 228 184 173 229 155 189 34]

    // Function：json: unsupported type: func()
    ToJson(Demo)
    
    // JSON --> 结构体
    var s1 ErrorLever
    json.Unmarshal([]byte(`{"message":["File not found","Stack overflow"],"lever":["debug"]}`), &s1)
    fmt.Println(s1)
    fmt.Println(s1.Lever) // [debug] ==> 反序列化时不区分大小写

}

func ToJson(v interface{}) (data []byte) {

    data, err := json.Marshal(v)
    if err == nil {
        fmt.Printf("\nv 的type是：%T \ndata的type是：%T \ndata的len是：%v \n%s\n", v, data, len(data), data)
    } else {
        fmt.Println(err)
    }
    
    return
}

func Demo()  {
    fmt.Println("demo function")
}
```

json 反序列化规则

JSON 类型 | Go 类型
--------| ------
boolean | bool
number | float64
string | string
数组 | []interface{}
object | map
null | nil

**注意**
- json 包是通过反射机制来实现 JSON 的序列化和反序列化，因此JSON与结构体的相互转换都基于“可访问字段”
- json 包反序列化时，不区分大小写
