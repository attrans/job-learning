简介
angular版本迭代非常之快速，目前已经更新到了angular5版本，因为本次实战项目在是基于angular4来搭建的，所以项目版本环境是以angular4基础来搭建的，后期可以进行更新。

目录
angular所需搭建的环境
几个比较常用的命令
几种常见的API测试工具
搭建所碰到的问题
开始第一个HelloWorld
angular所需搭建的环境
1.nodejs下载，进行下载安装。 
2. 安装vsCode 下载。 
3. 利用npm i -g @angular/cli （脚手架工具），完成一些繁琐的初始化工作。

查看是否安装成功： 


注：由于国内网络环境问题我们可以做一下方案：

npm 设置淘宝镜像 : npm config set registry “https://registry.npm.taobao.org/”
cnpm和yarn作为替代的包管理工具。安装cnpm命令：npm i -g cnpm。
几个常用的命令
npm i –save 包名：软件依赖 npm i –save-dev 包名：开发依赖。
ng new 项目名：新建Angular项目
ng build -prod:生产环境编译
ng serve:启动开发服务器
几种常见的API测试工具
Mock Rest API 
1. json-server:用于快速搭建REST API的利器 npm install -g json-server

查看json-server是否安装成功：打开cmd输入json-server -v(例如：0.11.2)。 
使用：自己创建一个json格式的文件，使用json-server （json文件路径）。 
然后打开网页： 

然后我们可以使用HTTP来模拟服务器数据。

2.使用Postman测试常用的API 
3.使用VSCode的REST Client插件

常见问题
安装@angular/cli出现错误

解决：首先：npm uninstall -g @angular/cli 
然后：npm cache clean 
继续: npm install -g @angular/cli

开始第一个HelloWorld
1.使用ng new HelloWorld 
 
文件目录结构： 


2.对项目结构主要内容解释如下：

e2e ------------------------------用于自动化测试
node_modules------------------存放依赖包的地方
src--------------------------------存放源代码
    app----------------------------根模块
           app.component.css------样式文件
　　　app.component.html---模板
　　　app.component.spec.ts-测试
　　　app.component.ts-------组件
　　　app.module.ts------------模块
    environments----------------环境
　　　environment.prod.ts----生产环境
　　　environment.ts----------非生产环境
    index.html-------------------宿主页面
    mian.ts-----------------------程序引导
    tsconfig.json-----------------编译配置
　 angular-cli.json--------------angular-cli配置
    package.json----------------依赖包以及npm的命令
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
3.运行程序 ng serve 在浏览器上输入localhost:4200 


完成我们angular的第一个demo的开发 
--------------------- 
作者：android_Mr_夏 
来源：CSDN 
原文：https://blog.csdn.net/xiajun2356033/article/details/79287103 
版权声明：本文为博主原创文章，转载请附上博文链接！
