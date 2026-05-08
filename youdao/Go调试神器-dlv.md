`Delve` 是一个针对 Go 应用程序进行源码级别调试的工具。
- https://github.com/go-delve/delve

Delve 可以让你：交互式的控制应用程序的执行过程、变量评估（查看变量计算及其变化过程）、查看线程/协程状态信息、CPU寄存器状态等信息

该工具的目标是：为调试 Go 应用程序提供一个简单而强大的界面。

通过 `--` 标志传递调试参数，例如：`dlv exec ./hello -- server --config conf/config.toml`

## 用法

```sh
dlv [command]
```

## 可用命令

显示命令详细信息可以使用：`dlv <command> --help`

| 命令 | 备注 |
| ---- | ---- |
| attach | 调试一个正在运行的程序 `dlv attach pid [executable] [flags]` [阅读扩展：Dlv 深入探究](https://zhuanlan.zhihu.com/p/364346530) |
| connect | 连接到指定的无头调试服务 `dlv connect addr [flags]` |
| core | 检查 `core dump`，该命令只支持 `Linux/Windows`。`dlv core <executable> <core> [flags]` |
| dap |  `dlv dap [flags]` |
| debug | 编译并开始调试当前目录下的主包，或指定的包 |
| exec | 执行预编译的二进制文件，并开始调试会话 |
| help | 显示帮助信息 |
| ~~run~~ | ~~已经弃用，请使用 `dlv debug` 代替~~ |
| test | 编译测试二进制文件并开始调试程序 |
| trace | 编译并追踪程序 |
| version | 打印版本 |

## 可选参数

| 参数 | 备注 |
| ---- | ---- |
| --accept-multiclient | Allows a headless server to accept multiple client connections.  |
| --allow-non-terminal-interactive | Allows interactive sessions of Delve that don't have a terminal as stdin, stdout and stderr  |
| --api-version int | Selects API version when headless. New clients should use v2. Can be reset via RPCServer.SetApiVersion. See Documentation/api/json-rpc/ README.md. (default 1) |
| --backend string | Backend selection (see 'dlv help backend'). (default "default")  |
| --build-flags string | Build flags, to be passed to the compiler. For example: --build-flags="-tags=integration -mod=vendor -cover -v"  |
| --check-go-version | Checks that the version of Go in use is compatible with Delve. (default true)  |
| --disable-aslr | Disables address space randomization  |
| --headless | Run debug server only, in headless mode.  |
| --init string | Init file, executed by the terminal client.  |
| -l, --listen string | Debugging server listen address. (default "127.0.0.1:0")  |
| --log | Enable debugging server logging.  |
| --log-dest string | Writes logs to the specified file or file descriptor (see 'dlv help log').  |
| --log-output string | Comma separated list of components that should produce debug output (see 'dlv help log')  |
| --only-same-user | Only connections from the same user that started this instance of Delve are allowed to connect. (default true)  |
| -r, --redirect stringArray | Specifies redirect rules for target process (see 'dlv help redirect')  |
| --wd string | Working directory for running the program.  |
| ---- | ---- |
|--accept-multiclient | 允许无头服务器接受多个客户端连接 |
|--allow-non-terminal-interactive | 允许没有终端的 Delve 互动会话作为stdin、stdout 和 stderr |
|--api-version int | 选择无头时的API版本。新的客户端应该使用v2。可以通过RPCServer.SetApiVersion重置。请参阅文档/api/json-rpc/ README.md。(默认为1) |
| --后台字符串 | 后台选择(见'dlv help backend')。(默认为 "default") |
| --build-flags string | 构建标志，将被传递给编译器。例如： --build-flags="-tags=integration -mod=vendor -cover -v"  |
|--check-go-version | 检查所使用的Go版本是否与Delve兼容。(默认为true) |
| --disable-aslr | 禁用地址空间随机化 |
|--headless |只运行调试服务器，采用无头模式。 |
|-init string |初始文件，由终端客户端执行。 |
| -l, --listen string | 调试服务器监听地址。(默认为 "127.0.0.1:0") |
| --log | 启用调试服务器的日志记录。 |
| --log-dest string | 将日志写到指定的文件或文件描述符(见'dlv help log')。 |
| --log-output string | 以逗号分隔的应产生调试输出的组件列表(见'dlv help log') |
|--only-same-user | 只允许启动这个Delve实例的同一个用户的连接。(默认为true) |
| -r, --redirect stringArray | 为目标进程指定重定向规则(见'dlv help redirect') |
| --wd string | 运行程序的工作目录。 |

```txt
Flags:
      --accept-multiclient               Allows a headless server to accept multiple client connections.
      --allow-non-terminal-interactive   Allows interactive sessions of Delve that don't have a terminal as stdin, stdout and stderr
      --api-version int                  Selects API version when headless. New clients should use v2. Can be reset via RPCServer.SetApiVersion. See Documentation/api/json-rpc/README.md. (default 1)
      --backend string                   Backend selection (see 'dlv help backend'). (default "default")
      --build-flags string               Build flags, to be passed to the compiler. For example: --build-flags="-tags=integration -mod=vendor -cover -v"
      --check-go-version                 Checks that the version of Go in use is compatible with Delve. (default true)
      --disable-aslr                     Disables address space randomization
      --headless                         Run debug server only, in headless mode.
      --init string                      Init file, executed by the terminal client.
  -l, --listen string                    Debugging server listen address. (default "127.0.0.1:0")
      --log                              Enable debugging server logging.
      --log-dest string                  Writes logs to the specified file or file descriptor (see 'dlv help log').
      --log-output string                Comma separated list of components that should produce debug output (see 'dlv help log')
      --only-same-user                   Only connections from the same user that started this instance of Delve are allowed to connect. (default true)
  -r, --redirect stringArray             Specifies redirect rules for target process (see 'dlv help redirect')
      --wd string                        Working directory for running the program.

Additional help topics:
  dlv backend  Help about the --backend flag.
  dlv log      Help about logging flags.
  dlv redirect Help about file redirection.

Use "dlv [command] --help" for more information about a command.



--------------------

The following commands are available:

Running the program:
    call ------------------------ Resumes process, injecting a function call (EXPERIMENTAL!!!)
    continue (alias: c) --------- Run until breakpoint or program termination.
    next (alias: n) ------------- Step over to next source line.
    rebuild --------------------- Rebuild the target executable and restarts it. It does not work if the executable was not built by delve.
    restart (alias: r) ---------- Restart process.
    step (alias: s) ------------- Single step through program.
    step-instruction (alias: si)  Single step a single cpu instruction.
    stepout (alias: so) --------- Step out of the current function.

Manipulating breakpoints:
    break (alias: b) ------- Sets a breakpoint.
    breakpoints (alias: bp)  Print out info for active breakpoints.
    clear ------------------ Deletes breakpoint.
    clearall --------------- Deletes multiple breakpoints.
    condition (alias: cond)  Set breakpoint condition.
    on --------------------- Executes a command when a breakpoint is hit.
    toggle ----------------- Toggles on or off a breakpoint.
    trace (alias: t) ------- Set tracepoint.
    watch ------------------ Set watchpoint.

Viewing program variables and memory:
    args ----------------- Print function arguments.
    display -------------- Print value of an expression every time the program stops.
    examinemem (alias: x)  Examine memory:
    locals --------------- Print local variables.
    print (alias: p) ----- Evaluate an expression.
    regs ----------------- Print contents of CPU registers.
    set ------------------ Changes the value of a variable.
    vars ----------------- Print package variables.
    whatis --------------- Prints type of an expression.

Listing and switching between threads and goroutines:
    goroutine (alias: gr) -- Shows or changes current goroutine
    goroutines (alias: grs)  List program goroutines.
    thread (alias: tr) ----- Switch to the specified thread.
    threads ---------------- Print out info for every traced thread.

Viewing the call stack and selecting frames:
    deferred --------- Executes command in the context of a deferred call.
    down ------------- Move the current frame down.
    frame ------------ Set the current frame, or execute command on a different frame.
    stack (alias: bt)  Print stack trace.
    up --------------- Move the current frame up.

Other commands:
    config --------------------- Changes configuration parameters.
    disassemble (alias: disass)  Disassembler.
    dump ----------------------- Creates a core dump from the current process state
    edit (alias: ed) ----------- Open where you are in $DELVE_EDITOR or $EDITOR
    exit (alias: quit | q) ----- Exit the debugger.
    funcs ---------------------- Print list of functions.
    help (alias: h) ------------ Prints the help message.
    libraries ------------------ List loaded dynamic libraries
    list (alias: ls | l) ------- Show source code.
    source --------------------- Executes a file containing a list of delve commands
    sources -------------------- Print list of source files.
    types ---------------------- Print list of types

Type help followed by a command for full documentation.
```