英雄编辑器
应用程序现在有了基本的标题。 接下来你要创建一个新的组件来显示英雄信息并且把这个组件放到应用程序的外壳里去。

创建英雄列表组件
使用 Angular CLI 创建一个名为 heroes 的新组件。

content_copy
ng generate component heroes
CLI 创建了一个新的文件夹 src/app/heroes/，并生成了 HeroesComponent 的三个文件。

HeroesComponent 的类文件如下：

app/heroes/heroes.component.ts (initial version)
content_copy
import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-heroes',
  templateUrl: './heroes.component.html',
  styleUrls: ['./heroes.component.css']
})
export class HeroesComponent implements OnInit {

  constructor() { }

  ngOnInit() {
  }

}
你要从 Angular 核心库中导入 Component 符号，并为组件类加上 @Component 装饰器。

@Component 是个装饰器函数，用于为该组件指定 Angular 所需的元数据。

CLI 自动生成了三个元数据属性：

selector— 组件的选择器（CSS 元素选择器）

templateUrl— 组件模板文件的位置。

styleUrls— 组件私有 CSS 样式表文件的位置。

CSS 元素选择器 app-heroes 用来在父组件的模板中匹配 HTML 元素的名称，以识别出该组件。

ngOnInit 是一个生命周期钩子，Angular 在创建完组件后很快就会调用 ngOnInit。这里是放置初始化逻辑的好地方。

始终要 export 这个组件类，以便在其它地方（比如 AppModule）导入它。

添加 hero 属性
往 HeroesComponent 中添加一个 hero 属性，用来表示一个名叫 “Windstorm” 的英雄。

heroes.component.ts (hero property)
content_copy
hero = 'Windstorm';
显示英雄
打开模板文件 heroes.component.html。删除 Angular CLI 自动生成的默认内容，改为到 hero 属性的数据绑定。

heroes.component.html
content_copy
{{hero}}
显示 HeroesComponent 视图
要显示 HeroesComponent 你必须把它加到壳组件 AppComponent 的模板中。

别忘了，app-heroes 就是 HeroesComponent 的 元素选择器。 所以，只要把 <app-heroes> 元素添加到 AppComponent 的模板文件中就可以了，就放在标题下方。

src/app/app.component.html
content_copy
<h1>{{title}}</h1>
<app-heroes></app-heroes>
如果 CLI 的 ng serve 命令仍在运行，浏览器就会自动刷新，并且同时显示出应用的标题和英雄的名字。

创建 Hero 类
真实的英雄当然不止一个名字。

在 src/app 文件夹中为 Hero 类创建一个文件，并添加 id 和 name 属性。

src/app/hero.ts
content_copy
export class Hero {
  id: number;
  name: string;
}
回到 HeroesComponent 类，并且导入这个 Hero 类。

把组件的 hero 属性的类型重构为 Hero。 然后以 1 为 id、以 “Windstorm” 为名字初始化它。

修改后的 HeroesComponent 类应该是这样的：

src/app/heroes/heroes.component.ts
content_copy
import { Component, OnInit } from '@angular/core';
import { Hero } from '../hero';

@Component({
  selector: 'app-heroes',
  templateUrl: './heroes.component.html',
  styleUrls: ['./heroes.component.css']
})
export class HeroesComponent implements OnInit {
  hero: Hero = {
    id: 1,
    name: 'Windstorm'
  };

  constructor() { }

  ngOnInit() {
  }

}
页面显示变得不正常了，因为你刚刚把 hero 从字符串改成了对象。

显示 hero 对象
修改模板中的绑定，以显示英雄的名字，并在详情中显示 id 和 name，就像这样：

