# Local Firebase Functions Test Rehberi

## 🚀 Test Adımları

### 1. Firebase Emulator'ı Başlat
```bash
cd functions-backend
npm run serve
```

Emulator başladığında şu mesajları göreceksin:
```
✔  All emulators ready! It is now safe to connect your app.
i  View Emulator UI at http://127.0.0.1:4000/

┌───────────┬────────────────┬─────────────────────────────────┐
│ Emulator  │ Host:Port      │ View in Emulator UI             │
├───────────┼────────────────┼─────────────────────────────────┤
│ Functions │ 127.0.0.1:5001 │ http://127.0.0.1:4000/functions │
└───────────┴────────────────┴─────────────────────────────────┘
```

### 2. Flutter Uygulamasını Çalıştır
```bash
flutter run
```

### 3. Test Senaryoları

#### Senaryo 1: Google Play Purchase Validation
1. Uygulamada Store sayfasına git
2. Bir karakter satın almayı dene
3. Console'da şu logları göreceksin:
   - `✅ Using Firebase Functions Emulator at 127.0.0.1:5001`
   - Purchase validation çağrısı yapıldığında emulator logları görünecek

#### Senaryo 2: Manuel Test (Postman/curl)
Emulator UI'dan veya curl ile test edebilirsin:

```bash
curl -X POST http://127.0.0.1:5001/zonerun-43c59/us-central1/validateGooglePlayPurchase \
  -H "Content-Type: application/json" \
  -d '{
    "data": {
      "productId": "character_1",
      "purchaseToken": "test_token_123",
      "packageName": "com.example.zone_run"
    }
  }'
```

**Not**: Gerçek test için authentication token gerekir. Flutter uygulamasından çağrı yapıldığında otomatik olarak token eklenir.

### 4. Emulator UI'da İzleme
1. Tarayıcıda `http://127.0.0.1:4000/` aç
2. "Functions" sekmesine git
3. Function çağrılarını ve logları görebilirsin

## 🔍 Debug İpuçları

### Emulator Bağlantı Sorunu
Eğer "Could not connect to Functions Emulator" hatası alırsan:
1. Emulator'ın çalıştığından emin ol: `npm run serve`
2. Port 5001'in açık olduğundan emin ol
3. Firewall ayarlarını kontrol et

### Function Çağrıları Görünmüyor
1. Emulator UI'da "Functions" sekmesine bak
2. Console loglarını kontrol et
3. Flutter debug console'da hata mesajlarını kontrol et

### Authentication Hatası
Local emulator'da authentication kontrol edilir. Test için:
1. Flutter uygulamasında giriş yap
2. Veya emulator'da authentication'ı devre dışı bırak (sadece test için)

## ✅ Başarılı Test İşaretleri

1. **Emulator Logları**: Function çağrıları emulator console'da görünür
2. **Flutter Console**: "Purchase validated successfully" mesajı
3. **Emulator UI**: Function çağrıları ve sonuçları görünür
4. **Firestore**: Purchase kayıtları `users/{userId}/purchases` collection'ında görünür

## 🎯 Sonraki Adımlar

1. Gerçek satın alma akışını test et
2. Firestore'da purchase kayıtlarını kontrol et
3. Character purchase'ın Firestore'a kaydedildiğini doğrula
4. Production deploy için Blaze planına yükselt
