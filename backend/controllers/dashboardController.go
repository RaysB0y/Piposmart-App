// backend/controllers/dashboardController.go
package controllers

import (
	"laundry-backend/database"
	"laundry-backend/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

// GetDashboardStats - Get dashboard statistics
func GetDashboardStats(c *gin.Context) {
    var totalIncome int64
    var totalOrders int64
    var totalCustomers int64
    var totalItems int64
    var pendingOrders int64

    // Total customers
    database.DB.Model(&models.Customer{}).Count(&totalCustomers)

    // Total items
    database.DB.Model(&models.Item{}).Count(&totalItems)

    // Total orders
    database.DB.Model(&models.Order{}).Count(&totalOrders)

    // Pending orders (diterima + diproses)
    database.DB.Model(&models.Order{}).Where("status IN ?", []string{"diterima", "diproses"}).Count(&pendingOrders)

    // Total income from orders (sum of total_price)
    database.DB.Model(&models.Order{}).Select("COALESCE(SUM(total_price), 0)").Scan(&totalIncome)

    stats := gin.H{
        "total_income":     totalIncome,
        "total_orders":     totalOrders,
        "total_customers":  totalCustomers,
        "total_items":      totalItems,
        "pending_orders":   pendingOrders,
    }

    c.JSON(http.StatusOK, gin.H{
        "success": true,
        "data":    stats,
    })
}