<p align="center">
  <img src="assets/images/logo.png" alt="MyTabungan Logo" width="120" height="120" style="border-radius: 24px;" />
</p>

<h1 align="center">MyTabungan</h1>

<p align="center">
  <em>Kelola masa depan finansial Anda dengan elegan.</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.11-blue?logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-3.11-0175C2?logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/Firebase-Cloud_Firestore-FFCA28?logo=firebase&logoColor=black" alt="Firebase" />
  <img src="https://img.shields.io/badge/Riverpod-State_Management-6B4FBB" alt="Riverpod" />
  <img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License" />
</p>

---

## 📖 Tentang Aplikasi

**MyTabungan** adalah aplikasi pencatat & perencana tabungan pribadi dengan desain **Glassmorphism** yang mewah, dibangun menggunakan **Flutter** dan **Firebase**. Aplikasi ini membantu Anda:

- 🎯 Menetapkan target tabungan dengan deadline
- 💰 Mencatat setiap transaksi setoran & penarikan
- 📊 Memantau progress tabungan secara visual
- 🧮 Mensimulasikan berapa yang harus ditabung per hari/minggu/bulan
- 🔒 Mengamankan akses dengan autentikasi biometrik (sidik jari)

---

## 📸 Screenshot

<p align="center">
  <img src="assets/screenshots/home.png" width="250" alt="MyTabungan - Beranda" />
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="assets/screenshots/simulator.png" width="250" alt="MyKalkulator - Simulasi" />
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="assets/screenshots/report.png" width="250" alt="MyLaporan - Laporan" />
</p>

<p align="center">
  <sub><strong>Beranda</strong> • <strong>Simulasi</strong> • <strong>Laporan</strong></sub>
</p>

---

## ✨ Fitur Unggulan

### 🏠 MyTabungan — Beranda
- Kartu saldo total dengan efek **3D Tilt Parallax**
- Daftar target tabungan dengan desain kartu **Glassmorphism**
- Progress bar visual per target tabungan
- Countdown hari menuju target deadline
- Animasi **staggered entrance** saat membuka halaman

### 🧮 MyKalkulator — Simulasi Nabung
- Masukkan target dana dan durasi waktu
- Hitung otomatis nominal tabungan per **bulan**, **minggu**, dan **hari**
- Slider interaktif untuk mengatur durasi
- Kartu hasil dengan efek tilt 3D

### 📊 MyLaporan — Laporan Global
- **Donut chart** animasi interaktif (PieChart)
- Persentase pencapaian total dari semua target
- Rincian tabungan per target dengan progress bar
- Statistik keseluruhan keuangan Anda

### 🔐 Keamanan
- Autentikasi pengguna via **Firebase Auth** (Email & Password)
- Kunci biometrik (Fingerprint / Face ID) opsional
- Data terenkripsi dan tersimpan di **Cloud Firestore**

### 🎨 Desain & Animasi Premium
- **Dark Theme** mewah dengan aksen **Gold/Champagne**
- Efek **Glassmorphism** (blur + transparansi) di seluruh UI
- Background **Orbs Bercahaya** yang bergerak perlahan (floating ambient light)
- Animasi **staggered entrance** untuk setiap elemen halaman
- Transisi halaman **slide 3D** dengan skala dan opacity
- **Counting animation** untuk angka-angka nominal
- **Bottom Navigation Bar** transparan dengan indikator bercahaya
- Tipografi premium: **Outfit** (heading) & **Inter** (body) dari Google Fonts

---

## 🏗️ Arsitektur Proyek

