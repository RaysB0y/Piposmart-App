// backend/controllers/transactionController.go
package controllers

import (
	"laundry-backend/database"
	"laundry-backend/models"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

// GetTransactions - Get all transactions
func GetTransactions(c *gin.Context) {
	var transactions []models.Transaction
	database.DB.Preload("Customer").Preload("Item").Find(&transactions)
	c.JSON(http.StatusOK, transactions)
}

// GetTransactionByID - Get transaction by ID
func GetTransactionByID(c *gin.Context) {
	id, _ := strconv.Atoi(c.Param("id"))
	var transaction models.Transaction
	if err := database.DB.Preload("Customer").Preload("Item").First(&transaction, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Transaction not found"})
		return
	}
	c.JSON(http.StatusOK, transaction)
}

// CreateTransaction - Create new transaction
func CreateTransaction(c *gin.Context) {
	var transaction models.Transaction
	if err := c.ShouldBindJSON(&transaction); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	database.DB.Create(&transaction)
	c.JSON(http.StatusCreated, transaction)
}

// UpdateTransaction - Update transaction
func UpdateTransaction(c *gin.Context) {
	id, _ := strconv.Atoi(c.Param("id"))
	var transaction models.Transaction
	if err := database.DB.First(&transaction, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Transaction not found"})
		return
	}
	if err := c.ShouldBindJSON(&transaction); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	database.DB.Save(&transaction)
	c.JSON(http.StatusOK, transaction)
}

// DeleteTransaction - Delete transaction
func DeleteTransaction(c *gin.Context) {
	id, _ := strconv.Atoi(c.Param("id"))
	database.DB.Delete(&models.Transaction{}, id)
	c.JSON(http.StatusOK, gin.H{"message": "Transaction deleted"})
}