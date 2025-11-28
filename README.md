# ZoneRun 🗺️

GPS tabanlı fitness oyunu. Kullanıcılar yürüyerek haritada poligonlar çizer ve alan fetheder.

## 📋 İçindekiler

- [Mimari Yapı](#mimari-yapı)
- [Klasör Yapısı](#klasör-yapısı)
- [Teknoloji Yığını](#teknoloji-yığını)
- [Kurulum](#kurulum)
- [Proje Yapısı Detayları](#proje-yapısı-detayları)

---

## 🏗️ Mimari Yapı

ZoneRun projesi **Feature-First (Özellik Tabanlı)** mimari kullanılarak geliştirilmiştir. Bu mimari, her özelliğin bağımsız ve modüler olmasını sağlar.

### Mimari Prensipler

1. **Feature-First Yaklaşım**: Her özellik kendi klasöründe, bağımsız olarak geliştirilir
2. **Separation of Concerns**: Her katman (presentation, service, model) ayrı tutulur
3. **Dependency Injection**: Servisler singleton pattern ile yönetilir
4. **Scalability**: Yeni özellikler kolayca eklenebilir

---

## 📁 Klasör Yapısı

```
lib/
├── core/                           # Tüm projede kullanılan ortak yapılar
│   ├── constants/                 # Uygulama sabitleri
│   │   └── app_constants.dart     # Veritabanı, harita, konum ayarları
│   ├── models/                     # Ortak veri modelleri
│   │   └── polygon_model.dart      # Poligon ve LatLng modelleri
│   ├── services/                   # Ortak servisler
│   │   ├── database_service.dart  # SQLite veritabanı işlemleri
│   │   └── location_service.dart   # GPS konum servisi
│   └── theme/                      # Tema ve stil tanımları
│       └── app_theme.dart         # Ultra-minimalist dark tema
│
├── features/                       # Özellik bazlı klasörler
│   ├── map/                        # Harita özelliği
│   │   ├── presentation/          # UI katmanı
│   │   │   ├── pages/             # Sayfa widget'ları
│   │   │   │   └── map_page.dart
│   │   │   ├── widgets/           # Feature'a özel widget'lar
│   │   │   │   ├── map_controls_widget.dart
│   │   │   │   ├── polygon_drawing_widget.dart
│   │   │   │   └── location_marker_widget.dart
│   │   │   └── providers/         # State management
│   │   │       └── map_provider.dart
│   │   └── services/              # Feature'a özel servisler
│   │       └── map_service.dart   # Harita işlemleri, alan hesaplama
│   │
│   ├── history/                    # Geçmiş özelliği
│   │   ├── presentation/
│   │   │   ├── pages/
│   │   │   │   └── history_page.dart
│   │   │   ├── widgets/
│   │   │   │   ├── polygon_card_widget.dart
│   │   │   │   ├── history_list_widget.dart
│   │   │   │   └── area_stats_widget.dart
│   │   │   └── providers/
│   │   │       └── history_provider.dart
│   │   └── services/
│   │       └── history_service.dart
│   │
│   └── profile/                    # Profil özelliği
│       ├── presentation/
│       │   ├── pages/
│       │   │   └── profile_page.dart
│       │   ├── widgets/
│       │   │   ├── stat_card_widget.dart
│       │   │   └── profile_header_widget.dart
│       │   └── providers/
│       │       └── profile_provider.dart
│       └── services/
│           └── profile_service.dart
│
└── main.dart                       # Uygulama giriş noktası
```

---

## 🛠️ Teknoloji Yığını

### State Management
- **Provider** (`^6.1.5+1`) - State yönetimi için

### Harita & Konum
- **google_maps_flutter** (`^2.14.0`) - Google Maps entegrasyonu
- **location** (`^8.0.1`) - GPS konum servisi

### Veritabanı
- **sqflite** (`^2.4.2`) - SQLite veritabanı
- **path** (`^1.9.1`) - Dosya yolu işlemleri

---

## 🚀 Kurulum

### Gereksinimler
- Flutter SDK 3.10.1 veya üzeri
- Dart SDK 3.10.1 veya üzeri

### Adımlar

1. **Bağımlılıkları yükleyin:**
   ```bash
   flutter pub get
   ```

2. **Google Maps API Key ekleyin:**
   - `android/app/src/main/AndroidManifest.xml` dosyasına API key ekleyin
   - `ios/Runner/AppDelegate.swift` dosyasına API key ekleyin

3. **Uygulamayı çalıştırın:**
   ```bash
   flutter run
   ```

---

## 📚 Proje Yapısı Detayları

### 🎯 Core Klasörü

Tüm projede kullanılan ortak yapıları içerir.

#### `core/constants/`
- **app_constants.dart**: Uygulama genelinde kullanılan sabitler
  - Veritabanı adı ve versiyonu
  - Harita zoom seviyeleri
  - Konum güncelleme aralıkları
  - Poligon çizim ayarları

#### `core/models/`
- **polygon_model.dart**: Poligon veri modeli
  - `PolygonModel`: Poligon bilgileri (id, name, points, area, dates)
  - `LatLng`: Enlem-boylam koordinat modeli

#### `core/services/`
- **database_service.dart**: SQLite veritabanı işlemleri
  - Singleton pattern ile yönetilir
  - CRUD işlemleri (Create, Read, Update, Delete)
  - Poligon filtreleme (tamamlanmış/aktif)
  
- **location_service.dart**: GPS konum servisi
  - Konum izni kontrolü ve isteme
  - Anlık konum alma
  - Konum stream'i (sürekli takip)

#### `core/theme/`
- **app_theme.dart**: Ultra-minimalist dark tema
  - Zemin: Siyah (#000000)
  - Yazılar: Beyaz
  - Nike Run Club benzeri premium tasarım

---

### 🗺️ Features Klasörü

Her özellik kendi klasöründe, bağımsız olarak geliştirilir.

#### Feature Yapısı

Her feature şu yapıyı takip eder:

```
feature_name/
├── presentation/          # UI Katmanı
│   ├── pages/            # Ana sayfa widget'ları
│   ├── widgets/          # Feature'a özel widget'lar
│   └── providers/        # State management (Provider)
└── services/             # Business Logic Katmanı
    └── feature_service.dart
```

#### Map Feature (`features/map/`)

**Amaç**: Kullanıcıların haritada poligon çizmesi ve alan fethetmesi

**Servisler**:
- `map_service.dart`:
  - Konum takibi başlatma/durdurma
  - Poligon alan hesaplama (Shoelace formülü)
  - Poligon kaydetme ve tamamlama
  - Konum izni kontrolü

**Presentation**:
- `pages/map_page.dart`: Ana harita sayfası
- `widgets/`: Harita kontrolleri, poligon çizimi widget'ları
- `providers/map_provider.dart`: Harita state yönetimi

#### History Feature (`features/history/`)

**Amaç**: Tamamlanmış poligonların geçmişini görüntüleme

**Servisler**:
- `history_service.dart`:
  - Geçmiş poligonları listeleme
  - Toplam fethedilen alan hesaplama
  - Poligon silme
  - İstatistik hesaplama

**Presentation**:
- `pages/history_page.dart`: Geçmiş listesi sayfası
- `widgets/`: Poligon kartları, istatistik widget'ları
- `providers/history_provider.dart`: Geçmiş state yönetimi

#### Profile Feature (`features/profile/`)

**Amaç**: Kullanıcı istatistikleri ve profil bilgileri

**Servisler**:
- `profile_service.dart`:
  - Kullanıcı istatistikleri toplama
  - Alan formatlama (m², km²)
  - Genel performans metrikleri

**Presentation**:
- `pages/profile_page.dart`: Profil sayfası
- `widgets/`: İstatistik kartları, profil header
- `providers/profile_provider.dart`: Profil state yönetimi

---

## 🔄 Veri Akışı

```
UI (Presentation)
    ↓
Provider (State Management)
    ↓
Service (Business Logic)
    ↓
Core Service (Database, Location)
    ↓
Model (Data)
```

### Örnek: Poligon Çizme Akışı

1. **UI**: Kullanıcı haritada yürür, `MapProvider` konumları toplar
2. **Provider**: `MapProvider` state'i günceller
3. **Service**: `MapService` alan hesaplar
4. **Core Service**: `DatabaseService` poligonu kaydeder
5. **Model**: `PolygonModel` veriyi temsil eder

---

## 📝 Kodlama Standartları

### Dosya İsimlendirme
- **snake_case**: `map_service.dart`, `polygon_model.dart`
- **PascalCase**: Sınıf isimleri için

### Klasör İsimlendirme
- **lowercase**: `features/`, `core/`, `presentation/`

### Import Sıralaması
1. Dart core imports
2. Flutter imports
3. Package imports
4. Relative imports

### Servis Pattern
- Tüm servisler singleton pattern kullanır
- Factory constructor ile instance oluşturulur

---

## 🎨 Tasarım Dili

### Renkler
- **Zemin**: Siyah (#000000)
- **Yazılar**: Beyaz (#FFFFFF)
- **Vurgular**: Beyaz (neon renkler yok)

### Tipografi
- Minimalist, sade fontlar
- Negatif letter-spacing (-0.5, -0.3)
- Font weight: 400-700 arası

### UI Prensipleri
- Ultra-minimalist yaklaşım
- Nike Run Club benzeri ciddi ve premium hava
- Gereksiz dekorasyon yok

---

## 🧪 Test Yapısı (Gelecek)

```
test/
├── unit/                    # Unit testler
│   ├── core/
│   └── features/
├── widget/                  # Widget testleri
│   └── features/
└── integration/             # Integration testleri
```

---

## 📦 Yeni Feature Ekleme

Yeni bir feature eklemek için:

1. `lib/features/` altında yeni klasör oluştur
2. `presentation/` ve `services/` klasörlerini ekle
3. Gerekli dosyaları oluştur (page, service, provider)
4. `main.dart`'a gerekirse route ekle

**Örnek**: `features/settings/` feature'ı eklemek
```
features/
└── settings/
    ├── presentation/
    │   ├── pages/
    │   │   └── settings_page.dart
    │   └── providers/
    │       └── settings_provider.dart
    └── services/
        └── settings_service.dart
```

---

## 🤝 Katkıda Bulunma

1. Feature-First mimarisine uygun kod yazın
2. Her feature'ı bağımsız tutun
3. Core klasörüne sadece ortak yapılar ekleyin
4. Servislerde singleton pattern kullanın
5. Minimalist tasarım diline uyun

---

## 📄 Lisans

Bu proje özel bir projedir.

---

## 👨‍💻 Geliştirici Notları

- **Mimari**: Feature-First Architecture
- **State Management**: Provider
- **Veritabanı**: SQLite (sqflite)
- **Harita**: Google Maps Flutter
- **Tasarım**: Ultra-Minimalist Dark Mode

---

**ZoneRun** - Yürü, Çiz, Fethet! 🏃‍♂️🗺️
