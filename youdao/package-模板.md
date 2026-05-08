## Golang 模板

Go 语言提供了 html/template 包来支持模板渲染（服务端程序渲染可变部分，生成动态网页）。

当前基本都是前后端分离，该包做了解。https://pkg.go.dev/html/template

## 基本语法

1、变量

模板中的变量通过 `{{.}}`（管道、root） 进行访问，其代表当前变量，模板中使用 `{{/*comment*/}}` 来进行注释。

`struct` 和 `map[string]interface{}` 两种类型，常常被作为传入类型在模板中被使用。

假定有如下结构体：

```golang
type User struct {
    UserId int
    Username string
    Age uint
    Sex string
}
```

在模板内获取数据方式如下：

```golang
{{.}}、{{.Username}}、{{.UserId}}、{{.Age}}、{{.Age}}
```

假定有如下 map：

```golang
locals := make(map[string]interface{})
locals["filelist"] = filelist
locals["username"] = username
```

在模板内获取数据方式如下：

```golang
{{.}}、{{.filelist}}、{{.username}}
```

2、模板中定义变量

`{{$Hello := "Hello"}}` 这样在下方模板中即可调用 `{{$Hello}}`

3、逻辑判断

```golang
{{if .condition1}}
// code
{{else if .condition2}}
// code
{{end}}
```

| 内置语法 | 作用 |
| -------- | ---- |
| {{if not .condition}} <br/> {{end}} | not 非 |
| {{if and .condition1 .condition2}} <br/> {{end}} | and 与 |
| {{if or .condition1 .condition2}} <br/> {{end}} | or 或 |
| eq | 等于 |
| ne | 不等于 |
| lt | 小于 |
| le | 小于等于 |
| gt | 大于 |
| ge | 大于等于 |


4、遍历循环

```golang
{{range $index, $value := .slice}}
// {{$index}} {{$value}}
{{end}}
```

```golang
{{range .slice}}
// {{.}} // 表示当前的 $value
{{end}}
```

循环体内，访问外部变量使用 `{{$.}}` 来访问。

5、模板嵌套

`{{template "header.html"}}`

