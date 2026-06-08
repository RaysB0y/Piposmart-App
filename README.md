<div align="center">
  
  # 🧺 Piposmart Laundry Management System
  
  **Aplikasi Manajemen Laundry Modern Berbasis Mobile | Flutter + Golang**
  
  [![Flutter](https://img.shields.io/badge/Flutter-3.44-blue?logo=flutter&style=for-the-badge)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.12-blue?logo=dart&style=for-the-badge)](https://dart.dev)
  [![Go](https://img.shields.io/badge/Go-1.26-blue?logo=go&style=for-the-badge)](https://golang.org)
  [![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-blue?logo=postgresql&style=for-the-badge)](https://postgresql.org)
[![Docker](https://img.shields.io/badge/Docker-29.5-blue?logo=docker&style=for-the-badge)](https://docker.com)
</div>

---

## 📋 Daftar Isi

<details open>
<summary><b>📑 Klik untuk lihat daftar isi</b></summary>

- [🎯 Tentang Aplikasi](#-tentang-aplikasi)
- [✨ Fitur Utama](#-fitur-utama)
- [🎬 Demo & Screenshots](#-demo--screenshots)
- [🛠️ Teknologi yang Digunakan](#️-teknologi-yang-digunakan)
- [🗄️ Database Schema](#️-database-schema)
- [📁 Struktur Project](#-struktur-project)
- [🚀 Cara Instalasi](#-cara-instalasi)
- [🏃 Cara Menjalankan Aplikasi](#-cara-menjalankan-aplikasi)
- [📚 API Documentation](#-api-documentation)

</details>

---

## 🎯 Tentang Aplikasi

**Piposmart Laundry** adalah aplikasi manajemen laundry berbasis mobile yang dirancang untuk membantu pemilik bisnis laundry dalam mengelola operasional sehari-hari.

### 🎬 Fitur Role-Based Access

| Role | Akses |
|------|-------|
| 👑 **Owner** | Dashboard, Kelola Layanan, Kelola Pelanggan, Transaksi, Status Order |
| 🧾 **Kasir** | Kelola Pelanggan, Transaksi, Status Order |
| 👕 **Karyawan** | Status Order (Update status cucian) |

---

## ✨ Fitur Utama

<details>
<summary><b>🔐 Authentication & Security</b></summary>

- ✅ Login dengan JWT Token
- ✅ Register akun baru
- ✅ Logout
- ✅ Role Based Access Control (Owner, Kasir, Karyawan)
- ✅ Password hashing dengan Bcrypt

</details>

<details>
<summary><b>📊 Dashboard (Owner)</b></summary>

- ✅ Statistik real-time (Pendapatan, Total Pesanan, Total Pelanggan)
- ✅ Menu akses cepat
- ✅ Ringkasan keuangan (Pendapatan, Pengeluaran, Laba)

</details>

<details>
<summary><b>👥 Manajemen Pelanggan</b></summary>

- ✅ Tambah, Edit, Hapus, Lihat pelanggan
- ✅ Data pelanggan tersimpan di database
- ✅ Validasi input data

</details>

<details>
<summary><b>🧺 Manajemen Layanan</b></summary>

- ✅ Tambah, Edit, Hapus, Lihat layanan laundry
- ✅ Harga per layanan
- ✅ Kategori layanan (kiloan, satuan, express)

</details>

<details>
<summary><b>📝 Manajemen Pesanan</b></summary>

- ✅ Buat pesanan baru (pilih pelanggan + pilih layanan + quantity)
- ✅ Update status pesanan (Diterima → Diproses → Selesai → Diambil)
- ✅ Filter pesanan berdasarkan status
- ✅ Hitung total otomatis

</details>

<details>
<summary><b>💰 Transaksi</b></summary>

- ✅ Lihat daftar transaksi
- ✅ Filter berdasarkan status pembayaran (Lunas / Belum)
- ✅ Detail transaksi
- ✅ Format mata uang Rupiah

</details>

<details>
<summary><b>👤 Profile & Setting</b></summary>

- ✅ Lihat data profil pengguna
- ✅ Informasi akun (Nama, Email, Role, Outlet)
- ✅ Logout

</details>

<details>
<summary><b>📱 Fitur Tambahan</b></summary>

- ✅ Responsive layout (support berbagai ukuran layar)
- ✅ Loading state, Error state, Empty state
- ✅ Pull to refresh
- ✅ Bottom navigation dengan tombol scan QR
- ✅ Animasi dan transisi yang halus

</details>

---

## 🎬 Screenshots

<div align="center">
  
  | Login Screen | Dashboard | Manajemen Pelanggan |
  |:-----------:|:---------:|:-------------------:|
  | <img src="https://imgur.com/wYqMBRz.png" width="200" alt="Login"> | <img src="https://imgur.com/xHF1gzi.png" width="200" alt="Dashboard"> | <img src="https://imgur.com/DDhgzpc.png" width="200" alt="Customers"> |
  
  | Buat Pesanan | Status Order | Transaksi |
  |:-----------:|:------------:|:---------:|
  | <img src="https://imgur.com/vJehnpu.png" width="200" alt="Create Order"> | <img src="https://imgur.com/WV8ufeW.png" width="200" alt="Order Status"> | <img src="https://imgur.com/RnDMSSA.png" width="200" alt="Transactions"> |
  
  | Profile |
  |:------:|
  | <img src="https://imgur.com/mTgjLiW.png" width="200" alt="Profile"> |

</div>

---

## 🛠️ Teknologi yang Digunakan

### Frontend
| Teknologi | Versi | Kegunaan |
|-----------|-------|----------|
| **Flutter** | 3.x | Framework UI utama |
| **Riverpod** | 2.5.0 | State Management |
| **HTTP** | 1.1.0 | API Client |
| **Shared Preferences** | 2.2.2 | Penyimpanan token lokal |
| **Intl** | 0.18.1 | Format mata uang & tanggal |
| **Google Fonts** | 6.1.0 | Tipografi Poppins |

### Backend
| Teknologi | Versi | Kegunaan |
|-----------|-------|----------|
| **Golang** | 1.26 | Bahasa pemrograman |
| **Gin Framework** | 1.9.1 | Web framework & routing |
| **GORM** | 1.25.5 | ORM untuk database |
| **JWT** | 5.0.0 | Autentikasi token |
| **Bcrypt** | - | Password hashing |
| **Godotenv** | 1.5.1 | Environment variables |

### Database
| Teknologi | Versi | Kegunaan |
|-----------|-------|----------|
| **PostgreSQL** | 15 | Database utama |
| **Docker** | 29.x | Containerization |

---

## 🗄️ Database Schema

### Entity Relationship Diagram (ERD)

<div align="center">
  <img src="https://imgur.com/WEPRrht.png" alt="ERD Piposmart Laundry" width="600"/>
  <br>
  <i>Entity Relationship Diagram (Simple)</i>
</div>

---

## 📁 Struktur Project

```bash
pipolaundry/
│
├── 📁 backend/                          # Backend Golang
│   ├── 📁 controllers/                  # HTTP handlers
│   ├── 📁 database/                     # Database connection & seeder
│   ├── 📁 middleware/                   # Middleware (Auth, CORS)
│   ├── 📁 models/                       # Data models
│   ├── 📁 routes/                       # API routes
│   ├── 📁 utils/                        # Utilities (JWT, Password)
│   ├── 📄 .env                          # Environment variables
│   ├── 📄 go.mod                        # Go dependencies
│   └── 📄 main.go                       # Entry point
│
├── 📁 frontend/
│   └── 📁 piposmart_app/                # Frontend Flutter
│       ├── 📁 lib/
│       │   ├── 📁 screens/              # UI pages
│       │   ├── 📁 widgets/              # Reusable components
│       │   ├── 📁 providers/            # State management
│       │   ├── 📁 services/             # API services
│       │   ├── 📁 models/               # Data models
│       │   └── 📁 utils/                # Utilities
│       └── 📄 pubspec.yaml              # Flutter dependencies
│        
├── 📁 postman/                          # Postman collection
│   └── 📄 PiposmartAPICollection.json   # Postman API collection
│
├── 📄 README.md                         # Documentation
└── 🐳 docker-compose.yml                # Docker Compose (PostgreSQL)


```

# 🚀 Cara Instalasi

## 1️⃣ Clone Repository

```bash
git clone https://github.com/username/pipolaundry.git
cd pipolaundry
```

---

## 2️⃣ Setup Database PostgreSQL

### 🐳 Menggunakan Docker

```bash
docker run --name postgres-piposmart \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_DB=piposmart_db \
  -p 5432:5432 \
  -d postgres:15
```

---

## 3️⃣ Setup Backend (Golang)

```bash
# Masuk ke folder backend
cd backend

# Buat file .env
cat > .env << EOF
DB_HOST=localhost
DB_USER=postgres
DB_PASSWORD=postgres
DB_NAME=piposmart_db
DB_PORT=5432
JWT_SECRET=supersecretkey123
PORT=8080
EOF

# Install dependencies
go mod tidy

# Jalankan backend
go run main.go
```

**Output jika berhasil:**
```
✅ Database connected successfully
✅ Database migration completed
✅ Database seeding completed
🚀 Server running on port 8080
```

---

## 4️⃣ Setup Frontend (Flutter)

```bash
# Buka terminal baru
cd frontend/piposmart_app

# Install dependencies
flutter pub get

# Jalankan aplikasi
flutter run
flutter run -d chrome
```

---

# 🏃 Cara Menjalankan Aplikasi

## Terminal 1: Menjalankan Backend

```bash
cd backend
go run main.go
```

Backend akan berjalan di: `http://localhost:8080`

---

## Terminal 2: Menjalankan Frontend

```bash
cd frontend/piposmart_app
flutter run
```
---

## 🔐 Login ke Aplikasi

Setelah aplikasi running, login dengan akun berikut:

| Role | Email | Password |
|------|-------|----------|
| **Owner** | `owner@piposmart.com` | `password123` |
| **Kasir** | `kasir@piposmart.com` | `password123` |
| **Karyawan** | `karyawan@piposmart.com` | `password123` |


---

## 📚 API Documentation

Dokumentasi API lengkap tersedia di file terpisah:

📁 **[Piposmart API Collection](./PiposmartAPICollection.json)** - Import ke Postman

### Bukti API Berfungsi

| Endpoint | Screenshot |
|----------|------------|
| **POST /login** | <img src="https://imgur.com/sBqpUwl.png" width="300" alt="Login API"> |
| **GET /items** | <img src="https://imgur.com/qIgTUSN.png" width="300" alt="Get Items API"> |

### Cara Import Postman Collection

1. Download file Collection 
2. Buka Postman Desktop
3. Klik **Import** → **Upload Files**
4. Pilih file yang sudah di download
5. Klik **Import**







