# Proje Detaylı İnceleme Raporu (Code Review Report)
**Dosya Yolu:** `doc/review_report.md`
**Denetleyen:** Kıdemli Yazılım Mimarı (AI Senior Architect)

> **Kapsam:** `lib/` altındaki tüm Dart kaynak kodu, bağımlılık enjeksiyonu (GetIt), ağ katmanı (Dio + interceptor’lar), BLoC/Cubit state yönetimi, depolama (SecureStorage/SharedPreferences), bildirim (FCM) ve UI katmanı statik + zihinsel çalıştırma (mental simulation) ile incelenmiştir. Kod; `junior_flutter_roadmap` (Flutter + go_router + flutter_bloc + get_it + dio) projesidir.

> **Güncelleme:** Aşağıdaki bulgular kod üzerinde çözülmüş ve bu rapordan çıkarılmıştır:
> **L1, L2, L3, L5, L7, A1, A2, A4, A5, A6, F1, F2, F3, F4, F5, U2, U3, U4, U5, U6, E2, E3, E4, E6, UY1, UY6, UY8, K1, K2.**

---

## 1. Mantıksal Hatalar (Logical Errors)

- **L4 — Kategori filtresi muhtemelen no-op (etkisiz):**
  `lib/features/products/data/services/remote_product_services.dart:30` `categoryId` query parametresini `/products` endpoint’ine gönderiyor. İncelenen backend’in (`/products`) `categoryId` parametresini desteklememesi (kategori bazlı ürün için `/categories/{id}/products` kullanılması) yüksek olasılık; bu durumda `CategorySelected` olayı ürün listesini **sunucu tarafında filtrelemez**, tüm ürünler döner. Kategori seçimi “çalışıyor” gibi görünür ama aslında filtrelemez. Backend sözleşmesi ile mutlaka doğrulanmalı; desteklemiyorsa `/categories/{id}/products` kullanılmalı.

- **L6 — `removeAvatar` yalnızca yerelde çalışır:**
  `lib/features/profile/data/repositories/profile_repository.dart:66-74` `removeAvatar` yalnızca `UserProfileStore`’u günceller, sunucuya silme isteği atmaz. Profil sayfasındaki “Remove photo” kullanıcıyı yanıltır; sunucudaki avatar kalır.

---

## 2. Mimari Hatalar (Architectural Errors)

- **A3 — İki ayrı tema/renk sistemi (tek doğruluk kaynağı yok):**
  `lib/core/theme/app_theme.dart` `ThemeData` tanımlarken `colorScheme` belirlemiyor; buna karşılık tüm UI `lib/core/common/helpers/helpers.dart` içindeki `ContextColors` (özel `LightColors`/`DarkColors` sabitleri) üzerinden boyanıyor. Yani `Theme.of(context).colorScheme` ile `context.colors` **farklı renkler** döndürebilir. Material widget’ları (varsayılan renkler) ile özel widget’lar (context.colors) tutarsız görünür. Tema `ThemeData.colorScheme` üzerinden tek kaynaktan yönetilmeli.

---

## 3. Eksik Kodlar (Missing/Unimplemented Code)

- **E1 — FCM token backend’e gönderilmiyor:**
  `lib/core/services/notifications/notification_service.dart:42-46` alınan FCM token yalnızca locale’e (`_fcmTokenManager.saveToken`) kaydediliyor; hiçbir `/devices`/`/fcm-token` endpoint’ine gönderilmiyor. Backend kullanıcıyı hedefleyen push gönderemez. Token tescil/ yenileme API çağrısı eksik.

- **E5 — `AppRoutes.cart` tanımlı ama rota yok:**
  `lib/core/constants/app_constants.dart:57` `/cart` rotası `app_router.dart` içinde tanımlı değil; sepet özelliği tamamen eksik (ölü rotaya işaret).

---

## 4. Gereksiz/Fazla Kodlar (Redundant/Dead Code)

- **G1 — `FirebaseInitializer` tescil edilmiş ama hiç kullanılmıyor:**
  `lib/core/di/injection.dart:48` register ediliyor; `main.dart` kendi `Firebase.initializeApp(options: ...)` çağırıyor. `firebase_initializer.dart` tamamen ölü (ayrıca options’sız çağrı yapmaya kalkarsa çökme riski).

- **G2 — `SignInRequestDto.userName` ↔ `SignUpRequestDto.avatar` ölü alanlar:**
  - `sign_up_request_dto.dart:5` `avatar` alanı constructor’da alınıyor ama `toJson` içinde **görmezden gelinip** sabit `'https://i.imgur.com/LDOO4Qs.jpg'` gönderiliyor. `avatar` parametresi ölü; sabit URL her kullanıcıya aynı varsayılan avatarı atar.

