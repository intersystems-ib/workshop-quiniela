import { Component } from '@angular/core';
import { IrisService } from '../services/iris.service';
import { Subscription, switchMap, timer } from 'rxjs';

@Component({
  selector: 'app-data',
  templateUrl: './data.component.html',
  styleUrls: ['./data.component.scss']
})
export class DataComponent {

  public dataCount: Array<any> = [];
  public totalDataRaw = 0;
  public totalDataPrepared = 0;
  public totalOfModelsCreated = 0;
  public totalOfModelsTrained = 0;

  subscription !: Subscription;

  constructor(private irisService: IrisService) {
    
  }

  ngOnInit(): void {

    this.subscription = timer(0, 10000).pipe(switchMap(() => this.irisService.getStatus("GetDataCount"))).subscribe(res => {
      this.dataCount = JSON.parse(res.Result.replace("\\",""));
      this.totalDataRaw = this.dataCount[0].count;
      this.totalDataPrepared = this.dataCount[1].count;
      this.totalOfModelsCreated = this.dataCount[2].count;
      this.totalOfModelsTrained = this.dataCount[3].count;       
    }
    );
        
  }

  ngOnDestroy() {
    if (this.subscription !== undefined)
    {
      this.subscription.unsubscribe();
    }    
  }
}
