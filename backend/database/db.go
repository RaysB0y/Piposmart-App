// backend/database/db.go
package database

import (
	"fmt"
	"laundry-backend/models"
	"log"
	"os"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

var DB *gorm.DB

func ConnectDB() {
    host := os.Getenv("DB_HOST")
    user := os.Getenv("DB_USER")
    password := os.Getenv("DB_PASSWORD")
    dbname := os.Getenv("DB_NAME")
    port := os.Getenv("DB_PORT")

    if host == "" {
        host = "localhost"
    }
    if user == "" {
        user = "postgres"
    }
    if password == "" {
        password = "postgres"
    }
    if dbname == "" {
        dbname = "piposmart_db"
    }
    if port == "" {
        port = "5432"
    }

    dsn := fmt.Sprintf("host=%s user=%s password=%s dbname=%s port=%s sslmode=disable TimeZone=Asia/Jakarta",
        host, user, password, dbname, port)

    log.Println("🔄 Connecting to database...")

    var err error
    DB, err = gorm.Open(postgres.Open(dsn), &gorm.Config{
        Logger: logger.Default.LogMode(logger.Info),
        SkipDefaultTransaction: true,
    })
    if err != nil {
        log.Fatal("❌ Failed to connect to database:", err)
    }

    log.Println("✅ Database connected successfully")
}

func MigrateDB() {
    log.Println("🔄 Running database migration...")
    
    // Migrasi dengan urutan yang benar (tabel tanpa foreign key dulu)
    if err := DB.AutoMigrate(&models.User{}); err != nil {
        log.Fatal("❌ Failed to migrate User table:", err)
    }
    log.Println("✅ Users table migrated")
    
    if err := DB.AutoMigrate(&models.Item{}); err != nil {
        log.Fatal("❌ Failed to migrate Item table:", err)
    }
    log.Println("✅ Items table migrated")
    
    if err := DB.AutoMigrate(&models.Outlet{}); err != nil {
        log.Fatal("❌ Failed to migrate Outlet table:", err)
    }
    log.Println("✅ Outlets table migrated")
    
    if err := DB.AutoMigrate(&models.Customer{}); err != nil {
        log.Fatal("❌ Failed to migrate Customer table:", err)
    }
    log.Println("✅ Customers table migrated")
    
    if err := DB.AutoMigrate(&models.Transaction{}); err != nil {
        log.Fatal("❌ Failed to migrate Transaction table:", err)
    }
    log.Println("✅ Transactions table migrated")
    
    if err := DB.AutoMigrate(&models.Order{}); err != nil {
        log.Fatal("❌ Failed to migrate Order table:", err)
    }
    log.Println("✅ Orders table migrated")
    
    log.Println("✅ Database migration completed")
}

func SeedDB() {
    log.Println("🌱 Running database seeder...")
    SeedData(DB)
    log.Println("✅ Database seeding completed")
}

func GetDB() *gorm.DB {
    return DB
}

func CloseDB() {
    sqlDB, err := DB.DB()
    if err != nil {
        log.Println("⚠️ Error getting database instance:", err)
        return
    }
    
    if err := sqlDB.Close(); err != nil {
        log.Println("⚠️ Error closing database:", err)
    } else {
        log.Println("✅ Database connection closed")
    }
}