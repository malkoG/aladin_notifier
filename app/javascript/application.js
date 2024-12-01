// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import { createApp } from 'vue';
import Counter from './components/Counter.vue';

document.addEventListener('DOMContentLoaded', () => {
  const app = createApp({});
  app.component('Counter', Counter);
  app.mount('#vue-app');
});
