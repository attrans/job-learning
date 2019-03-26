应用的外壳
首先，使用 Angular CLI 来创建最初的应用程序。 在本教程中，你将修改并扩展这个入门级的应用程序，以创建出《英雄指南》应用。

在教程的这个部分，你将完成下列工作：

设置开发环境。

创建新的工作区，并初始化应用项目。

启动开发服务器。

修改此应用。

设置开发环境
要想设置开发环境，请按照快速上手 中的说明进行操作：

先决条件

安装 Angular CLI

注意：你不用做完整个快速上手。只要完成了上面这两个部分，你的环境就已经设置好了。然后继续下面的步骤来创建一个《英雄指南》的工作区和一个初始应用项目。

创建新的工作区和一个初始应用
Angular 的工作区就是你开发应用所在的上下文环境。一个工作区包含一个或多个项目所需的文件。 每个项目都是一组由应用、库或端到端（e2e）测试组成的文件集合。 在本教程中，你将创建一个新的工作区。

要想创建一个新的工作区和一个初始应用项目，需要：

确保你现在没有位于 Angular 工作区的文件夹中。例如，如果你之前已经创建过 "快速上手" 工作区，请回到其父目录中。

运行 CLI 命令 ng new，空间名请使用 angular-tour-of-heroes，如下所示：

content_copy
ng new angular-tour-of-heroes
ng new 命令会提示你输入要在初始应用项目中包含哪些特性，请按 Enter 或 Return 键接受其默认值。

Angular CLI 会安装必要的 Angular npm 包和其它依赖项。这可能需要几分钟。

它还会创建下列工作区和初始项目的文件：

新的工作区，其根目录名叫 angular-tour-of-heroes。

一个最初的骨架应用项目，同样叫做 angular-tour-of-heroes（位于 src 子目录下）。

一个端到端测试项目（位于 e2e 子目录下）。

相关的配置文件。

初始应用项目是一个简单的 "欢迎" 应用，随时可以运行它。

启动应用服务器
进入工作区目录，并启动这个应用。

content_copy
cd angular-tour-of-heroes
ng serve --open
ng serve 命令会构建本应用、启动开发服务器、监听源文件，并且当那些文件发生变化时重新构建本应用。

--open 标志会打开浏览器，并访问 http://localhost:4200/。

你会发现本应用正运行在浏览器中。

Angular 组件
你所看到的这个页面就是应用的外壳。 这个外壳是被一个名叫 AppComponent 的 Angular 组件控制的。

组件是 Angular 应用中的基本构造块。 它们在屏幕上显示数据，监听用户输入，并且根据这些输入执行相应的动作。

修改应用标题
用你最喜欢的编辑器或 IDE 打开这个项目，并访问 src/app 目录，来对这个起始应用做一些修改。

你会在这里看到 AppComponent 壳的三个实现文件：

app.component.ts— 组件的类代码，这是用 TypeScript 写的。

app.component.html— 组件的模板，这是用 HTML 写的。

app.component.css— 组件的私有 CSS 样式。

更改应用标题
打开组件的类文件 (app.component.ts)，并把 title 属性的值修改为 'Tour of Heroes' （英雄指南）。

app.component.ts (class title property)
content_copy
title = 'Tour of Heroes';
打开组件的模板文件 app.component.html 并清空 Angular CLI 自动生成的默认模板。改为下列 HTML 内容：

app.component.html (template)
content_copy
<h1>{{title}}</h1>
双花括号语法是 Angular 的插值绑定语法。 这个插值绑定的意思是把组件的 title 属性的值绑定到 HTML 中的 h1 标记中。

浏览器自动刷新，并且显示出了新的应用标题。

添加应用样式
大多数应用都会努力让整个应用保持一致的外观。 因此，CLI 会生成一个空白的 styles.css 文件。 你可以把全应用级别的样式放进去。

打开 src/styles.css 并把下列代码添加到此文件中。

src/styles.css (excerpt)
content_copy
/* Application-wide Styles */
h1 {
  color: #369;
  font-family: Arial, Helvetica, sans-serif;
  font-size: 250%;
}
h2, h3 {
  color: #444;
  font-family: Arial, Helvetica, sans-serif;
  font-weight: lighter;
}
body {
  margin: 2em;
}
body, input[type="text"], button {
  color: #888;
  font-family: Cambria, Georgia;
}
/* everywhere else */
* {
  font-family: Arial, Helvetica, sans-serif;
}
查看最终代码
本教程的源文件以及英雄指南的完整全局样式可以在 在线例子 / 下载范例 中看到。

下面是本页所提到的源代码：

src/app/app.component.ts
src/app/app.component.html
src/styles.css (excerpt)
content_copy
import { Component } from '@angular/core';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'Tour of Heroes';
}
小结
你使用 Angular CLI 创建了初始的应用结构。

你学会了使用 Angular 组件来显示数据。

你使用双花括号插值表达式显示了应用标题。