```
lib/
├── main.dart                          # Entry point aplikasi
├── firebase_options.dart              # Konfigurasi Firebase
│
├── core/                              # Fondasi aplikasi
│   ├── constants/
│   │   └── app_colors.dart            # Palet warna (Gold, Dark Theme)
│   ├── theme/
│   │   └── app_theme.dart             # Material Theme kustom
│   ├── ui/
│   │   └── main_scaffold.dart         # Layout utama + PageView + Bottom Nav
│   ├── models/                        # Model data global
│   ├── repositories/                  # Repository global
│   └── utils/
│       └── hex_color.dart             # Utilitas konversi warna
│
├── features/                          # Fitur-fitur aplikasi
│   ├── auth/                          # 🔐 Autentikasi
│   │   ├── views/
│   │   │   ├── login_view.dart        # Halaman login/register
│   │   │   └── auth_checker.dart      # Router autentikasi + biometrik
│   │   └── repositories/
│   │       └── auth_repository.dart   # Firebase Auth wrapper
│   │
│   ├── savings/                       # 💰 Fitur Tabungan (inti)
│   │   ├── views/
│   │   │   ├── dashboard_view.dart    # Beranda — daftar target
│   │   │   ├── goal_detail_view.dart  # Detail target + riwayat transaksi
│   │   │   ├── report_view.dart       # Laporan global + chart
│   │   │   └── widgets/
│   │   │       ├── looping_background.dart    # Animasi orbs background
│   │   │       ├── add_goal_sheet.dart        # Form tambah target
│   │   │       ├── edit_goal_sheet.dart       # Form edit target
│   │   │       ├── add_transaction_sheet.dart # Form tambah transaksi
│   │   │       └── edit_transaction_sheet.dart# Form edit transaksi
│   │   ├── controllers/
│   │   │   └── savings_controller.dart # Riverpod state management
│   │   ├── models/
│   │   │   ├── savings_goal.dart       # Model target tabungan
│   │   │   └── transaction.dart        # Model transaksi
│   │   └── repositories/
│   │       └── savings_repository.dart # Firestore CRUD operations
│   │
│   ├── simulator/                     # 🧮 Simulasi Tabungan
│   │   └── views/
│   │       └── simulator_view.dart    # Kalkulator pintar
│   │
│   └── settings/                      # ⚙️ Pengaturan
│       ├── views/
│       │   └── settings_view.dart     # Halaman pengaturan
│       └── controllers/
│           └── settings_controller.dart
```

---

## 🛠️ Tech Stack

| Teknologi | Kegunaan |
|---|---|
| **Flutter 3.11** | Framework UI cross-platform |
| **Dart 3.11** | Bahasa pemrograman |
| **Firebase Auth** | Autentikasi pengguna |
| **Cloud Firestore** | Database NoSQL real-time |
| **Riverpod** | State management reaktif |
| **fl_chart** | Chart/grafik interaktif |
| **flutter_tilt** | Efek 3D parallax tilt |
| **Google Fonts** | Tipografi premium (Outfit, Inter) |
| **local_auth** | Autentikasi biometrik |
| **animations** | Transisi Material Motion |

---

## 🚀 Cara Menjalankan

### Prasyarat
- Flutter SDK `>= 3.11.0`
- Android Studio / VS Code
- Akun Firebase (untuk backend)
- Perangkat Android / Emulator

### Langkah-langkah

1. **Clone repository ini**
   ```bash
   git clone https://github.com/YOUR_USERNAME/tabungan_online.git
   cd tabungan_online
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Konfigurasi Firebase**
   - Buat project baru di [Firebase Console](https://console.firebase.google.com/)
   - Aktifkan **Authentication** (Email/Password)
   - Aktifkan **Cloud Firestore**
   - Download `google-services.json` ke `android/app/`
   - Atau gunakan FlutterFire CLI:
     ```bash
     flutterfire configure
     ```

4. **Jalankan aplikasi**
   ```bash
   # Mode debug (untuk development)
   flutter run

   # Mode release (performa optimal — DIREKOMENDASIKAN)
   flutter run --release
   ```

5. **Build APK untuk distribusi**
   ```bash
   flutter build apk --release
   ```
   Output: `build/app/outputs/flutter-apk/app-release.apk`

---

## 🎨 Desain System

### Palet Warna

| Warna | Hex | Kegunaan |
|---|---|---|
| 🟫 Deep Black | `#121212` | Background utama |
| ⬛ Surface | `#1E1E1E` | Kartu & elemen permukaan |
| 🟡 Metallic Gold | `#D4AF37` | Aksen utama (Primary) |
| 🟨 Champagne | `#F3E5AB` | Variasi aksen (Secondary) |
| ⬜ White | `#FFFFFF` | Teks utama |
| 🔘 Gray | `#A0A0A0` | Teks sekunder |
| 🟢 Green | `#4CAF50` | Status sukses |
| 🔴 Red | `#E57373` | Status error |

