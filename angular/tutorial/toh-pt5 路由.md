路由
有一些《英雄指南》的新需求：

添加一个仪表盘视图。

添加在英雄列表和仪表盘视图之间导航的能力。

无论在哪个视图中点击一个英雄，都会导航到该英雄的详情页。

在邮件中点击一个深链接，会直接打开一个特定英雄的详情视图。

完成时，用户就能像这样在应用中导航：

View navigations
添加 AppRoutingModule
在 Angular 中，最好在一个独立的顶级模块中加载和配置路由器，它专注于路由功能，然后由根模块 AppModule 导入它。

按照惯例，这个模块类的名字叫做 AppRoutingModule，并且位于 src/app 下的 app-routing.module.ts 文件中。

使用 CLI 生成它。

content_copy
ng generate module app-routing --flat --module=app
--flat 把这个文件放进了 src/app 中，而不是单独的目录中。
--module=app 告诉 CLI 把它注册到 AppModule 的 imports 数组中。

生成的文件是这样的：

src/app/app-routing.module.ts (generated)
content_copy
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

@NgModule({
  imports: [
    CommonModule
  ],
  declarations: []
})
export class AppRoutingModule { }
你通常不会在路由模块中声明组件，所以可以删除 @NgModule.declarations 并删除对 CommonModule 的引用。

你将会使用 RouterModule 中的 Routes 类来配置路由器，所以还要从 @angular/router 库中导入这两个符号。

添加一个 @NgModule.exports 数组，其中放上 RouterModule 。 ***导出 RouterModule 让路由器的相关指令可以在 AppModule 中的组件中使用***。

此刻的 AppRoutingModule 是这样的：

src/app/app-routing.module.ts (v1)
content_copy
import { NgModule }             from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

@NgModule({
  exports: [ RouterModule ]
})
export class AppRoutingModule {}
添加路由定义
路由定义 会告诉路由器，当用户点击某个链接或者在浏览器地址栏中输入某个 URL 时，要显示哪个视图。

典型的 Angular 路由（Route）有两个属性：

path：一个用于匹配浏览器地址栏中 URL 的字符串。

component：当导航到此路由时，路由器应该创建哪个组件。

如果你希望当 URL 为 localhost:4200/heroes 时，就导航到 HeroesComponent。

首先要导入 HeroesComponent，以便能在 Route 中引用它。 然后定义一个路由数组，其中的某个路由是指向这个组件的。

content_copy
import { HeroesComponent }      from './heroes/heroes.component';

const routes: Routes = [
  { path: 'heroes', component: HeroesComponent }
];
完成这些设置之后，路由器将会把 URL 匹配到 path: 'heroes'，并显示 HeroesComponent。

RouterModule.forRoot()
你必须首先初始化路由器，并让它开始监听浏览器中的地址变化。

把 RouterModule 添加到 @NgModule.imports 数组中，并用 routes 来配置它。你只要调用 imports 数组中的 RouterModule.forRoot() 函数就行了。

content_copy
imports: [ RouterModule.forRoot(routes) ],
这个方法之所以叫 forRoot()，是因为你要在应用的顶级配置这个路由器。 forRoot() 方法会提供路由所需的服务提供商和指令，还会基于浏览器的当前 URL 执行首次导航。

添加路由出口 （RouterOutlet）
打开 AppComponent 的模板，把 <app-heroes> 元素替换为 <router-outlet> 元素。

src/app/app.component.html (router-outlet)
content_copy
<h1>{{title}}</h1>
<router-outlet></router-outlet>
<app-messages></app-messages>  
***之所以移除\<app-heroes\>，是因为只有当用户导航到这里时，才需要显示 HeroesComponent。***   

***\<router-outlet\> 会告诉路由器要在哪里显示路由的视图。***   

能在 AppComponent 中使用 RouterOutlet，是因为 AppModule 导入了 AppRoutingModule，而 AppRoutingModule 中导出了 RouterModule。

试试看
你的 CLI 命令应该仍在运行吧。

content_copy
ng serve
浏览器应该刷新，并显示着应用的标题，但是没有显示英雄列表。

看看浏览器的地址栏。 URL 是以 / 结尾的。 而到 HeroesComponent 的路由路径是 /heroes。

