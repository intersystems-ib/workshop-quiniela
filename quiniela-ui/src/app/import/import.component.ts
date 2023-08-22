import { Component } from '@angular/core';
import { IrisService } from '../services/iris.service';
import { Subscription, timer } from 'rxjs';
import { switchMap } from 'rxjs/operators';
import { Router } from '@angular/router';

@Component({
  selector: 'app-import',
  templateUrl: './import.component.html',
  styleUrls: ['./import.component.scss']
})
export class ImportComponent {

  loading: boolean = false;
  status: String = "";
  subscription !: Subscription;
  
  constructor(private irisService: IrisService) {
    
  }

  ngOnInit(): void {
    this.refresh();
  }

  launchImport(): void {
    this.irisService.import().subscribe({
      next: res => {  
        this.loading = true;
        this.subscription = timer(0, 5000).pipe(
          switchMap(() => this.irisService.getStatus("CheckImport"))
        ).subscribe(result => {
          if (result.Status !== "In Process" && result.Status !== undefined){
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
    this.irisService.getStatus("CheckImport").subscribe({
      next: res => { 
        if (res.Status !== "In Process"){
          this.loading = false;
          this.status = "";
        }
        else {
          this.loading = true;
          this.launchImport();
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

