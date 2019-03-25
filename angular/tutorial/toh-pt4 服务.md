服务
英雄指南的 HeroesComponent 目前获取和显示的都是模拟数据。

本节课的重构完成之后，HeroesComponent 变得更精简，并且聚焦于为它的视图提供支持。这也让它更容易使用模拟服务进行单元测试。

为什么需要服务  
***`组件不应该直接获取或保存数据，它们不应该了解是否在展示假数据。 它们应该聚焦于展示数据，而把数据访问的职责委托给某个服务。`***  

本节课，你将创建一个 HeroService，应用中的所有类都可以使用它来获取英雄列表。 不要使用 new 来创建此服务，而要依靠 Angular 的[依赖注入](https://angular.cn/guide/dependency-injection)机制把它注入到 HeroesComponent 的构造函数中。

服务是在多个“互相不知道”的类之间共享信息的好办法。 你将创建一个 MessageService，并且把它注入到两个地方：

HeroService 中，它会使用该服务发送消息。

MessagesComponent 中，它会显示其中的消息。

创建 HeroService
使用 Angular CLI 创建一个名叫 hero 的服务。

content_copy  
ng generate service hero  
~~ng g s service/hero~~  
~~ng generate service service/hero~~  
该命令会在 src/app/hero.service.ts 中生成 HeroService 类的骨架。 HeroService 类的代码如下：

src/app/hero.service.ts (new service)
content_copy
import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root',
})
export class HeroService {

  constructor() { }

}
@Injectable() 服务
注意，这个新的服务导入了 Angular 的 Injectable 符号，并且给这个服务类添加了 @Injectable() 装饰器。 它把这个类标记为依赖注入系统的参与者之一。HeroService 类将会提供一个可注入的服务，并且它还可以拥有自己的待注入的依赖。 目前它还没有依赖，但是很快就会有了。

@Injectable() 装饰器会接受该服务的元数据对象，就像 @Component() 对组件类的作用一样。

获取英雄数据
HeroService 可以从任何地方获取数据：Web 服务、本地存储（LocalStorage）或一个模拟的数据源。

从组件中移除数据访问逻辑，意味着将来任何时候你都可以改变目前的实现方式，而不用改动任何组件。 这些组件不需要了解该服务的内部实现。

这节课中的实现仍然会提供模拟的英雄列表。

导入 Hero 和 HEROES。

content_copy
import { Hero } from './hero';
import { HEROES } from './mock-heroes';
添加一个 getHeroes 方法，让它返回模拟的英雄列表。

content_copy
getHeroes(): Hero[] {
  return HEROES;
}  
~~方法名(参数名: 参数类型, 参数名: 参数类型, ...): 返回值类型？~~  ~~Typescript方法声明~~  
提供（provide） HeroService
在要求 Angular 把 HeroService 注入到 HeroesComponent 之前，你必须先把这个服务提供给依赖注入系统。稍后你就要这么做。 你可以通过注册提供商来做到这一点。提供商用来创建和交付服务，在这个例子中，它会对 HeroService 类进行实例化，以提供该服务。

现在，你需要确保 HeroService 已经作为该服务的提供商进行过注册。 你要用一个注入器注册它。注入器就是一个对象，负责在需要时选取和注入该提供商。

默认情况下，Angular CLI 命令 ng generate service 会通过给 @Injectable 装饰器添加元数据的形式，用根注入器将你的服务注册成为提供商。

如果你看看 HeroService 紧前面的 @Injectable() 语句定义，就会发现 providedIn 元数据的值是 'root'：

content_copy
@Injectable({
  providedIn: 'root',
})
当你在顶层提供该服务时，Angular 就会为 HeroService 创建一个单一的、共享的实例，并把它注入到任何想要它的类上。 在 @Injectable 元数据中注册该提供商，还能允许 Angular 通过移除那些完全没有用过的服务来进行优化。

