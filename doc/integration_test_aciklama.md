# Entegrasyon Testi Açıklaması (`integration_test/app_flow_test.dart`)

Bu dosya, tüm uygulamayı **gerçek bir cihazda/emülatörde** uçtan uca çalıştıran
testi satır satır anlatır. Daha önce test yazmadıysanız önce
`test_temelleri.md` dosyasını okuyun.

**Ne yapar bu test?** Bir kullanıcı gibi giriş yapar, ana sayfayı kontrol eder,
bir ürüne tıklar, arama yapar, profilde fotoğrafı kaldırır ve adres (konum)
kaydeder. Yani "uygulama gerçekten kullanılabilir mi?" sorusunu otomatik cevaplar.

---

## A. Çalıştırma ve Gereksinimler

```powershell
flutter test integration_test/app_flow_test.dart
```

Gerekliler:
- Telefon veya emülatör (bilgisayar tarayıcısı DEĞİL).
- İnternet erişimi (sahte API `api.escuelajs.co` kullanılır).
- Uygulamada Firebase yapılandırması tamamlanmış olmalı.
- Giriş formu **otomatik doldurulmuş** bir test hesabıyla gelir; biz sadece
  butona dokunuruz. Bu yüzden gerçek şifre bilmemize gerek yok.
- **Bilinçli olarak** gerçek kamera/galeri seçiciyi açmıyoruz; o native (işletim
  sistemine ait) bir pencere açar ve test otomatik devam edemezdi.

---

## B. Import (kütüphane) Satırları (1–15)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:integration_test/integration_test.dart';
```

- `flutter_test` → `testWidgets`, `expect`, `find`, `WidgetTester` verir.
- `integration_test` → `IntegrationTestWidgetsFlutterBinding` verir; bu, testi
  gerçek cihazda çalıştırmamızı sağlar.
- `iconsax_plus` → Bazı ikonları (profil, ev, konum) bulmak için import ettik.
- Geri kalan importlar, uygulamadaki gerçek sınıfları teste tanıtır:
  `AppNetworkImage`, `AppPrimaryButton`, `SearchPage`, `BannerSlider`,
  `ProductCard`, `ProfileAvatar`, `main` (uygulama başlangıcı) vb.

---

## C. Üstteki Açıklama Bloğu (17–38)

Dosyanın en üstündeki `///` yorumu, testin akışını (adım adım) ve "neden bu
şekilde yazıldığını" anlatır. Özellikle şu iki kural vurgulanır:

1. **Dilden bağımsız (locale-independent):** Hiçbir yerde `find.text('Giriş')`
   gibi yazı kullanmayız; her bulucu ya **tip** (`byType`) ya da **ikon**
   (`byIcon`) ile çalışır. Böylece uygulama Türkçe, Arapça veya İngilizce
   olsa da test kırılmaz.
2. **Zamandan bağımsız:** Sabit `sleep` beklemesi yoktur; bunun yerine
   `waitFor*` yardımcıları "beklenen widget çıkana kadar bekle" yapar.

---

## D. Yardımcı Fonksiyonlar (40–100)

Testin gövdesi tekrarları önlemek için birkaç küçük yardımcı tanımlar.

### `wait` (41–42)
```dart
Future<void> wait(WidgetTester tester, [int milliseconds = 1000]) =>
    tester.pump(Duration(milliseconds: milliseconds));
```
Ekranı kısa bir süre ilerletir (yeniden çizdirir). Varsayılan 1 saniye.