heroes.component.html (HeroesComponent's template)
content_copy
<h2>{{hero.name}} Details</h2>
<div><span>id: </span>{{hero.id}}</div>
<div><span>name: </span>{{hero.name}}</div>
浏览器自动刷新，并显示这位英雄的信息。

使用 UppercasePipe 进行格式化
把 hero.name 的绑定修改成这样：

content_copy
<h2>{{hero.name | uppercase}} Details</h2>
浏览器刷新了。现在，英雄的名字显示成了大写字母。

绑定表达式中的 uppercase 位于管道操作符（ | ）的右边，用来调用内置管道 UppercasePipe。

管道 是格式化字符串、金额、日期和其它显示数据的好办法。 Angular 发布了一些内置管道，而且你还可以创建自己的管道。

编辑英雄名字
用户应该能在一个 <input> 输入框中编辑英雄的名字。

当用户输入时，这个输入框应该能同时显示和修改英雄的 name 属性。 也就是说，数据流从组件类流出到屏幕，并且从屏幕流回到组件类。

要想让这种数据流动自动化，就要在表单元素 <input> 和组件的 hero.name 属性之间建立双向数据绑定。

双向绑定
把模板中的英雄详情区重构成这样：

src/app/heroes/heroes.component.html (HeroesComponent's template)
content_copy
<div>
  <label>name:
    <input [(ngModel)]="hero.name" placeholder="name">
  </label>
</div>
[(ngModel)] 是 Angular 的双向数据绑定语法。

这里把 hero.name 属性绑定到了 HTML 的 textbox 元素上，以便数据流可以双向流动：从 hero.name 属性流动到 textbox，并且从 textbox 流回到 hero.name 。

缺少 FormsModule
注意，当你加上 [(ngModel)] 之后这个应用无法工作了。

打开浏览器的开发工具，就会在控制台中看到如下信息：

content_copy
Template parse errors:
Can't bind to 'ngModel' since it isn't a known property of 'input'.
虽然 ngModel 是一个有效的 Angular 指令，不过它在默认情况下是不可用的。

它属于一个可选模块 FormsModule，你必须自行添加此模块才能使用该指令。

AppModule
Angular 需要知道如何把应用程序的各个部分组合到一起，以及该应用需要哪些其它文件和库。 这些信息被称为元数据（metadata）。

有些元数据位于 @Component 装饰器中，你会把它加到组件类上。 另一些关键性的元数据位于 @NgModule 装饰器中。

最重要的 @NgModule 装饰器位于顶级类 AppModule 上。

Angular CLI 在创建项目的时候就在 src/app/app.module.ts 中生成了一个 AppModule 类。 这里也就是你要添加 FormsModule 的地方。

导入 FormsModule
打开 AppModule (app.module.ts) 并从 @angular/forms 库中导入 FormsModule 符号。

app.module.ts (FormsModule symbol import)
content_copy
import { FormsModule } from '@angular/forms'; // <-- NgModel lives here
然后把 FormsModule 添加到 @NgModule 元数据的 imports 数组中，这里是该应用所需外部模块的列表。

app.module.ts ( @NgModule imports)
content_copy
imports: [
  BrowserModule,
  FormsModule
],
刷新浏览器，应用又能正常工作了。你可以编辑英雄的名字，并且会看到这个改动立刻体现在这个输入框上方的 <h2> 中。

声明 HeroesComponent
每个组件都必须声明在（且只能声明在）一个 NgModule 中。

你没有声明过 HeroesComponent，可为什么本应用却正常呢？

这是因为 Angular CLI 在生成 HeroesComponent 组件的时候就自动把它加到了 AppModule 中。

打开 src/app/app.module.ts 你就会发现 HeroesComponent 已经在顶部导入过了。

content_copy
import { HeroesComponent } from './heroes/heroes.component';
HeroesComponent 也已经声明在了 @NgModule.declarations 数组中。

content_copy
declarations: [
  AppComponent,
  HeroesComponent
],
注意 AppModule 声明了应用中的所有组件，AppComponent 和 HeroesComponent。

查看最终代码
应用跑起来应该是这样的：在线例子 / 下载范例。本页中所提及的代码如下：

src/app/heroes/heroes.component.ts
src/app/heroes/heroes.component.html
src/app/app.module.ts
src/app/app.component.ts
src/app/app.component.html
src/app/hero.ts
content_copy
import { Component, OnInit } from '@angular/core';
import { Hero } from '../hero';
 
@Component({
  selector: 'app-heroes',
  templateUrl: './heroes.component.html',
  styleUrls: ['./heroes.component.css']
})
export class HeroesComponent implements OnInit {
  hero: Hero = {
    id: 1,
    name: 'Windstorm'
  };
 
  constructor() { }
 
  ngOnInit() {
  }
 
}
小结
你使用 CLI 创建了第二个组件 HeroesComponent。

你把 HeroesComponent 添加到了壳组件 AppComponent 中，以便显示它。

你使用 UppercasePipe 来格式化英雄的名字。

你用 ngModel 指令实现了双向数据绑定。

你知道了 AppModule。

你把 FormsModule 导入了 AppModule，以便 Angular 能识别并应用 ngModel 指令。

你知道了把组件声明到 AppModule 是很重要的，并认识到 CLI 会自动帮你声明它。
