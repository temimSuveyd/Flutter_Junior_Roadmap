# Proje İnceleme Raporu (Sade ve Anlaşılır Türkçe)

Bu rapor, projedeki sorunları çok basit bir dille açıklar. Her sorunun yanında ne olduğunu ve nasıl düzelteceğini bulacaksın.

---

## 1. Mantık Hataları (Kod Yanlış Çalışıyor)

### 1.1 Giriş (Auth) Bölümündeki Sorunlar
**Dosya:** `lib/features/auth/presentation/Bloc/auth_bloc.dart` (satır 27-61)

- **Aynı işlem birden fazla kez başlıyor:** Kullanıcı hızlıca butona basarsa aynı giriş işlemi birden fazla başlayabiliyor.
- **Bekleyen işlem durmuyor:** Sayfa kapanınca bile devam eden internet isteği bitip yanlış durum gönderebiliyor.
- **İptal edilemiyor:** Giriş yaparken yapılan internet istekleri iptal edilemiyor.

**Çözüm:** Butonları kısa sürede tekrar basılamaz yap. İnternet isteklerini `CancelToken` ile iptal et.

### 1.2 Profil Bölümündeki Sorunlar
**Dosya:** `lib/features/profile/presentation/Bloc/profile_bloc.dart` (satır 38-56)

- **Aynı anda iki fotoğraf yükleme:** Kullanıcı hızlıca iki kez fotoğraf seçerse ikisi de aynı anda yükleniyor ve karışıyor.
- **Hata mesajı belirsiz:** Fotoğraf yüklenmezse kullanıcıya net bir sebep gösterilmiyor.

**Çözüm:** Yükleme devam ederken ikinci isteği engelle. Hata mesajını daha açıklayıcı yap.

### 1.3 Ürün Yükleme Sorunu
**Dosya:** `lib/features/products/presentation/pages/home_page.dart` (satır 8-12)

- **Sonsuz döngü riski:** Hata olunca "yükleniyor" durumu hiç bitmezse uygulama takılı kalabilir.
- **Aynı istek tekrar tekrar:** Sayfa her yenilendiğinde gereksiz yere ürün tekrar isteniyor.

**Çözüm:** Hata durumunda "yükleniyor"u mutlaka bitir. Aynı anda birden fazla yenilemeyi engelle.

### 1.4 Oturum Yönetimi
**Dosya:** `lib/core/services/auth/session_expired_controller.dart` (satır 11-15)

- **Çakışma riski:** Oturum bitti işareti aynı anda birden fazla yerden değiştirilince hata çıkabiliyor.

**Çözüm:** Bu işareti güvenli (senkron) bir şekilde kontrol et.

### 1.5 Sayfa Geçişi (Navigasyon)
**Dosya:** `lib/features/products/presentation/pages/main_shell.dart` (satır 23-39)

- **Hızlı tıklamada çakışma:** Kullanıcı alt menüde hızlıca iki sekmeye basarsa hangi sayfanın açılacağı karışabiliyor.

**Çözüm:** Son basılan sekmeyi esas al, çakışmayı engelle.

---

## 2. Mimari Hatalar (Yapısal Sorunlar)

### 2.1 Durum Yönetimi
- **Ortak kod yok:** Benzer BLoC'lar var ama aralarında paylaşılan bir temel sınıf yok, kod tekrarı çok.
- **Bağımlılık fazla iç içe:** `getIt` ile her şey birbirine çok bağlı, kodu değiştirmek zor.
- **Karışık kullanım:** BLoC ve Cubit karışık kullanılmış, hangi nerede kullanılmalı belli değil.

**Çözüm:** BLoC mı Cubit mi karar ver ve proje boyunca onu kullan. Ortak işleri tek yere topla.

### 2.2 Bağımlılık (Dependency Injection)
- **Global değişken gibi davranan singletons:** Bazı sınıflar her yerden erişilince test edilmesi zorlaşıyor.
- **Dairevi bağımlılık:** Bir sınıf diğerine, o da ona bağlı olduğu için sistem karışıyor.

**Çözüm:** Gereksiz singleton kullanma. Bağımlılıkları test edilebilir şekilde ver.

### 2.3 Yönlendirme (Routing)
- **Elle hesaplama:** Navigasyon durumu elle hesaplanmış, hazır sistem (GoRouter) kullanılmamış.
- **Güvenlik kapalı:** Giriş koruması (auth guard) yorum satırına alınmış, yani herkes her sayfaya girebiliyor.

**Çözüm:** GoRouter'ın kendi mantığını kullan. Giriş korumasını geri aç.

### 2.4 Tema
- **Çift tema kaydı:** Hem `ThemeCubit` hem `AppTheme` ayrı ayrı tema tutuyor, kafalar karışıyor.
- **Sistem teması yok:** Telefon karanlık moda alınca uygulama takip etmiyor.

**Çözüm:** Tema kaynağını tek yap. Sistem temasını takip et.

---

## 3. Yazım ve Düzen Hataları

### 3.1 Import (Kütüphane) Düzeni
- **Kullanılmayan importlar:** Birçok dosyada gereksiz `import` satırı var.
- **Karışık yazım:** Bazı yerde `../` ile bazen tam yol ile import edilmiş.

**Çözüm:** Kullanılmayan importları sil. Import düzenini proje genelinde aynı yap.

### 3.2 İsimlendirme
- **Tutarsız isimler:** `AuthService`, `AuthServiceImpl`, `AuthRepository`, `AuthRepositoryImpl` gibi isimler karışık.

**Çözüm:** Bir isimlendirme kuralı seç ve her yerde uygula.

