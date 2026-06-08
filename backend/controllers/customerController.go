// backend/controllers/customerController.go
package controllers

import (
	"laundry-backend/database"
	"laundry-backend/models"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

// GetCustomers - Get all customers
func GetCustomers(c *gin.Context) {
    var customers []models.Customer
    database.DB.Find(&customers)
    c.JSON(http.StatusOK, customers)
}

// GetCustomerByID - Get customer by ID
func GetCustomerByID(c *gin.Context) {
    id, _ := strconv.Atoi(c.Param("id"))
    var customer models.Customer
    if err := database.DB.First(&customer, id).Error; err != nil {
        c.JSON(http.StatusNotFound, gin.H{"error": "Customer not found"})
        return
    }
    c.JSON(http.StatusOK, customer)
}

// CreateCustomer - Create new customer
func CreateCustomer(c *gin.Context) {
    var customer models.Customer
    if err := c.ShouldBindJSON(&customer); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }
    database.DB.Create(&customer)
    c.JSON(http.StatusCreated, customer)
}

// UpdateCustomer - Update customer
func UpdateCustomer(c *gin.Context) {
    id, _ := strconv.Atoi(c.Param("id"))
    var customer models.Customer
    if err := database.DB.First(&customer, id).Error; err != nil {
        c.JSON(http.StatusNotFound, gin.H{"error": "Customer not found"})
        return
    }
    if err := c.ShouldBindJSON(&customer); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }
    database.DB.Save(&customer)
    c.JSON(http.StatusOK, customer)
}

// DeleteCustomer - Delete customer
func DeleteCustomer(c *gin.Context) {
    id, _ := strconv.Atoi(c.Param("id"))
    database.DB.Delete(&models.Customer{}, id)
    c.JSON(http.StatusOK, gin.H{"message": "Customer deleted"})
}