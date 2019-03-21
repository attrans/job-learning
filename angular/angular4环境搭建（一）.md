# 简介

>`angular版本迭代非常之快速，目前已经更新到了angular5版本，因为本次实战项目在是基于angular4来搭建的，所以项目版本环境是以angular4基础来搭建的，后期可以进行更新。`

# 目录
>1. angular所需搭建的环境
>2. 几个比较常用的命令
>3. 几种常见的API测试工具
>4. 搭建所碰到的问题
>5. 开始第一个HelloWorld

# angular所需搭建的环境
1.nodejs[下载](https://nodejs.org/en/)，进行下载安装。  
2. 安装vsCode [下载](https://code.visualstudio.com/)。  
3. 利用npm i -g @angular/cli （脚手架工具），完成一些繁琐的初始化工作。  

查看是否安装成功：   
![](https://github.com/attrans/job-learning/blob/master/angular/images/angular-cli%E5%AE%89%E8%A3%85%E6%88%90%E5%8A%9F.png "angular-cli安装成功")

注：由于国内网络环境问题我们可以做一下方案：

>`1. npm 设置淘宝镜像 : npm config set registry “https://registry.npm.taobao.org/”`  
>`2. cnpm和yarn作为替代的包管理工具。安装cnpm命令：npm i -g cnpm。`  

# 几个常用的命令
>1. npm i –save 包名：软件依赖 npm i –save-dev 包名：开发依赖。
>2. ng new 项目名：新建Angular项目
>3. ng build -prod:生产环境编译
>4. ng serve:启动开发服务器

#几种常见的API测试工具
Mock Rest API 
1. json-server:用于快速搭建REST API的利器 npm install -g json-server

>`查看json-server是否安装成功：打开cmd输入json-server -v(例如：0.11.2)。`   
>`使用：自己创建一个json格式的文件，使用json-server （json文件路径）。 `  
>`然后打开网页： `  
>![](https://github.com/attrans/job-learning/blob/master/angular/images/json-server%E6%88%90%E5%8A%9F%E7%A4%BA%E4%BE%8B.png "json-server成功示例")
>然后我们可以使用HTTP来模拟服务器数据。

2.使用Postman测试常用的API 
3.使用VSCode的REST Client插件

# 常见问题
安装@angular/cli出现错误

>`解决：首先：npm uninstall -g @angular/cli `  
>`然后：npm cache clean `  
>`继续: npm install -g @angular/cli`  

# 开始第一个HelloWorld
1.使用ng new HelloWorld   
 ![](https://github.com/attrans/job-learning/blob/master/angular/images/ng%20new%20HelloWorld.png "ng new HelloWorld")
文件目录结构： 
 ![](https://github.com/attrans/job-learning/blob/master/angular/images/angular%E5%B7%A5%E4%BD%9C%E5%8C%BA%E6%96%87%E4%BB%B6%E7%9B%AE%E5%BD%95%E7%BB%93%E6%9E%84.png "angular工作区文件目录结构")

2.对项目结构主要内容解释如下：

` 1 e2e ------------------------------用于自动化测试
 2 node_modules------------------存放依赖包的地方
 3 src--------------------------------存放源代码
 4   app----------------------------根模块
 5          app.component.css------样式文件
 6　　　app.component.html---模板
 7　　　app.component.spec.ts-测试
 8　　　app.component.ts-------组件
 9　　　app.module.ts------------模块
10   environments----------------环境
11　　　environment.prod.ts----生产环境
12　　　environment.ts----------非生产环境
13   index.html-------------------宿主页面
14   mian.ts-----------------------程序引导
15   tsconfig.json-----------------编译配置
16  angular-cli.json--------------angular-cli配置
17    package.json----------------依赖包以及npm的命令`

3.运行程序 ng serve 在浏览器上输入localhost:4200 
 ![](https://github.com/attrans/job-learning/blob/master/angular/images/ng%20serve%20welcome.png "ng serve welcome")

完成我们angular的第一个demo的开发 
--------------------- 

转载自：https://blog.csdn.net/xiajun2356033/article/details/79287103 
