# Backend Kurulum Tamamlandı ✅

## 📁 Oluşturulan Dosyalar

### Firebase Functions
- ✅ `functions/package.json` - Dependencies
- ✅ `functions/tsconfig.json` - TypeScript config
- ✅ `functions/src/index.ts` - Receipt validation functions

### Firebase Config
- ✅ `firebase.json` - Firebase project config
- ✅ `.firebaserc` - Firebase project ID
- ✅ `firestore.rules` - Security rules
- ✅ `firestore.indexes.json` - Firestore indexes

### Flutter Entegrasyonu
- ✅ `lib/core/services/purchase_service.dart` - Güncellendi (Firebase Functions entegrasyonu)

## 🚀 Yapılacaklar

### 1. Firebase CLI Kurulumu
```bash
npm install -g firebase-tools
firebase login
```

### 2. Firebase Functions Başlat
```bash
# Proje root klasöründe
firebase init functions
```

**Seçimler:**
- ✅ TypeScript kullan
- ✅ Functions klasörü: `functions` (zaten var, mevcut dosyaları koru)

### 3. Dependencies Yükle
```bash
cd functions
npm install
```

### 4. Build
```bash
npm run build
```

### 5. Deploy
```bash
# Functions klasöründen
npm run deploy

# Veya root klasörden
firebase deploy --only functions
```

## 🔐 API Keys Ayarları

### Google Play API
1. [Google Play Console](https://play.google.com/console) → Settings → API access
2. Service account oluştur
3. JSON key'i indir
4. Firebase Functions environment variables:
```bash
firebase functions:config:set googleplay.service_account_key="<JSON_KEY_CONTENT>"
```

### App Store API
1. [App Store Connect](https://appstoreconnect.apple.com) → My Apps → In-App Purchases
2. Shared Secret oluştur
3. Firebase Functions environment variables:
```bash
firebase functions:config:set appstore.shared_secret="<SHARED_SECRET>"
```

## 📱 Flutter Dependencies

```bash
flutter pub get
```

## ✅ Test

### Local Test
```bash
cd functions
npm run serve
```

### Production Deploy
```bash
firebase deploy --only functions
```

## 📚 Detaylı Rehber

- `FUNCTIONS_SETUP_GUIDE.md` - Adım adım kurulum rehberi
- `FIREBASE_FUNCTIONS_SETUP.md` - Genel bakış

## ⚠️ Önemli Notlar

1. **Google Play Receipt Validation**: Şu anda basit validation var. Gerçek Google Play API entegrasyonu için `functions/src/index.ts` içindeki `validateGooglePlayReceipt` fonksiyonunu güncelle.

2. **App Store Receipt Validation**: Şu anda basit validation var. Gerçek App Store Server API entegrasyonu için `functions/src/index.ts` içindeki `validateAppStoreReceipt` fonksiyonunu güncelle.

3. **Security**: `firestore.rules` dosyası purchases için sadece backend yazma izni veriyor. Bu güvenlik için önemli.

4. **Error Handling**: Flutter tarafında `PurchaseService` hata durumlarını handle ediyor. Backend validation başarısız olursa purchase tamamlanmaz.
