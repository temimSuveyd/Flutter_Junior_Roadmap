# Proje Detaylı İnceleme Raporu (Code Review Report)
**Dosya Yolu:** `doc/review_report.md`
**Denetleyen:** Kıdemli Yazılım Mimarı (AI Senior Architect)

---

## 1. Mantıksal Hatalar (Logical Errors)

- **`SignInResponseDto.fromJson` yanlış JSON anahtarı okuyor (KRİTİK).**
  `lib/features/auth/data/dtos/sign_in/sign_in_response_dto.dart:9-11`
  ```dart
  accessToken: json['refresh_token'] as String?,
  refreshToken: json['refresh_token'] as String?,
  ```
  Hem `accessToken` hem `refreshToken` aynı `refresh_token` anahtarından okunuyor. `accessToken` değeri aslında `access_token` olmalıydı. Sonuç: `AuthInterceptor` (`auth_interceptor.dart:16`) yanlış (refresh) token'ı `Bearer` olarak gönderir → API 401 döner → oturum açma akışı tamamen kırılır. Bu tek satır tüm kimlik doğrulamayı çalışmaz hale getirir.

- **Token yenileme anahtarı uyumsuz (KRİTİK).**
  `lib/features/auth/data/services/auth_service.dart:67` `data['accessToken']` (camelCase) okunuyor; ancak backend (escuelajs) `access_token` (snake_case) döndürür. `TokenRefreshInterceptor` (`token_refresh_interceptor.dart:79-90`) her zaman `null` alır → `_tokenManager.clearTokens()` → kullanıcı zorla çıkışa düşürülür.

- **Ürün cache temizleme TÜM SharedPreferences'ı siler (KRİTİK).**
  `lib/features/products/data/services/local_product_services.dart:47`
  ```dart
  Future<void> clearProductCache() async {
    await _prefs.clear(); // Tüm uygulama verisi silinir!
  }
  ```
  `ProductRepositoryImpl.getProducts` (`product_repositories.dart:40`) bunu her çevrimiçi ilk yüklemede çağırır. Böylece ürünler yüklendikten hemen sonra kullanıcı profili, FCM token, dil ve tema kayıtları silinir → kullanıcı "çıkış yapmış" sayılır, dil/tema sıfırlanır. `remove(_cacheKey)` olmalıydı.

- **`uploadAvatar` uç noktası çift ön ek içeriyor.**
  `lib/core/services/network/api_endpoints.dart:16` `static const String uploadAvatar = '/api/v1/files/upload';`
  `baseUrl` zaten `https://api.escuelajs.co/api/v1` olduğundan nihai URL `/api/v1/api/v1/files/upload` olur → avatar yükleme her zaman başarısız.

- **`registerUser` token kaydetmiyor / oturum açmıyor.**
  `lib/features/auth/data/repositories/auth_repository.dart:72-85` Kayıt yanıtı yok sayılır, token saklanmaz, kullanıcı giriş yapmış sayılmaz.

- **Sayfalama limiti tutarsızlığı.**
  Servis `limit: 20` kullanırken (`remote_product_services.dart:19`), iç içe `ProductBloc` `_limit = 10` ile `hasReachedMax: data.length < _limit` hesaplar (`product_bloc/product_bloc.dart:53,175`). 20 öğe dönerse sonsuz/yanlış "daha fazla yükle" tetiklenir.

- **`SearchBloc` sorgu uzunluğu kontrolü emit'ten sonra.**
  `search_bloc.dart:39-44` `if (query.isEmpty) emit(SearchInitial());` sonra `if (query.length < 2) return;` → 1 karakterlik sorgu yine de `SearchLoading` ile ağ çağrısı yapar.

- **`product_card` sınır/ tip kontrolü yok.**
  `lib/features/products/presentation/widgets/shared/product_card.dart:31` `product.image[0]` — `image` bir `List<dynamic>`; liste boşsa `RangeError`, eleman `String` değilse runtime hatası. `errorBuilder` hiç devreye girmez.

- **Bildirim derin bağlantısında güvensiz cast.**
  `lib/core/services/notifications/notification_service.dart:78` `String targetPage = data['page'] as String;` — tip uyuşmazlığında crash. `as String?` olmalı.

- **`removeAvatar` yalnızca yerelde çalışır.**
  `lib/features/profile/data/repositories/profile_repository.dart:81-89` Sunucuya silme isteği gönderilmez; sunucu eski avatar URL'sini tutmaya devam eder.

---

## 2. Mimari Hatalar (Architectural Errors)

- **`DioClient` ↔ `AuthService` döngüsel bağımlılık.** `DioClient` constructor'ı `refreshTokenProvider: () => getIt<AuthService>()` alır; `AuthService` ise `DioClient` gerektirir. Sıkı çift yönlü bağlılık, test edilebilirliği zorlaştırır.

