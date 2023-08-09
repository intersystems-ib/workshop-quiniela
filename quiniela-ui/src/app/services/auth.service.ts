import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface Response {
  access_token: string,
  refresh_token: string,
  sub: string,
  iat: string,
  exp: string
}

const AUTH_API = 'api/quiniela/';

let httpOptions = {
  headers: new HttpHeaders({ 'Content-Type': 'application/json' })
};

@Injectable({
  providedIn: 'root',
})
export class AuthService {
  public tokenValue: string;
  constructor(private http: HttpClient) {
    this.tokenValue = "";
  }

  login(username: string, password: string): Observable<any> {
    return this.http.post<Response>(
      AUTH_API + 'login',
      {
        "user": username,
        "password": password,
      },
      httpOptions
    )
  }

  logout(): Observable<any> {
    return this.http.post(AUTH_API + 'logout', { }, httpOptions);
  }
}