# Token Refresh Interceptor — Çok Basit Anlatım

## Sorun
Access token'lar bir süre sonra **biter (expire)**. Token bittiğinde API `401 (Unauthorized)` döner. Bu olmadan önce herkesi tekrar login ekranına atmak gerekir.

## Çözüm: `TokenRefreshInterceptor`
Bu interceptor 401 görünce otomatik olarak:
1. Yeni access token alır (sakladığımız **refresh token** ile).
2. Yeni token'ı güvenli hafızaya kaydeder.
3. **Patlayan isteği yeniden gönderir** — kullanıcı hiçbir şey görmez, işlem devam eder.

## Adım Adım Akış

```
İstek atılır → API "401" döner
      │
      ▼
TokenRefreshInterceptor devreye girer
      │
      ├─ 1. Refresh token var mı?  → YOKSA: tüm tokenları sil → login ekranına
      │
      ├─ 2. refreshUserToken(refreshToken) ile yeni access token iste
      │        → BAŞARISIZSA: tüm tokenları sil → login ekranına
      │
      ├─ 3. Yeni token'ı kaydet (saveTokens)
      │
      ├─ 4. Eski isteğin başlığına yeni token'ı yaz
      │
      └─ 5. İsteği yeniden gönder (dio.fetch) → başarıyı sisteme teslim et
```

## Kurallar (kodda görülenler)

| Kural | Ne yapar |
| --- | --- |
| `statusCode == 401` değilse | Hiç dokunmaz, hatayı bir sonraki interceptor'a paslar |
| Refresh token yok / refresh başarısız | `clearTokens()` → `app_router`'daki redirect token'ı göremez → kullanıcı otomatik login ekranına düşer |
| `is_refresh_request` işareti | Refresh çağrısının kendisi 401 olursa tekrar refresh denemesin (sonsuz döngü koruması) |
| `token_refreshed` işareti | Aynı istek ikinci kez 401 yerse bir daha refresh denemesin (döngü koruması) |

## Yapılan Dosyalar

| Dosya | İçerik |
| --- | --- |
| `core/storage/auth_token_manager.dart` | Token yönetimi **arayüzü** (get/save/clear) |
| `core/storage/secure_storage_token_manager.dart` | Arayüzün şimdilik çalışan hali (güvenli hafıza, `auth_token` + `refresh_token` key'leri) |
| `core/services/auth/refresh_token_provider.dart` | "Yeni token ver" **arayüzü** |
| `core/services/network/interceptors/token_refresh_interceptor.dart` | **Ana iş:** 401 → refresh → isteği tekrar gönder |
| `auth_service.dart` | `refreshUserToken` eklendi (artık `RefreshTokenProvider`'ı da uyguluyor) |
| `api_endpoints.dart` | `/auth/refresh` endpoint'i eklendi |
| `error_interceptor.dart` | 401'de token silme kaldırıldı (bu iş artık refresh interceptor'ında) |
| `dio_clint.dart` | Interceptor lazy eklendi (döngü yok); `get`/`post`'a `Options` desteği |
| `injection.dart` | Token manager kaydı + DioClient'a lazy bağlantı |
| `app_router.dart` | Redirect aktifleştirildi (token yoksa login ekranına atar) |

## Döngü (Circular Dependency) Nasıl Çözüldü
`AuthService` → `DioClient` gerekli, `DioClient` da `AuthService`'i istiyor (refresh için). Kısır döngü olmasın diye: `DioClient`, AuthService'i **lazy** alıyor — yani sadece gerçekten 401 olunca `getIt<AuthService>()` ile çözülüyor. Kurulum anında değil.

## Şimdilik Bilinmesi Gerekenler
- `/auth/refresh` endpoint'i şimdilik **fake** — gerçek API'nle değiştirmen gerekir.
- **Login cevabında refresh token dönmüyor** (DTO'da sadece `token` var). Refresh akışının tam çalışması için backend'in login cevabına `refresh_token` eklemesi ve onu kaydetmen gerekir.
- Basit versiyonda aynı anda gelen birden fazla 401 için tek refresh çağrısı yapılır; çok eşzamanlı istek varsa iyileştirilebilir.