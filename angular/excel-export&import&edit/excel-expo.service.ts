import { Injectable } from '@angular/core';

import * as FileSaver from 'file-saver';
import * as XLSX from 'xlsx';

@Injectable({
  providedIn: 'root'
})
export class ExcelExpoService {

  constructor() { }

  /**
   *
   * @param excelFileName 文件名
   * @param headers 是否传入文件头，如果传空默认为变量名
   * @param sheetNames sheet名
   * @param obj  所提供的数据
   */
  
  //EXCEL_TYPE = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;charset=UTF-8';
  //EXCEL_EXTENSION = '.xlsx';

  public exportAsExcelFile(excelFileName: string, headers: string[], sheetNames: string[], obj: any[]): void {
    //excelFileName为必填字段，如果传入null会报异常，以下为判断。

    console.log(obj);

    if (typeof excelFileName == "undefined" || excelFileName == null || excelFileName == "") {
      throw new Error("please input excelFileName name");
    }
    //判断数据是否传入
    if (obj == null || obj.length == 0) {
      throw new Error("no datas show");
    }
    const worksheet: XLSX.WorkSheet = XLSX.utils.json_to_sheet(obj);    
    //WorkBook对象为主要对象，对象中的SheetNames表示传入的sheet名称。Sheets所对应的数据。两者一一对应。
    const workbook: XLSX.WorkBook = { Sheets: { 'data': worksheet }, SheetNames: ['data'] };
    //1.判断sheetNames传入的是否为空,为空默认为sheet。
    //2.遍历json数组,然后通过json_to_sheet方法导入每个数组里面的对象。
    //3.动态修改WorkSheet的头部。    

    /* obj.forEach((value, index) => {
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

    }) */
    //使用XLSX.write方法写入
    const excelBuffer: any = XLSX.write(workbook, { bookType: 'xlsx', type: 'buffer' });
    //保存文件
    this.saveAsExcelFile(excelBuffer, excelFileName);
  }

  private saveAsExcelFile(buffer: any, fileName: string): void {

    const buf = new ArrayBuffer(buffer.length);
    const view = new Uint8Array(buf);


    for (let i = 0; i !== buffer.length; ++i) {
      view[i] = buffer.charCodeAt(i) & 0xFF;
    };


    const data: Blob = new Blob([buf], {
      //type: EXCEL_TYPE
      type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;charset=UTF-8'
    });


    //FileSaver.saveAs(data, fileName + "_" + new Date().getTime() + EXCEL_EXTENSION);
    FileSaver.saveAs(data, fileName + "_" + new Date().getTime() + '.xlsx');
  }

  //将数字转化为chart类型
  private numberToChart(i: number): string {
    return String.fromCharCode(65 + i);
  }
}