在地址栏中把 /heroes 追加到 URL 后面。你应该能看到熟悉的主从结构的英雄显示界面。

添加路由链接 (routerLink)
不应该让用户只能把路由的 URL 粘贴到地址栏中。他们还应该能通过点击链接进行导航。

添加一个 <nav> 元素，并在其中放一个链接 <a> 元素，当点击它时，就会触发一个到 HeroesComponent 的导航。 修改过的 AppComponent 模板如下：

src/app/app.component.html (heroes RouterLink)
content_copy
<h1>{{title}}</h1>
<nav>
  <a routerLink="/heroes">Heroes</a>
</nav>
<router-outlet></router-outlet>
<app-messages></app-messages>
routerLink 属性的值为 "/heroes"，路由器会用它来匹配出指向 HeroesComponent 的路由。 ***routerLink 是 RouterLink 指令的选择器***，它会把用户的点击转换为路由器的导航操作。 它是 RouterModule 中的另一个公共指令。

刷新浏览器，显示出了应用的标题和指向英雄列表的链接，但并没有显示英雄列表。

点击这个链接。地址栏变成了 /heroes，并且显示出了英雄列表。

Click the link. The address bar updates to /heroes and the list of heroes appears.

从下面的 最终代码中把私有 CSS 样式添加到 app.component.css 中，可以让导航链接变得更好看一点。

添加仪表盘视图
当有多个视图时，路由会更有价值。不过目前还只有一个英雄列表视图。

使用 CLI 添加一个 DashboardComponent：

content_copy
ng generate component dashboard
CLI 生成了 DashboardComponent 的相关文件，并把它声明到 AppModule 中。

把这三个文件中的内容改成这样，并回来做一个随堂讨论：

src/app/dashboard/dashboard.component.html
src/app/dashboard/dashboard.component.ts
src/app/dashboard/dashboard.component.css
content_copy
<h3>Top Heroes</h3>
<div class="grid grid-pad">
  <a *ngFor="let hero of heroes" class="col-1-4">
    <div class="module hero">
      <h4>{{hero.name}}</h4>
    </div>
  </a>
</div>
这个模板用来表示由英雄名字链接组成的一个阵列。

***\*ngFor 复写器为组件的 heroes 数组中的每个条目创建了一个链接。***

这些链接被 dashboard.component.css 中的样式格式化成了一些色块。

这些链接还没有指向任何地方，但很快就会了。

这个类和 HeroesComponent 类很像。

它定义了一个 heroes 数组属性。

它的构造函数希望 Angular 把 HeroService 注入到私有的 heroService 属性中。

在 ngOnInit() 生命周期钩子中调用 getHeroes。

这个 getHeroes 函数会截取第 2 到 第 5 位英雄，也就是说只返回四个顶级英雄（第二，第三，第四和第五）。

content_copy
getHeroes(): void {
  this.heroService.getHeroes()
    .subscribe(heroes => this.heroes = heroes.slice(1, 5));
}
添加仪表盘路由
要导航到仪表盘，路由器中就需要一个相应的路由。

把 DashboardComponent 导入到 AppRoutingModule 中。

src/app/app-routing.module.ts (import DashboardComponent)
content_copy
import { DashboardComponent }   from './dashboard/dashboard.component';
把一个指向 DashboardComponent 的路由添加到 AppRoutingModule.routes 数组中。

content_copy
{ path: 'dashboard', component: DashboardComponent },
添加默认路由
当应用启动时，浏览器的地址栏指向了网站的根路径。 它没有匹配到任何现存路由，因此路由器也不会导航到任何地方。 <router-outlet> 下方是空白的。

要让应用自动导航到这个仪表盘，请把下列路由添加到 AppRoutingModule.Routes 数组中。

content_copy
{ path: '', redirectTo: '/dashboard', pathMatch: 'full' },
这个路由会把一个与空路径“完全匹配”的 URL 重定向到路径为 '/dashboard' 的路由。

浏览器刷新之后，路由器加载了 DashboardComponent，并且浏览器的地址栏会显示出 /dashboard 这个 URL。

把仪表盘链接添加到壳组件中
应该允许用户通过点击页面顶部导航区的各个链接在 DashboardComponent 和 HeroesComponent 之间来回导航。

把仪表盘的导航链接添加到壳组件 AppComponent 的模板中，就放在 Heroes 链接的前面。

