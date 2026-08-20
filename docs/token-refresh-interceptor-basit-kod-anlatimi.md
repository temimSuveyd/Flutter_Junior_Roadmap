# Token Refresh Interceptor — Kod Nasıl Çalışıyor? (Çok Basit Anlatım)

Bu doküman, son yazdığımız **TokenRefreshInterceptor** kodunu sıfırdan, satır satır anlatır. Önce sorunu anlayıp sonra her dosyayı tek tek okuyalım.

---

## 1) Önce Sorunu Anlayalım (benzetme ile)

Düşün ki okula girişte **bir kart** gösteriyorsun.

- Kartın üzerinde **senin numaran** yazar → bu **Access Token** (kısa ömürlü, mesela 1 saat).
- Bu kart **süre dolunca geçersiz** olur.
- Kart geçersizken kapıya gidersen kapıcı der ki: **"401 — bu kart geçersiz!"** (401 = Unauthorized).

Ama okulda bir de **veli kartın** var → bu **Refresh Token** (uzun ömürlü). Kapıcıya veli kartını gösterirsin, sana **yeni bir öğrenci kartı** verir, okula girersin. Kullanıcı bunun hiçbirini fark etmez.

**Sorun:** Aynı anda 10 kişi kapıya gelip kartı bozuk derse (10 istek aynı anda 401 alırsa), hepsi birden "yeni kart isteyeyim" diye koşarsa karışıklık çıkar, uygulama çökebilir. Bizim yazdığımız kod bunu da çözer.

---

## 2) İşin İçindeki Dosyalar (harita)

| Dosya | Ne işe yarar |
| --- | --- |
| `auth_token_manager.dart` | Token'ları **saklama/güncelleme/silme** sözleşmesi (arayüz). |
| `refresh_token_provider.dart` | "Bana yeni access token ver" sözleşmesi (arayüz). |
| `auth_service.dart` | Bu sözleşmeyi **gerçekten çalıştıran** kod. API'ye istek atar, yeni token'ı alır. |
| `token_refresh_interceptor.dart` | **Ana kahraman.** 401 gördüğünde hepsini yönetir. |
| `dio_clint.dart` | Bu kahramanı Dio'nun "istek sırasına" ekler. |

> **Arayüz (interface) ne demek?** Sadece "böyle bir şey olacak" diye söz veren şablondur. `abstract class` görürsen aklına "bu bir sözleşme" gel.

---

## 3) `refresh_token_provider.dart` — sözleşme

```dart
import 'package:dio/dio.dart';

abstract class RefreshTokenProvider {
  static const isRefreshRequestKey = 'is_refresh_request';

  Future<String?> refreshUserToken(String refreshToken, Dio dio);
}
```

Satır satır:

| Satır | Anlamı |
| --- | --- |
| `abstract class RefreshTokenProvider` | "Yeni token ver" diye bir şey olacak diye söz veriyoruz. |
| `isRefreshRequestKey = 'is_refresh_request'` | Sabit bir **etiket**. "Bu istek refresh isteğidir" diye isteğe işaret koymak için kullanılır. İleride "sonsuz döngü koruması"nda göreceğiz. |
| `Future<String?> refreshUserToken(String refreshToken, Dio dio)` | Söz: "refresh token ver, **bir de dio ver**, sana yeni access token döndüreceğim." <br> ⚠️ Dikkat: Buraya **dio** neden veriliyor? → Çünkü refresh isteği, normal isteklerin gittiği sıradan **ayrı** bir yol kullanmalı (nedenini 7. bölümde anlatacağız). |

---

## 4) `auth_service.dart` — sözleşmeyi gerçekten yapan kod

```dart
@override
Future<String?> refreshUserToken(String refreshToken, Dio dio) async {
  final response = await dio.post(
    ApiEndpoints.refreshToken,
    data: {'refresh_token': refreshToken},
    options: Options(
      extra: {RefreshTokenProvider.isRefreshRequestKey: true},
    ),
  );
  final data = response.data as Map<String, dynamic>;
  return data['token'] as String?;
}
```

