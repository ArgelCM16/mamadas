self.addEventListener('install', (event) => {
    event.waitUntil(
      caches.open('flutter-app-cache').then((cache) => {
        return cache.addAll([
          '/',
          '/index.html',
          '/main.dart.js',
          '/flutter.js',
          '/manifest.json',
          '/favicon.png',
          '/assets/AssetManifest.json',
          '/assets/FontManifest.json',
          '/assets/fonts/MaterialIcons-Regular.otf',
          '/assets/icons/icon-192.png',
          '/assets/icons/icon-512.png',
          '/assets/...', // Agrega tus recursos estáticos adicionales.
        ]);
      })
    );
  });
  
  self.addEventListener('fetch', (event) => {
    event.respondWith(
      caches.match(event.request).then((response) => {
        return response || fetch(event.request);
      })
    );
  });
  