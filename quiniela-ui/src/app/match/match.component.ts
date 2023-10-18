import { Component, EventEmitter, Output } from '@angular/core';
import { Router } from '@angular/router';
import { IrisService } from '../services/iris.service';
import { FormBuilder, FormControl, FormGroup, UntypedFormControl, UntypedFormGroup, Validators } from '@angular/forms';

@Component({
  selector: 'app-match',
  templateUrl: './match.component.html',
  styleUrls: ['./match.component.scss']
})
export class MatchComponent {

  @Output() newMatchEvent = new EventEmitter<any>();

  public referees: Array<String> = [];
  public teams: Array<String> = [];
  public selectedReferee: String = "";
  public selectedLocalTeam: String = "";
  public selectedVisitorTeam: String = "";
  public dateValue: Date;
  
  public matchForm = new UntypedFormGroup({
    LocalTeam: new UntypedFormControl('', {nonNullable: true, validators: [Validators.required]}),
    VisitorTeam: new UntypedFormControl('', {nonNullable: true, validators: [Validators.required]}),
    Referee: new UntypedFormControl(''),
    Day: new UntypedFormControl('', {nonNullable: true, validators: [Validators.required]}),
    Journey: new UntypedFormControl('', {nonNullable: true, validators: [Validators.required]}),
    Division: new UntypedFormControl('', {nonNullable: true, validators: [Validators.required]})
  })

  constructor(private irisService: IrisService) {
    
      this.dateValue = new Date();
  }

  ngOnInit(): void {
    this.loadReferees();
    this.loadTeams();
  }

  get referee() {
    return this.matchForm.get('Referee');
  }
 
  get localTeam() {
    return this.matchForm.get('LocalTeam');
  }
  
  get visitorTeam() {
    return this.matchForm.get('VisitorTeam');
  }
  
  get day() {
    return this.matchForm.get('Day');
  }
  
  get division() {
    return this.matchForm.get('Division');
  }
  
  get journey() {
    return this.matchForm.get('Journey');
  }
  
  loadReferees(): void {
    this.irisService.getReferees().subscribe({
      next: res => {  
        this.referees = JSON.parse(res.Result.replace("\\",""));
      },
      error: err => {
        console.error(JSON.stringify(err));
      }
    });
  }

  loadTeams(): void {
    this.irisService.getTeams().subscribe({
      next: res => {  
        this.teams = JSON.parse(res.Result.replace("\\",""));
      },
      error: err => {
        console.error(JSON.stringify(err));
      }
    });
  }

  onSubmit(): void {
    
    this.newMatchEvent.emit({division: ''});
    const matchData = {
      "Journey": this.journey?.value, 
      "LocalTeam": this.localTeam?.value, 
      "VisitorTeam": this.visitorTeam?.value, 
      "Day": this.day?.value.year+'-'+('0'+this.day?.value.month).slice(-2)+'-'+('0'+this.day?.value.day).slice(-2), 
      "Division": this.division?.value, 
      "Referee":this.referee?.value
    };
    
    this.irisService.saveMatch(matchData).subscribe({next: res => {
      if (res.Status == "Finished"){
        this.newMatchEvent.emit({division: this.division?.value});
        this.matchForm.get("VisitorTeam")?.setValue("");
        this.matchForm.get("LocalTeam")?.setValue("");
        this.matchForm.get("Referee")?.setValue("");
      }      
    },
    error: err => {
      console.error(JSON.stringify(err));
    }
  });
  }
}
