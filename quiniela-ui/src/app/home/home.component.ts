import { Component } from '@angular/core';
import { AuthService } from '../services/auth.service';
import { StorageService } from '../services/storage.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss']
})
export class HomeComponent {

  selection: String = "Prediction"
  
  constructor(private authService: AuthService, 
    private storageService: StorageService,
    private router: Router) { }

  ngOnInit(): void {
  }

  logout(): void {
    this.authService.logout().subscribe({
      next: res => {  
        this.storageService.clean();
        this.router.navigate(['login']);
      },
      error: err => {
        this.storageService.clean();
        this.router.navigate(['login']);
      }
    });
  }

  loadPage(page: String): void {
    this.selection = page;
  }
}