- **Aynı isimde iki ayrı `ProductBloc` sınıfı.** `lib/features/products/presentation/bloc/product_bloc.dart` ve `lib/features/products/presentation/bloc/product_bloc/product_bloc.dart` — ikisi de `ProductBloc extends Bloc<ProductEvent, ProductState>` tanımlar ama farklı `part` ağaçlarına sahiptir. `home_body.dart` iç içe olanı import eder; `app_router.dart`/`injection.dart`/`mobile_home_body.dart` ise üst seviyedekini sağlar. Çalışma zamanında `context.read<ProductBloc>()` yanlış tipi arar → `ProviderNotFoundException`.

- **Router `redirect` tamamen yoruma alınmış.** `lib/core/routing/app_router.dart:56-70` Kimlik doğrulama koruması yok; token varlığı hiç kontrol edilmez, herkes `/home` ve `/profile`'a ulaşabilir.

- **`ProductDetailsBloc` / `SearchBloc` hiç sağlanmıyor.** Bu bloc'lar ne `GetIt`'e kayıtlı ne de sayfada `BlocProvider` ile sarılmış (`product_details_page.dart:26`, `search_page.dart:62` sadece `BlocBuilder`/`context.read` kullanır). Sayfaya ulaşılsa bile anında crash.

- **`CategoryList` tamamen bağlantısız.** `lib/features/products/presentation/widgets/shared/category_list.dart` sabit `mock_data.dart` kullanır, bloc'a abone değildir, dokunma (tap) işleyicisi yoktur → kategori filtresi UI'da çalışmaz; iç içe `ProductBloc`'taki `CategorySelected` ölüdür.

- **Bloc'lar `registerFactory` ile tutulup `BlocProvider(create: () => getIt<X>())` ile kullanılıyor.** `lib/core/di/injection.dart:121-130` Her `getIt<X>()` çağrısı yeni instance üretir; başka yerden çağrılırsa farklı instance → tutarsız durum. Bloc'lar widget yaşam döngüsüne bağlı `BlocProvider` ile oluşturulmalı.

- **`NetworkInfo` mixin'i gerçek bağlantı kontrolü yapmıyor.** `lib/core/services/network/network_info.dart:4-11` `InternetAddress.lookup('google.com')` (hard-coded DNS) başarılı olsa bile gerçek API erişimini garanti etmez.

---

## 3. Yazım ve Format Hataları (Syntax/Formatting Errors)

- **Dosya adı yazım hatası:** `lib/features/products/data/dtos/product_responce.dart` ("responce"). Doğru yazılışlı `product_response.dart` ise ölü dosyadır (hiç import edilmez).
- **Sabit adı yazım hatası:** `lib/core/constants/app_constants.dart:33` `authBackgroundImapge` ("Imapge").
- **Karışık dilde yorumlar:** Arapça/Türkçe/İngilizce yorumlar tutarsız şekilde dağılmış (ör. `profile_bloc.dart:11`, `injection.dart:80`, `notification_service.dart`, `app_constants.dart:5`). Profesyonel değildir.
- **Gereksiz boş satırlar:** `auth_state.dart:15-18`, `product_state.dart` sonu, `search_bloc.dart:23-24`.
- **Ölü yorum satırı:** `sign_up_request_dto.dart:18` `// if (avatar != null)`.
- **Tip parametresi sınıf adını gölgülüyor:** `search_bloc.dart:25-31` metod `debounceAndRestartable<SearchEvent>` tip parametresi gerçek `SearchEvent` sınıfını gölgüler; `// ignore: avoid_types_as_parameter_names` ile kapatılmış.

---

## 4. Kullanım Hataları (Usability/Anti-patterns)

- **`AuthBloc` hem `droppable()` hem `_isProcessing` bayrağı** (`auth_bloc.dart:16-17,35`). Çift koruma, gereksiz ve kafa karıştırıcı.
- **`ProfileBloc._isAvatarBusy` çoğunlukla gereksiz** (`profile_bloc.dart:20,43`), çünkü Bloc zaten olayları seri işler; koruma zayıf.
- **`LogInterceptor` her zaman açık** (`dio_client.dart:35`). Release derlemesinde header/body (token dahil) loglanır → güvenlik riski; `kDebugMode` ile şartlandırılmalı.
- **`ForgotPasswordButton` işlevsiz** (`sign_in_page.dart:161` `onPressed: () {}`). Kullanıcıya hiçbir geri bildirim/akış yok.
- **`main_shell` navigasyonu kırılgan hack** (`main_shell.dart:28,37-45`). Yalnızca 2 sekme hard-coded; yeni rota eklenirse kırılır.

---

## 5. Eksik Kodlar (Missing/Unimplemented Code)

