import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { LoginComponent } from './login/login.component';
import { HomeComponent } from './home/home.component';

import { NgbModule } from '@ng-bootstrap/ng-bootstrap';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { HTTP_INTERCEPTORS, HttpClientModule } from '@angular/common/http';
import { FontAwesomeModule } from '@fortawesome/angular-fontawesome';
import { ImportComponent } from './import/import.component';
import { AuthInterceptor } from './services/auth.interceptor';
import { DataComponent } from './data/data.component';
import { PrepareComponent } from './prepare/prepare.component';
import { ErrorInterceptor } from './services/error.interceptor';
import { TrainComponent } from './train/train.component';
import { PredictionComponent } from './prediction/prediction.component';
import { MatchComponent } from './match/match.component';
import { NgSelectModule } from '@ng-select/ng-select';
import { ResultsComponent } from './results/results.component';

@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    HomeComponent,
    ImportComponent,
    DataComponent,
    PrepareComponent,
    TrainComponent,
    PredictionComponent,
    MatchComponent,
    ResultsComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    FormsModule,
    NgbModule,
    HttpClientModule,
    FontAwesomeModule,
    NgSelectModule,
    FormsModule,
    ReactiveFormsModule
  ],
  providers: [{provide: HTTP_INTERCEPTORS, useClass: AuthInterceptor, multi: true},
    { provide: HTTP_INTERCEPTORS, useClass: ErrorInterceptor, multi: true },],
  bootstrap: [AppComponent]
})
export class AppModule { }
