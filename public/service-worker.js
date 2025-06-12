// //Add a service worker for processing Web Push notifications:

// self.addEventListener("push", async (event) => {
//   const { title, options } = await event.data.json()
//   event.waitUntil(self.registration.showNotification(title, options))
// })

// self.addEventListener("notificationclick", function(event) {
//   event.notification.close()
//   event.waitUntil(
//     clients.matchAll({ type: "window" }).then((clientList) => {
//       for (let i = 0; i < clientList.length; i++) {
//         let client = clientList[i]
//         let clientPath = (new URL(client.url)).pathname

//         if (clientPath == event.notification.data.path && "focus" in client) {
//           return client.focus()
//         }
//       }

//       if (clients.openWindow) {
//         return clients.openWindow(event.notification.data.path)
//       }
//     })
//   )
// })

const CACHE_NAME = 'v1';
const ASSETS_TO_CACHE = [
  '/',
  '/assets/application-2e41d586.css',
  '/assets/application-487c08dc.js',
  '/icon-192.png',
  '/icon-512.png'
];

self.addEventListener('install', e => {
  e.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => cache.addAll(ASSETS_TO_CACHE))
      .then(() => self.skipWaiting())
  );
});

self.addEventListener('activate', e => {
  // Clean up old caches if you change CACHE_NAME
  e.waitUntil(self.clients.claim());
});

self.addEventListener('fetch', event => {
  const url = event.request.url;
  if (url.startsWith('https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js')) {
    event.respondWith(
      caches.match(event.request)
        .then(cached => cached || fetch(event.request).then(networkRes => {
          caches.open(CACHE_NAME).then(cache => cache.put(event.request, networkRes.clone()));
          return networkRes;
        }))
    );
    return;
  }
  event.respondWith(
    caches.match(event.request)
      .then(cached => cached || fetch(event.request))
  );
});;

