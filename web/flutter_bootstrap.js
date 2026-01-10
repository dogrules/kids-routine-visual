// Flutter web bootstrap loader with service worker support.
if ('serviceWorker' in navigator) {
  window.addEventListener('load', function () {
    navigator.serviceWorker.register('flutter_service_worker.js');
  });
}
