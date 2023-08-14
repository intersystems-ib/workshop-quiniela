import { Component } from '@angular/core';
import { IrisService } from '../services/iris.service';
import { UntypedFormControl, UntypedFormGroup, Validators } from '@angular/forms';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';

@Component({
  selector: 'app-results',
  templateUrl: './results.component.html',
  styleUrls: ['./results.component.scss']
})
export class ResultsComponent {

  public matches: Array<any> = []
  public modalMatchTitle: String = "";
  public resultForm = new UntypedFormGroup({
    MatchId: new UntypedFormControl('', {nonNullable: true, validators: [Validators.required]}),
    LocalGoals: new UntypedFormControl('', {nonNullable: true, validators: [Validators.required]}),
    VisitorGoals: new UntypedFormControl('', {nonNullable: true, validators: [Validators.required]})
  })

  constructor(private irisService: IrisService,
    private modalService: NgbModal) {
    
  }

  open(content: any, match: any) {
		this.modalService.open(content, { ariaLabelledBy: 'modal-basic-title' }).result.then(
			(result) => {
			},
			(reason) => {
			},
		);
	}

  ngOnInit(): void {
    this.getMatches();
  }
  
  getMatches(): void {
    this.irisService.getMatches().subscribe({
      next: res => {  
        this.matches = JSON.parse(res.Result.replace("\\",""));
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
      
    },
    error: err => {
      console.error(JSON.stringify(err));
    }
    });
  }

}
