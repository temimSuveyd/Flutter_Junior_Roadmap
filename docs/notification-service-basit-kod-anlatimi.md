# Bildirim (Notification) Servisi — Kod Nasıl Çalışıyor? (Çok Basit Anlatım)

Bu doküman, `lib/core/services/notifications/` içindeki kodu satır satır, basitçe anlatır. Önce ne işe yaradığını, sonra her parçayı tek tek okuyalım.

---

## 1) Önce Sorunu Anlayalım (benzetme ile)

Telefonunuzun **postacısı** var. Sunucu size bir mektup (bildirim) gönderince postacı kapıya gelir.

- Uygulama **açıkken** gelirse → mektubu elinizle alırsınız (ön plan).
- Uygulama **arkada** çalışırken gelirse → zili çalar, tıklayınca içeri girersiniz (arka plan tıklaması).
- Uygulama **kapalıyken** gelirse → telefonu açınca postacı "al bakalım bu mektup" der (başlangıç mesajı).

Bizim kodumuz bu üç durumu da yakalar, token (cihaz kimliği) alır ve gerekirse sizi doğru sayfaya yönlendirir.

---

## 2) Dosya Haritası

| Dosya | Ne işe yarar |
| --- | --- |
| `notification_service.dart` | Bildirim mantığı. **Arayüz** + onun **gerçek çalışan** hâli. |
| `firebase_initializer.dart` | Firebase'i başlatan küçük yardımcı. |

> **Arayüz (interface) ne demek?** `abstract class` = "böyle bir şey olacak" diyen sözleşme. Gerçek işi yapan ayrı bir sınıf `implements` ile uygular. Testte kolayca taklit (mock) edilebilir.

---

## 3) `notification_service.dart` — arayüz

```dart
abstract class NotificationService {
  void setRouter(GoRouter router);
  Future<void> initializeNotificationPipeline();
}
```

| Satır | Anlamı |
| --- | --- |
| `abstract class NotificationService` | Sözleşme: "bildirim servisi şunları yapabilmeli" diyoruz. |
| `setRouter(GoRouter router)` | "Bildirime tıklayınca **nereye gideceğini** söyle" diyen metot. |
| `initializeNotificationPipeline()` | "Başlat: izin iste, token al, dinlemeye başla" diyen metot. |

---

## 4) `notification_service.dart` — çalışan kısım (FirebaseNotificationService)

```dart
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("تم القبض على الإخطار في الخلفية: ${message.messageId}");
  }
}
```

| Parça | Anlamı |
| --- | --- |
| `_firebaseMessagingBackgroundHandler` | Uygulama **tamamen kapalıyken** bildirim gelirse çalışan fonksiyon. Üstte (`top-level`) olmalı. |
| `@pragma('vm:entry-point')` | Release (yayın) sürümünde bu fonksiyonun **silinmesini engeller**. Olmazsa kapalıyken bildirim çalışmaz. |
| `print(...)` | Şimdilik sadece yazdırıyor. İleride burada token kaydetme/işlem yapılabilir. |

### 4.1) Sınıf ve kurucu

```dart
class FirebaseNotificationService implements NotificationService {
  FirebaseNotificationService(this._fcmTokenManager);

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FcmTokenManager _fcmTokenManager;
  GoRouter? _router;
```

| Parça | Anlamı |
| --- | --- |
| `implements NotificationService` | "Sözleşmedeki metotları ben yapacağım" demek. |
| `FirebaseMessaging.instance` | Firebase'in bildirim motoruna doğrudan bağlanıyoruz. |
| `_fcmTokenManager` | Token'ı hafızaya kaydedecek alet (ayrı bir soyut sınıf). |
| `GoRouter? _router` | Yönlendirme aracı. `?` = başta boş olabilir. |

### 4.2) `setRouter` — yönlendirmeyi bağla

```dart
@override
void setRouter(GoRouter router) {
  _router = router;
}
```

| Satır | Anlamı |
| --- | --- |
| `_router = router` | Dışarıdan gelen router'ı içeri kaydederiz. Artık bildirime tıklayınca onu kullanabiliriz. |

### 4.3) `initializeNotificationPipeline` — ana başlatma

```dart
await _messaging.requestPermission(alert: true, badge: true, sound: true);
```

| Satır | Anlamı |
| --- | --- |
| `requestPermission(...)` | Kullanıcıdan **bildirim izni** ister (iOS ve Android 13+ için şart). |

```dart
String? token = await _messaging.getToken();
if (token != null) {
  await _fcmTokenManager.saveToken(token);
}
```

| Satır | Anlamı |
| --- | --- |
| `getToken()` | Cihazın **FCM token**'ını alır (sunucu bununla size mesaj yollar). |
| `saveToken(token)` | Token'ı hafızaya yazar ki ileride sunucuya gönderebilesiniz. |

