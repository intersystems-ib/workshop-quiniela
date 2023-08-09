import { Component } from '@angular/core';
import { IrisService } from '../services/iris.service';

@Component({
  selector: 'app-data',
  templateUrl: './data.component.html',
  styleUrls: ['./data.component.scss']
})
export class DataComponent {

  public dataCount: Array<any> = [];
  public totalDataRaw = 0;
  public totalDataPrepared = 0;

  constructor(private irisService: IrisService) {
    
  }

  ngOnInit(): void {
    this.irisService.getStatus("GetDataCount").subscribe({
      next: res => { 
        this.dataCount = JSON.parse(res.Result.replace("\\",""));
        this.totalDataRaw = this.dataCount[0].count;
        this.totalDataPrepared = this.dataCount[1].count;
      },
      error: err => {
        console.error(JSON.stringify(err));
      }
    });
  }
}
