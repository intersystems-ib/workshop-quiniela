import { ComponentFixture, TestBed } from '@angular/core/testing';

import { PrepareComponent } from './prepare.component';

describe('PrepareComponent', () => {
  let component: PrepareComponent;
  let fixture: ComponentFixture<PrepareComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [PrepareComponent]
    });
    fixture = TestBed.createComponent(PrepareComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