### `waitForAny` (45–56)
```dart
Future<void> waitForAny(
  WidgetTester tester,
  List<Finder> finders, {
  int timeoutSeconds = 20,
}) async {
  final deadline = DateTime.now().add(Duration(seconds: timeoutSeconds));
  while (DateTime.now().isBefore(deadline)) {
    await tester.pump(const Duration(milliseconds: 250));
    if (finders.any((f) => f.evaluate().isNotEmpty)) return;
  }
  throw Exception('waitForAny timed out (${finders.length} finders)');
}
```
Verilen buluculardan **herhangi biri** ekranda görünene kadar 250 ms aralıkla
ekranı tazeler. Süre dolunca hata fırlatır. Yani "ya şu ya bu çıksın" deriz;
örneğin ya giriş butonu çıktı ya da ana sayfa (zaten giriş yapılmışsa).

### `waitFor` (59–63)
```dart
Future<void> waitFor(WidgetTester tester, Finder finder, {int timeoutSeconds = 20}) =>
    waitForAny(tester, [finder], timeoutSeconds: timeoutSeconds);
```
Tek bir bulucu için `waitForAny` sarmalayıcısıdır.

### `tapFirst` (68–74)
```dart
Future<void> tapFirst(WidgetTester tester, Finder finder) async {
  final elements = finder.evaluate().toList();
  if (elements.isEmpty) {
    throw Exception('tapFirst: no widgets found for $finder');
  }
  await tester.tap(find.byWidget(elements.first.widget), warnIfMissed: false);
}
```
Bulucunun bulduğu **ilk** widget'a dokunur. `evaluate()` ile elle eleman
listesini alıp `elements.first` diyerek tıklamak, bazı karmaşık (descendant)
bulucularda güvenli olması içindir. Bulamazsa açık bir hata verir.

### `descendantOfType` (77–78)
```dart
Finder descendantOfType(Type ancestor, Type type) =>
    find.descendant(of: find.byType(ancestor), matching: find.byType(type));
```
"Şu büyük widget'ın **içindeki** şu tip widget'ı bul" işini kısaltır. Örneğin
`ProductDetailsGallery` içindeki `AppNetworkImage`'ı bulmak için kullanılır.

### `tapProductWithImage` (85–100)
```dart
Future<bool> tapProductWithImage(WidgetTester tester, Finder cards) async {
  final elements = cards.evaluate().toList();
  if (elements.isEmpty) throw Exception('tapProductWithImage: no ProductCard found');
  for (final el in elements) {
    final product = (el.widget as ProductCard).product;
    final images = product.image;
    if (images.isNotEmpty) {
      await tester.tap(find.byWidget(el.widget), warnIfMissed: false);
      return true;
    }
  }
  await tester.tap(find.byWidget(elements.first.widget), warnIfMissed: false);
  return false;
}
```
Ürün kartları arasında **resmi olan** birini bulup ona tıklar ve `true` döner.
Hiç resimli ürün yoksa ilk kartı tıklar, `false` döner. Bu sayede detay
sayfasında "resim var mı?" kontrolünü güvenli yaparız; resimsiz üründe
"resim bekliyorum" demeyiz, test bozulmaz.

---

## E. Testin Gövdesi — `main()` (102–281)

### Başlangıç (103–107)
```dart
IntegrationTestWidgetsFlutterBinding.ensureInitialized();
testWidgets(
  'Full user flow: login → home → details → search → details → profile → address',
  (tester) async {
```
Önce entegrasyon bağlamasını kurarız. Sonra `testWidgets` ile senaryoyu yazarız;
`tester` artık gerçek cihazı yöneten robottur.

### ADIM 1 — GİRİŞ (109–120)
```dart
app.main();                 // uygulamayı başlat
await waitForAny(tester, [
  find.byType(AppPrimaryButton), // giriş ekranındaki buton
  find.byType(ProductCard),      // zaten giriş yapılmışsa ana sayfa
]);
if (find.byType(ProductCard).evaluate().isEmpty) {
  await tapFirst(tester, find.byType(AppPrimaryButton)); // giriş butonuna dokun
  await waitFor(tester, find.byType(ProductCard));        // ana sayfa gelsin
}
```
`app.main()` uygulamayı ayağa kaldırır. Ya giriş ekranı çıkar ya da kullanıcı
zaten oturum açmışsa ana sayfa. Eğer ana sayfa yoksa, giriş butonuna
(`AppPrimaryButton`) dokunup ana sayfanın gelmesini bekleriz.

