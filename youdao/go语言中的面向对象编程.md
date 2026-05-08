1、Go 是面向对象的语言吗？

- https://golang.org/doc/faq#Is_Go_an_object-oriented_language
- https://www.zhihu.com/question/315995798
- https://medium.com/gophersland/gopher-vs-object-oriented-golang-4fa62b88c701

2、什么是面向对象？

面向对象是一种编程思想，并不限制语言。

- https://www.zhihu.com/question/27468564/answer/757537214
- https://zhuanlan.zhihu.com/p/75265007
- https://www.zhihu.com/question/305042684/answer/550196442
- https://www.zhihu.com/question/32085928/answer/910539183
- https://zhuanlan.zhihu.com/p/332281685

「面向对象编程的精髓在于将操作绑定在数据上」

==> 更好的管理代码、代码复用、模块化开发

3、面向对象的优点

封装、继承、多态

4、Go语言面向对象
- “类”：结构体+方法。结构体提供了支持绑定数据和方法的行为
- 没有继承(自然就没有多态)、没有构造方法、没有析构方法等概念
- 曲线救国的方式：匿名字段-实现继承、接口实现多态、结构体+方法实现“类”


## 结构体

5、结构体：一系列相同类型或不相同类型的数据构成的**数据集合**

定义结构体：

```golang
type StructName struct {
    parmas1 Type1
    parmas2,parmas3 Type2
    ......
    parmasN TypeN
}
```

- Go 语言中，`type` 关键字是用于定义类型别名，用法：`type TypeAlias = Type`，如 `type byte uint8`
- type 关键字也可用于定义结构体：`type 类型名 struct{}`
- `StructNam`(类型名)是标识结构体唯一性的名称，在**同一个包中**不能重复
- **结构体的属性（也叫字段）-paramN，在结构体中必须唯一**
- 同类型的成员属性可以放在同一行（注意末尾没有分号，而是直接采用换行符进行分隔）。如：`name, email string`
- **结构体的定义只是一种内存布局的描述，只有当结构体实例化的时候，才会真正分配内存**
- **实例化结构体：根据结构体定义的格式，创建一份与格式一直的内存区域，每个结构体之间是完全独立的**
- **结构体是值类型**

实例化结构体：

- 通过 `var` 关键字实例化结构体：`var object StructName`；初始化方式为： `object.Param = value`
- 通过简短字面量方式实例化：`object := StructName{}`；初始化方式为： `object.Param = value`
- 通过字面量“Key:Value”方式实例化并初始化结构体：`object := StructName{ Param1:value1, Param2:value2 }`
    - 【如果在初始化时没有写`Param`-属性名，表示按声明时属性顺序进行初始化顺序】
    - **通过该种方式初始化结构体时候 `}` 不能单独成一行**
- 通过 new 函数方式实例化：`objectPtr = new(StructName)`；初始化方式为：`(*objectPtr).Param = value`。**通过`new()`方式实例化结构体返回的是该结构体对象的指针（指针结构体）**

new() 是用于创建某个类型的指针，返回的值是指向该类型新分配的零值的指针。（调用了 new 函数，内存会开辟一块指定类型的空间，该空间的存放的是指定类型的零值，该指针地址会作为 new 函数返回值返回）。

结构体原本是值类型，但是使用 new 函数初始化得到的是一个“指针结构体”，而指针是引用类型

6、结构体的深拷贝、浅拷贝

就“面向对象的编程语言”中所指的对象，其对象是“引用类型”的。但**在 Go 中的结构体是值类型**。

**值类型是深拷贝（为新的变量或对象分配一个独立的新内存空间）。引用类型是浅拷贝（只是开辟了一个空间，复制了该变量或对象的指针）**==>为什么传递函数参数使用切片比数组更好，且使用起来几乎没有性能开销？为什么 unsafe.Sizeof(切片) 永远是 24？

```php
<?php
class A {
    public $b;
}

$testA = new A();

function test(A $obj) {
    $obj->b = 'hhhh'; 
}

test($testA);

echo $testA->b; // 此时输出的是：hhhh
```

