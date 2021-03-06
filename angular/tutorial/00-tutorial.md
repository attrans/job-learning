# 教程：英雄指南

英雄指南教程涵盖了 Angular 的基本知识。在本教程中，你将构建一个应用，来帮助招聘机构管理一群英雄。

这个入门级 app 包含很多数据驱动的应用所需的特性。 它需要获取并显示英雄的列表、编辑所选英雄的详情，并且在英雄数据的不同视图之间导航。

在本教程的最后，你将完成下列工作：

* 使用Angular 的内置指令来显示 / 隐藏元素，并显示英雄数据的列表。

* 创建 Angular 组件以显示英雄的详情，并显示一个英雄数组。

* 为只读数据使用单项数据绑定。

* 添加可编辑字段，使用双向数据绑定来更新模型。

* 把组件中的方法绑定到用户事件上，比如按键和点击。

* 让用户可以在主列表中选择一个英雄，然后在详情视图中编辑他。

* 使用管道来格式化数据。

* 创建共享的服务来管理这些英雄。

* 使用路由在不同的视图及其组件之间导航。

你将学到足够的 Angular 知识，并确信 Angular 确实能提供你所需的支持。

完成本教程的所有步骤之后，最终的应用会是这样的：[在线例子](https://angular.cn/generated/live-examples/toh-pt6/stackblitz.html) / [下载范例](https://angular.cn/generated/zips/toh-pt6/toh-pt6.zip)。

你要构建出什么
下面是本教程关于界面的构想：开始是“Dashboard（仪表盘）”视图，来展示最勇敢的英雄。

Output of heroes dashboard
仪表盘顶部中有两个链接：“Dashboard（仪表盘）”和“Heroes（英雄列表）”。 你将点击它们在“仪表盘”和“英雄列表”视图之间导航。

当你点击仪表盘上名叫“Magneta”的英雄时，路由会打开英雄详情页，在这里，你可以修改英雄的名字。

Details of hero in app
点击“Back（后退）”按钮将返回到“Dashboard（仪表盘）”。 顶部的链接可以把你带到任何一个主视图。 如果你点击“Heroes（英雄列表）”链接，应用将把你带到“英雄”列表主视图。

Output of heroes list app
当你点击另一位英雄时，一个只读的“微型详情视图”会显示在列表下方，以体现你的选择。

你可以点击“View Details（查看详情）”按钮进入所选英雄的编辑视图。

下面这张图汇总了所有可能的导航路径。

View navigations
下图演示了本应用中的动图。

Tour of Heroes in Action
