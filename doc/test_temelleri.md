# Flutter Test Temelleri (Yeni Başlayanlar İçin)

Bu dosya, projedeki testleri (unit / widget / integration) anlamak için gereken
temel kavramları çok sade bir dille anlatır. Diğer üç açıklama dosyası
(`integration_test_aciklama.md`, `image_picker_service_test_aciklama.md`,
`location_service_test_aciklama.md`) buradaki kavramları kullanır.

> **Not:** Daha önce hiç test yazmadıysanız önce bu dosyayı baştan sona okuyun.
> Test, uygulamanın "doğru çalıştığını" otomatik olarak kontrol eden küçük
> programlardır. Elle tıklamak yerine, bilgisayar bizim yerimize tıklar ve
> "beklediğim sonuç bu mu?" diye bakar.

---

## 1. Test Neden Yazılır?

Elle "uygulamayı aç, giriş yap, ürüne tıkla" demek yerine, test bunu otomatik
yapar. Testler sayesinde:

- Bir değişiklik yaptığımızda eski özellikler bozulmuş mu hemen anlarız.
- Elle tekrar tekrar deneme zahmetinden kurtuluruz.
- "İşte çalışıyor" demek yerine "testler yeşil, yani çalışıyor" diyebiliriz.

---

## 2. Üç Test Çeşidi

| Çeşit | Ne test eder? | Nerede? | Örnek dosya |
|------|---------------|---------|-------------|
| **Unit (birim)** | Tek bir sınıfın / fonksiyonun mantığı | `test/` | `image_picker_service_test.dart`, `location_service_test.dart` |
| **Widget** | Bir ekran parçasının (buton, kart) çizimini ve tıklamasını | `test/` | `product_card_test.dart` |
| **Integration (entegrasyon)** | Tüm uygulamayı uçtan uca (giriş → ana sayfa → detay → …) | `integration_test/` | `app_flow_test.dart` |

---

## 3. Kullanılan Paketler

- **`flutter_test`** → Flutter ile gelir, test yazmanın temel aracıdır.
  `test`, `testWidgets`, `expect`, `WidgetTester`, `Finder` buradan gelir.
- **`mocktail`** → "sahte nesne" (mock/fake) üretmek için. Gerçek işletim
  sistemine bağlı şeyleri (izinler, kamera, konum) taklit ederiz ki test
  bilgisayarda da çalışsın.
- **`integration_test`** → Gerçek cihazda/emülatörde tüm uygulamayı çalıştırır.

`pubspec.yaml` içinde `dev_dependencies` altındadırlar; yani sadece test
sırasında yüklenir, yayınladığımız uygulamaya dahil olmazlar.

---

## 4. En Önemli Kelimeler

### `test()` ve `testWidgets()`
Bir test senaryosu tanımlar.

```dart
test('toplama doğru mu', () {
  expect(1 + 1, 2);
});
```

`testWidgets` ise içinde `tester` (WidgetTester) olan, ekran çizen testler
içindir.

### `group()`
Birkaç testi başlık altında toplar, sadece düzen için.

```dart
group('Sepet', () {
  test('boşken 0 gösterir', () => ...);
  test('ürün eklenince sayar', () => ...);
});
```

### `setUp()`
Her testten ÖNCE çalışır. Ortak hazırlık burada yapılır (örnek: mock
oluşturmak). Böylece her test temiz bir nesneyle başlar.

```dart
late MockPermissionService permission;
setUp(() {
  permission = MockPermissionService();
});
```

### `expect(gerçek_değer, matcher)`
"Gerçek değer, beklediğim kurala uyuyor mu?" kontrolü. Uymassa test KIRMIZI
olur.

```dart
expect(sonuc, isNull);            // sonuç null olmalı
expect(sonuc, isNotNull);         // sonuç null OLMAMALI
expect(adi, 'Halep');             // tam eşitlik
expect(adres, contains('Halep')); // içinde geçiyor mu
expect(() => fonk(), throwsA(isA<LocationException>())); // hata fırlatmalı
expect(find.byType(ProductCard), findsWidgets);          // ekrana çizilmiş mi
```

### `Matcher` (eşleştirici) nedir?
`expect`in ikinci parametresi bir "kural"dır. Sık kullanılanlar:
`equals`, `isNull`, `isNotNull`, `isTrue`, `isA<T>()`, `contains`,
`findsWidgets`, `findsOneWidget`, `throwsA`.

---

## 5. `WidgetTester` (ekranı yöneten robot)

`tester` değişkeni, testin ekrana dokunan yeridir.