```golang
package main

import "fmt"

type A struct {
    b string
}

func test(obj A) {
    obj.b = "hhhh"
    fmt.Printf("%T %v", obj, obj)
}

function main() {
    testA := A{}
    test(testA)
    fmt.Printf("%T %v", testA, testA)
}
```

Go 中结构体默认的赋值就是深拷贝。要实现结构体的浅拷贝：
- 直接复制指针地址 `struct2 := &struct1`
- 通过 new() 函数实例化结构体，得到一个指针结构体（指针是“引用”类型）：`struct1 := new(Struct)`


结构体作为函数的参数及返回值：结构体默认是值类型，深拷贝。

7、匿名结构体

匿名结构体即：不通过 type 关键字定义就直接使用的结构体（没有 StructName），匿名结构体需要在创建结构体时同时创建对象。

```golang
变量名 := struct {
    parmas1 Type1
    parmas2 Type2
} {
    [parmas1:] value1,
    [parmas2:] value2
}
```

如

```golang
student := struct {
    name string,
    sex string
} {"小明", "男"}
```

8、结构体的匿名字段

匿名字段即：在结构体中没有具体字段/属性名，只包含了一个字段名的类型，而这些字段被称为“匿名字段”。
- **匿名字段，默认使用字段类型名称作为字段名**（也就是说，其实还是有名称的...）
- 根据**结构体的属性（也叫字段）-paramN，在结构体中必须唯一**，因此：**同一个类型的匿名字段只能有且仅有一个**

```golang
type Student struct {
    string
    int8
}

user := Student{"小明", 18}
fmt.Printf("姓名：%s \t 年龄：%d", user.string, user.int8)
```

结构体的匿名字段常常用于：**结构体嵌套结构体中，用匿名字段模拟继承关系**。


9、结构体嵌套：将一个结构体作为另一个结构体的属性

结构体的嵌套可用“**模拟**”面向对象编程中的两种关系：
- 聚合关系：整体与部分的关系（一个类作为另一个类的属性）
- 泛华关系(继承关系)：一般与特殊的关系，指定了子类如何特殊化父类的所有特征和行为。（子类和父类的关系）

聚合关系：

![image](578F12081D4E4D5BA573357DA7BA36FE)

```golang
type Engine struct {
    type string
    fuel string
}

type Tire struct {
    AreaOfProduction string
}

type Car struct {
    carName string
    engine *Engine
    tire *Tire
}
```

泛华关系：

![image](AB104185802C40E292E1091CEDC0FE79)

**注意：结构体嵌套时，可能存在相同成员名导致调用时发生成员名字冲突(Ambiguours reference)。需要在调用时加上各自的结构体名称**

```golang
type A struct {
    a, b int
}

type B struct {
    a, c int
}

type C struct {
    A
    B
}

type D struct {
    A
    B
    d int
}

func main() {
    c := C{A{a: 1, b: 2}, B{a: 3, c: 4}}
    fmt.Println(c.b) // 2
    fmt.Println(c.A.b) // 2
    fmt.Println(c.A.a) // 1
    fmt.Println(c.B.a) // 3
    
    // 匿名字段：默认使用字段类型名称作为字段名
    d := D{A{a: 1, b: 2}, B{a: 3, c: 4}, 5} // 注意：`A{a: 1, b: 2}` 整体属于 value，不包含属性名
    e := D{A:A{a: 1, b: 2}, B:B{a: 3, c: 4}, d:5} //  属于 “Key:Value” 方式初始化
    fmt.Println(d)
    fmt.Println(e)
    
    // 两种初始化方式混合会报错：mixture of field:value and value initializers
    // f := D{A{a: 1, b: 2}, B{a: 3, c: 4}, d:5} 
    // fmt.Println(f)
}
```

## 方法和函数

