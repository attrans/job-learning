Angular4模板中数据显示（三）

简介
在开发过程中，我们需要从服务器获取到数据需要显示在html模板中，把大量的数据显示在界面中给用户展示，在原生js中，我们需要获取到元素然后通过设置属性来赋值。但是js操作dom存在着跨浏览器兼容的问题，以及频繁操作dom元素带来安全隐患。angular在显示数据给我们提供了数据绑定来帮助我们解决这一问题。

目录
angular插值表达式
angular属性绑定
angular中事件绑定
angular中双向数据绑定
angular中组件之间交互
注：

HTML是Angular模板的语言，基本所有的html元素都能被Angular所识别，但是值得注意的是<script>元素在angular中被禁用，原因是防止脚本注入攻击，含有安全漏洞的问题。

angular插值表达式
angular为我们提供了插值表达式来将组件中的值显示在模板中，该表达式属于组件->模板，使用插值表达式就把组件的属性名包裹在双花括号里放进视图模板，如 {{title}}。 
例子：

import { Component } from '@angular/core';
@Component({
  selector: 'app-root',
  template:`
    <h1>{{title}}</h1>
  `

})
export class AppComponent {

  title:string="插值表达式的例子";
  constructor() {

  }
}
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
注：模板中{{表达式}}括号里面是以表达式的形式存在，例如{{1+1}},模板中就会以<h1>2</h1> 的形式显示。如果以组件变量形式存在，该模板的{{title}}会去读取组件中title的值显示在页面中。

angular属性绑定
当要把模板中标签的属性设置为模板表达式时，最常用的就是把属性表达式设置为组件属性的值。 
例如：

import { Component } from '@angular/core';
@Component({
  selector: 'app-root',
  template:`
  <img [src]="imageUrl">
  `

})
export class AppComponent {

  imageUrl:string="./assets/hello.jpg";
  constructor() {

  }
}
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
属性绑定是将组件的数据流入到对应模板元素的属性中。不要忘了方括号，方括号告诉 Angular 要计算模板表达式。 如果忘了加方括号，Angular 会把这个表达式当做字符串常量看待，并用该字符串来初始化目标属性。 它不会计算这个字符串。属性绑定单向输入，不能使用属性绑定来从目标元素拉取值，也不能绑定到目标元素的属性来读取它。只能设置它。与插值表达式类似也是从组件->模板。 
那么我们用 <img src="{{imageUrl}}"> 是否可以使用，答案是肯定的，插值表达式也是从组件中的属性获取值显示在模板中。

那么： 
有了插值表达式为什么还需要属性绑定？？

在多数情况下，插值表达式是更方便的备选项。 实际上，在渲染视图之前，Angular 把这些插值表达式翻译成相应的属性绑定。 
当要渲染的数据类型是字符串时，没有技术上的理由证明哪种形式更好。 你倾向于可读性，所以倾向于插值表达式。 建议建立代码风格规则，选择一种形式， 这样，既遵循了规则，又能让手头的任务做起来更自然。 
但数据类型不是字符串时，就必须使用属性绑定了。

angular中事件绑定
用户在网页中交互当然存在着一系列相对应的事件，如：点击，输入，拖拽。。。。，这些交互相当于从模板中流向组件，也是单向属性，但是与属性绑定不一样的是模板->组件。 
例如：

import { Component } from '@angular/core';
@Component({
  selector: 'app-root',
  template:`
  <button (click)="onSave($event)">Save</button>
  `

})
export class AppComponent {

  constructor() {
  }
  onSave(event){
      console.log(event);
  }
}
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
事件绑定是已小括号中写入相对应的事件，然后等号右边写入对应的组件函数，当事件发生时，这个处理器会执行模板语句。 典型的模板语句通常涉及到响应事件执行动作的接收器，例如从 HTML 控件中取得值，并存入模型。然后去寻找组件中对应的函数。然后执行与服务器中的交互操作。绑定会通过名叫 $event 的事件对象传递关于此事件的信息（包括数据值）。 
我们打印event事件对象包含信息有： 
这里写图片描述

angular中双向数据绑定
属性绑定是从组件->模板，事件绑定是从模板->组件，那有没有两者结合起来可以相互进行交互的呢？答案是肯定的。angular为我们提供了双向数据绑定来解决程序只能单向流入的问题。 
注意：使用双向数据绑定的时候，我们需要在模块中添加FormsModule模块。如果不添加会报无法解析异常。

import { NgModule } from '@angular/core';
import { BrowserModule }  from '@angular/platform-browser';
import { FormsModule } from '@angular/forms'; // <--- 加入FormsModule模块

/* Other imports */

@NgModule({
  imports: [
    BrowserModule,
    FormsModule  // <--- import into the NgModule
  ],

})
export class AppModule { }
1
2
3
4
5
6
7
8
9
10
11
12
13
14
import { Component } from '@angular/core';
@Component({
  selector: 'app-root',
  template:`
  <input [(ngModel)]="title">
  {{title}}
  `

})
export class AppComponent {

  title:string="从组件从显示到模板中";

  constructor() {

  }

  onSave(event){
    console.log(event);
  }
}
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
当我们在input元素中输入任意值的时候，相对应title也会进行改变。

总结：

angular对于数据这块给我们提供太多便利，从中让我们的程序进行组件化，让组件与模板相互分离。

参考： 
[angular官网中数据结构](https://www.angular.cn/guide/template-syntax#ngmodel---two-way-binding-to-form-elements-with-span-classsyntaxngmodelspan)

转自： https://blog.csdn.net/xiajun2356033/article/details/79971692
