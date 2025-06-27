import { ComponentFixture, TestBed } from '@angular/core/testing';
import { By } from '@angular/platform-browser';
import { ButtonComponent } from './button.component';

describe('ButtonComponent', () => {
  let component: ButtonComponent;
  let fixture: ComponentFixture<ButtonComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [ButtonComponent],
    }).compileComponents();

    fixture = TestBed.createComponent(ButtonComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });

  it('should render button with default variant and size', () => {
    const button = fixture.debugElement.query(By.css('button'));
    expect(button.nativeElement.className).toContain('primary');
    expect(button.nativeElement.className).toContain('md');
  });

  it('should render button with specified variant', () => {
    component.variant = 'secondary';
    fixture.detectChanges();
    const button = fixture.debugElement.query(By.css('button'));
    expect(button.nativeElement.className).toContain('secondary');
  });

  it('should render button with specified size', () => {
    component.size = 'lg';
    fixture.detectChanges();
    const button = fixture.debugElement.query(By.css('button'));
    expect(button.nativeElement.className).toContain('lg');
  });

  it('should show loading state', () => {
    component.isLoading = true;
    fixture.detectChanges();
    expect(fixture.debugElement.query(By.css('svg'))).toBeTruthy();
    expect(fixture.nativeElement.textContent).toContain('Loading...');
  });

  it('should apply full width class when isFullWidth is true', () => {
    component.isFullWidth = true;
    fixture.detectChanges();
    const button = fixture.debugElement.query(By.css('button'));
    expect(button.nativeElement.className).toContain('full-width');
  });

  it('should emit click event when not disabled or loading', () => {
    const spy = jasmine.createSpy('buttonClick');
    component.buttonClick.subscribe(spy);

    const button = fixture.debugElement.query(By.css('button'));
    button.nativeElement.click();
    expect(spy).toHaveBeenCalled();
  });

  it('should not emit click event when disabled', () => {
    component.disabled = true;
    fixture.detectChanges();

    const spy = jasmine.createSpy('buttonClick');
    component.buttonClick.subscribe(spy);

    const button = fixture.debugElement.query(By.css('button'));
    button.nativeElement.click();
    expect(spy).not.toHaveBeenCalled();
  });

  it('should not emit click event when loading', () => {
    component.isLoading = true;
    fixture.detectChanges();

    const spy = jasmine.createSpy('buttonClick');
    component.buttonClick.subscribe(spy);

    const button = fixture.debugElement.query(By.css('button'));
    button.nativeElement.click();
    expect(spy).not.toHaveBeenCalled();
  });
});