- 函数(function)：一段具有独立功能的代码段，可以反复调用
- 方法（method）：一个类的行为功能，只有该类的对象才能调用
- 方法的本质也是函数（方法是一种作用于特定类型变量的函数）方法有接受者，而函数没有接受者（即：面向对象中的 this 或 self 关键字）
- 函数不可以重名，方法只要接受者不同，那么方法是可以重名的（此处接受者的作用相当于“作用域”）
- Go 语言中，接受者可以是结构体，也可以是任意其他类型

```golang
// 函数
func 函数名(参数名...类型) [(返回值列表)] {
    // code
}
// 函数调用
函数名()

// 方法
func (接受者变量 接受者类型) 方法名(参数名...类型) [(返回值列表)] {
    // code
}
// 方法调用
接受者对象.方法名()
```

- 官方建议接受者类型第一个首字母小写（小驼峰命名法-表示仅当前包可调用）

10、Go 中的“继承”：在面向对象编程中，有一条非常经典的设计原则，那就是：**组合优于继承，多用组合少用继承**。

事实上，[**Go 语言根本就不支持面向对象思想中的继承这一概念**](https://golang.org/doc/faq#Is_Go_an_object-oriented_language)。此处只是便于描述，所以使用“继承”来形容。

- https://blog.csdn.net/kingscoming/article/details/78836229
- https://kknews.cc/code/bmzzy8n.html
- https://blog.csdn.net/weixin_43935927/article/details/115877124
- https://www.cnblogs.com/appsucc/p/13117618.html

关于“继承”，维基百科中有这么一句：现今面向对象程序设计技巧中，继承并非以继承类别的“行为”为主，而是继承类别的“类型”，使得组件的类型一致。另外在设计模式中提到一个守则，“多用合成，少用继承”，此守则也是用来处理继承无法在运行期动态扩展行为的遗憾。

为什么“少用继承，多用组合”？
- 继承是 “is a” 的描述，而组合是 “has a” 的描述
- 若类之间的继承结构稳定（不会轻易改变==>软件编程中需求总是不稳定且变化的），继承层次比较浅（最多两层继承关系）且继承关系不复杂，那么可以使用继承

面向对象编程语言中的访问权限：

![image](7741D3DE5C7F49328F9DB13BD18FA3FB)

Go 中可见性规则（访问权限）：

- Go语言中没有像Java、PHP、C++这类面向对象编程语言一样的访问控制修饰符（private/protected/public）
- Go 中的访问权限只有两种：公有-所有包皆可访问、私有-只有本包可以访问
- Go 中通过**首字母大小写**来控制常量可见性：首字母大写-公有；首字母小写-私有


**模拟面向对象的“继承”与“重写”**

- GoLang：OOP(面向对象)？坑！:https://zhuanlan.zhihu.com/p/157786743



```golang
package main

import "fmt"

type Human struct {
    name,phone string
    age int
}

type Student struct {
    Human // 通过匿名字段方式-进行
    school string
}

type Employee struct {
    Human
    company,job string
}

func (h *Human) SayHi() {
    fmt.Printf("Hello, 我是 %s, 今年 %d, 联系方式是：%s \n", h.name, h.age, h.phone)
}

func (s *Student) SayHi() {
    fmt.Printf("Hello, 我是 %s, 今年 %d, 联系方式是：%s，在 %s 上学 \n", s.name, s.age, s.phone, s.school)
}

func (e *Employee) SayHi() {
    fmt.Printf("Hello, 我是 %s, 今年 %d, 联系方式是：%s，在 %s 担任 %s 一职 \n", e.name, e.age, e.phone, e.company, e.job)
}

func main() {
    student := Student{Human{"小明", "111", 18}, "巴拉巴拉高中"}
    employee := Employee{Human{"大明", "222", 23}, "巴拉巴拉高中", "教师"}

    student.SayHi()
    employee.SayHi()
}
```

## 接口

11、Go 中的接口

在面向对象编程语言中，接口用于定义对象的“行为”。即：指定对象“要”做什么行为，但具体行为的实现方式由对象自己来决定（通常使用 implements/extends 关键字来 ==**显示声明**== 实现接口，否则不管你是否在类中实现了接口规定的所有方法也不算是实现了接口）

Go 中，接口是一组方法签名。指定了类型应该具有的方法，类型决定如何实现这些方法。

```golang
// 定义接口
type 接口名 interface {
    方法1([参数列表]) [返回值列表]
    ......
    方法n([参数列表]) [返回值列表]
}

// 实现接口
func (接受者变量 接受者类型) 接口中的方法名([参数列表]) [返回值列表] {
    // code
}
...
```
==当类型为接口中的所有方法提供了具体实现细节，这个类型就被称为实现了接口==。**Go 语言中的类型都是隐式实现接口的**

==> “鸭子模型”（duck typing）：如果一只鸟走起来像鸭子，游泳像鸭子，叫起来也像鸭子，那么这只鸟就是一只鸭子。

==> ==**duck typing 关注的不是对象的类型本身，而是它是如何使用的。**==

==> Go 采取了如下做法

- 结构体不需要显示地声明它实现了接口，只要该结构体实现了接口中规定的所有的方法就自动的实现了接口。==> 能想动态类型语言一样剩下很多代码，少了很多限制
- 将结构体类型的变量显示或隐式地转换为接口类型的变量 ==> 可以和其他静态类型语言一样，在编译时检查参数的合法性


12、接口的作用：约束对象行为

面向对象编程语言（PHP）中的接口

```php
<?php
/**
 * @desc 接口：约束类的行为。不管对象是否一致，但可以交换使用，无需修改代码，就能切换不同的实现方式
 * - 数据库的访问使用 ==> 从 Oracle 切换到 MySQL（依然是连接数据库->CURD）
 * - 支付网关 ==> 银行卡支付切到支付宝、微信等支付方式（支付）
 * - 不同的缓存策略等 ==> 从 MC 切到 Redis（连接缓存服务）
 */
 interface Sky {
    public function fly();
 }
 
/**
* @desc 抽象类：代码复用 
*/

abstract class Animal {
    abstract public function getValue();
}

abstract class Bird extends Animal implements Sky {
    public function fly() {
        return $this->getValue() . '-鸟类-在天空飞翔';
    }
}

abstract class Plane implements Sky {
    abstract public function getCompany();
     
    public function fly() {
        return $this->getCompany() . '系列的飞机，在天空飞翔';
    }
}

/**
 * 具体类
 */
class Boyin extends Plane {
    public function getCompany() {
        return '波音';
    }
}

class Eagle extends Bird {
    public function getValue() {
        return '苍鹰';
    }
}

class Dog extends Animal {
    public function getValue() {
        return '狗';
    }
    
    public function Say() {
        return '汪汪汪';
    }
}

/**
 * 测试类
 */
class TestClass {
    // 1. 判断对象是否属于某个类：<obj> instanceof <Interface>
    public function Test1 ($obj) {
        if($obj instanceof Sky) {
            echo $obj->fly() . PHP_EOL;    
        }
        else {
            echo '什么玩意儿？不是会飞的东西' . PHP_EOL;
        }
    }

    // 2. 判断传入的参数对象是否属于接口：参数形式，若不是接口则异常
    public function Test2(Sky $sky) {
        echo $sky->fly() . PHP_EOL;  
    }
    
    public function Test3(Animal $animal) {
        echo $animal->getValue() . '是动物' . PHP_EOL;
    }
}

$eagle = new Eagle();
$boyin = new Boyin();
$dog = new Dog();

// 接口对象测试：不管对象是什么，只要是实现了 Sky 接口类即可  ==> 不care你是什么，只关注你能够做什么
$test = new TestClass();
$test->Test1($boyin);
$test->Test1($dog);
$test->test2($eagle);

// 类对象测试：不管你的行为有多不一样，只要是同“源”即可 ==> 不管你能干什么，只关心你是什么
$test->Test3($dog);
$test->Test3($eagle);
```

**==> Go 中如何判断实例是否为某个结构体的实例或子实例？**
```golang
func hasEmbedded(objType reflect.Type, classType reflect.Type)bool{
	if classType.Kind() == reflect.Ptr {
		classType = classType.Elem()
	}
	if objType.Kind()==reflect.Ptr{
		objType = objType.Elem()
	}

	for i := 0; i < objType.NumField(); i++{
		fieldType := objType.Field(i)
		if fieldType.Anonymous && (classType == fieldType.Type || hasEmbedded(fieldType.Type, classType)){
			return true
		}
	}
	return false
}


func InstanceOf(obj interface{},class interface{}) bool {
	if obj == nil || class == nil{
		return false
	}
	classType := reflect.TypeOf(class)
	objType := reflect.TypeOf(obj)

	if classType.Kind() == reflect.Ptr{
		classType = classType.Elem()
	}
	if objType.Kind() == reflect.Ptr{
		objType = objType.Elem()
	}

	if classType.Kind()==reflect.Interface{
		if objType.Kind()!=reflect.Interface{
			return reflect.PtrTo(objType).Implements(classType)
		}else{
			return objType.Implements(classType)
		}
	}else{
		return classType == objType || hasEmbedded(objType, classType)
	}
}
```

**==> Go 中如何判断实例是否实现了接口？**

1、Go 是强类型编译型语言，利用编译器编译时是否会报错：**`var _ 接口类型 = new(结构体)`**

==> 这是判断某个结构体是否已经完全实现了接口

```golang
type Sky interface {
	fly() string
}

type Dog struct {
	name string
}

func main()  {
    var _ Sky = new(Dog) 
}
```

![image](684B8774B2154D84A5B33733ACD7D4F2)

2、利用类型断言：判断具体实例是否实现了接口 `instance , ok := interfaceExamp.(interfaceType)`

- https://learnku.com/articles/44168

```golang
type Sky interface {
	fly() string
}

type Bird struct {
	name string
}
func (bird Bird) fly() string { // 隐式实现接口
	return bird.name + "-鸟类-在天空飞翔"
}

func main() {
    eagle := Bird{name: "苍鹰"}
    canFly(eagle)
}

func canFly(sky Sky)  {
	// 如何判断一个对象是否实现了接口？
	// if instance, ok := interface{}(sky).(Sky); ok { // 强制将 sky 转为 interface 类型
	if instance, ok := sky.(Sky); ok {
		fmt.Printf("%s\n",instance.fly())
	} else {
		fmt.Println("什么玩意儿？不是会飞的东西")
	}
}
```


13、“多态”：同一个**行为**具有多个**不同表现形式**或形态的能力。

- https://zh.wikipedia.org/wiki/%E5%A4%9A%E6%80%81_(%E8%AE%A1%E7%AE%97%E6%9C%BA%E7%A7%91%E5%AD%A6)

14、空接口-`interface{}`：
- 空接口中没有任何的方法
- **任意类型都实现了空接口，因此：==空接口可表示任意数据类型==**
- 空接口类似于 Java 中的 object、PHP 中的 StdClass

空接口应用场景：

- fmt.Println(interface{}) 该函数的参数就是空接口，因此可以接收任意类型参数进行打印
- 定义一个map：key和value都是任意类型 `make(map[interface{}]interface{})`
- 定义一个切片，其中存储任意类型的数据 `make([]interface{}, 0, 10)`


15、接口对象转型：

```golang
type Sky interface {
	fly() string
}

type Bird struct {
	name string
}
func (bird Bird) fly() string {
	return bird.name + "-鸟类-在天空飞翔"
}

func main() {
    eagle := Bird{name: "苍鹰"}
}

// 1、`instance , ok := 接口对象.(实际类型)`
// 该函数只接收实现了 Sky 接口的对象，否则会报错 `xx does not implement Sky (missing fly method)`
func canFly(sky Sky) {}


```

- `instance , ok := 接口对象.(实际类型)`
- `instance := 接口对象.(type)` ==> 必须配合 switch-case 使用： use of .(type) outside type switch