Satır satır:

| Satır | Anlamı |
| --- | --- |
| `@override` | "Sözleşmedeki bu maddeyi ben uyguluyorum" demek. |
| `dio.post(...)` | API'ye **POST** isteği atıyoruz. Endpoint: `/auth/refresh`. |
| `data: {'refresh_token': refreshToken}` | Gövdeye (body) elimizdeki refresh token'ı koyuyoruz. |
| `extra: { is_refresh_request: true }` | Bu isteğe **"ben refresh isteğiyim"** etiketi takıyoruz. Böylece ana interceptor bu isteği görünce "bu zaten refresh isteği, buna bir daha refresh uygulama" diyecek (döngü koruması). |
| `return data['token'] as String?` | API cevabındaki `token` alanını geri döndürüyoruz. |

---

## 5) `token_refresh_interceptor.dart` — ana kahraman

Bu dosyayı parça parça inceleyelim. Hepsi bir **Interceptor**: Dio'nun her isteği geçerken uğradığı bir **kontrol noktası** gibi.

### 5.1) Sınıf ve kurucu (constructor)

```dart
class TokenRefreshInterceptor extends QueuedInterceptor {
  TokenRefreshInterceptor({
    required AuthTokenManager tokenManager,
    required RefreshTokenProvider Function() refreshTokenProvider,
    required Dio dio,
  })  : _tokenManager = tokenManager,
        _refreshTokenProvider = refreshTokenProvider,
        _dio = dio {
    _refreshDio = Dio(_dio.options);
  }
```

| Parça | Anlamı |
| --- | --- |
| `extends QueuedInterceptor` | Önceki hali sadece `Interceptor` idi. `QueuedInterceptor` bir **kuyruk (sıra)** tutar: gelen işlemleri **tek tek**, sırayla işler. Aynı anda 10 tane 401 gelse bile bunlar **yarışmaz**, birbiri ardına işlenir. İşte "aynı anda istek gelirse uygulama patlar" sorununun ana çözümü budur. |
| `tokenManager` | Token'ları okuyup yazacak alet. |
| `refreshTokenProvider` | Yeni token isteyecek alet. `Function()` yazması = "henüz hazır değil, **lazım olunca** çağır" (döngüyü kırmak için). |
| `dio` | Ana Dio. |
| `_refreshDio = Dio(_dio.options)` | **Yeni ve tertemiz bir Dio** yaratıyoruz. Ayarlarını ana Dio'dan kopyalıyor ama **hiç interceptor'ı yok**. Neden? → Bölüm 7'de. |

### 5.2) Alanlar (değişkenler)

```dart
static const _refreshedKey = 'token_refreshed';

final AuthTokenManager _tokenManager;
final RefreshTokenProvider Function() _refreshTokenProvider;
final Dio _dio;
late final Dio _refreshDio;

Future<String?>? _inFlightRefresh;
```

| Değişken | Anlamı |
| --- | --- |
| `_refreshedKey` | "Bu istek zaten bir kez yenilendi" etiketi. Aynı isteğin **ikinci kez** 401 vermesini tespit için. |
| `_tokenManager`, `_refreshTokenProvider`, `_dio`, `_refreshDio` | Kurucudan gelen aletlerin saklandığı yerler. |
| `_inFlightRefresh` | **"Devam eden refresh var mı?"** sorusunun cevabı. Null = yok. Bir future tutar. Aynı anda ikinci istek gelirse bunu bekler, tekrar refresh başlatmaz. |

### 5.3) Ana olay: `onError`

Dio her hata gördüğünde (mesela 401) bu metodu çağırır.

```dart
@override
Future<void> onError(
  DioException err,
  ErrorInterceptorHandler handler,
) async {
  final isRefreshRequest =
      err.requestOptions.extra[RefreshTokenProvider.isRefreshRequestKey] == true;
  final alreadyRefreshed = err.requestOptions.extra[_refreshedKey] == true;

  if (err.response?.statusCode != 401 ||
      isRefreshRequest ||
      alreadyRefreshed) {
    return handler.next(err);
  }
```

