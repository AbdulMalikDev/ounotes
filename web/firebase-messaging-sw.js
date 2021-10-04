importScripts("https://www.gstatic.com/firebasejs/7.15.5/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/7.15.5/firebase-messaging.js");
importScripts("https://www.gstatic.com/firebasejs/8.8.1/firebase-analytics.js");
importScripts("https://www.gstatic.com/firebasejs/8.8.1/firebase-storage.js");
importScripts("https://www.gstatic.com/firebasejs/8.8.1/firebase-auth.js");
importScripts("https://www.gstatic.com/firebasejs/8.8.1/firebase-firestore.js");
importScripts("https://www.gstatic.com/firebasejs/8.8.1/firebase-functions.js");
importScripts("https://www.gstatic.com/firebasejs/8.8.1/firebase-remote-config.js");

//Using singleton breaks instantiating messaging()
// App firebase = FirebaseWeb.instance.app;


firebase.initializeApp({
    apiKey,
    authDomain,
    databaseURL,
    projectId,
    storageBucket,
    messagingSenderId,
    appId,
    measurementId,
});

const messaging = firebase.messaging();
messaging.setBackgroundMessageHandler(function (payload) {
    const promiseChain = clients
        .matchAll({
            type: "window",
            includeUncontrolled: true
        })
        .then(windowClients => {
            for (let i = 0; i < windowClients.length; i++) {
                const windowClient = windowClients[i];
                windowClient.postMessage(payload);
            }
        })
        .then(() => {
            return registration.showNotification("New Message");
        });
    return promiseChain;
});
self.addEventListener('notificationclick', function (event) {
    console.log('notification received: ', event)
});