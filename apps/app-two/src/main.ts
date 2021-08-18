import { enableProdMode } from '@angular/core';
import { platformBrowserDynamic } from '@angular/platform-browser-dynamic';
import * as Sentry from '@sentry/angular';
import { Integrations } from '@sentry/tracing';
import { AppModule } from './app/app.module';
import { environment } from './environments/environment';

if (environment.production) {
  enableProdMode();
}

Sentry.init({
  dsn: '',
  // Sentry allows us to filter data by environment, this is to take advantage of that
  environment: environment.production ? 'Production' : 'Development',
  // Allow Sentry to report what release a bug or performance report came from
  release: environment.version,
  integrations: [
    new Integrations.BrowserTracing({
      // Customize the origins to the urls your app is deployed to.
      tracingOrigins: ['*'],
      // Allow Sentry to know what route is active for performance and bug tracking
      routingInstrumentation: Sentry.routingInstrumentation,
    }),
  ],
  // Percentage of traffic Sentry captures for performance metrics
  // In production, we limit this to a 20% sample rate
  tracesSampleRate: environment.production ? 0.2 : 1.0,
});

platformBrowserDynamic()
  .bootstrapModule(AppModule)
  .catch((err) => console.error(err));
