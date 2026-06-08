// backend/database/seeder.go
package database

import (
	"laundry-backend/models"
	"laundry-backend/utils"
	"log"
	"time"

	"gorm.io/gorm"
)

func SeedData(db *gorm.DB) {
    SeedUsers(db)
    SeedItems(db)
    SeedOutlets(db)
    SeedCustomers(db)
    SeedTransactions(db)
}

func SeedUsers(db *gorm.DB) {
    var userCount int64
    db.Model(&models.User{}).Count(&userCount)

    if userCount > 0 {
        log.Println("✅ Users already seeded, skipping...")
        return
    }

    log.Println("🌱 Seeding users...")

    users := []models.User{
        {
            Name:     "Admin Owner",
            Email:    "owner@piposmart.com",
            Password: "password123",
            Role:     "owner",
        },
        {
            Name:     "Kasir Laundry",
            Email:    "kasir@piposmart.com",
            Password: "password123",
            Role:     "kasir",
        },
        {
            Name:     "Karyawan Cuci",
            Email:    "karyawan@piposmart.com",
            Password: "password123",
            Role:     "karyawan",
        },
    }

    for _, user := range users {
        var existingUser models.User
        if err := db.Where("email = ?", user.Email).First(&existingUser).Error; err != nil {
            // User not found, create new one
            hashedPassword, err := utils.HashPassword(user.Password)
            if err != nil {
                log.Printf("⚠️ Failed to hash password for %s: %v", user.Email, err)
                continue
            }
            user.Password = hashedPassword
            if err := db.Create(&user).Error; err != nil {
                log.Printf("⚠️ Failed to seed user %s: %v", user.Email, err)
            } else {
                log.Printf("✅ User created: %s (%s)", user.Email, user.Role)
            }
        } else {
            log.Printf("⏭️ User already exists: %s", user.Email)
        }
    }

    log.Println("✅ Users seeding completed!")
    log.Println("📋 Available users:")
    log.Println("   Owner: owner@piposmart.com / password123")
    log.Println("   Kasir: kasir@piposmart.com / password123")
    log.Println("   Karyawan: karyawan@piposmart.com / password123")
}

func SeedCustomers(db *gorm.DB) {
    var count int64
    db.Model(&models.Customer{}).Count(&count)
    if count > 0 {
        log.Println("✅ Customers already seeded, skipping...")
        return
    }

    log.Println("🌱 Seeding customers...")
    customers := []models.Customer{
        {Name: "Budi Santoso", Phone: "081234567890", Address: "Jl. Merdeka No. 1"},
        {Name: "Siti Aminah", Phone: "081298765432", Address: "Jl. Sudirman No. 5"},
        {Name: "Agus Wijaya", Phone: "081355577788", Address: "Jl. Gatot Subroto No. 10"},
    }
    for _, c := range customers {
        db.Create(&c)
    }
    log.Println("✅ Customers seeding completed!")
}

func SeedTransactions(db *gorm.DB) {
    var count int64
    db.Model(&models.Transaction{}).Count(&count)
    if count > 0 {
        log.Println("✅ Transactions already seeded, skipping...")
        return
    }

    log.Println("🌱 Seeding transactions...")
    transactions := []models.Transaction{
        {
            TransactionCode: "TR/20240601/001",
            CustomerID:      1,
            ItemID:          1,
            Quantity:        3,
            TotalPrice:      15000,
            PaymentStatus:   "lunas",
            OrderStatus:     "selesai",
            OutletName:      "Piposmart Laundry Pusat",
            EstimatedAt:     time.Now().Add(24 * time.Hour),
        },
        {
            TransactionCode: "TR/20240601/002",
            CustomerID:      2,
            ItemID:          2,
            Quantity:        2,
            TotalPrice:      16000,
            PaymentStatus:   "belum_lunas",
            OrderStatus:     "diproses",
            OutletName:      "Piposmart Laundry Pusat",
            EstimatedAt:     time.Now().Add(48 * time.Hour),
        },
        {
            TransactionCode: "TR/20240601/003",
            CustomerID:      3,
            ItemID:          3,
            Quantity:        5,
            TotalPrice:      50000,
            PaymentStatus:   "lunas",
            OrderStatus:     "diterima",
            OutletName:      "Piposmart Laundry Pusat",
            EstimatedAt:     time.Now().Add(72 * time.Hour),
        },
    }
    for _, t := range transactions {
        db.Create(&t)
    }
    log.Println("✅ Transactions seeding completed!")
}

func SeedItems(db *gorm.DB) {
    var itemCount int64
    db.Model(&models.Item{}).Count(&itemCount)

    if itemCount > 0 {
        log.Println("✅ Items already seeded, skipping...")
        return
    }

    log.Println("🌱 Seeding items...")

    items := []models.Item{
        {Name: "Cuci Kering Reguler", Price: 5000},
        {Name: "Cuci Setrika", Price: 8000},
        {Name: "Setrika Saja", Price: 3000},
        {Name: "Cuci Kering + Lipat", Price: 7000},
        {Name: "Express (3 jam selesai)", Price: 15000},
        {Name: "Laundry Kiloan (per kg)", Price: 10000},
        {Name: "Bed Cover (besar)", Price: 25000},
        {Name: "Jaket / Hoodie", Price: 15000},
    }

    for _, item := range items {
        if err := db.Create(&item).Error; err != nil {
            log.Printf("⚠️ Failed to seed item %s: %v", item.Name, err)
        } else {
            log.Printf("✅ Item created: %s (Rp %d)", item.Name, item.Price)
        }
    }

    log.Println("✅ Items seeding completed!")
}

func SeedOutlets(db *gorm.DB) {
    var outletCount int64
    db.Model(&models.Outlet{}).Count(&outletCount)

    if outletCount > 0 {
        log.Println("✅ Outlets already seeded, skipping...")
        return
    }

    log.Println("🌱 Seeding outlets...")

    outlets := []models.Outlet{
        {Name: "Piposmart Laundry Pusat", Address: "Jl. Laundry No. 1", Phone: "08123456789"},
        {Name: "Piposmart Laundry Cabang", Address: "Jl. Laundry No. 2", Phone: "08123456780"},
    }

    for _, outlet := range outlets {
        if err := db.Create(&outlet).Error; err != nil {
            log.Printf("⚠️ Failed to seed outlet %s: %v", outlet.Name, err)
        }
    }

    log.Println("✅ Outlets seeding completed!")
}