### ADIM 2 — ANA SAYFA KONTROLÜ (123–127)
```dart
expect(find.byType(ProductCard), findsWidgets);  // ürün kartları var
expect(find.byType(BannerSlider), findsWidgets); // kayan reklam var
expect(find.byType(CategoryList), findsWidgets); // kategori listesi var
```
Ana sayfada **olması gereken üç temel parça** gerçekten çizilmiş mi diye bakarız.
Bunlar tiplerle (`byType`) arandığı için dil fark etmez.

### ADIM 3 — DETAY (Ana sayfadan) (130–158)
```dart
final homeHasImage = await tapProductWithImage(tester, find.byType(ProductCard));
await waitFor(tester, find.byIcon(Icons.adaptive.arrow_back)); // detay üst çubuğu
await waitFor(tester, find.byType(ProductDetailsGallery));      // detay yüklendi
expect(find.byType(ProductDetailsGallery), findsWidgets);
if (homeHasImage) {
  expect(descendantOfType(ProductDetailsGallery, AppNetworkImage), findsWidgets);
}
await tapFirst(tester, find.byIcon(Icons.adaptive.arrow_back)); // geri
await waitFor(tester, find.byType(ProductCard));                // ana sayfaya dön
```
Bir ürüne tıklarız. Geri ok (`arrow_back`) çıkana ve detay galerisi yüklenene
kadar bekleriz. Eğer ürünün resmi varsa, galeri içinde `AppNetworkImage`
olduğunu doğrularız. Sonra geri okla ana sayfaya döneriz.

### ADIM 4 — ARAMA (161–191)
```dart
await tapFirst(tester, find.descendant(
  of: find.byType(HomeSearchBar),
  matching: find.byIcon(IconsaxPlusLinear.search_normal_1),
));
await waitFor(tester, find.byType(SearchPage));
await tester.enterText(descendantOfType(SearchPage, TextField), 'aceite');
await waitFor(tester, descendantOfType(SearchPage, ProductCard)); // sonuçlar
final searchHasImage = await tapProductWithImage(
  tester, descendantOfType(SearchPage, ProductCard));
await waitFor(tester, find.byIcon(Icons.adaptive.arrow_back));
await waitFor(tester, find.byType(ProductDetailsGallery));
expect(find.byType(ProductDetailsGallery), findsWidgets);
if (searchHasImage) {
  expect(descendantOfType(ProductDetailsGallery, AppNetworkImage), findsWidgets);
}
```
Arama çubuğundaki büyüteç ikonuna dokunuruz (`HomeSearchBar` içindeki
`search_normal_1` ikonu). Arama sayfası açılınca `TextField`'e `"aceite"` yazarız.
Sonuç kartları çıkınca birine (resimliyse) tıklar, detay sayfasını doğrularız.

### ADIM 5 — İKİ KEZ GERİ (194–202)
```dart
await tapFirst(tester, find.byIcon(Icons.adaptive.arrow_back)); // detay -> arama
await waitFor(tester, find.byIcon(Icons.adaptive.arrow_back));
await tapFirst(tester, find.byIcon(Icons.adaptive.arrow_back)); // arama -> ana sayfa
await waitFor(tester, find.byType(ProductCard));
```
Detaydan aramaya, aramadan ana sayfaya döneriz. Her adımda geri oku bulup
 Ana sayfanın geldiğini doğrularız.

