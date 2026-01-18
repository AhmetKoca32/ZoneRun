# Firebase Functions Emulator Bağlantı Sorunu

## 🔍 Sorun
`UNAVAILABLE` hatası alınıyor - Firebase Functions emulator'a bağlanılamıyor.

## ✅ Kontrol Listesi

### 1. Emulator Çalışıyor mu?
```bash
cd functions-backend
npm run serve
```

Emulator çalışıyorsa şunu görmelisin:
```
✔  All emulators ready!
│ Functions │ 127.0.0.1:5001 │
```

### 2. Port Kontrolü
Emulator'ın port 5001'de dinlediğinden emin ol.

### 3. Android Emulator Host
Android emulator'da `10.0.2.2` kullanılıyor. Kod zaten bunu yapıyor:
```dart
final host = Platform.isAndroid ? '10.0.2.2' : '127.0.0.1';
```

### 4. Test: Manuel Bağlantı
Android emulator içinden test et:
```bash
# Android emulator'da adb shell ile
adb shell
curl http://10.0.2.2:5001
```

### 5. Alternatif: Farklı Port
Eğer port 5001 çalışmıyorsa, emulator'ın hangi portta dinlediğini kontrol et.

## 🔧 Olası Çözümler

### Çözüm 1: Emulator'ı Yeniden Başlat
1. Emulator'ı durdur (Ctrl+C)
2. `firebase-debug.log` dosyasını sil
3. Emulator'ı tekrar başlat

### Çözüm 2: Flutter Uygulamasını Tamamen Yeniden Başlat
1. Uygulamayı tamamen kapat
2. `flutter clean`
3. `flutter run` ile yeniden başlat

### Çözüm 3: Emulator Host IP Kontrolü
Bazı Android emulator'lar farklı IP kullanabilir. Kontrol et:
- Genellikle: `10.0.2.2`
- Bazı durumlarda: `10.0.3.2` veya başka

### Çözüm 4: Firewall Kontrolü
Windows Firewall port 5001'i engelliyor olabilir.

## 📝 Debug Logları
Uygulama başladığında şunu görmelisin:
```
✅ Using Firebase Functions Emulator at 10.0.2.2:5001
   (Android emulator detected, using 10.0.2.2)
```

Eğer bu mesajı görmüyorsan, `useFunctionsEmulator` çağrısı çalışmıyor demektir.