- **G3 — Kullanılmayan sabitler:**
  `lib/core/constants/app_constants.dart:16-20` `pageSize`, `pageSizeSmall`, `lowStockThreshold` hiçbir yerde kullanılmıyor; `ProductBloc` kendi `_limit = 10` sabitini ayrıca tanımlıyor. Çakışan/ölü sabitler.

- **G4 — Kullanılmayan asset sabitleri:**
  `lib/core/common/helpers/helpers.dart` `ContextAssets.logo`, `logoOutline`, `pdfIcon`, `quizIcon` tanımlı ama hiçbir widget’ta kullanılmıyor; ayrıca `assets/images/logo.png`, `logo_outline.png`, `pdf_icon.png`, `quiz_icon.png` dosyaları `pubspec.yaml` asset klasörlerinde mevcut değil.

- **G5 — `AuthInterceptor` için `_secureStorage` ile `tokenManager` çift parametre:**
  `lib/core/di/injection.dart:78-84` `DioClient` hem pozisyonel `_secureStorage` hem de `tokenManager` alıyor; ikisi aynı tekil örneğe işaret ediyor. `tokenManager` parametresi gereksiz.

- **G6 — `product_card.dart` içinde gereksiz `const` yorumları:**
  `product_card.dart:18-20` yorum satırına alınmış `// width: double.infinity` gibi kodlar ölü.

---

## 5. Optimize Edilebilecek Kodlar (Optimization Opportunities)

- **O1 — `ProductResponse` ↔ `ProductModel` tamamen gereksiz kopya:**
  `product_response.dart` ve `product_model.dart` alanları birebir aynı; `ProductMapper` yalnızca alanları kopyalıyor. DTO ile domain modeli arasında gerçek bir dönüşüm/davranış farkı yoksa `ProductModel` doğrudan `fromJson` ile kurulabilir ya da `freezed`/`json_serializable` ile kod üretilerek bu boilerplate ortadan kaldırılabilir. (Aynısı `CategoryResponse`/`CategoryModel` ve `Address` için geçerli.)

- **O2 — `LocalProductServicesImpl.getCachedProducts` her okumada JSON parse + map:**
  `lib/features/products/data/services/local_product_services.dart:34-43` cache’ten her erişimde `jsonDecode` + `ProductMapper` çalıştırıyor. Offline listeler büyüdükçe maliyet artar; parsed model bellekte tutulabilir ya da lazy cache.

- **O3 — `search_bloc.dart:16-21` kendi transformer’ını elle yazıyor:**
  `restartable<SearchEvent>().call(events.debounce(duration), mapper)` deseni `bloc_concurrency` + `stream_transform` ile doğrudan `restartable`+`debounce` composite olarak ifade edilebilir; mevcut yazım okunması zor ve tip parametresi gölgeleme yapıyor.

- **O5 — `failure.dart` içinde `extractServerErrorMessage` her hatada yeni liste/regEx:**
  `_serverMessageKeys` sabit ama `RegExp` (`_extractHtmlTitle`) her çağrımda derleniyor; `static final` olarak tanımlanabilir.

- **O6 — `ProductBloc` state hiyerarşisi çok tekrarlı:**
  `ProductState` taban sınıfı `categories`/`selectedCategoryId` taşıyor ve her alt sınıf bunları ileriye taşımak zorunda; `freezed`/union + `copyWith` ile çok daha okunaklı ve hatasız olur.

---

## 6. Yanlış Kütüphane Kullanımı (Misuse of Libraries)

- **K3 — `SharedPreferences` ile büyük JSON cache:**
  `local_product_services.dart` ürün listesini tek bir JSON string olarak `SharedPreferences`’e yazıyor. Daha yapısal/performanslı çözüm `drift`/`hive`/`sqflite` olurdu; mevcut yaklaşımda parse maliyeti ve boyut sınırı riski var.

- **K4 — `flutter_secure_storage` yalnızca token için ama FCM/UserProfile `SharedPreferences`’te:**
  `user_profile_data.dart` ve `fcm_token_manager` düz metin `SharedPreferences`’te; profil/email gibi PII için secure storage daha uygun olabilir (en azından değerlendirilmeli).

- **K5 — `FlutterLocalNotificationsService.showNotification` payload olarak `data?.toString()`:**
  `local_notification_service.dart:81` `Map.toString()` ile payload gönderiliyor; tıklamada veri yapısı kaybolur. `payload` yerine JSON string veya platforma özgü `notificationResponse` kullanılmalı.

- **K6 — `url_launcher` `canLaunchUrl` + `launchUrl` iki kez çözüm:**
  `launcher_service_impl.dart` her çağrıda `canLaunchUrl` kontrolü yapıyor; `launchUrl` zaten false döndürebilir. Gerekli ama tekrarlı I/O; ayrıca `makePhoneCall`/`openWhatsApp` hata yönetimi sadece `false` dönüyor, UI’ya neden başarısız olduğu bildirilmiyor.

---