| Satır | Anlamı |
| --- | --- |
| `isRefreshRequest` | Bu hata, "refresh isteğinin kendisinden" mi geldi? (etiketle anlıyoruz) |
| `alreadyRefreshed` | Bu istek daha önce bir kez yenilenip tekrar denendiyse true. |
| `if (... ) return handler.next(err)` | **"Beni ilgilendirmiyor"** durumu. Üç hâlde bırakır gider: <br> 1. Hata 401 değilse, <br> 2. Hata refresh isteğinin kendisiyse, <br> 3. İstek zaten bir kez yenilendiyse. <br> `handler.next(err)` = "hatayı bir sonraki kontrol noktasına devret." Bu korumalar **sonsuz döngüyü** engeller. |

```dart
  final newAccessToken = await _getNewAccessToken();
  if (newAccessToken == null) {
    await _tokenManager.clearTokens();
    return handler.next(err);
  }
```

| Satır | Anlamı |
| --- | --- |
| `_getNewAccessToken()` | Yeni token al (Bölüm 5.4). |
| `newAccessToken == null` | Token alamadık (refresh token yok veya sunucu reddetti). |
| `clearTokens()` | O zaman tüm token'ları sil → `app_router`'daki redirect token'ı göremez → kullanıcı otomatik login ekranına düşer. |

```dart
  err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
  err.requestOptions.extra[_refreshedKey] = true;

  try {
    final response = await _refreshDio.fetch(err.requestOptions);
    return handler.resolve(response);
  } on DioException catch (retryError) {
    return handler.next(retryError);
  }
}
```

| Satır | Anlamı |
| --- | --- |
| `headers['Authorization'] = ...` | Patlayan isteğin başlığına **yeni token'ı** yaz. |
| `extra[_refreshedKey] = true` | Bu isteğe "bir kez yenilendim" damgası vur → bir daha refresh denenmesin. |
| `_refreshDio.fetch(err.requestOptions)` | Patlayan isteği **yeniden gönder**. `_refreshDio` kullanıyoruz → **aynı kuyruğa takılmaz** (Bölüm 7). |
| `handler.resolve(response)` | Başarılı oldu → "İşte cevap" diye sisteme teslim et. Kullanıcı hiçbir şey fark etmez. |
| `on DioException catch (retryError)` | Yeniden deneme de başarısız olursa hatayı devret. |

### 5.4) Tek seferlik refresh: `_getNewAccessToken` + `_refresh`

```dart
Future<String?> _getNewAccessToken() {
  final inFlight = _inFlightRefresh;
  if (inFlight != null) {
    return inFlight;
  }
  final future = _refresh().whenComplete(() {
    _inFlightRefresh = null;
  });
  _inFlightRefresh = future;
  return future;
}
```

| Satır | Anlamı |
| --- | --- |
| `inFlight != null` | Zaten bir refresh **devam ediyor** mu? Ediyorsa **aynı işi bekleyen** future'ı geri ver. → Tekrar refresh başlamaz. |
| `_inFlightRefresh = future` | "Bu refresh başladı, ben takip ediyorum" diye kaydet. |
| `whenComplete(() => _inFlightRefresh = null)` | Refresh bitince kaydı temizle. |

> Bu sayede aynı anda gelen 20 istek olsa bile **sadece 1 kez** refresh isteği atılır, 20'si de aynı sonucu paylaşır.

```dart
Future<String?> _refresh() async {
  final refreshToken = await _tokenManager.getRefreshToken();
  if (refreshToken == null) {
    return null;
  }
  try {
    final newAccessToken = await _refreshTokenProvider().refreshUserToken(
      refreshToken,
      _refreshDio,
    );
    if (newAccessToken == null) {
      return null;
    }
    await _tokenManager.saveTokens(
      accessToken: newAccessToken,
      refreshToken: refreshToken,
    );
    return newAccessToken;
  } catch (_) {
    return null;
  }
}
```

