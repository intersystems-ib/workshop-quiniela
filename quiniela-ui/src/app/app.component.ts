import { Component } from '@angular/core';
import { AuthService } from './services/auth.service';
import { fas } from '@fortawesome/free-solid-svg-icons';
import { FaIconLibrary } from '@fortawesome/angular-fontawesome';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {
  title = 'quiniela-ui';
  username?: string;

  constructor(library: FaIconLibrary) {
    library.addIconPacks(fas);
   }

  ngOnInit(): void {
  }

}
