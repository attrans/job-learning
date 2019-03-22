# Angular4架构概述（二）

## 简介
由angular的cli（脚手架）创建出来的项目可知，angular项目由模块(module)构建成，每个angular应用都至少有一个根模块,通常我们默认为AppModule模块。然后每个模块由组件+服务组成。

## 目录
angular模块分析
angular组件分析
angular服务分析

## angular模块分析
angular模块是由装饰器@ngModule来修饰，里面包含的元数据有：

declarations 声明本模块所用到的组件，管道以及指令
imports 引入本模块需要的其他模块
providers 全局模块的服务创建器，注册之后，在任何模块都可以使用
bootstrap 应用的主视图，只有根模块才需要使用。也就是程序的主入口声明模块
exports 导出本模块的组件可供给其他模块使用
通常我们创建项目默认的根模块在app.module.ts文件中，引导这个根模块就可以启动我们自己的应用了。 
如图： 
 
注：exports属性一般不会导入根组件(AppComponent)，因为其它模块永远不需要导入根模块。

## angular组件分析
angular组件组件是由装饰器@Component来修饰，里面包含的元数据对象属性有:

selector css的选择器，一旦在html中找到所对应的标签，就会实例化该组件。
templateUrl 显示组件视图页面HTML的所在位置。
styleUrls 显示组件视图样式的地址。
providers 当前组件所需的依赖注入提供商的数据
如图: 


**注：你还可以用 template 属性的值来提供内联的 HTML 模板。 这个模板定义了该组件的宿主视图。**
``` TypeScript
  template : `<h1>hello</h1>
               <div>...</div>`
```
## angular服务分析
angular把组件和服务给分离开是为了程序更好的扩展性，以及复用性，服务由装饰器@Injectable修饰。

如图: 
 
图中创建了一个LoggerService服务，其中用@Injectable所修饰。那么我们可以在组件中来调用该服务： 
1.首先我们在app.component.html创建3个按钮，构造它们的点击事件：

<button (click)="onclik(1)">提示</button>
<button (click)="onclik(2)">提示1</button>
<button (click)="onclik(3)">提示2</button>
1
2
3
注：（click）在angular中属于点击事件。 
2.我们继续在app.component.ts的构造方法传入该service：

@Component({
  selector: 'app-root',//css的选择器，一旦在html中找到所对应的标签，就会实例化该组件。
  templateUrl: './app.component.html',//该组件视图页面HTML的地址。
  styleUrls: ['./app.component.css'],//该组件视图样式的地址.
  providers: []//当前组件所需的依赖注入提供商的数据
})
export class AppComponent{

  constructor(private service:LoggerService) {
  }
  onclik(data: number) {
    if (data === 1) {
      this.service.log("log");
    } else if (data === 2) {
      this.service.warn("warn");
    } else if (data === 3) {
      this.service.error("error");
    }
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
如果用上面方式开启ng serve开启项目会报以下错误：

AppComponent_Host.ngfactory.js? [sm]:1 ERROR Error: StaticInjectorError(AppModule)[AppComponent -> LoggerService]: 
  StaticInjectorError(Platform: core)[AppComponent -> LoggerService]: 
    NullInjectorError: No provider for LoggerService!
    at _NullInjector.get (core.js:1002)
    at resolveToken (core.js:1300)
    at tryResolveToken (core.js:1242)
    at StaticInjector.get (core.js:1110)
    at resolveToken (core.js:1300)
    at tryResolveToken (core.js:1242)
    at StaticInjector.get (core.js:1110)
    at resolveNgModuleDep (core.js:10854)
    at NgModuleRef_.get (core.js:12087)
    at resolveDep (core.js:12577)
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
上述错误是我们没有在provider中注入LoggerService，我们应该把所有的服务中注入到provider中，在这里程序启动会自动帮我们实例化该服务对象。

修改之后：

@Component({
  selector: 'app-root',//css的选择器，一旦在html中找到所对应的标签，就会实例化该组件。
  templateUrl: './app.component.html',//该组件视图页面HTML的地址。
  styleUrls: ['./app.component.css'],//该组件视图样式的地址.
  providers: [LoggerService]//当前组件所需的依赖注入提供商的数据
})
1
2
3
4
5
6


## @Injectable（）
**@Injectable（）修饰器是否必须要**
首先我们把上面LoggerService中的修饰器@Injectable删除之后，发现程序依旧可以运行起来。

猜想：LoggerService是独立运行起来的，根本没有依赖别的对象，相当于一个简单的类。那我们试试在LoggerService注入别的Service看看。

新建一个Service：

export class HeroService {
  heros: { id: number; name: string } =
    { id: 11, name: 'Mr. Nice' }
  getHeros() {
    return this.heros;
  }
}
1
2
3
4
5
6
7
import { Injectable } from '@angular/core';
import { HeroService } from './hero.service';

export class LoggerService {

  constructor(heroService:HeroService){

  }

  log(msg: any)   { console.log(msg); }
  error(msg: any) { console.error(msg); }
  warn(msg: any)  { console.warn(msg); }
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
这次我们在LoggerService中没有添加@Injectable（），在构造方法传入HeroService,然后把HeroService注入到Provider中避免出现上面错误。运行程序：

compiler.js:485 Uncaught Error: Can't resolve all parameters for LoggerService: (?).
    at syntaxError (compiler.js:485)
    at CompileMetadataResolver._getDependenciesMetadata (compiler.js:15700)
    at CompileMetadataResolver._getTypeMetadata (compiler.js:15535)
    at CompileMetadataResolver._getInjectableMetadata (compiler.js:15515)
    at CompileMetadataResolver.getProviderMetadata (compiler.js:15875)
    at eval (compiler.js:15786)
    at Array.forEach (<anonymous>)
    at CompileMetadataResolver._getProvidersMetadata (compiler.js:15746)
    at CompileMetadataResolver.getNonNormalizedDirectiveMetadata (compiler.js:15007)
    at CompileMetadataResolver._getEntryComponentMetadata (compiler.js:15848）
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
上面异常信息说明无法解析 LoggerService的所有参数，加上@Injectable之后项目可以运行起来。

## 总结：
@Injectable() 是必须的么？

如果所创建的服务不依赖于其他对象，是可以不用使用 Injectable 类装饰器。但当该服务需要在构造函数中注入依赖对象，就需要使用 Injectable 装饰器。不过比较推荐的做法不管是否有依赖对象，在创建服务时都使用 Injectable 类装饰器。


转自：https://blog.csdn.net/xiajun2356033/article/details/79869483 
