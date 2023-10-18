import { Component, Input, OnChanges, SimpleChanges } from '@angular/core';
import { IrisService } from '../services/iris.service';
import { UntypedFormControl, UntypedFormGroup, Validators } from '@angular/forms';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';

@Component({
  selector: 'app-results',
  templateUrl: './results.component.html',
  styleUrls: ['./results.component.scss']
})
export class ResultsComponent implements OnChanges{

  @Input() division: String = "1";

  public matches: Array<any> = []
  public modalMatchTitle: String = "";
  public resultForm = new UntypedFormGroup({
    MatchId: new UntypedFormControl('', {nonNullable: true, validators: [Validators.required]}),
    LocalGoals: new UntypedFormControl('', {nonNullable: true, validators: [Validators.required]}),
    VisitorGoals: new UntypedFormControl('', {nonNullable: true, validators: [Validators.required]})
  })

  public selectedMatch: any;

  constructor(private irisService: IrisService,
    private modalService: NgbModal) {
    
  }

  open(content: any, match: any) {
    this.selectedMatch = match;
    this.matchSelected(match);
		this.modalService.open(content, { ariaLabelledBy: 'modal-basic-title' }).result.then(
			(result) => {
			},
			(reason) => {
			},
		);
	}

  ngOnChanges(changes: SimpleChanges) {
    this.getMatches();
  }

  ngOnInit(): void {
    this.getMatches();
  }
  
  getMatches(): void {
    this.irisService.getMatches(this.division).subscribe({
      next: res => {  
        this.matches = JSON.parse(res.Result.replace("\\",""));
      },
      error: err => {
        console.error(JSON.stringify(err));
      }
    });
  }

  deleteMatch(matchId: number): void {
    this.irisService.deleteMatch(matchId).subscribe({
      next: res => {  
        this.getMatches();
      },
      error: err => {
        console.error(JSON.stringify(err));
      }
    });
  }

  matchSelected(match: any): void {
    this.modalMatchTitle = match.local +" - "+match.visitor;
    this.localGoals?.setValue(match.localGoals);
    this.visitorGoals?.setValue(match.visitorGoals);
    this.matchId?.setValue(match.id)
  }

  get localGoals() {
    return this.resultForm.get('LocalGoals');
  }
 
  get visitorGoals() {
    return this.resultForm.get('VisitorGoals');
  }
  
  get matchId() {
    return this.resultForm.get('MatchId');
  }

  onSubmit(): void {
    
    const resultData = {
      "LocalGoals": this.localGoals?.value, 
      "VisitorGoals": this.visitorGoals?.value, 
      "MatchId": this.matchId?.value, 
    };

    this.irisService.saveResult(resultData).subscribe({next: res => {  
      this.getMatches();
    },
    error: err => {
      console.error(JSON.stringify(err));
    }
    });
  }

}
