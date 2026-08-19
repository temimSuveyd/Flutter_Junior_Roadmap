# Result Pattern — Çok Basit Anlatım

Bu doküman, koddaki yapıyı **sıfırdan, adım adım** açıklar. Amacı: ne yaptık, neden yaptık, nasıl çalışıyor — hepsi günlük dilde.

---

## 0. Baştan: Sorun neydi?

Eski kodda her repository metodu şöyleydi:

```dart
try {
  final response = await _authService.signIn(loginDto);
  await _secureStorage.saveToken(response.token);
  return (null, true);          // başarı: hata yok, değer "true"
} on Failure catch (customFailure) {
  return (customFailure, null); // hata var, değer yok
} catch (unexpectedError) {
  final systemFailure = Failure("A system error occurred: ${unexpectedError.toString()}");
  return (systemFailure, null); // beklenmedik hata
}
```

**İki kötü tarafı vardı:**

1. **Kopyala-yapıştır:** Aynı `try-catch` bloğu her metoda aynen yazılıyordu. Bir yerde hata mesajını değiştirsen, hepsini ayrı ayrı bulup değiştirmen gerekir.
2. **`(Failure?, bool?)` tipi güvensizdi:** Bu, "hata olabilir **ve** değer olabilir" demek. İkisi birden `null` olabilir mi? İkisi birden dolu olabilir mi? **Derleyici bunu bilmez, kontrol edemez.** İnsan hatasına açık.

---

## 1. Ana Fikir: "Kutu" (`Result`)

Bir kargo kutusu düşün. İçinde **ya** senin istediğin ürün var **ya da** "kargo kayboldu" notu var. İkisi aynı anda olamaz.

Kodda bunu `Result<T>` diye bir kutu olarak düşündük:

- Kutu `Success` ise → içinde **veri** var (senin istediğin şey).
- Kutu `Error` ise → içinde **hata** var.

Bu kutuyu tanımlayan tek dosya: `lib/core/errors/result.dart`.

---

## 2. Adım 1: `result.dart` dosyası (kutunun tanımı)

Bu dosya 5 küçük parçadan oluşur. Tek tek bakalım.

### 2.1 `sealed class Result<T>`

```dart
sealed class Result<T> {
  const Result();
}
```

- `sealed` = "Bu kutunun çeşitleri yalnızca bu dosyada tanımlanabilir." Böylece kimse başka bir yerde üçüncü bir çeşit (`PartialResult` gibi) uydurup işi bozamaz.
- `<T>` (generic) = "Kutu herhangi bir tipte veri taşıyabilir." `Result<bool>`, `Result<UserModel>`, `Result<List<ProductModel>>` hepsi olabilir. `T`, o anda hangi tip ise o olur.
- `const Result();` = sadece "kutu var" demek, dışarıdan biri doğrudan `Result()` yaratmasın diye gövdesiz.

### 2.2 `Success<T>` — "Başarılı kutu"

```dart
final class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}
```

- `extends Result<T>` = bu, kutunun bir çeşidi.
- `final T data;` = içinde tuttuğu tek şey: **veri**.
- `const Success(this.data);` = yapıcı; `Success(5)` dersen 5'i `data`'ya koyar.

### 2.3 `Error<T>` — "Hatalı kutu"

```dart
final class Error<T> extends Result<T> {
  final Failure error;
  const Error(this.error);
}
```

- Kutunun diğer çeşidi. Veri değil, **`Failure` tipinde hata** tutar.
- `Failure`, zaten projede var olan sınıf (`core/services/network/failure.dart`), içinde `message` ve `statusCode` var.

> Şimdiye kadar: kutu = `Result`, kutunun iki hali = `Success` / `Error`. Bitti. Bu kısım sadece "kalıp" tanımlar.

### 2.4 `runCatching` — "Hata yakalama robotu"

```dart
Future<Result<T>> runCatching<T>(Future<T> Function() body) async {
  try {
    return Success(await body());
  } on Failure catch (customFailure) {
    return Error(customFailure);
  } catch (unexpectedError) {
    return Error(
      Failure("A system error occurred: ${unexpectedError.toString()}"),
    );
  }
}
```

Bu, **senin eski `try-catch` bloğunun ta kendisi**. Sadece bu sefer her metoda yazmak yerine **tek bir fonksiyon** içinde duruyor.

Nasıl çalışır:

- `body` = "yapılacak iş" (bir `Future` döndüren fonksiyon).
- `await body()` = işi dene.
- Başarılıysa → `Success(await body())` → işin sonucu kutuya veri olarak konur.
- `on Failure` → bilinen hata geldiyse → `Error(customFailure)` → hata kutuya konur, aynen eski kod gibi.
- `catch (unexpectedError)` → başka bir şey patlarsa → `Failure("A system error occurred: ...")` yapıp `Error` kutusuna koyar.

Yani senin eski bloklarının **birebir aynısı**, sadece bir kez yazılmış hali.

### 2.5 `toResult` — Kısayol

```dart
extension FutureResult<T> on Future<T> {
  Future<Result<T>> toResult() => runCatching(() => this);
}
```

- `extension ... on Future<T>` = "Bütün `Future`'lere yeni bir yetenek ekle." Bu bir **mixin değil**, extension. Mixin sınıflara yetenek katar, extension hazır tiplere (burada `Future`) yetenek katar.
- `toResult()` = "Bu `Future`'ı `runCatching` ile sar." Yani tek satırlık `runCatching` çağrısı.

