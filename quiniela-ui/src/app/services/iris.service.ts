import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';

const IRIS_API = 'api/quiniela/';

let httpOptions = {
  headers: new HttpHeaders({ 'Content-Type': 'application/json' })
};

@Injectable({
  providedIn: 'root',
})
export class IrisService {
  
  constructor(private http: HttpClient) {}

  import(): Observable<any> {
    return this.http.get<Response>(
      IRIS_API + 'import', httpOptions
    )
  }

  prepare(): Observable<any> {
    return this.http.get<Response>(
      IRIS_API + 'prepare', httpOptions
    )
  }

  train(): Observable<any> {
    return this.http.get<Response>(
      IRIS_API + 'train', httpOptions
    )
  }

  getStatus(type: String): Observable<any> {
    return this.http.get<Response>(
      IRIS_API + 'getStatus/'+type, httpOptions
    )
  }

  getTeams(): Observable<any> {
    return this.http.get<Response>(
      IRIS_API + 'getTeams', httpOptions
    )
  }

  getReferees(): Observable<any> {
    return this.http.get<Response>(
      IRIS_API + 'getReferees', httpOptions
    )
  }

  saveMatch(match: any): Observable<any> {
    return this.http.post<Response>(
      IRIS_API + 'saveMatch',match
    )
  }

  saveResult(match: any): Observable<any> {
    return this.http.post<Response>(
      IRIS_API + 'saveResult',match
    )
  }

  getMatches(division: String): Observable<any> {
    return this.http.get<Response>(
      IRIS_API + 'getMatches/' + division, httpOptions
    )
  }

  deleteMatch(matchId: number): Observable<any> {
    return this.http.delete<Response>(
      IRIS_API + 'deleteMatch/' + matchId, httpOptions
    )
  }
}