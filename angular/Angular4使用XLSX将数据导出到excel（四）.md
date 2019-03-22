Angular4使用XLSX将数据导出到excel（四）

简介
将后台传过来的json数据对象，然后以excel表格进行导出，传统的方案：后台进行数据导入表格，然后将excel二进制文件提供给前端去下载。由此我们可以思考是否直接将后台的json数据通过前端来导出到excel表格中呢？答案是肯定的。我们可以借用XLSX这个插件来实现数据的导入导出功能。

目录
项目创建
添加所需要的依赖
编写service
测试
项目创建
使用angular4的cli快速搭建项目脚手架。具体步骤可查看angular4环境搭建（一）

ng new excelExport 完成项目创建

添加所需要的依赖
在命令行中输入

npm install xlsx –save 
npm install file-saver –save

如果npm下载受限制已经下载报错我们可以国内网络环境问题我们可以做一下方案，可使用镜像来完成下载。例如淘宝镜像：npm config set registry “https://registry.npm.taobao.org/”。

编写service
1.首先我们用 ng g s service/excelPort创建一个service

import { Injectable } from '@angular/core';

@Injectable()
export class ExcelService {
constructor() { }
}
1
2
3
4
5
6
2.导入我们所需要的依赖

import * as FileSaver from 'file-saver';//浏览器读取本地的文件已经保存文件所需要的依赖。
import * as XLSX from 'xlsx';//数据导出导入所需要的依赖
1
2
3.添加导出excel文件的方法


 /**
   *
   * @param excelFileName 文件名
   * @param headers 是否传入文件头，如果传空默认为变量名
   * @param sheetNames sheet名
   * @param obj  所提供的数据
   */
  public exportAsExcelFile(excelFileName: string, headers: string[], sheetNames: string[], obj: any[]): void {
    //excelFileName为必填字段，如果传入null会报异常，以下为判断。
    if (typeof excelFileName == "undefined" || excelFileName == null || excelFileName == "") {
      throw new Error("please input excelFileName name");
    }
    //判断数据是否传入
    if (obj == null || obj.length == 0) {
      throw new Error("no datas show");
    }
    //WorkBook对象为主要对象，对象中的SheetNames表示传入的sheet名称。Sheets所对应的数据。两者一一对应。
    const workbook: XLSX.WorkBook = { SheetNames: [], Sheets: {} };
    //1.判断sheetNames传入的是否为空,为空默认为sheet。
    //2.遍历json数组,然后通过json_to_sheet方法导入每个数组里面的对象。
    //3.动态修改WorkSheet的头部。
    obj.forEach((value, index) => {
      if (sheetNames == null) {
        workbook.SheetNames.push("sheet" + index);
      } else {
        workbook.SheetNames.push(sheetNames[index]);
      }

      if (value.length != 0) {
        const tempSheet = XLSX.utils.json_to_sheet(value);
        if (headers != null || headers.length != 0) {
          for (let i = 0; i < headers.length; i++) {
            tempSheet[this.numberToChart((i)) + "1"] = { v: headers[i] };
          }
        }
        workbook.Sheets[workbook.SheetNames[index]] = tempSheet;
      }

    })
    //使用XLSX.write方法写入
    const excelBuffer: any = XLSX.write(workbook, { bookType: 'xlsx', type: 'buffer' });
    //保存文件
    this.saveAsExcelFile(excelBuffer, excelFileName);

 private saveAsExcelFile(buffer: any, fileName: string): void {

    const buf = new ArrayBuffer(buffer.length);
    const view = new Uint8Array(buf);


    for (let i = 0; i !== buffer.length; ++i) {
      view[i] = buffer.charCodeAt(i) & 0xFF;
    };


    const data: Blob = new Blob([buf], {
      type: EXCEL_TYPE
    });


    FileSaver.saveAs(data, fileName + "_" + new Date().getTime() + EXCEL_EXTENSION);
  }

//将数字转化为chart类型
  private numberToChart(i: number): string {
    return String.fromCharCode(65 + i);
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
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
40
41
42
43
44
45
46
47
48
49
50
51
52
53
54
55
56
57
58
59
60
61
62
63
64
65
66
67
68
69
测试
导入model

export class Person {
    id: number;
    name: String;
    surname: String;
    age: number;
}


export const PERSONS: Person[] = [
    {
        id: 1,
        name: 'Thomas',
        surname: 'Novicky',
        age: 21
    },
    {
        id: 2,
        name: 'Adam',
        surname: 'Tracz',
        age: 12
    },
    {
        id: 3,
        name: 'Steve',
        surname: 'Laski',
        age: 38
    }
];
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
22
23
24
25
26
27
28
1.在app.component.html加入点击按钮

<div class="container" style="margin-top: 20px;">
  <div class="panel panel-default">
    <div class="panel-heading">All persons data</div>
    <table class="table" *ngIf="persons">
      <thead>
        <tr>
          <th>Id</th>
          <th>Name</th>
          <th>Surname</th>
          <th>Age</th>
        </tr>
      </thead>
      <tbody>
        <tr *ngFor="let person of persons">
          <td>{{person.id}}</td>
          <td>{{person.name}}</td>
          <td>{{person.surname}}</td>
          <td>{{person.age}}</td>
        </tr>
      </tbody>
    </table>
  </div>
  <button (click)="exportToExcel()" class="btn btn-primary">Export to excel</button>
</div>
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
22
23
24
25
2.在app.component.ts导入service和model

import { Component } from '@angular/core';
import { ExcelService } from './excel.service';
import { PERSONS, Person } from './model';
@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {

  constructor(private excelService: ExcelService) {
    this.persons = PERSONS;
  }

  exportToExcel(event) {
    this.excelService.exportAsExcelFile("name",null, null, this.persons );
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
效果图: 
这里写图片描述


转自：https://blog.csdn.net/xiajun2356033/article/details/80077735
