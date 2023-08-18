import { Component, Input } from '@angular/core';
import { IrisService } from '../services/iris.service';
import { Subscription, timer } from 'rxjs';
import { switchMap } from 'rxjs/operators';
import { Router } from '@angular/router';

@Component({
  selector: 'app-prepare',
  templateUrl: './prepare.component.html',
  styleUrls: ['./prepare.component.scss']
})
export class PrepareComponent {

  @Input() totalData: number = 0;

  loading: boolean = false;
  status: String = "";
  subscription !: Subscription;
  
  constructor(private irisService: IrisService) {
    
  }

  ngOnInit(): void {
    this.refresh();
  }

  launchPreparation(): void {
    this.irisService.prepare().subscribe({
      next: res => {  
        this.loading = true;
        this.subscription = timer(0, 5000).pipe(
          switchMap(() => this.irisService.getStatus("CheckPrepare"))
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
    this.irisService.getStatus("CheckPrepare").subscribe({
      next: res => { 
        if (res.Status !== "In Process"){
          this.loading = false;
          this.status = "";
        }  
        else {
          this.loading = true;
          this.launchPreparation();
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
