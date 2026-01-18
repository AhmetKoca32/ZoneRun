# Emulator Uyarısı Çözümü

## Durum
Emulator başlatılırken eski `functions` klasörü için hata görünüyor ama `functions-backend` başarıyla yükleniyor.

## Çözüm

### Yöntem 1: Cache Temizleme (Önerilen)
```bash
# Firebase cache'i temizle
firebase emulators:exec --only functions "echo 'Cache cleared'"

# Veya manuel olarak
Remove-Item -Path "firebase-debug.log" -Force
```

### Yöntem 2: Emulator'ı Yeniden Başlat
1. Emulator'ı durdur (Ctrl+C)
2. `firebase-debug.log` dosyasını sil
3. Emulator'ı tekrar başlat:
```bash
cd functions-backend
npm run serve
```

## Not
Bu uyarı önemli değil - `functions-backend` başarıyla çalışıyor:
```
✅ validateGooglePlayPurchase - http://127.0.0.1:5001/...
✅ validateAppStorePurchase - http://127.0.0.1:5001/...
```

Eğer uyarı rahatsız ediyorsa, yukarıdaki adımları uygulayabilirsin.