| Komut | Ne yapar? |
|-------|-----------|
| `tester.pump()` | Ekranı bir kare ilerlet (çizimi güncelle) |
| `tester.pumpAndSettle()` | Ekran durulana kadar bekle (animasyonlar biter) |
| `tester.tap(bulucu)` | Bir yere tıkla |
| `tester.enterText(bulucu, 'yazı')` | Yazı kutusuna yaz |
| `tester.pumpWidget(MyApp())` | Uygulamayı baştan kur (widget testlerinde) |

> **Önemli:** Bizim entegrasyon testimiz `pumpAndSettle` kullanmaz, çünkü ana
> sayfada kendi kendine dönen bir reklam kaydırıcısı (`BannerSlider`) var;
> o hiç durmaz, bu yüzden test sonsuza kadar bekler. Onun yerine `waitFor`
> yardımcı fonksiyonuyla "şu widget çıkana kadar bekle" yaparız.

---

## 6. `Finder` (ekranda bir şeyi bulma aracı)

Test bir butona tıklamak için önce onu "bulmalıdır". Bulucular:

```dart
find.byType(ProductCard)                 // tipine göre bul
find.byIcon(Icons.search)                // ikonuna göre bul
find.text('Giriş Yap')                   // yazısına göre bul
find.byKey(const Key('loginButton'))     // özel anahtara göre bul
find.descendant(of: A, matching: B)      // A'nın içindeki B'yi bul
```

> **Neden `find.text` kullanmadık?** Çünkü uygulama çok dilli (Türkçe, Arapça,
> İngilizce). Yazı değişirse test kırılır. Bu yüzden testlerimizde **tip
> (`byType`)** veya **ikon (`byIcon`)** kullandık; dil ne olursa olsun çalışır.

---

## 7. Mock, Fake ve Stub (sahte nesneler)

Gerçek kamerayı / konumu / izin sistemini testte çağıramayız. Bunun yerine
"sahte" sınıflar yaparız.

### Mock (mocktail ile)
Bir arayüzün taklididir. "Şu method çağrılırsa şunu döndür" deriz.

```dart
class MockPermissionService extends Mock implements PermissionService {}

final permission = MockPermissionService();

// STUB: "checkAndRequestCameraPermission sorulursa false döndür"
when(() => permission.checkAndRequestCameraPermission())
    .thenAnswer((_) async => false);

// VERIFY: "gerçekten çağrıldı mı?"
verify(() => permission.checkAndRequestCameraPermission()).called(1);
```

- `when(...).thenAnswer(...)` → yöntemi taklit eder (stub).
- `verify(...).called(n)` → o yöntemin n kez çağrıldığını doğrular.

### Fake
Arayüzün gerçekten çalışan basit bir kopyasıdır. Örneğin kamera yerine
"her seferinde şu sahte dosyayı döndür" diyen sınıf.

```dart
class FakeImagePicker extends Fake implements ImagePicker {
  XFile? picked;
  int pickCallCount = 0;
  @override
  Future<XFile?> pickImage({...}) async {
    pickCallCount++;
    return picked;   // gerçek kamera açılmaz!
  }
}
```

### Neden fark var?
- **Mock**: "çağrıldı mı, ne döndü?" takibini yapar.
- **Fake**: "gerçek bir iş yapar" ama basitçe (dosya üretir, hesaplar).

---

## 8. Testleri Nasıl Çalıştırırız?

### Unit / Widget testi (bilgisayarda, hızlı)
```powershell
flutter test test/core/services/device_features/image_picker_service_test.dart
flutter test test/core/services/device_features/location_service_test.dart
flutter test            # hepsini çalıştırır
```
Yeşil "All tests passed!" görürseniz başarılı.

### Integration testi (gerçek cihaz / emülatör gerekir)
```powershell
flutter test integration_test/app_flow_test.dart
```
Dikkat: Bu test bilgisayarın tarayıcısında değil, telefon/emülatörde çalışır.
Ayrıca internet ve (bildirimler için) Firebase ayarı gerekir.

---

## 9. Proje Klasör Düzeni

```
lib/                     -> Uygulama kodu (gerçek sınıflar)
test/                    -> Birim/widget testleri; Klasör yapısı lib/ ile AYNI olmalı
  features/data/service/local/image_picker_service_test.dart
  core/services/device_features/image_picker_service_test.dart
  core/services/device_features/location_service_test.dart
integration_test/        -> Uçtan uca testler
  app_flow_test.dart
doc/                     -> Açıklama dosyaları (bunları okuyorsunuz)
```

> **Kural:** `test/` içindeki dosya yolu, test ettiği `lib/` dosyasının yolunu
> birebir yansıtır. Böylece "bu test nereyi test ediyor?" hemen anlaşılır.
