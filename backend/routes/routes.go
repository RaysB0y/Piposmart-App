// backend/routes/routes.go
package routes

import (
	"laundry-backend/controllers"
	"laundry-backend/middleware"

	"github.com/gin-gonic/gin"
)

func SetupRoutes(r *gin.Engine) {
    // API routes group
    api := r.Group("/api")
    {
        // Public routes
        api.POST("/register", controllers.Register)
        api.POST("/login", controllers.Login)

        // Protected routes
        protected := api.Group("/")
        protected.Use(middleware.AuthMiddleware())
        {
            // Items
            protected.GET("/items", controllers.GetItems)
            protected.GET("/items/:id", controllers.GetItemByID)
            protected.POST("/items", controllers.CreateItem)
            protected.PUT("/items/:id", controllers.UpdateItem)
            protected.DELETE("/items/:id", controllers.DeleteItem)

            // Transactions
            protected.GET("/transactions", controllers.GetTransactions)
            protected.GET("/transactions/:id", controllers.GetTransactionByID)
            protected.POST("/transactions", controllers.CreateTransaction)
            protected.PUT("/transactions/:id", controllers.UpdateTransaction)
            protected.DELETE("/transactions/:id", controllers.DeleteTransaction)

            // Customers
            protected.GET("/customers", controllers.GetCustomers)
            protected.GET("/customers/:id", controllers.GetCustomerByID)
            protected.POST("/customers", controllers.CreateCustomer)
            protected.PUT("/customers/:id", controllers.UpdateCustomer)
            protected.DELETE("/customers/:id", controllers.DeleteCustomer)

            // Orders
            protected.GET("/orders", controllers.GetOrders)
            protected.GET("/orders/:id", controllers.GetOrderByID)
            protected.POST("/orders", controllers.CreateOrder)
            protected.PUT("/orders/:id/status", controllers.UpdateOrderStatus)
            protected.DELETE("/orders/:id", controllers.DeleteOrder)

            // Dashboard Stats
            protected.GET("/dashboard/stats", controllers.GetDashboardStats)
        }
    }

    // Health check
    r.GET("/health", func(c *gin.Context) {
        c.JSON(200, gin.H{
            "status":  "ok",
            "message": "Server is running",
        })
    })
}