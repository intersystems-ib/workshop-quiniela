import { Component } from '@angular/core';
import { AuthService } from '../services/auth.service';
import { StorageService } from '../services/storage.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent {
  form: any = {
    username: null,
    password: null
  };
  isLoggedIn = false;
  isLoginFailed = false;
  errorMessage = '';

  constructor(private authService: AuthService, 
    private storageService: StorageService,
    private router: Router) { }

  ngOnInit(): void {
    if (this.storageService.isLoggedIn()) {
      this.isLoggedIn = true;
      this.router.navigate(['home']);
    }
  }

  onSubmit(): void {
    const { username, password } = this.form;

    this.authService.login(username, password).subscribe({
      next: data => {
        this.storageService.save(data.access_token)
        this.isLoggedIn = true;
        this.router.navigate(['home']);
      },
      error: err => {
      }
    });
  }

  reloadPage(): void {
    window.location.reload();
  }
}
