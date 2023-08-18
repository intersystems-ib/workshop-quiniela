import { Component, Input } from '@angular/core';
import { IrisService } from '../services/iris.service';
import { Subscription, switchMap, timer } from 'rxjs';

@Component({
  selector: 'app-train',
  templateUrl: './train.component.html',
  styleUrls: ['./train.component.scss']
})
export class TrainComponent {
  
  @Input() totalData: number = 0;

  loading: boolean = false;
  status: String = "";
  subscription !: Subscription;
  
  constructor(private irisService: IrisService) {
    
  }

  ngOnInit(): void {
    this.refresh();
  }

  launchTraining(): void {
    this.irisService.train().subscribe({
      next: res => {  
        this.loading = true;
        this.subscription = timer(0, 5000).pipe(
          switchMap(() => this.irisService.getStatus("CheckTrain"))
        ).subscribe(result => {
          if (result.Status !== "In Process"){
            this.loading = false;
            this.status = "";
            this.subscription.unsubscribe();
          }       
        }
        );
        
      },
      error: err => {
        console.error(JSON.stringify(err));
      }
    });
  }

  refresh(): void {
    this.irisService.getStatus("CheckTrain").subscribe({
      next: res => { 
        if (res.Status !== "In Process"){
          this.loading = false;
          this.status = "";
        }      
        else {
          this.loading = true;
          this.launchTraining();
        }   
      },
      error: err => {
        console.error(JSON.stringify(err));
      }
    });
  }

  ngOnDestroy() {
    if (this.subscription !== undefined)
    {
      this.subscription.unsubscribe();
    }  
  }
}
