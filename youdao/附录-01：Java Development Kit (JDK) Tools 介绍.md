以下内容通过 **通义千问** 生成：

Java Development Kit (JDK)是Java编程语言的核心开发环境，包含了编译器、解释器、文档生成器等一系列重要工具，这些工具极大地支持了Java开发的各个环节。以下从功能、用户、基本用法和示例的角度详细介绍一些核心工具：

### 1. **javac**

**功能：** Java源代码编译器

**用户：** Java开发者

**基本用法：**

```bash
javac [options] [source files]
```

**示例：**

```bash
javac -d build src/com/example/Main.java
```

在此示例中，`javac`命令用于编译位于`src/com/example`目录下的`Main.java`源文件。`-d`选项指定了编译后的`.class`文件存放的目录为`build`。编译成功后，相应的字节码文件会被放置在对应的包结构下。

### 2. **java**

**功能：** Java应用程序启动器

**用户：** Java开发者、终端用户（运行已编译的Java程序）

**基本用法：**

```bash
java [options] class [arguments]
```

或

```bash
java [options] -jar jarfile [arguments]
```

**示例：**

```bash
java -cp build com.example.Main arg1 arg2
```

此示例中，`java`命令用于运行已编译的`com.example.Main`类，`-cp`选项指定了类路径（此处为`build`目录），`arg1`和`arg2`是传递给`Main`类的`main`方法的参数。

另一个示例：

```bash
java -jar myapplication.jar --config=config.txt
```

这里，`java`命令通过`-jar`选项运行名为`myapplication.jar`的Java归档文件（包含主类信息的清单文件），并传递`--config=config.txt`作为程序的命令行参数。

### 3. **javadoc**

**功能：** 文档生成器

**用户：** Java开发者、API使用者

**基本用法：**

```bash
javadoc [options] [packagenames] [sourcefiles] [@files]
```

**示例：**

```bash
javadoc -d doc -sourcepath src -subpackages com.example
```

在这个例子中，`javadoc`命令用于从`src`目录下`com.example`及其子包内的源代码生成API文档，并将生成的HTML文档保存在`doc`目录下。`-subpackages`选项指示javadoc处理指定包及其所有子包。

### 4. **javap**

**功能：** 类文件反汇编器

**用户：** Java开发者、逆向工程师、JVM研究者

**基本用法：**

```bash
javap [options] class [args...]
```

**示例：**

```bash
javap -c -private com.example.Main
```

这个示例中，`javap`命令使用`-c`选项显示`com.example.Main`类的字节码指令，`-private`选项则要求显示所有（包括私有）成员的字节码。这有助于开发者理解编译器生成的字节码以及JVM如何执行代码。

### 5. **jar**

**功能：** Java归档文件管理工具

**用户：** Java开发者、构建脚本作者

**基本用法：**

```bash
jar [options] [manifest-file] [input-files] [-C dir input-files] ...
```

**示例：**

```bash
jar -cvf myapp.jar -C build .
```

此例中，`jar`命令创建一个名为`myapp.jar`的新归档文件（`-cvf`选项），并使用`-C build .`将`build`目录下的所有文件（包括子目录）添加到归档中。这用于将编译好的类文件和相关资源打包成便于分发和运行的JAR文件。

### 6. **jps**

**功能：** Java进程状态查看器

**用户：** Java开发者、系统管理员

**基本用法：**

```bash
jps [options] [hostid]
```

**示例：**

```bash
jps -lvm
```

此示例中，`jps`命令使用`-lvm`选项列出本地机器上所有Java进程的详细信息，包括进程ID、主类全名（含包名）、JVM启动参数。

### 7. **jstack**

**功能：** Java线程堆栈跟踪工具

**用户：** Java开发者、性能分析师

**基本用法：**

```bash
jstack [options] <pid>
```

**示例：**

```bash
jstack 12345 > thread_dump.txt
```

在此示例中，`jstack`命令获取进程ID为12345的Java进程的线程堆栈信息，并将其重定向至`thread_dump.txt`文件。这有助于诊断多线程程序中的死锁、阻塞等问题。

### 8. **jvisualvm** 或 **jconsole**

**功能：** Java性能分析与监控工具（GUI界面）

**用户：** Java开发者、系统管理员、性能分析师

**基本用法：**

- 对于`jvisualvm`，直接启动`jvisualvm`应用程序。
- 对于`jconsole`，直接启动`jconsole`应用程序。

这两个工具提供图形化界面，用于监控Java进程的内存消耗、CPU使用、线程状态、类加载等信息，支持远程连接及采样分析，是深入分析Java应用程序性能的重要工具。

总结起来，JDK提供的核心工具覆盖了Java开发的全过程，包括源代码编译、程序运行、文档生成、字节码分析、归档打包、进程管理、线程诊断和性能监控等方面，为开发者提供了全方位的支持。