Kullanımı: `_productServices.getProducts().toResult()` → "ürünleri çek ve sonucu kutuya koy, hata da olsa."

---

## 3. Adım 2: `auth_repository.dart` — Repository nasıl değişti?

**Eski imza:**
```dart
Future<(Failure? failure, bool? isSuccess)> loginUser(SignInRequestDto loginDto);
```

**Yeni imza:**
```dart
Future<Result<bool>> loginUser(SignInRequestDto loginDto);
```

Dikkat: `(Failure?, bool?)` yerine `Result<bool>` — yani "işin sonucu bir **kutu** olacak; kutuda ya `true` ya da hata var."

**Eski gövde** (uzun `try-catch`) → **yeni gövde**:

```dart
@override
Future<Result<bool>> loginUser(SignInRequestDto loginDto) {
  return runCatching(() async {
    final response = await _authService.signIn(loginDto);
    await _secureStorage.saveToken(response.token);
    return true;
  });
}
```

Neden `runCatching` (robota sarıyoruz) kullanıldı da `toResult` değil?
- `loginUser` tek bir işlem değil: **iki** işlem yapıyor (login + token kaydetme).
- `runCatching(() async { ... })` içine birden fazla satır koyulabiliyor. Robot hepsini dener, hangisi patlarsa yakalar.

`registerUser` de aynı mantık; sadece başarı verisi `UserModel`.

---

## 4. Adım 3: `product_repositories.dart`

```dart
@override
Future<Result<List<ProductModel>>> getProducts() {
  return _productServices.getProducts().toResult();
}
```

Burada tek işlem var: ürünleri çek. O yüzden `runCatching` yerine kısayol `toResult()` kullanıldı. İkisi aynı şey; kısayol daha az yazı.

---

## 5. Adım 4: Bloc tarafı — Kutuyu açma (`switch`)

Artık repository bir **kutu** veriyor. Bloc, kutuyu açıp içine bakmalı:

```dart
final result = await _authRepository.loginUser(event.signInRequestDto);
switch (result) {
  case Success():
    emit(AuthSignInSuccess());
  case Error(:final error):
    emit(AuthError(error.message));
}
```

Satır satır:

- `case Success():` → "Kutu başarılıysa" → giriş başarılı durumunu yay.
- `case Error(:final error):` → "Kutu hatalıysa" → içindeki `error`'ı al (`:final error` = kutudan hatayı çıkar) → `error.message`'ı ekrana ver.

Neden `switch` zorunlu? Çünkü `Result` **sealed**. Derleyici, "bunun iki hali var, ikisini de yazmalısın" diye seni **zorlar**. Birini unutursan kod **derlenmez**. Eski `if (failure != null)`'da hata yapabilirdin (örneğin ikisini de `null` kabul edip hiçbir şey yaymayan bir durum), şimdi imkânsız.

`ProductBloc` da aynı, tek fark başarıda veriyi kullanıyor:

```dart
case Success(:final data):
  emit(ProductLoaded(data));
```

`data` = ürünler listesi, doğrudan duruma koyulur.

---

## 6. Akışın Özeti

```
Service (API'yi çağırır, Failure fırlatır)
        │
        ▼
Repository  ──>  runCatching/toResult (kutuyu doldurur)
        │               │
        │               └── başarılıysa  → Success(veri)
        │                   hata varsa    → Error(hata)
        ▼
Bloc  ──>  switch (kutuyu açar)
        │      ├── case Success → başarı state'i
        │      └── case Error   → hata mesajı state'i
        ▼
UI / State
```

---

## 7. Neden Mixin Kullanmadık?

Mixin, **bir grup sınıf**a aynı yeteneği kazandırmak içindir. Burada gerek yok:

- `Result` = bir **tip** (kalıp) — class olarak tanımlanır.
- `runCatching` = tek bir **fonksiyon** — her yerden çağrılabilir.
- `toResult` = hazır `Future` tipine yetenek — **extension** ile eklenir.

Mixin eklemek bu üçünü gereksiz yere birbirine bağlardı.

---

## 8. Hangi Dosyada Ne Var? (kısa tablo)

| Dosya | İçeriği | Rolü |
| --- | --- | --- |
| `lib/core/errors/result.dart` | `Result`, `Success`, `Error`, `runCatching`, `toResult` | Kutuyu tanımlar + hata yakalama robotu |
| `auth_repository.dart` | `runCatching(...)` | Login/register çağrılarını kutuya sarar |
| `product_repositories.dart` | `.toResult()` | Ürünleri çekip kutuya sarar |
| `auth_bloc.dart` | `switch (result)` | Kutuyu açıp state üretir |
| `product_bloc.dart` | `switch (result)` | Kutuyu açıp state üretir |

---

## 9. Özet (tek cümleyle)

Eski koddaki `try-catch` kopyalarını **tek bir fonksiyona** (`runCatching`) taşıdık, dönen değeri de **iki ihtimalli bir kutuya** (`Result<T>`) çevirdik; artık hiçbir yerde `try-catch` yazmıyoruz, sadece kutuyu açıp `switch` ile iki ihtimali de zorunlu olarak ele alıyoruz.