### Tipografi
- **Heading**: [Outfit](https://fonts.google.com/specimen/Outfit) — Bold, modern, geometric
- **Body**: [Inter](https://fonts.google.com/specimen/Inter) — Clean, readable, versatile

---

## 📱 Versi Minimum

| Platform | Versi Minimum |
|---|---|
| Android | API 21 (Android 5.0 Lollipop) |
| iOS | iOS 12.0 |

---

## 🤝 Kontribusi

Kontribusi sangat diterima! Silakan:

1. **Fork** repository ini
2. Buat **branch** fitur baru: `git checkout -b fitur/fitur-baru`
3. **Commit** perubahan: `git commit -m 'Menambahkan fitur baru'`
4. **Push** ke branch: `git push origin fitur/fitur-baru`
5. Buat **Pull Request**

---

## 📄 Lisensi

Proyek ini dilisensikan di bawah [MIT License](LICENSE).

---

<p align="center">
  <strong>MyTabungan</strong> — Tabungan cerdas untuk masa depan cerah ✨
</p>
## 📊 Code Walkthroughs & Visual Diagrams

### 🔄 Application Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                      main.dart                             │
│   ┌─ Initialize Firebase                                  │
│   ├─ Set Indonesian locale                                  │
│   └─ Launch MyApp()                                         │
└───────────────────────┬───────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│                    MyApp Widget                             │
│   ┌─ MaterialApp with Dark Theme                           │
│   └─ Home: AuthChecker                                    │
└───────────────────────┬───────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│                   AuthChecker                               │
│   ┌─ Check Firebase Auth state                            │
│   │  ├─ CurrentUser EXISTS? ──► YES ──► MainScaffold      │
│   │  └─ NO ──► Biometric prompt?                          │
│   │     └─ Authenticated ──► MainScaffold               │
│   │     └─ Failed ──► LoginView                           │
│   └─ Biometric fallback to LoginView                       │
└───────────────────────┬───────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│                   MainScaffold                              │
│   ├─ PageView with 3 pages (Dashboard, Simulator, Report)   │
│   ├─ Bottom Navigation (Glassmorphism + Gold indicator)      │
│   └─ AppBar transparent                                   │
└─────────────────────────────────────────────────────────────┘
```

---

### 🔐 Authentication Deep Dive

#### Flow: Login Process

```dart
// lib/features/auth/views/login_view.dart (simplified)
class _LoginViewState extends ConsumerState<LoginView> {
  Future<void> _submit() async {
    // 1. Show loading state
    setState(() => _isLoading = true);
    
    try {
      // 2. Validate & submit to Firebase Auth
      final auth = ref.read(authRepositoryProvider);
      if (_isLogin) {
        await auth.signInWithEmail(email, password);
      } else {
        await auth.signUpWithEmail(email, password);
      }
      // 3. SUCCESS → AuthChecker auto-redirect to MainScaffold
    } catch (e) {
      // 4. ERROR → Show user-friendly Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error)
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
```

#### Security Architecture

```
┌─────────────────┐
│   User Device   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐      ┌──────────────────┐
│ Firebase Auth   │─────►│ Email/Password   │
└────────┬────────┘      │ Biometric (local_ │
         │               │ auth)            │
         ▼               └──────────────────┘
┌─────────────────┐
│ Security Rules  │
│ IF user.id ==   │
│ resource.id     │
│ ALLOW read/write│
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Cloud Firestore │
│ /users/{userId} │
│   └─ /goals     │
│   └─ /settings  │
└─────────────────┘
```

---

### 💾 Firestore Data Structure

```
Firestore Collections:
┌─ users/{userId}/                    [Document]
  ├─ savings_goals/{goalId}/         [Collection]
  │  ├─ title: "Liburan Bali"
  │  ├─ targetAmount: 5000000
  │  ├─ currentAmount: 1250000
  │  ├─ createdAt: 2024-01-15
  │  ├─ targetDate: 2024-12-31
  │  └─ transactions/{txId}/         [Sub-collection]
  │     ├─ amount: 250000
  │     ├─ note: "Setoran gaji"
  │     ├─ date: 2024-01-20
  │     └─ updatedAt: 2024-01-20
  │
  ├─ savings_goals/{goalId}/         [Another Goal]
  │  ├─ title: "Beli Laptop"
  │  └─ ...
  │
  └─ settings/{docId}
     ├─ biometricEnabled: true
     └─ notifications: true
```

---

### 🧠 State Management Flow

```dart
// Riverpod Architecture
┌──────────────────────────────────────────────┐
// 1. PROVIDERS (Global State)
└──────────────────────────────────────────────┘

// StreamProvider — Real-time data listening
final savingsGoalsProvider = StreamProvider<List<SavingsGoal>>((ref) {
  final repository = ref.watch(savingsRepositoryProvider);
  return repository.watchSavingsGoals();  // ← Continuous listener
});

// AsyncNotifierProvider — Mutations (add/edit/delete)
final savingsControllerProvider = AsyncNotifierProvider<SavingsController, void>(() {
  return SavingsController();
});

┌──────────────────────────────────────────────┐
// 2. CONTROLLER (Business Logic)
└──────────────────────────────────────────────┘
class SavingsController extends AsyncNotifier<void> {
  Future<void> addSavingsGoal(...) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {  // ← Auto error handling
      final repository = ref.read(savingsRepositoryProvider);
      final newGoal = SavingsGoal(...);
      await repository.addSavingsGoal(newGoal);
    });
  }
}

┌──────────────────────────────────────────────┐
// 3. REPOSITORY (Data Operations)
└──────────────────────────────────────────────┘
class SavingsRepository {
  Stream<List<SavingsGoal>> watchSavingsGoals() {
    return _firestore.collection('users')
      .doc(userId)
      .collection('savings_goals')
      .snapshots()           // ← Real-time
      .map((snapshot) => snapshot.docs
        .map((doc) => SavingsGoal.fromMap(doc.data(), doc.id))
        .toList());
  }
}

┌──────────────────────────────────────────────┐
// 4. VIEW (UI Consumption)
└──────────────────────────────────────────────┘
class DashboardView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(savingsGoalsProvider);
    
    return goalsAsync.when(  // ← Reactive state handling
      data: (goals) => _buildGoalsList(goals),
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
    );
  }
}
```

---

### 📊 Dashboard UI Architecture

```dart
// lib/features/savings/views/dashboard_view.dart (simplified structure)
ListView(
  children: [
    // 1. Total Balance Card (3D Tilt Effect)
    TiltWidget(
      child: GlassmorphismContainer(
        child: Column([
          Text('Total Saldo', style: Theme.textTheme.bodyMedium),
          AnimatedCount(
            count: _calculateTotalAmount(goals),
            duration: 800.ms,
          ),
          LinearProgressIndicator(value: _overallProgress(goals)),
        ]),
      ),
    ),
    
    // 2. Goals List (Animated)
    ListView.builder(
      itemCount: goals.length,
      itemBuilder: (context, index) => 
        AnimatedGoalCard(goal: goals[index]),
    ),
    
    // 3. Floating Action Button
    FloatingActionButton.extended(
      onPressed: () => showAddGoalSheet(context),
      label: Text('Tambah Target'),
      icon: Icon(Icons.add),
    ),
  ],
)
```

#### Widget Tree Visualization

```
DashboardView
├─ CustomScrollView
│  ├─ SliverToBoxAdapter
│  │  └─ TotalBalanceCard (TiltWidget + Glassmorphism)
│  ├─ SliverAnimatedList
│  │  └─ AnimatedGoalCard (each goal)
│  │     ├─ GlassmorphismContainer
│  │     ├─ ProgressIndicator (custom)
│  │     ├─ CountdownWidget
│  │     └─ RippleEffect (InkWell)
│  └─ SliverToBoxAdapter
│     └─ FloatingActionButton
└─ AddGoalSheet (showModalBottomSheet)
   ├─ TextField (title)
   ├─ TextField (amount)
   ├─ DatePicker (target date)
   └─ SubmitButton
```

---

### 🧮 Simulator Logic Walkthrough

```dart
// lib/features/simulator/views/simulator_view.dart
class SimulatorView extends StatefulWidget {
  // Logic: Calculate daily/weekly/monthly savings needed
  
  double _calculateDaily(double target, DateTime start, DateTime end) {
    final days = end.difference(start).inDays;
    return days > 0 ? target / days : 0;
  }
  
  double _calculateWeekly(double target, DateTime start, DateTime end) {
    final weeks = end.difference(start).inDays / 7;
    return weeks > 0 ? target / weeks : 0;
  }
  
  double _calculateMonthly(double target, DateTime start, DateTime end) {
    final months = (end.year - start.year) * 12 + (end.month - start.month);
    return months > 0 ? target / months : 0;
  }
}
```

---

### 📈 Report Chart Integration

```dart
// lib/features/savings/views/report_view.dart
PieChart(
  PieChartData(
    sections: goals.map((goal) => PieChartSectionData(
      value: goal.currentAmount,
      color: goal.color,  // From AppColors palette
      radius: 50,
      title: '${(goal.currentAmount / goal.targetAmount * 100).toStringAsFixed(0)}%',
    )).toList(),
    centerSpaceRadius: 40,
  ),
)
```

---

### 🎨 Glassmorphism Effect Implementation

```dart
// lib/core/theme/app_theme.dart
BoxDecoration(
  color: Colors.white.withValues(alpha: 0.1),  // Blur effect
  borderRadius: BorderRadius.circular(20),
  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 10,
    ),
  ],
)
```

---

### 📱 Feature Flow Summary

| Feature | Screen | State Management | Data Source | Animation |
|---------|--------|------------------|-------------|---------|
| Login | login_view.dart | authRepositoryProvider | Firebase Auth | Staggered fade-in |
| Dashboard | dashboard_view.dart | savingsGoalsProvider | Firestore Stream | List animations |
| Add Goal | add_goal_sheet.dart | savingsControllerProvider | Firestore Batch | Slide transition |
| Simulator | simulator_view.dart | Local state (StatefulWidget) | User input | Slider transition |
| Report | report_view.dart | savingsGoalsProvider | Firestore Stream | Chart animation |
| Settings | settings_view.dart | settingsControllerProvider | SharedPreferences | Fade transitions |

---

### 🛠️ Tech Stack Relationships

```
┌─────────────────────────────────────────────────────────────┐
│                         Flutter                             │
│  ├─ UI Rendering (Widgets)                                  │
│  ├─ Navigation (PageView + BottomNav)                       │
│  └─ Animations (Hero, SharedAxis, Tilt)                     │
├─────────────────────────────────────────────────────────────┤
│                    Flutter Riverpod                           │
│  ├─ StreamProvider (real-time data)                         │
│  ├─ AsyncNotifierProvider (mutations)                        │
│  └─ Provider (services injection)                           │
├─────────────────────────────────────────────────────────────┤
│                     Firebase Ecosystem                     │
│  ├─ Authentication (Email + Biometric)                      │
│  ├─ Cloud Firestore (Database)                              │
│  └─ Security Rules (User isolation)                         │
└─────────────────────────────────────────────────────────────┘
```

---

## 🚀 Next Steps

- [ ] Implement offline sync capability
- [ ] Add comprehensive test coverage
- [ ] Export reports to PDF/Excel
- [ ] Add notification reminders
- [ ] Implement dark/light theme toggle