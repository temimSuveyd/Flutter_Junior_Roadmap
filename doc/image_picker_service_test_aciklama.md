# Image Picker Service Testi Açıklaması
(`test/core/services/device_features/image_picker_service_test.dart`)

Bu dosya, **kamera/galeri ile resim seçme** mantığını test eder. Önce
`test_temelleri.md` dosyasını okuyun. Bu bir **unit (birim)** testidir; yani
uygulamanın tamamını değil, sadece `ImagePickerServiceImpl` adlı tek bir sınıfı
test eder. Ve gerçek kamera/galeri AÇILMAZ — onun yerine sahte (fake) nesneler
kullanırız.

---

## A. Çalıştırma

```powershell
flutter test test/core/services/device_features/image_picker_service_test.dart
```
Bilgisayarda çalışır, cihaz gerekmez. Çıktı: `All tests passed!`

---

## B. Test Edilen Gerçek Sınıf (kısaca)

`lib/core/services/device_features/image_picker_service.dart` içinde:

```dart
abstract class ImagePickerService {
  Future<File?> pickImageFromCamera();
  Future<File?> pickImageFromGallery();
}

class ImagePickerServiceImpl implements ImagePickerService {
  ImagePickerServiceImpl(this._permissionService, [ImagePicker? picker])
      : _picker = picker ?? ImagePicker();

  final PermissionService _permissionService;
  final ImagePicker _picker;

  Future<File?> pickImageFromCamera() async {
    final hasPermission = await _permissionService.checkAndRequestCameraPermission();
    if (!hasPermission) return null;          // izin yoksa hemen null
    return _pick(source: ImageSource.camera);
  }

  Future<File?> pickImageFromGallery() async {
    final hasPermission = await _permissionService.checkAndRequestPhotoPermission();
    if (!hasPermission) return null;
    return _pick(source: ImageSource.gallery);
  }

  Future<File?> _pick({required ImageSource source}) async {
    final picked = await _picker.pickImage(
      source: source, maxWidth: 1024, maxHeight: 1024, imageQuality: 85);
    if (picked == null) return null;           // kullanıcı iptal ettiyse null
    return File(picked.path);
  }
}
```

Mantık basit:
1. Önce izin iste.
2. İzin yoksa `null` döndür, kamerayı hiç açma.
3. İzin varsa `ImagePicker` ile resim al; kullanıcı iptal ettiyse `null`,
   seçerse `File` döndür.

> **Dikkat:** Constructor `[ImagePicker? picker]` şeklinde bir parametre aldığı
> için test, kendi `FakeImagePicker`'ını verebilir. Bu sayede gerçek kamera
> açılmaz. (Bu esneklik, test yazılabilsin diye koda eklenmiş bir değişikliktir.)

---

## C. Import Satırları (1–7)

```dart
import 'dart:io';                                                       // File/XFile
import 'package:flutter_test/flutter_test.dart';                        // test, expect
import 'package:image_picker/image_picker.dart';                        // XFile, ImageSource
import 'package:juniorflutterroadmap/core/services/device_features/permission_service.dart';
import 'package:juniorflutterroadmap/core/services/device_features/image_picker_service.dart';
import 'package:mocktail/mocktail.dart';                                // Mock/Fake
```
`mocktail` burada sahte sınıfları üretmemizi sağlar.

---

## D. Sahte (Fake/Mock) Sınıflar (9–34)

### `MockPermissionService` (10)
```dart
class MockPermissionService extends Mock implements PermissionService {}
```
İzin sisteminin taklididir. Gerçek izin penceresi açılmaz; biz "şu sorulursa
şu cevabı ver" deriz.

### `MockImagePickerService` (14)
```dart
class MockImagePickerService extends Mock implements ImagePickerService {}
```
`ImagePickerService`'in kendisinin taklididir. Bunu, başka testlerde (örneğin
profil sayfası testi) gerçek resim seçme yerine kullanmak için "tekrar
kullanılabilir" bir mock olarak tanımladık.

### `FakeImagePicker` (18–34)
```dart
class FakeImagePicker extends Fake implements ImagePicker {
  XFile? picked;
  int pickCallCount = 0;

  @override
  Future<XFile?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool? requestFullMetadata,
  }) async {
    pickCallCount++;
    return picked;
  }
}
```
Gerçek `ImagePicker` yerine geçen basit bir kopyadır:
- `picked` değişkenine ne koyarsak onu döndürür (örneğin `XFile('fake_photo.jpg')`).
- `null` koyarsak "kullanıcı iptal etti" durumunu taklit eder.
- `pickCallCount` sayesinde "pickImage gerçekten çağrıldı mı?" diye doğrulayabiliriz.
  Bu çok önemlidir: izin yokken kameranın hiç açılmadığını kanıtlarız.

