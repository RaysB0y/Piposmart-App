// backend/main.go
package main

import (
	"laundry-backend/database"
	"laundry-backend/routes"
	"log"
	"os"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
)

func main() {
    // Load .env file
    if err := godotenv.Load(); err != nil {
        log.Println("⚠️ No .env file found, using default values")
    }

    // Initialize database
    database.ConnectDB()

    // Run migrations
    database.MigrateDB()

    // Run seeder
    database.SeedDB()

    // Create gin router
    r := gin.Default()

    // CORS configuration
    r.Use(cors.New(cors.Config{
        AllowOrigins:     []string{"*"},
        AllowMethods:     []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
        AllowHeaders:     []string{"Origin", "Content-Type", "Authorization"},
        ExposeHeaders:    []string{"Content-Length"},
        AllowCredentials: true,
    }))

    // Setup routes
    routes.SetupRoutes(r)

    // Get port from env or default to 8080
    port := os.Getenv("PORT")
    if port == "" {
        port = "8080"
    }

    // Start server
    log.Printf("🚀 Server running on port %s", port)
    if err := r.Run(":" + port); err != nil {
        log.Fatal("❌ Failed to start server:", err)
    }
}