### 3.3 Kod Yapısı
- **Anlamsız rakamlar:** `9999` gibi ne olduğu belli olmayan sabit sayılar var.
- **Yazım hatası:** `authBackgroundImapge` kelimesinde yanlış yazılmış (`Imapge`).

**Çözüm:** Sabit sayıları anlamlı isimle tanımla. Yazım hatalarını düzelt.

### 3.4 Dosya Düzeni
- **Aynı işi yapan iki servis:** `features/data/service/local/` ile `core` içindeki servisler çakşıyor.

**Çözüm:** Aynı işi yapan dosyaları birleştir veya birini sil.

---

## 4. Kötü Alışkanlıklar (Anti-patterns)

- **Gereksiz tekrar:** Aynı `BlocConsumer` yapısı her yerde tekrar yazılmış.
- **Hatalar gizleniyor:** `try-catch` içinde hata yakalanıp üstü kapatılıyor, kullanıcı haber almıyor.
- **Mesajlar koda gömülü:** Hata mesajları kodun içine yazılmış, tek yerden yönetilmiyor.

**Çözüm:** Tekrarları ortak widget'a çevir. Hataları kullanıcıya göster. Mesajları merkezi bir yere koy.

---

## 5. Eksik Kodlar

- **Giriş koruması eksik:** Sayfalara giriş kontrolü yapılmıyor.
- **Yükleniyor ekranı yok:** Ürün yüklenirken kullanıcıya gösterilecek iskelet (skeleton) ekran yok.
- **Tekrar dene yok:** Hata olunca "Tekrar dene" butonu yok.
- **Çevrimdışı destek yok:** İnternet yokken ne yapılacağı bilinmiyor.
- **Erişilebilirlik eksik:** Görme engelliler için ekran okuyucu etiketleri yok.

**Çözüm:** Yukarıdakilerin hepsini tek tek ekle, özellikle "Tekrar dene" ve iskelet ekran önemli.

---

## 6. Gereksiz / Ölü Kodlar

- **Yorum satırına alınmış giriş koruması:** `app_router.dart` içinde tamamen yazılmış ama kapatılmış kod var.
- **Çift responsive mantığı:** `AppBreakpoints` ve `ContextResponsive` aynı işi yapıyor.
- **Tekrar eden hata ekranları:** Her özellik kendi hata widget'ını yazmış.

**Çözüm:** Kullanılmayan kodları sil. Aynı işi yapanları birleştir.

---

## 7. İyileştirilebilecek (Performans) Kodlar

- **Liste gereksiz yenileniyor:** Büyük listeler her seferinde baştan çiziliyor.
- **Fotoğraf önbelleği yok:** Profil fotoğrafları tekrar tekrar indiriliyor.
- **Aramada gecikme yok:** Yazarken her harfte kontrol yapılıyor, performans düşüyor.

**Çözüm:** Listeyi parçalara böl (`ListView.builder`). Fotoğrafları önbelleğe al. Arama için gecikme (debounce) ekle.

---

## 8. Kütüphane Kullanım Hataları

- **Dio timeout tutarsız:** Bazı istekler farklı sürede timeout oluyor.
- **Droppable fazla kullanımı:** Çok sık kullanılınca bazı olaylar (event) kaybolabiliyor.
- **Arapça (RTL) desteği yarım:** Sağdan sola dil desteği tam değil.
- **Dil tercihi kaydedilmiyor:** Kullanıcı dil seçince hatırlanmıyor.

**Çözüm:** Timeout değerlerini sabit yap. Droppable'ı sadece gerekli yerde kullan. RTL ve dil kaydetmeyi tamamla.

---

## 9. Kullanıcı Arayüzü (UI) Mantık Hataları

- **Alt menü güncellenmiyor:** Link ile açılan sayfada alt menü seçili görünmüyor.
- **Form anında kontrol ediyor:** Her harfte hata mesajı çıkıyor, kullanıcıyı bunaltıyor.
- **Yükleniyor belirsiz:** Bazı yerlerde ne kadar süreceği belli değil.
- **Çok fazla uyarı:** Üst üste hata mesajları (snackbar) çıkabiliyor.

**Çözüm:** Link ile açılışta menüyü senkronize et. Form kontrolünü yazmayı bitirince yap. Uyarıları üst üste çıkarma.

---

## Puanlar

- **Mimari:** 4 / 10 — Yapı dağınık, parçalar birbirine çok bağlı.
- **Kod Kalitesi:** 5 / 10 — Ortalama, ama düzeltilmeli çok yer var.
- **Mantık Tutarlılığı:** 3 / 10 — İş mantığında ciddi hatalar var.

**Özet:** Proje şu haliyle yayına hazır değil. Önce kritik hatalar, sonra yapısal sorunlar düzeltilmeli.

---

## Hemen Yapılması Gerekenler (Kritik)

1. Giriş korumasını (auth guard) aç ve çalıştır.
2. Profil fotoğrafı yüklemedeki çakışmayı düzelt.
3. Yorum satırındaki ölü kodları temizle.
4. Durum yönetimini tek tip yap (BLoC ya da Cubit).
5. Hata mesajlarını kullanıcıya düzgün göster.

---

## Junior Geliştirici İçin 3 Adımlı Plan

**1. Hafta 1-2: Temizlik**
- Ölü kodları ve kullanılmayan importları sil.
- İsimlendirme ve import düzenini düzelt.

**2. Hafta 3-4: Kritik Hatalar**
- Profil yükleme çakışmasını düzelt.
- Girişte aynı işlemin tekrarını engelle.
- Hata yönetimini iyileştir.

**3. Hafta 5-6: Mimari İyileştirme**
- Giriş korumasını ekle.
- Durum yönetimini sadeleştir.
- Kritik yerlere test yaz.