- **Router'da `productDetails` ve `search` için `GoRoute` yok.** `AppRoutes.productDetails` sabiti var ama `app_router.dart` içinde rota tanımlı değil → `search_page.dart:93-96` `context.push(AppRoutes.productDetails, extra: product)` GoRouter hatası fırlatır; bu sayfalara hiç gidilemez.
- **`ProductDetailsBloc`'a `product`/`productId` iletilmiyor.** Bloğun constructor'ı bunları bekler (`product_details_bloc.dart:13-22`) ama sayfa hiç geçirmiyor; `ProductDetailsRequested` olayında id yok.
- **`SessionExpiredController` hiç enjekte edilmemiş** (`session_expired_controller.dart`). Oturum süresi dolma akışı tamamen eksik; ayrıca `_isNotifying` kilidi hiç sıfırlanmadığından tekrarlı bildirim engellenir ama gerçek bir sonraki süre bitimi de bastırılır.
- **`removeAvatar` sunucu çağrısı eksik** (bkz. Madde 1).
- **`getProfileData(accessToken)` parametresi kullanılmıyor** (`auth_service.dart:71-79`) — ölü imza, interceptor'a bel bağlar.
- **`HomeSearchBar` arama sayfasına yönlendiriyor olabilir ama rota yok** → arama özelliği eksik.

---

## 6. Gereksiz/Fazla Kodlar (Redundant/Dead Code)

