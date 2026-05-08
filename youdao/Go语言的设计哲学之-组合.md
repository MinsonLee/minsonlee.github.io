OOP 语言的三大特性：封装、继承、多态！

```java
public class Main {
    // 接收一个 Animal 类型的对象
    // Java 中方法传递对象默认是引用传递的
    public static void show(Animal a)  {
        a.eat();
        
        // 类型判断：父类对象是不能调用子类方法
        if (a instanceof Cat)  {
            Cat c = (Cat)a; // 需要先将父类对象转为子类类型的对象
            c.work();
            //a.work(); // 错误：error: cannot find symbol
        } 
    }
    
    public static void main(String[] args) {
      Cat $cat = new Cat();
      show($cat);  // 以 Cat 对象调用 show 方法
                
      Animal a = $cat;  // 向上转型(可以直接隐式转换)：父类对象由子类实例化
      a.eat(); // 调用的是 Cat 的 eat
      
      Cat c = (Cat)a; // 向下转型：必须显示转换
      c.work();        // 调用的是 Cat 的 work
  }
}

class Animal {
    public void eat() {
        System.out.println("基类中的 eat 方法");
    }
}  
  
class Cat extends Animal {
    public void work() {
        System.out.println("Cat 类中的 work 方法");
    }
}
  
class Dog extends Animal {
    public void work() {
        System.out.println("Dog 类中的 work 方法");
    }
}
```

```php
<?php
// 基类
class SuperClass{
    public function superTest(SuperClass $obj) {
        if ($obj instanceof SuperClass) {
            echo "对象属于 SuperClass 的实例";
        } else {
            echo "对象不属于 SuperClass 的实例";
        }
    }
}

// 子类
class SubClass extends SuperClass {}

// 测试类
class TestClass {
    public function test() {
        $super = new SuperClass();
        $sub = new SubClass();
        $super->superTest($sub);
        
        //$test = new TestClass();
        //$sub->superTest($test);
    }
}

$obj = new TestClass();
$obj->test();
```

Go 中实现的「继承」与 OOP 语言中的「继承」是有本质区别的。Go 中通过 `type embedding` 方式实现的类似 「继承」 的访问方式，只是 Go 语言的一个语法糖。而 OOP 语言中的继承是可以「子类实例化父类对象」，即：隐式向上转换。

```golang
// 如何扩展系统内置或第三方类型？？？
// 方法1: 定义别名
// 就像 Go 源码一样：src/builtin/builtin.go:88 `type byte = uint8`


// 方法2: 使用组合
type company struct {
	companyName string
	companyAddress string
}

type staff struct {
	name string
	age int
	gender string
	position string
	company
}

type myStaff struct {
	staff
	benefits string
}

var mySt = myStaff{staff{
	"李小明",
	26,
	"male",
	"开发工程师",
	company{"AAA", "xxx"}}, "996福利"}
fmt.Printf("myStaff 类型：%v %s\n", mySt, mySt.companyName)

// myStaff 类型：{{李小明 26 male 开发工程师 {AAA xxx}} 996福利} Leaders

var st staff
st = mySt // 隐式转换(实际 Go 不支持类型隐式转换)，报错：cannot use mySt (type myStaff) as type staff in assignment
st = staff(mySt) // 显示转换，报错：cannot convert mySt (type myStaff) to type staff
fmt.Println("%v", st)
```


- https://segmentfault.com/a/1190000014700528 
- Java lambda 表达式：https://objcoding.com/2019/03/04/lambda/