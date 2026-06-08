// backend/controllers/orderController.go
package controllers

import (
	"laundry-backend/database"
	"laundry-backend/models"
	"net/http"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
)

// GetOrders - Get all orders
func GetOrders(c *gin.Context) {
    var orders []models.Order
    database.DB.Preload("Customer").Preload("Item").Find(&orders)
    c.JSON(http.StatusOK, orders)
}

// GetOrderByID - Get order by ID
func GetOrderByID(c *gin.Context) {
    id, _ := strconv.Atoi(c.Param("id"))
    var order models.Order
    if err := database.DB.Preload("Customer").Preload("Item").First(&order, id).Error; err != nil {
        c.JSON(http.StatusNotFound, gin.H{"error": "Order not found"})
        return
    }
    c.JSON(http.StatusOK, order)
}

// CreateOrder - Create new order
func CreateOrder(c *gin.Context) {
    var input struct {
        CustomerID uint `json:"customer_id"`
        ItemID     uint `json:"item_id"`
        Quantity   int  `json:"quantity"`
    }
    
    if err := c.ShouldBindJSON(&input); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }

    // Get customer
    var customer models.Customer
    if err := database.DB.First(&customer, input.CustomerID).Error; err != nil {
        c.JSON(http.StatusNotFound, gin.H{"error": "Customer not found"})
        return
    }

    // Get item
    var item models.Item
    if err := database.DB.First(&item, input.ItemID).Error; err != nil {
        c.JSON(http.StatusNotFound, gin.H{"error": "Item not found"})
        return
    }

    // Calculate total price
    totalPrice := item.Price * input.Quantity

    // Generate order code
    orderCode := "ORD/" + time.Now().Format("20060102") + "/" + strconv.Itoa(int(time.Now().UnixNano())%10000)

    order := models.Order{
        OrderCode:  orderCode,
        CustomerID: input.CustomerID,
        ItemID:     input.ItemID,
        Quantity:   input.Quantity,
        TotalPrice: totalPrice,
        Status:     "diterima",
    }

    if err := database.DB.Create(&order).Error; err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create order"})
        return
    }

    database.DB.Preload("Customer").Preload("Item").First(&order, order.ID)
    c.JSON(http.StatusCreated, order)
}

// UpdateOrderStatus - Update order status
func UpdateOrderStatus(c *gin.Context) {
    id, _ := strconv.Atoi(c.Param("id"))
    var input struct {
        Status string `json:"status"`
    }
    
    if err := c.ShouldBindJSON(&input); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }

    var order models.Order
    if err := database.DB.First(&order, id).Error; err != nil {
        c.JSON(http.StatusNotFound, gin.H{"error": "Order not found"})
        return
    }

    order.Status = input.Status
    database.DB.Save(&order)
    c.JSON(http.StatusOK, order)
}

// DeleteOrder - Delete order
func DeleteOrder(c *gin.Context) {
    id, _ := strconv.Atoi(c.Param("id"))
    database.DB.Delete(&models.Order{}, id)
    c.JSON(http.StatusOK, gin.H{"message": "Order deleted"})
}