要了解关于提供商的更多知识，参见[提供商部分](https://angular.cn/guide/providers)。 要了解关于注入器的更多知识，参见[依赖注入指南](https://angular.cn/guide/dependency-injection)。

现在 HeroService 已经准备好插入到 HeroesComponent 中了。

这是一个过渡性的代码范例，它将会允许你提供并使用 HeroService。此刻的代码和最终代码相差很大。

修改 HeroesComponent
打开 HeroesComponent 类文件。

删除 HEROES 的导入语句，因为你以后不会再用它了。 转而导入 HeroService。

src/app/heroes/heroes.component.ts (import HeroService)
content_copy
import { HeroService } from '../hero.service';
把 heroes 属性的定义改为一句简单的声明。

content_copy
heroes: Hero[];
注入 HeroService
往构造函数中添加一个私有的 heroService，其类型为 HeroService。

content_copy
constructor(private heroService: HeroService) { }
这个参数同时做了两件事：1. 声明了一个私有 heroService 属性，2. 把它标记为一个 ***HeroService 的注入点***。

当 Angular 创建 HeroesComponent 时，依赖注入系统就会***把这个 heroService 参数设置为 HeroService 的单例对象***。

添加 getHeroes()
创建一个函数，以从服务中获取这些英雄数据。

content_copy
getHeroes(): void {
  this.heroes = this.heroService.getHeroes();
}
在 ngOnInit 中调用它
你固然可以在构造函数中调用 getHeroes()，但那不是最佳实践。

让构造函数保持简单，只做初始化操作，比如把构造函数的参数赋值给属性。 构造函数不应该做任何事。 它当然不应该调用某个函数来向远端服务（比如真实的数据服务）发起 HTTP 请求。

而是选择在 ngOnInit 生命周期钩子中调用 getHeroes()，之后交由 Angular 处理，它会在构造出 HeroesComponent 的实例之后的某个合适的时机调用 ngOnInit。

content_copy
ngOnInit() {
  this.getHeroes();
}
查看运行效果
刷新浏览器，该应用仍运行的一如既往。 显示英雄列表，并且当你点击某个英雄的名字时显示出英雄详情视图。  
~~数据流向: ~~  

可观察（Observable）的数据
HeroService.getHeroes() 的函数签名是同步的，它所隐含的假设是 HeroService 总是能同步获取英雄列表数据。 而 HeroesComponent 也同样假设能同步取到 getHeroes() 的结果。

content_copy
this.heroes = this.heroService.getHeroes();
这在真实的应用中几乎是不可能的。 现在能这么做，只是因为目前该服务返回的是模拟数据。 不过很快，该应用就要从远端服务器获取英雄数据了，而那天生就是异步操作。

HeroService 必须等服务器给出响应， 而 getHeroes() 不能立即返回英雄数据， 浏览器也不会在该服务等待期间停止响应。

HeroService.getHeroes() 必须具有某种形式的异步函数签名。

它可以使用回调函数，可以返回 Promise（承诺），也可以返回 Observable（可观察对象）。

这节课，HeroService.getHeroes() 将会返回 Observable，因为它最终会使用 Angular 的 HttpClient.get 方法来获取英雄数据，而 HttpClient.get() 会返回 Observable。

可观察对象版本的 HeroService
Observable 是 RxJS 库中的一个关键类。

在稍后的 HTTP 教程中，你就会知道 Angular HttpClient 的方法会返回 RxJS 的 Observable。 这节课，你将使用 RxJS 的 of() 函数来模拟从服务器返回数据。

打开 HeroService 文件，并从 RxJS 中导入 Observable 和 of 符号。

src/app/hero.service.ts (Observable imports)
content_copy
import { Observable, of } from 'rxjs';
把 getHeroes 方法改成这样：

content_copy
getHeroes(): Observable<Hero[]> {
  return of(HEROES);
}
of(HEROES) 会返回一个 Observable<Hero[]>，它会发出单个值，这个值就是这些模拟英雄的数组。

在 HTTP 教程中，你将会调用 HttpClient.get<Hero[]>() 它也同样返回一个 Observable<Hero[]>，它也会发出单个值，这个值就是来自 HTTP 响应体中的英雄数组。

在 HeroesComponent 中订阅
HeroService.getHeroes 方法之前返回一个 Hero[]， 现在它返回的是 Observable<Hero[]>。

你必须在 HeroesComponent 中也向本服务中的这种形式看齐。

找到 getHeroes 方法，并且把它替换为如下代码（和前一个版本对比显示）：

heroes.component.ts (Observable)
heroes.component.ts (Original)
content_copy
getHeroes(): void {
  this.heroService.getHeroes()
      .subscribe(heroes => this.heroes = heroes);
}
Observable.subscribe() 是关键的差异点。

上一个版本把英雄的数组赋值给了该组件的 heroes 属性。 这种赋值是同步的，这里包含的假设是服务器能立即返回英雄数组或者浏览器能在等待服务器响应时冻结界面。

当 HeroService 真的向远端服务器发起请求时，这种方式就行不通了。

新的版本等待 Observable 发出这个英雄数组，这可能立即发生，也可能会在几分钟之后。 然后，subscribe 函数把这个英雄数组传给这个回调函数，该函数把英雄数组赋值给组件的 heroes 属性。

使用这种异步方式，当 HeroService 从远端服务器获取英雄数据时，就可以工作了。

显示消息
在这一节，你将

添加一个 MessagesComponent，它在屏幕的底部显示应用中的消息。

创建一个可注入的、全应用级别的 MessageService，用于发送要显示的消息。

把 MessageService 注入到 HeroService 中。

当 HeroService 成功获取了英雄数据时显示一条消息。

创建 MessagesComponent
使用 CLI 创建 MessagesComponent。

content_copy
ng generate component messages
CLI 在 src/app/messages 中创建了组件文件，并且把 MessagesComponent 声明在了 AppModule 中。

修改 AppComponent 的模板来显示所生成的 MessagesComponent：

/src/app/app.component.html
content_copy
<h1>{{title}}</h1>
<app-heroes></app-heroes>
<app-messages></app-messages>
你可以在页面的底部看到来自的 MessagesComponent 的默认内容。

创建 MessageService
使用 CLI 在 src/app 中创建 MessageService。

content_copy
ng generate service message
打开 MessageService，并把它的内容改成这样：

/src/app/message.service.ts
content_copy
import { Injectable } from '@angular/core';
 
@Injectable({
  providedIn: 'root',
})
export class MessageService {
  messages: string[] = [];
 
  add(message: string) {
    this.messages.push(message);
  }
 
  clear() {
    this.messages = [];
  }
}
该服务对外暴露了它的 messages 缓存，以及两个方法：add() 方法往缓存中添加一条消息，clear() 方法用于清空缓存。

把它注入到 HeroService 中
重新打开 HeroService，并且导入 MessageService。

/src/app/hero.service.ts (import MessageService)
content_copy
import { MessageService } from './message.service';
修改这个构造函数，添加一个私有的 messageService 属性参数。 Angular 将会在创建 HeroService 时把 MessageService 的单例注入到这个属性中。

content_copy
constructor(private messageService: MessageService) { }
这是一个典型的“服务中的服务”场景： 你把 MessageService 注入到了 HeroService 中，而 HeroService 又被注入到了 HeroesComponent 中。

从 HeroService 中发送一条消息
修改 getHeroes 方法，在获取到英雄数组时发送一条消息。

content_copy
getHeroes(): Observable<Hero[]> {
  // TODO: send the message _after_ fetching the heroes
  this.messageService.add('HeroService: fetched heroes');
  return of(HEROES);
}
从 HeroService 中显示消息
MessagesComponent 可以显示所有消息， 包括当 HeroService 获取到英雄数据时发送的那条。

打开 MessagesComponent，并且导入 MessageService。

/src/app/messages/messages.component.ts (import MessageService)
content_copy
import { MessageService } from '../message.service';
修改构造函数，添加一个 public 的 messageService 属性。 Angular 将会在创建 MessagesComponent 的实例时 把 MessageService 的实例注入到这个属性中。

content_copy
constructor(public messageService: MessageService) {}
这个 messageService 属性必须是公共属性，因为你将会在模板中绑定到它。

Angular 只会绑定到组件的公共属性。

绑定到 MessageService
把 CLI 生成的 MessagesComponent 的模板改成这样：

src/app/messages/messages.component.html
content_copy
<div *ngIf="messageService.messages.length">

  <h2>Messages</h2>
  <button class="clear"
          (click)="messageService.clear()">clear</button>
  <div *ngFor='let message of messageService.messages'> {{message}} </div>

</div>
这个模板直接绑定到了组件的 messageService 属性上。

*ngIf 只有在有消息时才会显示消息区。

*ngFor 用来在一系列 <div> 元素中展示消息列表。

Angular 的事件绑定把按钮的 click 事件绑定到了 MessageService.clear()。

当你把 最终代码 某一页的内容添加到 messages.component.css 中时，这些消息会变得好看一些。

刷新浏览器，页面显示出了英雄列表。 滚动到底部，就会在消息区看到来自 HeroService 的消息。 点击“清空”按钮，消息区不见了。

查看最终代码
你的应用应该变成了这样 在线例子 / 下载范例。本页所提及的代码文件如下：

src/app/hero.service.ts
src/app/message.service.ts
src/app/heroes/heroes.component.ts
src/app/messages/messages.component.ts
src/app/messages/messages.component.html
src/app/messages/messages.component.css
src/app/app.module.ts
src/app/app.component.html
content_copy
import { Injectable } from '@angular/core';
 
import { Observable, of } from 'rxjs';
 
import { Hero } from './hero';
import { HEROES } from './mock-heroes';
import { MessageService } from './message.service';
 
@Injectable({
  providedIn: 'root',
})
export class HeroService {
 
  constructor(private messageService: MessageService) { }
 
  getHeroes(): Observable<Hero[]> {
    // TODO: send the message _after_ fetching the heroes
    this.messageService.add('HeroService: fetched heroes');
    return of(HEROES);
  }
}
小结
你把数据访问逻辑重构到了 HeroService 类中。

你在根注入器中把 HeroService 注册为该服务的提供商，以便在别处可以注入它。

你使用 Angular 依赖注入机制把它注入到了组件中。

你给 HeroService 中获取数据的方法提供了一个异步的函数签名。

你发现了 Observable 以及 RxJS 库。

你使用 RxJS 的 of() 方法返回了一个模拟英雄数据的可观察对象 (Observable<Hero[]>)。

在组件的 ngOnInit 生命周期钩子中调用 HeroService 方法，而不是构造函数中。

你创建了一个 MessageService，以便在类之间实现松耦合通讯。

HeroService 连同注入到它的服务 MessageService 一起，注入到了组件中。
