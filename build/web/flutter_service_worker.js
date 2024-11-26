'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".git/COMMIT_EDITMSG": "271dfd9b3b6db5959ad41ef45f436db0",
".git/config": "920a11de313bfb8d93d81f4a3a5b71b6",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/HEAD": "4cf2d64e44205fe628ddd534e1151b58",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-commit.sample": "305eadbbcd6f6d2567e033ad12aabbc4",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/index": "e792f6294304ffaae4c39808ec08a2eb",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "371d34b2f36ce65cf468e9581e1da9cc",
".git/logs/refs/heads/master": "371d34b2f36ce65cf468e9581e1da9cc",
".git/objects/03/325dc3884cfc3a52cce36032d1b69c2fdc1471": "4a563dfe2a0f73104df7f111b12327dd",
".git/objects/08/32d0db2def1613c1c45aa4fe9156a1c6b7d589": "e05df183e5eeaddf39672a2516f9c41d",
".git/objects/13/f8c483ce14299dd681379296fab47efb8f254b": "62cf990da5e00abe715d0eefee88cf51",
".git/objects/1c/c0ab1fb8af134286fa563aae69a8347f337965": "3e9ac326a34f0fbef876aa8603125b14",
".git/objects/1f/45b5bcaac804825befd9117111e700e8fcb782": "7a9d811fd6ce7c7455466153561fb479",
".git/objects/23/cf232e77e2585579b84f854545981167c05c03": "f908bdfa8095577d8144105dd9ea79ee",
".git/objects/25/8b3eee70f98b2ece403869d9fe41ff8d32b7e1": "05e38b9242f2ece7b4208c191bc7b258",
".git/objects/2d/0887a33b5df3ccf51f4b522a0c60338efe270b": "cb4a8551092f650356f1db938eff0f38",
".git/objects/32/aa3cae58a7432051fc105cc91fca4d95d1d011": "4f8558ca16d04c4f28116d3292ae263d",
".git/objects/36/b3345585249885ba01f7c5147d6e35147fb470": "b0fbe1be70e9a812409a8406a2694b57",
".git/objects/39/b7917bcf1b9798517aa2e6f6bf1870ef63ef87": "ce21866229d9ead530b92da1150cb7cc",
".git/objects/3a/7525f2996a1138fe67d2a0904bf5d214bfd22c": "ab6f2f6356cba61e57d5c10c2e18739d",
".git/objects/40/0d5b186c9951e294699e64671b9dde52c6f6a0": "f6bd3c7f9b239e8898bace6f9a7446b9",
".git/objects/44/a8b8e41b111fcf913a963e318b98e7f6976886": "5014fdb68f6b941b7c134a717a3a2bc6",
".git/objects/44/fe50d1712fd16f1234f7b471fdd7c25376f607": "9869def4ba9210dcd5ec138761ccc72b",
".git/objects/46/4ab5882a2234c39b1a4dbad5feba0954478155": "2e52a767dc04391de7b4d0beb32e7fc4",
".git/objects/48/871597b0b76773679d0b4b3e5ffa74e85751ec": "97dc844d8f1c81263e6a3fb7838561aa",
".git/objects/57/f07e3373e14e8a186f060ed3d8d8682acce397": "681841ab04c1b21fb37cfa994214bcf7",
".git/objects/58/d1db307695b60750849a4154c11c5869165d6c": "f17ab58173b659a93ffdefbda55fd965",
".git/objects/5a/8ec6564a34f2f3c78817400de808e8b2351954": "cdf149ac1e061c9a468b15c852ca0898",
".git/objects/63/0f634f7d93ece988014c491ff75320721c477d": "990d05d54fa3e5a707067c2bb38d5ee8",
".git/objects/6b/e909fbf40b23748412f0ea89bf0fae827ed976": "5f118419157d9534688915220cc803f7",
".git/objects/6c/ac85f3400e2c3f41c95757e132aeb8fb0e358f": "e26b119172bd8b4ab8359f585ed88899",
".git/objects/71/27aa8629ca756098a3265d8f08f00d427133b7": "fba479886d12fb6f38be02bbc4518be2",
".git/objects/79/fd3811cd0045cee9a2d6cfd9449edf45dfe68e": "edeb3c1c680bf07d613704c7e15722a2",
".git/objects/84/0516208d35dcb4298847ab835e2ef84ada92fa": "36a4a870d8d9c1c623d8e1be329049da",
".git/objects/84/4d1105cfde15b7906e0491bd6a6f1341e526c2": "aeb140e511212bdb65987716f6efb569",
".git/objects/85/6a39233232244ba2497a38bdd13b2f0db12c82": "eef4643a9711cce94f555ae60fecd388",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/8a/000423adf91b296014da2e51a6ebf3f9f3802c": "0e876742e05dbb14e40e2c5134a326d2",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/8f/739cfb6bcd4977b0560a8f2a8c70ca36fa9bd1": "8d1e4dca1d061265a750c5d1b6b2d01f",
".git/objects/90/bcfcf0a77ab618a826db0fd8b0942963b653af": "fc109675cdf1233dd6599a4c3c0a7a69",
".git/objects/97/3bf0dcec0797c2d12790a15fbca3b0ee811a57": "aa4ac64007a2750cc45000742af26ddd",
".git/objects/98/57c9b3b0448c92818efc5fda0f206b21914168": "ecbde07c564dabbec0f249821051b8af",
".git/objects/9d/814c2c1ca6369871710bb8b8b4541b0712561e": "5b831c344eef2f983dc1ed64ae25b3a6",
".git/objects/b1/5ad935a6a00c2433c7fadad53602c1d0324365": "8f96f41fe1f2721c9e97d75caa004410",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/ba/5317db6066f0f7cfe94eec93dc654820ce848c": "9b7629bf1180798cf66df4142eb19a4e",
".git/objects/be/7df394313fc9ed5bf141c7097329ac23608cd1": "381458c348d83d7a8213346be5da5698",
".git/objects/c2/2b255bb4d664e5712da305ceac0621d5b20ece": "6c4c9cd4bd74714d5162e0fe319c0987",
".git/objects/cb/2fd14e9d09919f47b717164288da4f537414e5": "211f748f761377527b342e61317c6a4e",
".git/objects/d0/23371979cf1e985205df19078051c10de0a82d": "700b71074bad7afee32068791dec7442",
".git/objects/d0/25ef75bdf3960655bd3da467e820e2ddda040f": "38de297eff748ef681ff22110db7ca0f",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/d5/bb50b3c3bc534b51ba035a5e8495ba7af5025b": "81d30e6f235d2cd1960b1a0d917b3043",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/da/fd65422747502c19b5c74b4230282644d2169c": "d8a62caf99a372ff6c7692e143787ce3",
".git/objects/eb/4f2567e02b19dcad5b4f6a7c5fdce074e92524": "17d924d22d06747c0a056816b8032a9b",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/f2/04823a42f2d890f945f70d88b8e2d921c6ae26": "6b47f314ffc35cf6a1ced3208ecc857d",
".git/objects/f2/356c56c1d17912e4db122bdf79f614f460c663": "590e84515ded70988e0c2e5dbf102fbb",
".git/objects/f5/7ad81ae414b688c89b4bcf58ee8d4e1b7004d5": "baa50b901f4a154b752f39ae48890eec",
".git/objects/fa/28fbb675e4c48b7b6998d6d95b4d3d2c8a04db": "9e72a470d9cfa39b00bb8411332d1bf7",
".git/objects/fd/440817dee41fc3c66f8b39f9cd365a949871f5": "60abd276c6897d32eb2934f67ac5975a",
".git/refs/heads/master": "d67ffc288cf96c78b38a00ffe132496a",
"assets/AssetManifest.bin": "00814ceafba271cf7c52be994e44415d",
"assets/AssetManifest.bin.json": "f21a68216f83ba4e4085117054a4c9e0",
"assets/AssetManifest.json": "b635597324e5ec83b5145a3d8b803542",
"assets/assets/dispo.png": "e64687ea84f64b8288c7699ee828845b",
"assets/assets/dispositivo.png": "3aa8de49d47b95989fedd9ba2fa43627",
"assets/assets/icon/icon.png": "5ad284ca75d0deca2a4a1f3a86bfc5a3",
"assets/assets/icon.png": "37045cb2c7b534b214d0d9dcd47af505",
"assets/assets/logo.png": "507692e2e50a5e8db521f7516d19d04a",
"assets/assets/perfil.png": "6f6bbb16aec97391aefe120ec5a4e6a2",
"assets/assets/pool.jpg": "410ab344feb903e756ee9d412d809e3b",
"assets/assets/pool2.jpg": "54927cda0e364d598d8b1f353168686b",
"assets/assets/pool3.jpg": "fe66208f390afa5ce5fb3f493f27562e",
"assets/assets/pool4.jpg": "5cf6e53ce81595fe07c7dafda6dd9d33",
"assets/assets/prueba.png": "5ad284ca75d0deca2a4a1f3a86bfc5a3",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "59084d366e53eb70c736e3dd7c852fcd",
"assets/NOTICES": "87ce6443d4462744f8f73183ad2e09fc",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "f393d3c16b631f36852323de8e583132",
"flutter_bootstrap.js": "68100588f0cbe59d61254c3740c345a6",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/icon.png": "37045cb2c7b534b214d0d9dcd47af505",
"index.html": "7097b834051159913e25f99839e6b172",
"/": "7097b834051159913e25f99839e6b172",
"main.dart.js": "86ec843c4476e01840943dcb30ff6557",
"manifest.json": "aad8e73b4c908c3729b2bf90db659ea2",
"service_worker.js": "694b6f98b30db57e9912f567907f8f8a",
"version.json": "a62f896b3d6234e997180d523f492f30"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