src/app/app.component.html
content_copy
<h1>{{title}}</h1>
<nav>
  <a routerLink="/dashboard">Dashboard</a>
  <a routerLink="/heroes">Heroes</a>
</nav>
<router-outlet></router-outlet>
<app-messages></app-messages>
刷新浏览器，你就能通过点击这些链接在这两个视图之间自由导航了。

导航到英雄详情
HeroDetailComponent 可以显示所选英雄的详情。 此刻，HeroDetailsComponent 只能在 HeroesComponent 的底部看到。

用户应该能通过三种途径看到这些详情。

通过在仪表盘中点击某个英雄。

通过在英雄列表中点击某个英雄。

通过把一个“深链接” URL 粘贴到浏览器的地址栏中来指定要显示的英雄。

在这一节，你将能导航到 HeroDetailComponent，并把它从 HeroesComponent 中解放出来。

从 HeroesComponent 中删除英雄详情
当用户在 HeroesComponent 中点击某个英雄条目时，应用应该能导航到 HeroDetailComponent，从英雄列表视图切换到英雄详情视图。 英雄列表视图将不再显示，而英雄详情视图要显示出来。

打开 HeroesComponent 的模板文件（heroes/heroes.component.html），并从底部删除 <app-hero-detail> 元素。

目前，点击某个英雄条目还没有反应。不过当你启用了到 HeroDetailComponent 的路由之后，很快就能修复它。

添加英雄详情视图
要导航到 id 为 11 的英雄的详情视图，类似于 ~/detail/11 的 URL 将是一个不错的 URL。

打开 AppRoutingModule 并导入 HeroDetailComponent。

src/app/app-routing.module.ts (import HeroDetailComponent)
content_copy
import { HeroDetailComponent }  from './hero-detail/hero-detail.component';
然后把一个参数化路由添加到 AppRoutingModule.routes 数组中，它要匹配指向英雄详情视图的路径。

content_copy
{ path: 'detail/:id', component: HeroDetailComponent },
path 中的冒号（:）表示 :id 是一个占位符，它表示某个特定英雄的 id。

此刻，应用中的所有路由都就绪了。

src/app/app-routing.module.ts (all routes)
content_copy
const routes: Routes = [
  { path: '', redirectTo: '/dashboard', pathMatch: 'full' },
  { path: 'dashboard', component: DashboardComponent },
  { path: 'detail/:id', component: HeroDetailComponent },
  { path: 'heroes', component: HeroesComponent }
];
DashboardComponent 中的英雄链接
此刻，DashboardComponent 中的英雄连接还没有反应。

路由器已经有一个指向 HeroDetailComponent 的路由了， 修改仪表盘中的英雄连接，让它们通过参数化的英雄详情路由进行导航。

src/app/dashboard/dashboard.component.html (hero links)
content_copy
<a *ngFor="let hero of heroes" class="col-1-4"
    routerLink="/detail/{{hero.id}}">
  <div class="module hero">
    <h4>{{hero.name}}</h4>
  </div>
