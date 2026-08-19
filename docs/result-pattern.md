# Result Pattern (B Seçeneği)

Bu doküman, repository katmanında tekrarlanan `try-catch` bloklarını ortadan kaldırmak için uygulanan **B seçeneğini** (tip güvenli `Result<T>` pattern) açıklar.

## Problem

Her repository metodu aynı hata yakalama mantığını kopyalıyordu:

```dart
try {
  final response = await _authService.signIn(loginDto);
  ...
  return (null, true);
} on Failure catch (customFailure) {
  return (customFailure, null);
} catch (unexpectedError) {
  final systemFailure = Failure(
    "A system error occurred: ${unexpectedError.toString()}",
  );
  return (systemFailure, null);
}
```

Ayrıca dönen tip `(Failure? failure, T? data)` record'uydu. Bu iki sorun yaratır:

1. **Kopyalanan kod**: Her metodun başına aynı try-catch yazılıyor.
2. **Tip güvensizliği**: Record'daki iki alan da nullable — ikisi aynı anda `null` veya dolu olabilir; derleyici bunu engelleyemez.

## Çözüm: Sealed `Result<T>`

`lib/core/errors/result.dart` dosyasında sealed bir `Result<T>` tipi tanımlandı:

- `Success<T>` — yalnızca başarılı veriyi tutar (`data`).
- `Error<T>` — yalnızca hata nesnesini tutar (`error`, `Failure` tipinde).

`sealed` olduğu için bu tipin tüm alt türleri aynı dosyada tanımlanır ve derleyici, UI/bloc katmanında `switch` kullanıldığında **tüm durumların kapatılmasını zorunlu kılar**. Bir durum unutulursa kod derlenmez.

## Tekrarı Bitiren Yardımcılar

`result.dart` içinde iki yardımcı var:

1. **`runCatching<T>(Future<T> Function() body)`** — tüm try-catch mantığını tek yerde tutar:
   - `Failure` fırlatılırsa → `Error(customFailure)`
   - Beklenmeyen hata olursa → `Failure("A system error occurred: ...")`'e sarıp `Error(...)`
   - Başarılı olursa → `Success(data)`

2. **`FutureResult<T> extension`** — tek satırlık çağrılar için `Future<T>` üzerinde `toResult()` sağlar (içten `runCatching` kullanır).

## Kullanım

### Repository

Çok adımlı mantık için `runCatching`:

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

Tek servis çağrısı için `toResult()`:

```dart
@override
Future<Result<List<ProductModel>>> getProducts() {
  return _productServices.getProducts().toResult();
}
```

Repository artık `(Failure?, T?)` yerine `Future<Result<T>>` döner.

### Bloc (Caller)

Caller `if` yerine exhaustive `switch` kullanır:

```dart
final result = await _productRepository.getProducts();
switch (result) {
  case Success(:final data):
    emit(ProductLoaded(data));
  case Error(:final error):
    emit(ProductError(error.message));
}
```

Başarı verisi gerekmiyorsa `case Success():` yazılır.

## Avantajlar

- **DRY**: try-catch artık yalnızca tek yerde (`runCatching`).
- **Tip güvenli**: `Result`'ın yalnızca bir hali var olabilir; `null` belirsizliği kalkar.
- **Exhaustive kontrol**: `switch`'te bir durumu unutmak derleme hatasıdır.
- **Okunabilirlik**: Repository metotları iş mantığına odaklanır.

## Değişen Dosyalar

| Dosya | Değişiklik |
| --- | --- |
| `lib/core/errors/result.dart` | Yeni: `Result`, `Success`, `Error`, `runCatching`, `toResult` |
| `lib/features/auth/data/repositories/auth_repository.dart` | `Result<bool>` / `Result<UserModel>` döner |
| `lib/features/products/data/repositories/product_repositories.dart` | `Result<List<ProductModel>>` döner |
| `lib/features/auth/presentation/bloc/auth_bloc.dart` | `switch` pattern kullanır |
| `lib/features/products/presentation/bloc/product_bloc.dart` | `switch` pattern kullanır |

## Neden Mixin Değil?

Mixin'ler sınıflar arasında davranış paylaşmak içindir. Burada paylaşılan şey bir **tip** (`Result<T>`) ve tek bir **fonksiyon**dur (`runCatching`). Extension + top-level fonksiyon, bu ihtiyacı daha idiomatik şekilde karşılar; mixin eklemek gereksiz kalabalık olurdu.