## 7. Hatalı Kullanıcı Arayüzü Mantığı (Flawed UI/UX Logic)

- **UY2 — Adres dialog’unda prefill race:**
  `lib/features/address/presentation/widgets/address_dialog.dart:72-79` `state.detected != null && !_prefilled` kontrolü `build` içinde yapılıyor ve `addPostFrameCallback` ile controller’a yazıyor. Eğer kullanıcı adresi elle değiştirip konum yeniden çekilirse (`_retry`), `detected` değiştiğinde tekrar prefill edilip kullanıcının girdiği metin silinebilir. Prefill yalnızca ilk açılışta ve kullanıcı henüz yazmadıysa yapılmalı.

- **UY3 — Bottom navigation ‘search’i yok sayıyor:**
  `lib/features/products/presentation/pages/main_shell.dart:23-28` `_indexFor` yalnızca home/profile’ı ayırıyor; kullanıcı `/search` içindeyken alt bar home’u seçili gösteriyor ama `onDestinationSelected` `current != target` kontrolüyle `/home`’e dönüyor — yani search ekranındayken “Home”a basınca doğru dönüyor ama görsel seçim yanlış. Search için de bir sekme/state gerekir.

- **UY4 — `product_card.dart:81-110` sahte renk noktaları:**
  Ürün renk seçenekleri sabit `[red, amber, blue, green]` listesiyle çiziliyor; gerçek ürün renkleriyle hiçbir ilgisi yok. Kullanıcıyı yanıltan kukla UI.

- **UY5 — Yükleniyor/boş/hata durumları ürün bölgesinde 0.55 ekran yüksekliğine sabitlenmiş:**
  `home_body.dart:142-147` durum ekranları `screenHeight * 0.55` ile kısıtlanmış; uzun hata mesajları taşabilir. Ayrıca `ProductInitial` ve `ProductLoading` aynı yükleniyor gösterimi → ilk açılışta mı yoksa yeniden yüklemede mi olduğu belirsiz.

- **UY7 — Profil çıkışı tüm `SharedPreferences`’ı siler:**
  `profile_page.dart:38-44` `_onSignOut` `SharedPreferences().clear()` çağırıyor; bu dil tercihini, önbelleği ve FCM token’ı da siler → çıkış sonrası uygulama dili varsayılana döner, cache boşalır. Yalnızca auth ile ilgili anahtarlar temizlenmeli.

---

## Nihai Değerlendirme ve Skor (Final Evaluation & Score)

* **Mimari Puan (Architecture Score):** 5 / 10
* **Kod Kalitesi Puanı (Code Quality Score):** 5 / 10
* **Mantıksal Tutarlılık (Logical Consistency):** 4 / 10

* **GENEL ÖZET (OVERALL SUMMARY):**
  İlk incelemede belirtilen en kritik güvenlik/mantık hatalarının çoğu kod üzerinde çözülmüştür: şifre varsayılan açık görünüyordu (L1), token yenileme akışı kırıktı (L2), `RefreshIndicator` gerçek yüklemeyi beklemiyordu (L3), çevrimdışı pagination boş dönüyordu (L5), ölü `getProfileData` parametresi vardı (L7). Mimari tarafta uygulama geneli cubit’ler `registerFactory` ile tescil ediliyordu (A1), yönlendirmede auth koruması pasifti (A2), `NetworkInfo` DNS probe kullanıyordu (A4), `ProductDetailsBloc` iskeletti (A5) ve interceptor sırası kırılgandı (A6) — bunların tamamı giderildi. Format/yazım hataları (F1-F5), validator/context bağımlılığı (U4), `droppable` transformer (U5), `_hasAvatar` deseni (U6), izin servisi (U2), `AddressState` immutability (U3), arka plan bildirim işleyicisi (E2) ve global oturum-sona-erdi akışı (E6) de tamamlandı.

  **Kalan açık konular:** (1) kategori filtresinin backend sözleşmesine göre no-op olma riski (L4), (2) FCM token’ının backend’e hiç gönderilmemesi (E1), (3) iki ayrı tema/renk sistemi (A3), (4) `removeAvatar`’ın sunucuya yansımaması (L6), (5) ölü/dead code ve optimizasyon alanları (G1-G6, O1-O6), (6) `SharedPreferences`/secure-storage ve payload kullanımı gibi kütüphane kullanım iyileştirmeleri (K3-K6), (7) birkaç UI/UX mantık hatası (UY2-UY5, UY7). Ayrıca `AppRoutes.cart` ölü rotası (E5) hâlâ mevcut.

  **Sonuç:** Çekirdek auth/üretim güvenliği hataları kapatıldı; proje artık belirtilen kritik risklerden arındı. Kalan işler daha çok “tamamlanmamış özellik” (E1, L4, E5), mimari tek kaynaklığa geçiş (A3) ve temizlik/optimizasyon (G/O/K/UY) kategorisindedir.