</a>
***你正在 \*ngFor 复写器中使用 Angular 的[插值表达式](https://angular.cn/guide/template-syntax#interpolation)来把当前迭代的 hero.id 插入到每个 [routerLink](https://angular.cn/tutorial/toh-pt5#routerlink) 中。***

HeroesComponent 中的英雄链接
HeroesComponent 中的这些英雄条目都是 <li> 元素，它们的点击事件都绑定到了组件的 onSelect() 方法中。

src/app/heroes/heroes.component.html (list with onSelect)
content_copy
<ul class="heroes">
  <li *ngFor="let hero of heroes"
    [class.selected]="hero === selectedHero"
    (click)="onSelect(hero)">
    <span class="badge">{{hero.id}}</span> {{hero.name}}
  </li>
</ul>
清理 <li>，只保留它的 *ngFor，把徽章（<badge>）和名字包裹进一个 <a> 元素中， 并且像仪表盘的模板中那样为这个 <a> 元素添加一个 routerLink 属性。

src/app/heroes/heroes.component.html (list with links)
content_copy
<ul class="heroes">
  <li *ngFor="let hero of heroes">
    <a routerLink="/detail/{{hero.id}}">
      <span class="badge">{{hero.id}}</span> {{hero.name}}
    </a>
  </li>
</ul>
你还要修改私有样式表（heroes.component.css），让列表恢复到以前的外观。 修改后的样式表参见本指南底部的最终代码。

~~dashboard和heroes列表都能通过点击超链接跳转到每个hero详情~~

移除死代码（可选）
虽然 HeroesComponent 类仍然能正常工作，但 onSelect() 方法和 selectedHero 属性已经没用了。

最好清理掉它们，将来你会体会到这么做的好处。 下面是删除了死代码之后的类。

src/app/heroes/heroes.component.ts (cleaned up)
content_copy
export class HeroesComponent implements OnInit {
  heroes: Hero[];

  constructor(private heroService: HeroService) { }

  ngOnInit() {
    this.getHeroes();
  }

  getHeroes(): void {
    this.heroService.getHeroes()
    .subscribe(heroes => this.heroes = heroes);
  }
}

## 支持路由的 HeroDetailComponent
以前，父组件 HeroesComponent 会设置 HeroDetailComponent.hero 属性，然后 HeroDetailComponent 就会显示这个英雄。

HeroesComponent 已经不会再那么做了。 现在，当路由器会在响应形如 ~/detail/11 的 URL 时创建 HeroDetailComponent。

HeroDetailComponent 需要从一种新的途径获取**要显示的英雄**。

* 获取创建本组件的路由，

* 从这个路由中提取出 id

* 通过 HeroService 从服务器上获取具有这个 id 的英雄数据。

先添加下列导入语句：

src/app/hero-detail/hero-detail.component.ts
content_copy
import { ActivatedRoute } from '@angular/router';
import { Location } from '@angular/common';

import { HeroService }  from '../hero.service';
然后把 ActivatedRoute、HeroService 和 Location 服务注入到构造函数中，将它们的值保存到私有变量里：

content_copy
constructor(
  private route: ActivatedRoute,
  private heroService: HeroService,
  private location: Location
) {}
ActivatedRoute 保存着到这个 HeroDetailComponent 实例的路由信息。 这个组件对从 URL 中提取的路由参数感兴趣。 其中的 id 参数就是要显示的英雄的 id。

HeroService 从远端服务器获取英雄数据，本组件将使用它来获取要显示的英雄。

location 是一个 Angular 的服务，用来与浏览器打交道。 稍后，你就会使用它来导航回上一个视图。

从路由参数中提取 id
在 ngOnInit() 生命周期钩子 中调用 getHero()，代码如下：

content_copy
ngOnInit(): void {
  this.getHero();
}

getHero(): void {
  const id = +this.route.snapshot.paramMap.get('id');
  this.heroService.getHero(id)
    .subscribe(hero => this.hero = hero);
}
***route.snapshot 是一个路由信息的静态快照，抓取自组件刚刚创建完毕之后。***  

***paramMap 是一个从 URL 中提取的路由参数值的字典。 "id" 对应的值就是要获取的英雄的 id。***  

***路由参数总会是字符串。 JavaScript 的 (+) 操作符会把字符串转换成数字，英雄的 id 就是数字类型。***  

刷新浏览器，应用挂了。出现一个编译错误，因为 HeroService 没有一个名叫 getHero() 的方法。 这就添加它。

添加 HeroService.getHero()
添加 HeroService，并添加如下的 getHero() 方法

src/app/hero.service.ts (getHero)
content_copy
getHero(id: number): Observable<Hero> {
  // TODO: send the message _after_ fetching the hero
  this.messageService.add(`HeroService: fetched hero id=${id}`);
  return of(HEROES.find(hero => hero.id === id));
}
注意，反引号 ( ` ) 用于定义 JavaScript 的 模板字符串字面量，以便嵌入 id。

像 getHeroes() 一样，getHero() 也有一个异步函数签名。 它用 RxJS 的 of() 函数返回一个 Observable 形式的模拟英雄数据。

你将来可以用一个真实的 Http 请求来重新实现 getHero()，而不用修改调用了它的 HeroDetailComponent。

试试看
刷新浏览器，应用又恢复正常了。 你可以在仪表盘或英雄列表中点击一个英雄来导航到该英雄的详情视图。

如果你在浏览器的地址栏中粘贴了 localhost:4200/detail/11，路由器也会导航到 id: 11 的英雄（"Mr. Nice"）的详情视图。

回到原路
通过点击浏览器的后退按钮，你可以回到英雄列表或仪表盘视图，这取决于你从哪里进入的详情视图。

如果能在 HeroDetail 视图中也有这么一个按钮就更好了。

把一个后退按钮添加到组件模板的底部，并且把它绑定到组件的 goBack() 方法。

src/app/hero-detail/hero-detail.component.html (back button)
content_copy
<button (click)="goBack()">go back</button>
在组件类中添加一个 goBack() 方法，利用你以前注入的 Location 服务在浏览器的历史栈中后退一步。

src/app/hero-detail/hero-detail.component.ts (goBack)
content_copy
goBack(): void {
  this.location.back();
}
刷新浏览器，并开始点击。 用户能在应用中导航：从仪表盘到英雄详情再回来，从英雄列表到 mini 版英雄详情到英雄详情，再回到英雄列表。

你已经满足了在本章开头设定的所有导航需求。

查看最终代码
你的应用应该变成了这样 在线例子 / 下载范例。本页所提及的代码文件如下：

AppRoutingModule、AppModule 和 HeroService
src/app/app-routing.module.ts
src/app/app.module.ts
src/app/hero.service.ts
content_copy
import { NgModule }             from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
 
import { DashboardComponent }   from './dashboard/dashboard.component';
import { HeroesComponent }      from './heroes/heroes.component';
import { HeroDetailComponent }  from './hero-detail/hero-detail.component';
 
const routes: Routes = [
  { path: '', redirectTo: '/dashboard', pathMatch: 'full' },
  { path: 'dashboard', component: DashboardComponent },
  { path: 'detail/:id', component: HeroDetailComponent },
  { path: 'heroes', component: HeroesComponent }
];
 
@NgModule({
  imports: [ RouterModule.forRoot(routes) ],
  exports: [ RouterModule ]
})
export class AppRoutingModule {}
AppComponent
src/app/app.component.html
src/app/app.component.css
content_copy
<h1>{{title}}</h1>
<nav>
  <a routerLink="/dashboard">Dashboard</a>
  <a routerLink="/heroes">Heroes</a>
</nav>
<router-outlet></router-outlet>
<app-messages></app-messages>
DashboardComponent
src/app/dashboard/dashboard.component.html
src/app/dashboard/dashboard.component.ts
src/app/dashboard/dashboard.component.css
content_copy
<h3>Top Heroes</h3>
<div class="grid grid-pad">
  <a *ngFor="let hero of heroes" class="col-1-4"
      routerLink="/detail/{{hero.id}}">
    <div class="module hero">
      <h4>{{hero.name}}</h4>
    </div>
  </a>
</div>
HeroesComponent
src/app/heroes/heroes.component.html
src/app/heroes/heroes.component.ts
src/app/heroes/heroes.component.css
content_copy
<h2>My Heroes</h2>
<ul class="heroes">
  <li *ngFor="let hero of heroes">
    <a routerLink="/detail/{{hero.id}}">
      <span class="badge">{{hero.id}}</span> {{hero.name}}
    </a>
  </li>
</ul>
HeroDetailComponent
src/app/hero-detail/hero-detail.component.html
src/app/hero-detail/hero-detail.component.ts
src/app/hero-detail/hero-detail.component.css
content_copy
<div *ngIf="hero">
  <h2>{{hero.name | uppercase}} Details</h2>
  <div><span>id: </span>{{hero.id}}</div>
  <div>
    <label>name:
      <input [(ngModel)]="hero.name" placeholder="name"/>
    </label>
  </div>
  <button (click)="goBack()">go back</button>
</div>
小结
添加了 Angular 路由器在各个不同组件之间导航。

你使用一些 <a> 链接和一个 <router-outlet> 把 AppComponent 转换成了一个导航用的壳组件。

你在 AppRoutingModule 中配置了路由器。

你定义了一些简单路由、一个重定向路由和一个参数化路由。

你在 <a> 元素中使用了 routerLink 指令。

你把一个紧耦合的主从视图重构成了带路由的详情视图。

你使用路由链接参数来导航到所选英雄的详情视图。

在多个组件之间共享了 HeroService 服务。
