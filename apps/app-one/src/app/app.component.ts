import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'nx-with-sentry-demo-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss'],
})
export class AppComponent implements OnInit {
  title = 'app-one';

  ngOnInit() {
    // trigger new build
    throw new Error('Very suspicious error');
  }
}
