package controllers

import (
	"laundry-backend/database"
	"laundry-backend/models"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

type CreateItemInput struct {
    Name  string `json:"name" binding:"required,min=2"`
    Price int    `json:"price" binding:"required,min=0"`
}

type UpdateItemInput struct {
    Name  string `json:"name" binding:"omitempty,min=2"`
    Price int    `json:"price" binding:"omitempty,min=0"`
}

// GetItems godoc
// @Summary Get all items
// @Description Get list of all items
// @Tags Items
// @Accept json
// @Produce json
// @Security BearerAuth
// @Success 200 {array} models.Item
// @Failure 401 {object} map[string]interface{}
// @Router /api/items [get]
func GetItems(c *gin.Context) {
    var items []models.Item
    if err := database.DB.Find(&items).Error; err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{
            "error": "Failed to fetch items",
        })
        return
    }

    c.JSON(http.StatusOK, items)
}

// GetItemByID godoc
// @Summary Get item by ID
// @Description Get single item by ID
// @Tags Items
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param id path int true "Item ID"
// @Success 200 {object} models.Item
// @Failure 400 {object} map[string]interface{}
// @Failure 401 {object} map[string]interface{}
// @Failure 404 {object} map[string]interface{}
// @Router /api/items/{id} [get]
func GetItemByID(c *gin.Context) {
    id, err := strconv.ParseUint(c.Param("id"), 10, 32)
    if err != nil {
        c.JSON(http.StatusBadRequest, gin.H{
            "error": "Invalid item ID",
        })
        return
    }

    var item models.Item
    if err := database.DB.First(&item, uint(id)).Error; err != nil {
        c.JSON(http.StatusNotFound, gin.H{
            "error": "Item not found",
        })
        return
    }

    c.JSON(http.StatusOK, item)
}

// CreateItem godoc
// @Summary Create new item
// @Description Add new item to database
// @Tags Items
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param request body CreateItemInput true "Item data"
// @Success 200 {object} models.Item
// @Failure 400 {object} map[string]interface{}
// @Failure 401 {object} map[string]interface{}
// @Router /api/items [post]
func CreateItem(c *gin.Context) {
    var input CreateItemInput

    if err := c.ShouldBindJSON(&input); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{
            "error":   "Validation failed",
            "details": err.Error(),
        })
        return
    }

    item := models.Item{
        Name:  input.Name,
        Price: input.Price,
    }

    if err := database.DB.Create(&item).Error; err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{
            "error": "Failed to create item",
        })
        return
    }

    c.JSON(http.StatusOK, item)
}

// UpdateItem godoc
// @Summary Update item
// @Description Update existing item by ID
// @Tags Items
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param id path int true "Item ID"
// @Param request body UpdateItemInput true "Updated item data"
// @Success 200 {object} models.Item
// @Failure 400 {object} map[string]interface{}
// @Failure 401 {object} map[string]interface{}
// @Failure 404 {object} map[string]interface{}
// @Router /api/items/{id} [put]
func UpdateItem(c *gin.Context) {
    id, err := strconv.ParseUint(c.Param("id"), 10, 32)
    if err != nil {
        c.JSON(http.StatusBadRequest, gin.H{
            "error": "Invalid item ID",
        })
        return
    }

    var item models.Item
    if err := database.DB.First(&item, uint(id)).Error; err != nil {
        c.JSON(http.StatusNotFound, gin.H{
            "error": "Item not found",
        })
        return
    }

    var input UpdateItemInput
    if err := c.ShouldBindJSON(&input); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{
            "error":   "Validation failed",
            "details": err.Error(),
        })
        return
    }

    if input.Name != "" {
        item.Name = input.Name
    }
    if input.Price != 0 {
        item.Price = input.Price
    }

    if err := database.DB.Save(&item).Error; err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{
            "error": "Failed to update item",
        })
        return
    }

    c.JSON(http.StatusOK, item)
}

// DeleteItem godoc
// @Summary Delete item
// @Description Delete item by ID
// @Tags Items
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param id path int true "Item ID"
// @Success 200 {object} map[string]interface{}
// @Failure 400 {object} map[string]interface{}
// @Failure 401 {object} map[string]interface{}
// @Failure 404 {object} map[string]interface{}
// @Router /api/items/{id} [delete]
func DeleteItem(c *gin.Context) {
    id, err := strconv.ParseUint(c.Param("id"), 10, 32)
    if err != nil {
        c.JSON(http.StatusBadRequest, gin.H{
            "error": "Invalid item ID",
        })
        return
    }

    result := database.DB.Delete(&models.Item{}, uint(id))
    if result.Error != nil {
        c.JSON(http.StatusInternalServerError, gin.H{
            "error": "Failed to delete item",
        })
        return
    }

    if result.RowsAffected == 0 {
        c.JSON(http.StatusNotFound, gin.H{
            "error": "Item not found",
        })
        return
    }

    c.JSON(http.StatusOK, gin.H{
        "message": "Item deleted successfully",
    })
}