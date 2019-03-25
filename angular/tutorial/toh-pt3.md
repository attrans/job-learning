主从组件
此刻，HeroesComponent 同时显示了英雄列表和所选英雄的详情。

把所有特性都放在同一个组件中，将会使应用“长大”后变得不可维护。 你要把大型组件拆分成小一点的子组件，每个子组件都要集中精力处理某个特定的任务或工作流。

本页面中，你将迈出第一步 —— 把英雄详情移入一个独立的、可复用的 HeroDetailComponent。

HeroesComponent 将仅仅用来表示英雄列表。 HeroDetailComponent 将用来表示所选英雄的详情。

制作 HeroDetailComponent
使用 Angular CLI 生成一个名叫 hero-detail 的新组件。

content_copy
ng generate component hero-detail
这个命令会做这些事：

创建目录 src/app/hero-detail。

在这个目录中会生成四个文件：

作为组件样式的 CSS 文件。

作为组件模板的 HTML 文件。

存放组件类 HeroDetailComponent 的 TypeScript 文件。

HeroDetailComponent 类的测试文件。

该命令还会把 HeroDetailComponent 添加到 src/app/app.module.ts 文件中 @NgModule 的 declarations 列表中。

编写模板
从 HeroesComponent 模板的底部把表示英雄详情的 HTML 代码剪切粘贴到所生成的 HeroDetailComponent 模板中。

所粘贴的 HTML 引用了 selectedHero。 新的 HeroDetailComponent 可以展示任意英雄，而不仅仅所选的。因此还要把模板中的所有 selectedHero 替换为 hero。

完工之后，HeroDetailComponent 的模板应该是这样的：

src/app/hero-detail/hero-detail.component.html
content_copy
<div *ngIf="hero">

  <h2>{{hero.name | uppercase}} Details</h2>
  <div><span>id: </span>{{hero.id}}</div>
  <div>
    <label>name:
      <input [(ngModel)]="hero.name" placeholder="name"/>
    </label>
  </div>

</div>
***添加 @Input() hero 属性***
HeroDetailComponent 模板中绑定了组件中的 hero 属性，它的类型是 Hero。

打开 HeroDetailComponent 类文件，并导入 Hero 符号。

src/app/hero-detail/hero-detail.component.ts (import Hero)
content_copy
import { Hero } from '../hero';
hero 属性必须是一个带有 @Input() 装饰器的输入属性，因为外部的 HeroesComponent 组件将会绑定到它。就像这样：

content_copy
<app-hero-detail [hero]="selectedHero"></app-hero-detail>
修改 @angular/core 的导入语句，导入 Input 符号。

src/app/hero-detail/hero-detail.component.ts (import Input)
content_copy
import { Component, OnInit, Input } from '@angular/core';
添加一个带有 @Input() 装饰器的 hero 属性。

content_copy
@Input() hero: Hero;
这就是你要对 HeroDetailComponent 类做的唯一一项修改。 没有其它属性，也没有展示逻辑。这个组件所做的只是通过 hero 属性接收一个英雄对象，并显示它。

显示 HeroDetailComponent
HeroesComponent 仍然是主从视图。

在你从模板中剪切走代码之前，它自己负责显示英雄的详情。现在它要把这个职责委托给 HeroDetailComponent 了。

这两个组件将会具有父子关系。 当用户从列表中选择了某个英雄时，父组件 HeroesComponent 将通过把要显示的新英雄发送给子组件 HeroDetailComponent，来控制子组件。

你不用修改 HeroesComponent 类，但是要修改它的模板。

修改 HeroesComponent 的模板
HeroDetailComponent 的选择器是 'app-hero-detail'。 把 <app-hero-detail> 添加到 HeroesComponent 模板的底部，以便把英雄详情的视图显示到那里。

把 HeroesComponent.selectedHero 绑定到该元素的 hero 属性，就像这样：

heroes.component.html (HeroDetail binding)
content_copy
<app-hero-detail [hero]="selectedHero"></app-hero-detail>
[hero]="selectedHero" 是 Angular 的属性绑定语法。

这是一种单向数据绑定。从 HeroesComponent 的 selectedHero 属性绑定到目标元素的 hero 属性，并映射到了 HeroDetailComponent 的 hero 属性。

现在，当用户在列表中点击某个英雄时，selectedHero 就改变了。 当 selectedHero 改变时，属性绑定会修改 HeroDetailComponent 的 hero 属性，HeroDetailComponent 就会显示这个新的英雄。

修改后的 HeroesComponent 的模板是这样的：

heroes.component.html
content_copy
<h2>My Heroes</h2>

<ul class="heroes">
  <li *ngFor="let hero of heroes"
    [class.selected]="hero === selectedHero"
    (click)="onSelect(hero)">
    <span class="badge">{{hero.id}}</span> {{hero.name}}
  </li>
</ul>

<app-hero-detail [hero]="selectedHero"></app-hero-detail>
浏览器刷新，应用又像以前一样开始工作了。

有哪些变化？
像以前一样，一旦用户点击了一个英雄的名字，该英雄的详情就显示在了英雄列表下方。 现在，HeroDetailComponent 负责显示那些详情，而不再是 HeroesComponent。

把原来的 HeroesComponent 重构成两个组件带来了一些优点，无论是现在还是未来：

你通过缩减 HeroesComponent 的职责简化了该组件。

你可以把 HeroDetailComponent 改进成一个功能丰富的英雄编辑器，而不用改动父组件 HeroesComponent。

你可以改进 HeroesComponent，而不用改动英雄详情视图。

将来你可以在其它组件的模板中重复使用 HeroDetailComponent。

查看最终代码
你的应用应该变成了这样 在线例子 / 下载范例。本页所提及的代码文件如下：

src/app/hero-detail/hero-detail.component.ts
src/app/hero-detail/hero-detail.component.html
src/app/heroes/heroes.component.html
src/app/app.module.ts
content_copy
import { Component, OnInit, Input } from '@angular/core';
import { Hero } from '../hero';
 
@Component({
  selector: 'app-hero-detail',
  templateUrl: './hero-detail.component.html',
  styleUrls: ['./hero-detail.component.css']
})
export class HeroDetailComponent implements OnInit {
  @Input() hero: Hero;
 
  constructor() { }
 
  ngOnInit() {
  }
 
}
小结
你创建了一个独立的、可复用的 HeroDetailComponent 组件。

你用属性绑定语法来让父组件 HeroesComponent 可以控制子组件 HeroDetailComponent。

你用 @Input 装饰器来让 hero 属性可以在外部的 HeroesComponent 中绑定。
