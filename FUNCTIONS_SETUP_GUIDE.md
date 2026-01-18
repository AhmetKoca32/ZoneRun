# Firebase Functions Kurulum Adımları

## 📋 Ön Hazırlık

### 1. Node.js Kurulumu
- [Node.js İndir](https://nodejs.org/) (v18 veya üzeri)
- Kurulumu kontrol et: `node --version`

### 2. Firebase CLI Kurulumu
```bash
npm install -g firebase-tools
```

### 3. Firebase'e Giriş
```bash
firebase login
```

## 🚀 Kurulum Adımları

### Adım 1: Firebase Functions Başlat
```bash
# Proje root klasöründe (zone_run/)
firebase init functions
```

**Seçimler:**
- ✅ TypeScript kullan
- ✅ ESLint kullan (opsiyonel)
- ✅ Functions klasörü oluştur

### Adım 2: Dependencies Yükle
```bash
cd functions
npm install
```

### Adım 3: Functions Kodunu Kontrol Et
`functions/src/index.ts` dosyası hazır (receipt validation functions içeriyor)

### Adım 4: Build
```bash
npm run build
```

### Adım 5: Local Test (Opsiyonel)
```bash
npm run serve
```

### Adım 6: Deploy
```bash
# Functions klasöründen
npm run deploy

# Veya root klasörden
firebase deploy --only functions
```

## 🔐 Google Play API Ayarları

### 1. Google Play Console'da Service Account Oluştur
1. [Google Play Console](https://play.google.com/console) → Settings → API access
2. Service account oluştur
3. JSON key'i indir

### 2. Firebase Functions Environment Variables
```bash
firebase functions:config:set googleplay.service_account_key="<JSON_KEY_CONTENT>"
```

## 🍎 App Store API Ayarları

### 1. App Store Connect'te Shared Secret
1. [App Store Connect](https://appstoreconnect.apple.com) → My Apps → In-App Purchases
2. Shared Secret oluştur

### 2. Firebase Functions Environment Variables
```bash
firebase functions:config:set appstore.shared_secret="<SHARED_SECRET>"
```

## 📱 Flutter Entegrasyonu

Flutter tarafında `PurchaseService` güncellenecek ve Firebase Functions çağrılacak.

## ✅ Test

```bash
# Local test
firebase emulators:start --only functions

# Production deploy
firebase deploy --only functions
```

## 📚 Kaynaklar

- [Firebase Functions Docs](https://firebase.google.com/docs/functions)
- [Google Play Developer API](https://developers.google.com/android-publisher)
- [App Store Server API](https://developer.apple.com/documentation/appstoreserverapi)
