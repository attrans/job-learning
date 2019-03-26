-------------------------
# constructor 与 ngOnInit
https://www.w3cschool.cn/angular/angular-2rh824o7.html

由 semlinker 创建， 最后一次修改 2017-06-06
查看新版Angular constructor vs ngOnInit

在 Angular 学习过程中，相信很多初学者对 constructor 和 ngOnInit 的应用场景和区别会存在困惑，本文我们会通过实际的例子，为读者一步步解开困惑。

constructor
在 ES6 中就引入了类，constructor(构造函数) 是类中的特殊方法，主要用来做初始化操作，在进行类实例化操作时，会被自动调用。马上来个例子：

class AppComponent {
  constructor(name) {
    console.log('Constructor initialization');
    this.name = name;
  }
}
let appCmp = new AppComponent('AppCmp');
console.log(appCmp.name); 
以上代码运行后，控制台的输出结果：

Constructor initialization
AppCmp
接下来我们看一下转换后的 ES5 代码：

var AppComponent = (function () {
    function AppComponent(name) {
        console.log('Constructor initialization');
        this.name = name;
    }
    return AppComponent;
}());
var appCmp = new AppComponent('AppCmp');
console.log(appCmp.name);
ngOnInit
ngOnInit 是 Angular 组件生命周期中的一个钩子，Angular 中的所有钩子和调用顺序如下：

ngOnChanges - 当数据绑定输入属性的值发生变化时调用
ngOnInit - 在第一次 ngOnChanges 后调用
ngDoCheck - 自定义的方法，用于检测和处理值的改变
ngAfterContentInit - 在组件内容初始化之后调用
ngAfterContentChecked - 组件每次检查内容时调用
ngAfterViewInit - 组件相应的视图初始化之后调用
ngAfterViewChecked - 组件每次检查视图时调用
ngOnDestroy - 指令销毁前调用
其中 ngOnInit 用于在 Angular 获取输入属性后初始化组件，该钩子方法会在第一次 ngOnChanges 之后被调用。

另外需要注意的是 ngOnInit 钩子只会被调用一次，我们来看一下具体示例：

import { Component, OnInit } from '@angular/core';
@Component({
  selector: 'my-app',
  template: `
    <h1>Welcome to Angular World</h1>
    <p>Hello {{name}}</p>
  `,
})
export class AppComponent implements OnInit {
  name: string = '';
  constructor() {
    console.log('Constructor initialization');
    this.name = 'Semlinker';
  }
  ngOnInit() {
    console.log('ngOnInit hook has been called');
  }
}
以上代码运行后，控制台的输出结果：

Constructor initialization
ngOnInit hook has been called
接下来我们再来看一个 父 - 子组件传参的例子：

parent.component.ts

import { Component } from '@angular/core';
@Component({
  selector: 'exe-parent',
  template: `
    <h1>Welcome to Angular World</h1>
    <p>Hello {{name}}</p>
    <exe-child [pname]="name"></exe-child>
  `,
})
export class ParentComponent {
  name: string = '';
  constructor() {
    this.name = 'Semlinker';
  }
}
child.component.ts

import { Component, Input, OnInit } from '@angular/core';
@Component({
    selector: 'exe-child',
    template: `
     <p>父组件的名称：{{pname}} </p>
    `
})
export class ChildComponent implements OnInit {
    @Input()
    pname: string; // 父组件的名称
    constructor() {
        console.log('ChildComponent constructor', this.pname); // Output：undefined
    }
    ngOnInit() {
        console.log('ChildComponent ngOnInit', this.pname);
    }
}
以上代码运行后，控制台的输出结果：

ChildComponent constructor undefined
ChildComponent ngOnInit Semlinker
我们发现在 ChildComponent 构造函数中，是无法获取输入属性的值，而在 ngOnInit 方法中，我们能正常获取输入属性的值。因为 ChildComponent 组件的构造函数会优先执行，当 ChildComponent 组件输入属性变化时会自动触发 ngOnChanges 钩子，然后在调用 ngOnInit 钩子方法，所以在 ngOnInit 方法内能获取到输入的属性。

constructor 应用场景
在 Angular 中，构造函数一般用于依赖注入或执行一些简单的初始化操作。

import { Component, ElementRef } from '@angular/core';
@Component({
  selector: 'my-app',
  template: `
    <h1>Welcome to Angular World</h1>
    <p>Hello {{name}}</p>
  `,
})
export class AppComponent {
  name: string = '';
  constructor(public elementRef: ElementRef) { // 使用构造注入的方式注入依赖对象
    this.name = 'Semlinker'; // 执行初始化操作
  }
}
ngOnInit 应用场景
在项目开发中我们要尽量保持构造函数简单明了，让它只执行简单的数据初始化操作，因此我们会把其他的初始化操作放在 ngOnInit 钩子中去执行。如在组件获取输入属性之后，需执行组件初始化操作等。

我有话说
在ES6 或 TypeScript 中的 Class 是不会自动提升的
因为当 class 使用 extends 关键字实现继承的时候，我们不能确保所继承父类的有效性，那么就可能导致一些无法预知的行为。具体可以参考 - Angular 2 Forward Reference 这篇文章。

TypeScrip 中 Class 静态属性和成员属性的区别
AppComponent.ts

class AppComponent {
  static type: string = 'component';
  name: string;
  constructor() {
    this.name = 'AppComponent';
  }
}
转化后的 ES5 代码：

var AppComponent = (function () {
    function AppComponent() {
        this.name = 'AppComponent';
    }
    return AppComponent;
}());
AppComponent.type = 'component';
通过转换后的代码，我们可以知道类中的静态属性是属于 AppComponent 构造函数的，而成员属性是属于 AppComponent 实例。

总结
在 Angular 中 constructor 一般用于依赖注入或执行简单的数据初始化操作，ngOnInit 钩子主要用于执行组件的其它初始化操作或获取组件输入的属性值。


-------------------------------------------------------------------------------------
 \*ngFor 复写器中使用 Angular 的插值表达式来把当前迭代的 hero.id 插入到每个 routerLink 中。
 
 -------------------------------------------------------------------------------------
 
 