- **`home_body.dart` (ve `HomeContent`) hiç import edilmiyor** → ölü; beraberinde iç içe gelişmiş `ProductBloc` de ölüdür. Gerçek UI `mobile_home_body.dart`/`tablet_home_body.dart` ile üst seviyedeki basit `ProductBloc`'u kullanır.
- **`core/services/device_features/image_picker_service.dart` ve `permission_service.dart` ölü** (yalnız `features/data/service/local/...` sürümleri `injection.dart`'ta kayıtlı).
- **`LocalNotificationService` / `FlutterLocalNotificationsService` ölü** (`local_notification_service.dart`) — `notification_service.dart` yalnızca `print`/`log` kullanır, bunları hiç enjekte etmez.
- **`FirebaseInitializer` ölü** (`firebase_initializer.dart`) — `main.dart` zaten `Firebase.initializeApp(options:)` çağırır; sınıf kayıtlı ama asla çağrılmaz. Ayrıca `init()` içindeki `Firebase.initializeApp()` options'sız → çağrılsa hata verir.
- **`product_response.dart` (doğru yazılış) ölü**; yalnız `product_responce.dart` kullanılıyor.
- **`SignUpRequestDto.avatar` alanı ölü** — `toJson` her zaman hard-coded URL gönderiyor (`sign_up_request_dto.dart:19`).
- **`SignInRequestDto.userName` alan adı yanıltıcı** — gönderimde `'email'` yapılıyor; okunabilirlik sorunu.
- **`DioClient` constructor'ında `_secureStorage` ile `tokenManager` aynı instance'ı iki kez alıyor** (`injection.dart:62-64`) → gereksiz çift parametre.

---

## 7. Optimize Edilebilecek Kodlar (Optimization Opportunities)

- **`helpers.dart` BuildContext başına cache** (`ContextColors._instances` vb.) `static final` map ile tutuluyor; dispose edilmeyen context'ler bellek sızıntısına yol açar. `Expando` veya `InheritedWidget` tabanlı çözüm daha sağlıklıdır.
- **`NetworkInfo` DNS yerine `connectivity_plus`** kullanmalı; gerçek ağ durumunu daha doğru bildirir.
- **`LogInterceptor` kaldırılmalı veya `kDebugMode` ile şartlandırılmalı** (güvenlik + performans).
- **`AuthInterceptor.onRequest` her istekte `await` ediyor** (`auth_interceptor.dart:14`); token bellekte tutulup senkron eklenebilir (gecikme azalır).
- **`product_card` `Image.network` yerine projedeki `AppNetworkImage` kullanılabilir** (varsa) → tutarlı hata yönetimi.
- **Çift `ProductBloc` tekilleştirilmeli**; kod tekrarı ve tip çakışması ortadan kalkar.
- **`runCatching` güzel ama** `Failure` zaten `Exception` olduğundan yakalama yeterli; beklenmeyen hata dalında mesaj string'e gömülüyor, daha yapılandırılmış hata tercih edilir.

---

## 8. Yanlış Kütüphane Kullanımı (Misuse of Libraries)

- **`SharedPreferences.clear()` ürün cache'i silmek için kullanılmış** (`local_product_services.dart:47`) — yanlış API; yalnızca `remove(_cacheKey)` çağrılmalıydı. (KRİTİK veri kaybı.)
- **`InternetAddress.lookup` bağlantı kontrolü için yanlış araç** — `connectivity_plus` veya Dio seviyesinde hata tipi kontrolü uygun olurdu.
- **`LogInterceptor(requestBody: true, responseBody: true)` release'de hassas veri loglar** — kütüphane doğru kullanılmıyor.
- **`bloc_concurrency` `droppable()` ile manuel `_isProcessing` bayrağı çakışıyor** — ya transformer'a ya da bayrağa güvenilmeli.
- **`GoRouter` `extra` ile nesne geçirmek** (`search_page.dart:93-96` `extra: product`) tip güvenli değil; rota parametresi veya DTO ile iletim daha doğru olurdu.

---

## 9. Hatalı Kullanıcı Arayüzü Mantığı (Flawed UI/UX Logic)

- **Kategori listesi statik ve etkileşimsiz** (`category_list.dart`) → kullanıcı kategori seçemez; filtreleme UI'da hiç görünmez/çalışmaz.
- **Ürün detay & arama sayfaları `BlocProvider`sız** → açılışta kullanıcıya hata göstermeden uygulama çöker (`provider not found`).
- **`ForgotPasswordButton` tıklanabilir ama işlevsiz** → kullanıcı kafa karışıklığı.
- **`product_card` `image[0]` boşsa önce crash olur**, `errorBuilder` hiç devreye girmez → kötü hata deneyimi.
- **`BannerSlider`/`CategoryList` internetten resim çeker, hata yönetimi yok** (özellikle `CategoryList` `NetworkImage` try yok) → resim URL'i bozuksa UI kırılır.
- **Tema/Locale Cubit async yüklenirken ilk açılışta kısa dil/tema "flaş"ı** (`local_cubit.dart:18-23`, `theme_cubit.dart`) — varsayılan değerle render edilip sonra güncellenir.
- **`main_shell` 2 sekme hard-coded** (`main_shell.dart:30-35`); yeni bir sekme eklenirse nav bar güncellenmez.

---

## Nihai Değerlendirme ve Skor (Final Evaluation & Score)

* **Mimari Puan (Architecture Score):** 3 / 10
* **Kod Kalitesi Puanı (Code Quality Score):** 3 / 10
* **Mantıksal Tutarlılık (Logical Consistency):** 2 / 10

* **GENEL ÖZET (OVERALL SUMMARY):**

Bu kod tabanı **üretime kesinlikle uygun değildir** ve neredeyse baştan yazılması gerekir. En kritik sorunlar katman mantığında değil, en temel çalışma akışlarında yatıyor: (1) `SignInResponseDto` yanlış JSON anahtarı okuduğu için tüm kimlik doğrulama akışı kırık; (2) `clearProductCache()` çağrısı tüm `SharedPreferences`'ı sildiği için kullanıcı her ürün yüklemesinde "çıkışa" düşüyor ve dil/tema/FCM kayıpları yaşıyor; (3) `uploadAvatar` çift ön ek nedeniyle hatalı URL üretiyor; (4) token yenileme anahtar uyumsuzluğu süre bitiminde zorla çıkışa yol açıyor. Mimari tarafta ise aynı isimde iki `ProductBloc`, ölü dosyalar, router'da eksik rotalar ve hiç sağlanmayan detay/arama bloc'ları uygulamayı açılışta çökertiyor; auth `redirect` yoruma alındığı için güvenlik koruması tamamen yok. Kod "çalışıyor gibi" görünse de temel akışların hepsi ya kırık ya da çökertici. Junior geliştirici deterministik olarak çalışan bir uygulama teslim etmemiş; yalnızca derlenen ama davranışsız bir iskelet üretmiş.

**3 Adımlık Eylem Planı (Sonraki Sprint):**

1. **Acil Blokajları Kaldır (P0):** `SignInResponseDto.fromJson` anahtarını `access_token`/`refresh_token` olarak düzelt; `LocalProductServices.clearProductCache` içindeki `_prefs.clear()` yerine `_prefs.remove(_cacheKey)` kullan; `ApiEndpoints.uploadAvatar` ön ekini `/files/upload` yap; `AuthServiceImpl.refreshUserToken` içinde `data['accessToken']` → `data['access_token']` olarak değiştir.
2. **Mimariyi Toparla (P1):** İç içe `ProductBloc` ve `home_body.dart`'ı silip tek `ProductBloc` kullan; detay/arama için `GoRoute` tanımla ve sayfaları `BlocProvider` ile sar; `app_router.dart` içindeki `redirect` korumasını geri getir; Bloc'ları `registerFactory` yerine widget içi `BlocProvider` ile oluştur.
3. **Temizlik & Kalite (P2):** Ölü kodları kaldır (`device_features` servisleri, `LocalNotificationService`, `FirebaseInitializer`, `SessionExpiredController`, mock `CategoryList` bağlantısı); yorum dillerini Türkçe'ye çevir; `LogInterceptor`'ı `kDebugMode` ile şartla; `product_card` için `image` listesine sınır/null kontrolü ekle.
