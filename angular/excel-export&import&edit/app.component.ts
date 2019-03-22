import { Component } from '@angular/core';

import { ExcelExpoService } from './service/excel-expo.service';
import { Person, PERSONS } from './model';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'excelExport';
  persons = PERSONS;

  constructor(private excelExpoService: ExcelExpoService) {
    
  }

  exportToExcel() {
    this.excelExpoService.exportAsExcelFile("name",null, null, this.persons );
  }

}