| Satır | Anlamı |
| --- | --- |
| `getRefreshToken()` | Saklı veli kartını (refresh token) oku. Yoksa `null` dön. |
| `refreshUserToken(refreshToken, _refreshDio)` | Sözleşmedeki kodu çağır, yeni token iste. **`_refreshDio` veriyoruz** ki bu istek ana kuyruğa takılmasın. |
| `if (newAccessToken == null) return null` | Sunucu yeni token vermediyse boş dön. |
| `saveTokens(...)` | Yeni token'ı hafızaya yaz. |
| `catch (_) { return null; }` | Herhangi bir hata olursa panik yapma, `null` dön (yukarısı zaten token'ları silip login ekranına atacak). |

---

## 6) `QueuedInterceptor` ne değiştirdi? (en önemli kısım)

Eskiden kod sadece `Interceptor` idi:

```
İstek A 401 olur → refresh başlar (çalışırken)
İstek B 401 olur → AYNEN AYNI ANDA refresh başlar  → İKİ refresh aynı anda → karışıklık / çökme
```

`QueuedInterceptor` her şeyi **sıraya** dizer:

```
İstek A 401 olur → refresh A başlar, biter, istek A yeniden gönderilir, biter.
İstek B ancak A bitince başlar → refresh gerekmez (zaten yeni token var) → hemen tekrar dener.
```

Yani **"aynı anda birden fazla istek gelirse uygulama patlar"** sorunu tam olarak burada çözülür.

---

## 7) Neden ayrı bir `_refreshDio`? (deadlock = kilitlenme)

`QueuedInterceptor` bir **sıra** tutar. Sıra şöyle çalışır: "Bir işlem bitmeden diğerine geçme."

Eğer refresh isteğini **aynı Dio'dan** gönderseydik:

```
1. İstek A 401 → interceptor sıraya girdi, sıra onu işliyor.
2. İçinde refresh isteği atıldı → bu istek DE aynı sıraya girmek istedi.
3. Ama sıra hâlâ A'yı işliyor, bitmesini bekliyor.
4. A da refresh'in sonucunu bekliyor.
→ İkisi birbirini bekler → sonsuza kadar kilitlenir (DEADLOCK).
```

Çözüm: **temiz bir Dio daha** yarat (`_refreshDio`). O sıraya hiç girmiyor. Böylece:

- Refresh isteği → temiz yoldan gider ✅
- Patlayan isteğin tekrarı → temiz yoldan gider ✅
- Ana sıra hiç kilitlenmez ✅

---

## 8) Özet: Kullanıcı ne görür?

1. Telefonda bir istek atılıyor (ör. ürün listesi).
2. Token bitmiş → API "401" diyor.
3. Kod arka planda: refresh token ile yeni access token alıyor → kaydediyor → isteği tekrar gönderiyor.
4. Kullanıcı **hiçbir şey fark etmiyor**, ekran normal çalışıyor.
5. Eğer refresh de olmuyorsa (kullanıcı çok uzun süre girmemiş) → tokenlar silinir → otomatik login ekranı.

---

## 9) Hızlı tekrar — mini sözlük

| Terim | Ne demek |
| --- | --- |
| Access Token | Kısa ömürlü giriş kartı (1 saat gibi). |
| Refresh Token | Uzun ömürlü veli kartı; yeni access token almak için kullanılır. |
| 401 Unauthorized | "Kimliğin geçersiz/süresi dolmuş" hatası. |
| Interceptor | Dio'nun istekleri geçerken uğradığı kontrol noktası. |
| QueuedInterceptor | Kontrol noktasını **sıraya** çeviren versiyonu. |
| Single-flight | "Bir iş devam ederken aynısını bir daha başlatma, sonucu paylaş" tekniği. |
| Deadlock | İki işin birbirini bekleyip kilitlenmesi. |
| `handler.next(err)` | "Bu hatayla işim bitti, devrediyorum." |
| `handler.resolve(response)` | "Bu isteği ben başarıyla hallettim, işte sonuç." |