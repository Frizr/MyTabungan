# Tabungan Online

Tabungan Online adalah aplikasi pencatatan keuangan berbasis *mobile* yang dirancang untuk membantu pengguna mengelola uang masuk dan keluar dengan mudah. Aplikasi ini dibangun dengan Flutter dan memanfaatkan Firebase sebagai *backend* untuk sinkronisasi data secara *real-time*.

## Fitur Aplikasi

- **Dashboard Keuangan:** Menampilkan total saldo pengguna saat ini.
- **Pencatatan Transaksi:** Mencatat setiap transaksi uang masuk (Pemasukan) dan uang keluar (Pengeluaran).
- **Riwayat Transaksi:** Menampilkan daftar riwayat transaksi terbaru.
- **Hide Balance:** Fitur untuk menyembunyikan nominal saldo demi privasi.
- **Real-time Database:** Data tersimpan menggunakan Firebase Firestore.

## Teknologi yang Digunakan

Proyek ini dibagi menjadi beberapa modul menggunakan arsitektur monorepo:

- **Frontend:** [Flutter](https://flutter.dev/) (Dart)
- **Database:** Firebase (Firestore)
- **Shared Models:** Package Dart terpisah untuk model data (`shared_models`)
- **Package Manager:** Melos

## Struktur Direktori

```text
tabungan_online/
├── frontend/          # Source code aplikasi utama (Flutter)
├── backend/           # Direktori backend (Cloud Functions/Server)
├── shared_models/     # Model data yang digunakan lintas modul
└── melos.yaml         # Konfigurasi Melos Workspace
```

## Panduan Instalasi dan Menjalankan Proyek

1. **Persiapan (Prerequisites):**
   - Pastikan Flutter SDK sudah terinstal.
   - Install `melos` secara global: `dart pub global activate melos`
   - Pastikan Anda sudah mengatur konfigurasi Firebase untuk project ini (`google-services.json` / `GoogleService-Info.plist` di dalam folder frontend).

2. **Clone Repository:**
   ```bash
   git clone https://github.com/USERNAME/tabungan_online.git
   cd tabungan_online
   ```

3. **Install Dependensi:**
   Jalankan perintah ini di root folder untuk mengunduh semua package dan menghubungkan antar modul:
   ```bash
   melos bootstrap
   ```

4. **Jalankan Aplikasi:**
   Pindah ke direktori frontend dan jalankan:
   ```bash
   cd frontend
   flutter run
   ```
