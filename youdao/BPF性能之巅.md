- [Linux超能力BPF技术介绍及学习分享（技术创作101训练营）-腾讯云开发者社区-腾讯云](https://cloud.tencent.com/developer/article/1698426)
- [BPF和eBPF初探 | Sharlayan](https://forsworns.github.io/zh/blogs/20210311/)
- [技术|深入理解 BPF：一个阅读清单](https://linux.cn/article-9507-1.html)
- [eBPF系列学习（1）-什么是内核BPF、eBPF](https://blog.csdn.net/inthat/article/details/119872701)
- [BTF：实践指南 | 深入浅出 eBPF](https://www.ebpf.top/post/btf-bpf-type-format/)
- [Linux内核之旅：高效入门eBPF](http://kerneltravel.net/blog/2021/ebpf_beginner/ebpf.pdf)
- [BPF之巅 (豆瓣)](https://book.douban.com/subject/35273652/)


--- 




BPF（`Berkeley Packet Filter` - 伯克利包过滤器，也有人说是 `BSD Packet Filter` 的缩写）最初是用于网络数据包过滤的技术。现在，它已经演变成一个高度灵活和高效的内核编程框架，允许用户空间应用程序在内核中注入小段代码（BPF 程序），以便执行各种类型的任务。

主要用途：

1. 数据包过滤和分析
2. 性能监控
3. 网络路由和防火墙规则
4. 安全增强
5. 系统内调用跟踪和日志记录

BPF 现在是 Linux 性能和可观测性工具（如 bcc, bpftrace）的基础，也是现代 Linux 容器和服务网格技术的关键组成部分。

它有两种主要类型：

1. cBPF（经典 BPF）
2. eBPF（扩展 BPF），功能更强大，更灵活。

BPF 允许安全、高效地在内核中执行预编译的指令，减少了系统调用的开销，提高了整体性能。

---

eBPF（扩展 Berkeley Packet Filter）是 BPF（Berkeley Packet Filter）的一个现代扩展。原始的 BPF 是为高效数据包过滤而设计的，主要用于 tcpdump 这样的网络监控工具。然而，eBPF 超越了仅仅用于网络数据包的过滤。

发展历史：

1. **1992**: 伯利克大学教授 `Steven McCanne` 和 `Van Jacobson` 写了一篇《The BSD Packet Filter: A New Architecture for User-level Packet Capture》论文 ，第一次提出了`BPF`技术，BPF 最初为网络数据包过滤而生。
  
2. **2014**: eBPF 引入 Linux Kernel 3.18。开始能用于多种用途，不仅仅是网络数据包过滤。

3. **2015-2016**: 工具集开始出现，如 BCC（BPF Compiler Collection），使得创建 eBPF 程序更容易。

4. **2017-2018**: 出现更多高级工具和库，例如 Cilium 用于网络安全，bpftrace 用于跟踪和监控。

5. **2019-现在**: Kubernetes、Istio 等现代云原生技术开始采用 eBPF，成为性能监控和网络安全的关键组件。

特点：

1. **高性能**: 由于运行在内核中，减少了用户空间和内核空间之间的切换开销。

2. **多用途**: 用于网络监控、系统调用跟踪、安全加固等。

3. **安全性**: eBPF 代码在执行前会被内核验证，确保不会导致内核崩溃。

4. **动态性**: 可以在系统运行时加载或卸载 eBPF 代码，无需重启。

eBPF 由于其高度的灵活性和性能优势，正在迅速成为 Linux 性能和安全工具的新标准。