---

## E. `main()` — İlk grup: `ImagePickerServiceImpl` (36–94)

```dart
group('ImagePickerServiceImpl', () {
  late MockPermissionService permission;
  late FakeImagePicker picker;
  late ImagePickerServiceImpl service;

  setUp(() {
    permission = MockPermissionService();
    picker = FakeImagePicker();
    service = ImagePickerServiceImpl(permission, picker);  // fake'i veriyoruz
  });
```
Her testten önce temiz bir `MockPermissionService`, `FakeImagePicker` ve
servis oluşturulur. Servise `picker` olarak fake verildiğine dikkat edin.

### Test 1 — İzin yoksa kamera açılmaz (48–57)
```dart
test('camera: returns null and never opens picker when permission denied', () async {
  when(() => permission.checkAndRequestCameraPermission())
      .thenAnswer((_) async => false);              // "izin sorulursa false de"

  final result = await service.pickImageFromCamera();

  expect(result, isNull);           // sonuç null olmalı
  expect(picker.pickCallCount, 0);  // kamera HİÇ çağrılmamalı
});
```
`when(...).thenAnswer(...)` ile "izin methodu false döndürsün" deriz. Servis
izin alamayınca `null` verir ve `pickCallCount` hâlâ `0`'dır; yani gerçek
kamera açılmamıştır. Bu, "izin reddedilince kullanıcıyı zorla kameraya
sokmuyoruz" kuralını test eder.

### Test 2 — İzin yoksa galeri açılmaz (59–68)
```dart
test('gallery: returns null and never opens picker when permission denied', () async {
  when(() => permission.checkAndRequestPhotoPermission())
      .thenAnswer((_) async => false);

  final result = await service.pickImageFromGallery();

  expect(result, isNull);
  expect(picker.pickCallCount, 0);
});
```
Aynısı galeri içindir (fotoğraf izni).

### Test 3 — İzin var ve resim seçildi (70–81)
```dart
test('camera: returns a File when permission granted and an image is picked', () async {
  when(() => permission.checkAndRequestCameraPermission())
      .thenAnswer((_) async => true);          // izin verildi
  picker.picked = XFile('fake_photo.jpg');     // fake seçilen dosya

  final result = await service.pickImageFromCamera();

  expect(result, isNotNull);                   // bir şey döndü
  expect(result!.path, 'fake_photo.jpg');      // doğru dosya yolu
  expect(picker.pickCallCount, 1);             // tam 1 kez çağrıldı
});
```
İzin verilince `FakeImagePicker` `fake_photo.jpg` döndürür; servis bunu `File`
olarak verir. `pickCallCount == 1` ile kameranın gerçekten (fake ile) çağrıldığını
doğrularız.

### Test 4 — İzin var ama kullanıcı iptal etti (83–93)
```dart
test('gallery: returns null when permission granted but user cancels', () async {
  when(() => permission.checkAndRequestPhotoPermission())
      .thenAnswer((_) async => true);
  picker.picked = null;                         // kullanıcı seçimden vazgeçti

  final result = await service.pickImageFromGallery();

  expect(result, isNull);                       // null dönmeli
  expect(picker.pickCallCount, 1);              // ama picker YİNE çağrıldı
});
```
İzin varken galeri açılır; ama kullanıcı bir şey seçmeden çıkarsa servis
`null` döndürür. `pickCallCount == 1` ile "galeri açıldı ama sonuç boş" durumunu
ayırt ederiz.

---

## F. İkinci grup: `MockImagePickerService` (96–106)

```dart
group('MockImagePickerService (reusable mock)', () {
  test('can be stubbed to return a picked file', () async {
    final mock = MockImagePickerService();
    when(() => mock.pickImageFromGallery())
        .thenAnswer((_) async => File('picked.png'));

    final result = await mock.pickImageFromGallery();

    expect(result?.path, 'picked.png');
  });
});
```
Bu grup, `MockImagePickerService`'in **başka testlerde** nasıl kullanılacağını
gösterir. Bir widget/bloc testi, gerçek servis yerine bu mock'u alıp
`pickImageFromGallery` sorulunca `File('picked.png')` döndürsün diyebilir. Böylece
profil sayfası testi gerçek kameraya/galeriye hiç dokunmaz.

---

## G. Özet

- 4 test, servisin 4 davranışını kapsar: izin yok → null + picker çağrılmaz;
  izin var + seçim var → `File`; izin var + iptal → `null`.
- `MockPermissionService` ile izin taklit edilir, `FakeImagePicker` ile kamera
  taklit edilir; böylece test bilgisayarda, gerçek cihaz olmadan çalışır.
- Çıktı **"All tests passed!"** ise resim seçme mantığı sağlamdır.
