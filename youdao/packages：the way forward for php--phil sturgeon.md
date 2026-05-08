# Packages：The Way Forward for PHP--Phil Sturgeon
# PHP 包管理演进之路 - (著)Phil Sturgeon
[TOC]

> 原文链接：https://phil.tech/2012/packages-the-way-forward-for-php/

## What is a package?
A package is a piece of reusable code that can be dropped into any application and be used without any tinkering to add functionality to that code. You don't need to know what is happening inside, only what the API for the class(es) are so that you can archive your goal. Maybe this package uses another package, that is called a dependency.

Most package systems also allow for something called dependencies. This will basically allow "Package A" to sit on top of "Package B". ==What is great about this is that== if I want to work on one chunk of code I can reuse another chunk. Instead of adding more code this can reduce the amount of extra code in your package, because "Package C" can sit on top of "Package B" too.

This is how most modern programming languages work, but to make a generalisation: PHP developers hate packages. Why? Well while other languages have great systems like CPAN for Perl, Gems for Ruby, PIP, PHP has had a terrible history with package management going back years.

## 什么是包?
包是一段**可复用**的代码块，它不需要在其原代码中做任何修改即可被其他应用所兼容调用。你不需要知道其内部逻辑到底做了什么处理，只需关注包所提供的 API 类即可帮助你实现目的。也许当前的包里面又使用了其他的包，这种包与包之间的调用关系称之为：依赖。

大部分包管理系统都是允许显示的去申明这些包依赖关系的，这样就可以允许`包 A`是基于`包 B`之上的(即：A 可以调用 B)。这样做的好处是：如果我想在一个代码块（包C）上工作，我需要调用另一个代码块（包B），与其书写重复的代码（包B），不如减少你的包中的额外代码量，因为 `包C`也可以放在 `包B` 之上。

这是大部分现代编程语言处理包管理的方式，但是笼统来讲：PHP 开发者不喜欢包！为什么呢？当其他编程语言已经拥有了非常好的包管理系统时，（如：`Perl 的 CPAN`、`Ruby 的 Gems`、`Node.JS 的 NPM`、`Python 的 Pip`等）PHP 仍用着可以追溯到多年前的糟糕的包管理系统。

> `包/接口` 的书写高度的体现及考验了一名开发程序员的**封装**意识：到底什么需要封装？封装到什么层度？封装的每一个方法、每一个类、每一层的职责是什么？既不粗制滥造-对重复的东西随意copy，破坏封装；又不会过度设计-明明只需要一个单车轮非设计了一套宇宙飞船级别的加速器，这都是非常考验一个人的编程思维和体现编程经验的！

## What about PEAR?
PHP has had a packaging system for years called PEAR. Let's get this understood right off the bat:

## `PEAR` 简述
下述带大家了解一下 `PHP` 曾使用多年的包管理系统-`PEAR`：

### PEAR sucks

To get code onto the main PEAR repository you need to get a certain number of up-votes, otherwise it will not be accepted. This was meant to ensure quality but has only helped to detur contributions and promote elitism.

Another knock-on effect is that you have to install pretty much any code you need to add a new repository, because so many people are using their own to avoid using the default repo. That makes it harder to search, harder to contribute and just generally more of a bitch to work with.

Of the packages already on on PEAR, most of them are massively out of date, inactive and no longer maintained, or never made it out of alpha. I have heard a few developers say "PEAR is awesome, they have a package for everything!" Maybe, but when I see that amongst a team of 4 developers, 2 are inactive and the code only got to 0.2.1 (alpha) in 2006-04-22, I am not full of hope for the stability of that codebase.

The nail in the coffin for me with PEAR is one of the biggest bug bears of the Gem system: system-wide installation. If I want to use a specific package, which requires a newer version of an already installed package, then I have to update it on my whole installation. That means an application I have not touched in weeks might break next time I try loading it on my local box. WAT?

### The community gave up on PEAR
With frameworks like Ruby on Rails doing a cracking job of helping developers get things done faster, PHP frameworks started springing up.

CodeIgniter set out in 2006 suggesting it was for developers who "are not interested in large-scale monolithic libraries like PEAR". Almost instantly people were hooked. They could make an entire application with the most useful libraries guaranteed to work with their code. Everything was versioned as one, released as one and had the same team.

In a time where nobody in the PHP community could decide on a standard, PHP frameworks would each adopts a coding standard. No matter what those standards were, at least they were the same in all the classes.

CodeIgniter was not the only framework around, with CakePHP and Symfony starting out at similar times. They all had the intention of helping developers build applications without the hassle of dependencies, so people got used to building everything with a framework.

### Let's all start building frameworks
Since late 2005 / early 2006 when these projects set out, hundreds of PHP frameworks have been developed by single developers, companies, community projects, everyone and their dog seems to have been involved with creating a PHP framework at some point or other, hell I've been involved in two: CodeIgniter and FuelPHP.

PHP frameworks themselves have taken some flak for building up all this new code, bundling in ORM's (I've always said ORM's should not be part of a framework), adding in their own DB abstraction layers, etc. Some see this as a barrier as to switch to a new framework means throwing out everything you know and starting again.

One problem with PHP frameworks is that when one framework doesn't do exactly what a developer wants, they either dump it and start building their own, or fork the existing one until there is no resemblance. This all or nothing approach is what has lead to our main problem: ** Reusable Code **.

Does a library written for Kohana work with CodeIgniter - which was at one point a CodeIgniter fork itself? Nope.