```dart
_messaging.onTokenRefresh.listen((String newToken) async {
  await _fcmTokenManager.saveToken(newToken);
});
```

| Satır | Anlamı |
| --- | --- |
| `onTokenRefresh` | Token değişirse (nadiren olur) otomatik yakalar, yeni halini kaydeder. |

```dart
FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
```

| Satır | Anlamı |
| --- | --- |
| `onBackgroundMessage(...)` | Kapalıyken gelen mesajlarda yukarıdaki handler'ı devreye sokar. |

```dart
FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  if (kDebugMode) log("app open: ${message.notification?.title}");
});
```

| Satır | Anlamı |
| --- | --- |
| `onMessage` | Uygulama **açıkken** bildirim geldiğinde çalışır. Şimdilik sadece yazdırıyor (TODO: snackbar göster). |

```dart
FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  _handleDeepLinkNavigation(message);
});
```

| Satır | Anlamı |
| --- | --- |
| `onMessageOpenedApp` | Bildirime **arka plandayken tıklayınca** çalışır → yönlendirme yapar. |

```dart
RemoteMessage? initialMessage = await _messaging.getInitialMessage();
if (initialMessage != null) {
  _handleDeepLinkNavigation(initialMessage);
}
```

| Satır | Anlamı |
| --- | --- |
| `getInitialMessage()` | Uygulama **kapalıyken** bildirime tıklanıp açıldıysa o mesajı verir → yönlendirir. |

### 4.4) Yönlendirme: `_handleDeepLinkNavigation`

```dart
void _handleDeepLinkNavigation(RemoteMessage message) {
  Map<String, dynamic> data = message.data;
  if (data.containsKey('page') && _router != null) {
    String targetPage = data['page'] as String;
    if (targetPage == 'profile') {
      _router!.go(AppRoutes.profile);
    }
  }
}
```

| Satır | Anlamı |
| --- | --- |
| `message.data` | Sunucunun gönderdiği ek bilgi (örn. `{"page": "profile"}`). |
| `data.containsKey('page')` | Mesajda hedef sayfa var mı? |
| `_router != null` | Router bağlanmış mı? (Bağlanmadıysa hiçbir yere gitmez.) |
| `_router!.go(AppRoutes.profile)` | Kullanıcıyı profil sayfasına yönlendirir. |

---

## 5) `firebase_initializer.dart` — küçük yardımcı

```dart
class FirebaseInitializer {
  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }
}
```

| Satır | Anlamı |
| --- | --- |
| `WidgetsFlutterBinding.ensureInitialized()` | Firebase gibi native (telefon) kodlarından önce Flutter'ı hazırlar. |
| `Firebase.initializeApp()` | Firebase'i başlatır. (Projede `main.dart` zaten `DefaultFirebaseOptions` ile başlatıyor.) |

---

## 6) Bağlantı Yerleri (çok önemli)

Kodun çalışması için iki yerde **çağrılması şart**:

| Nerede | Ne yapılır |
| --- | --- |
| `lib/main.dart` | `getIt<NotificationService>().initializeNotificationPipeline();` → izin/token/dinleme başlar. |
| `lib/core/di/injection.dart` | `getIt<NotificationService>().setRouter(getIt<GoRouter>());` → router bağlanır, deep link çalışır. |
| `injection.dart` (kayıt) | `registerLazySingleton<NotificationService>(() => FirebaseNotificationService(getIt<FcmTokenManager>()));` → arayüz olarak kayıt. |

> **Dikkat:** `initializeNotificationPipeline()` veya `setRouter()` unutulursa bildirim ya hiç çalışmaz ya da tıklayınca sayfa açılmaz.

---

## 7) Özet: Kullanıcı ne görür?

1. Uygulama açılır → izin sorusu çıkar (ilk seferde).
2. Cihaz token'ı alınır, hafızaya yazılır.
3. Bildirim gelirse:
   - Açıkken → ekrana yazılır (snackbar eklenecek).
   - Arkada/ kapalıyken tıklanınca → `data['page']` neyse o sayfaya gidilir (örn. profil).

---

## 8) Hızlı tekrar — mini sözlük

| Terim | Ne demek |
| --- | --- |
| FCM Token | Cihazın bildirim kimliği; sunucu bununla size mesaj yollar. |
| `requestPermission` | Kullanıcıdan bildirim izni isteme. |
| `onMessage` | Uygulama açıkken gelen bildirim. |
| `onMessageOpenedApp` | Arkadayken bildirime tıklanması. |
| `getInitialMessage` | Kapalıyken bildirimle açılış. |
| Deep Link | Bildirim verisine göre kullanıcıyı doğru sayfaya yönlendirme. |
| `abstract class` | Sözleşme; gerçek işi `implements` eden sınıf yapar. |
| `GoRouter` | Sayfalar arası geçişi yöneten yönlendirici. |
