import { Component } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-prediction',
  templateUrl: './prediction.component.html',
  styleUrls: ['./prediction.component.scss']
})
export class PredictionComponent {
  
  public selectedDivision: String = "1";

  constructor(private router: Router) { }

  refreshResults(value: any) {
    this.selectedDivision = value.division;
  }

  updateDivision(division: String) {
    this.selectedDivision = division;
  }

}


