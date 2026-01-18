# Firebase Functions Backend Kurulum Rehberi

## 📋 Gereksinimler

1. **Node.js** (v18 veya üzeri) - [İndir](https://nodejs.org/)
2. **Firebase CLI** - Terminal'de: `npm install -g firebase-tools`
3. **Firebase Projesi** - Zaten var (zonerun-43c59)

## 🚀 Adım 1: Firebase CLI Kurulumu

```bash
# Firebase CLI'yi global olarak yükle
npm install -g firebase-tools

# Firebase'e giriş yap
firebase login

# Projeyi başlat (zone_run klasöründe)
firebase init functions
```

## 📁 Adım 2: Firebase Functions Yapısı

Kurulum sonrası şu klasör yapısı oluşacak:

```
zone_run/
├── functions/
│   ├── src/
│   │   └── index.ts
│   ├── package.json
│   └── tsconfig.json
├── firebase.json
└── .firebaserc
```

## 🔧 Adım 3: Functions Dependencies

`functions/package.json` dosyasına şu paketleri ekle:

```json
{
  "dependencies": {
    "firebase-admin": "^12.0.0",
    "firebase-functions": "^4.5.0",
    "googleapis": "^128.0.0",
    "axios": "^1.6.0"
  }
}
```

## 💻 Adım 4: Receipt Validation Functions

`functions/src/index.ts` dosyasına receipt validation kodlarını ekle.

## 📝 Adım 5: Flutter Entegrasyonu

Flutter tarafında `PurchaseService`'i güncelle ve Firebase Functions'ı çağır.

## 🔐 Adım 6: Google Play/App Store API Keys

- Google Play: Service Account Key gerekli
- App Store: Shared Secret gerekli

## 📤 Adım 7: Deploy

```bash
firebase deploy --only functions
```