### ADIM 6 — PROFİL (205–252)
```dart
await tapFirst(tester, find.byIcon(IconsaxPlusLinear.profile));
await waitFor(tester, find.byType(AppPrimaryButton));

// Profilde "fotoğraf değiştir" tek AppPrimaryButton'dır
await tapFirst(tester, find.byType(AppPrimaryButton));
await waitFor(tester, find.byIcon(Icons.photo_library_outlined)); // alt sayfa açıldı

final removeOption = find.byIcon(Icons.delete_outline);
if (removeOption.evaluate().isNotEmpty) {
  await tapFirst(tester, removeOption);                 // fotoğrafı kaldır
  await waitFor(tester, find.byType(AlertDialog));       // onay kutusu
  final confirmButtons = find.descendant(
    of: find.byType(AlertDialog), matching: find.byType(TextButton),
  ).evaluate().toList();
  await tester.tap(find.byWidget(confirmButtons.last.widget)); // "Kaldır" en sonda
  await wait(tester, 1500);
  final stillHasAvatarImage = find.descendant(
    of: find.byType(ProfileAvatar), matching: find.byType(AppNetworkImage),
  ).evaluate().isNotEmpty;
  expect(stillHasAvatarImage, isFalse);                  // artık avatar resmi yok
} else {
  await tester.tapAt(const Offset(20, 20));              // avatar yoksa sayfayı kapat
  await wait(tester, 500);
}
```
Profil ikonuna dokunuruz. Profil sayfasında fotoğraf değiştirme butonu bir
`AppPrimaryButton`'dır. Ona dokununca bir alt sayfa (bottom sheet) açılır;
içinde `photo_library_outlined` ikonu vardır. Eğer hesabın avatarı varsa
`delete_outline` (çöp kutusu) ikonu belirir: ona dokunup çıkan onay kutusunda
**son** butona (`Kaldır`) basarız. Sonra avatarın artık bir ağ resmi
göstermediğini (`isFalse`) doğrularız. Avatar yoksa sadece sayfayı kapatırız.

> Burada **gerçek galeri açılmaz**; sadece "fotoğrafı kaldır" akışı test edilir.
> Böylece test insan müdahalesi beklemeden biter.

### ADIM 7 — ADRES / KONUM (255–278)
```dart
await tapFirst(tester, find.byIcon(IconsaxPlusLinear.home_2)); // ana sayfaya dön
await waitFor(tester, find.byType(ProductCard));

await tapFirst(tester, find.byIcon(IconsaxPlusBroken.location)); // konum diyaloğu
await waitFor(tester, find.byType(AlertDialog));
final saveFinder = descendantOfType(AlertDialog, AppPrimaryButton);
await waitFor(tester, saveFinder);                               // "Kaydet" çıksın

String? city;
final appValues = tester.widgetList<AppValue>(find.byType(AppValue));
if (appValues.isNotEmpty) city = appValues.first.value;          // bulunan şehri oku

await tapFirst(tester, saveFinder);                              // adresi kaydet
await wait(tester);
if (city != null && city.trim().isNotEmpty) {
  expect(find.text(city), findsWidgets);                         // ana sayfada görünmeli
}
```
Ana sayfaya dönüp konum (location) ikonuna dokunuruz; bir `AlertDialog` açılır
ve içinde bulunnan şehir görünür. "Kaydet" butonu (`AppPrimaryButton`) çıkana
kadar bekleriz, şehir adını diyalogdaki ilk `AppValue`'den okuruz, kaydederiz.
Son olarak o şehir adının ana sayfa başlığında göründüğünü doğrularız.

> `find.text(city)` burada güvenlidir, çünkü `city` değeri uygulamanın kendisi
> tarafından üretilmiş (dinamik) bir değerdir; sabit bir dil etiketi değildir.

---

## F. Özet

Bu test, uygulamanın **gerçek kullanım akışını** insan gibi takip eder ve her
adımda "beklenen ekran parçası çıktı mı?" diye kontrol eder. Bulucular dil-
bağımsız (tip/ikon) olduğu için Arapça/İngilizce gibi dillerde de çalışır.
Çıktıda **"All tests passed!"** görürseniz uygulama uçtan uca sağlıklıdır.