Does a package written for Symfony work with FuelPHP? Not even close!

### Stuff frameworks, let's go native
You wouldn't be the first to suggest it. As you know, creator of PHP Rasmus Lerdorf is all about procedural code and suggested years back that you write your own basic MVC architecture and not a full "framework".

Why do that? I have to build my own code that turns a URL into a loaded PHP file, I have to sort out a configuration system, handle "templates", do a million things that I could have done in seconds with a framework. Also, when I get another developer in I love just saying "this is CodeIgniter so you know whats going on" and not spend hours taking them through all my random code, which is probably different for each project.

The MVC wrappers were never the problem here, the problem was the lack of reusable code. Classes that developers can use to build their applications quickly. For years we Googled for PHP libraries and found them from places like SourceForge, PHP Classes, Google Code but this lead to a million different coding standards, no way to get notified about new versions and was generally just a shit way to manage code.

### Let's build an unframework!
This is a fun term that started sprining up with projects like Flourish and Spoon starting to build reusable components that you could drop into any application.

Thats idea is lovely and all but Flourish never made it out of BETA after years of development.

Spoon looks brilliant - mainly thanks to their shiny design - but is a one-man-army. How can we expect one guy to take care of all that code? It took a year for the developer to get from 1.2.0 to 1.3.0 which is not a speed of progress I am happy with.

Somebody is even working on a new unframework called Phrame which is only a splash page with a subscription box. Do we need more of these small-team solutions?

### So… what?
Packages were never the problem. The PHP community has coded itself round in circles for years without ever actually fixing the problem and we're back where we started.

We need a better packages system. PEAR2 happened, but it still just sucks.

Frameworks have been used to the idea that they were the solution to a problem - and they are. They are fixing a lot of problems but a problem all the frameworks have been trying to fix over the last year are - wait for it… packages!
  ● CodeIgniter has Sparks
  ● FuelPHP has Cells (website never went live)
  ● Laravel has Bundles
  ● CakePHP has The Bakery
  ● ZF2 just got Modules
Not even Zend are using PEAR? Funny that.

These framework specific packages - especially those with command line install / update utilities - are a breath of fresh air are and the communities are happy with the added functionality they can instantly put into their applications.

The downside is that the same code is being written over and over again for different frameworks, which is a massive waste of man-hours.

Let's take a personal example. I noticed recently that Laravel has a OAuth2 Bundle, which was forked from my CodeIgniter Spark. I converted that OAuth2 Spark from a FuelPHP Cell when I had a project that called for it.

### WHAT THE HELL?

The realisation hit me like kipper to the face. Why are we all sat around building out identical solutions to each other or forking and maintaining separate codebases when we could just be finishing projects?

I on average spend 70% of my working day on client projects and 30% building or fixing, writing or porting packages and libraries. That 30% could make me 30% richer, or give me 30% more time doing something more interesting than writing code. Maybe I could get around to writing an even BIGGER rant about something else?

Whatever it is we would end up doing with this extra time, we need to find a way to get there.

The PHP community needs to get together behind a new solution and the framework developers need to lead the charge.

### The Plan
Two very talented PHP developers (Nils Adermann and Jordi Boggiano) have been working on a PEAR-killer called Composer, which has a single default repository called Packagist. Composer is based on systems like npm (NodeJS Package Manager) and Bundler / RubyGems.

There is another solution called Phark but it's still unfinished and their syntax is horrid. Sorry guys but Phark just doesn't look any good to me - and the website linked from your GitHub repo is giving DNS errors. Moving on.

I am happy to see that Symfony are all over packages like a wet flannel. They have been helping out and a huge number of their packages are now using Composer - they've even been sending in pull requests.

Other well known developers like Ed Finkler and Chris Hartjes who record the /dev/null postcast are behind it too. Check the first episode for some of their reasoning. Ed has a bunch of code on Packagist and I'll be joining him with as much code as I can - such as my NinjAuth multi-provider user authentication system.

More than that I am really happy to say that after talking to the FuelPHP team they are all convinced this is the right way for FuelPHP to go. By removing the different between modules and packages, making pretty much everything into a package and fully supporting the PSR-0 standard of file and class naming, we become fully package based.

FuelPHP will still have Cells, but they will be a Composer package that uses a FuelPHP repository. That means our command line utility will be able to install FuelPHP specific code from the FuelPHP repo, and fall back to generic packages. We'll be amending our Autoloader in 2.0 to support Composer packages, and if there is no FuelPHP autoloader in there (which of course generic packages won't) then FuelPHP will just crack on and find the files, instead of being told where they are. Minor speed loss for full support of generic packages sounds reasonable to me!

Hopefully Laravel, Lithium and anyone developing a PHP 5.3 framework will see the light. Don't build out a new system, don't silo your users, don't waste time building code that already exists and for god's sake stop building un-frameworks.

### What Can You Do?
Got a good PHP class? Is it only on GitHub, or maybe it's just sitting around on your blog?

Stop that. Stop that right now. Make it into a Composer package and host it on Packagist. While you're at it add unit testing, set up Travis with a GitHub service hook and show off how stable it is.

This all makes it easier for anyone use your code, so anyone can contribute to it. The more we reuse the same packages, the more pull requests we can expect to see on that same code, which makes it more portable, more extensive, reduces bugs and means we can all spend a little more time working on that side-project that will eventually pay for us to get out of this coding lark, marry a fashion model and move to our private island for an early retirement.

Only half of that plan is far fetched, the other half you can do right now.