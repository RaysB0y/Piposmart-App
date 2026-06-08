// backend/controllers/authController.go
package controllers

import (
	"laundry-backend/database"
	"laundry-backend/models"
	"laundry-backend/utils"
	"net/http"

	"github.com/gin-gonic/gin"
)

// ==================== REQUEST & RESPONSE STRUCTS ====================

type LoginRequest struct {
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required"`
}

type RegisterRequest struct {
	Name     string `json:"name" binding:"required,min=2"`
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required,min=6"`
}

type UserResponse struct {
    ID         uint   `json:"id"`
    Name       string `json:"name"`
    Email      string `json:"email"`
    Role       string `json:"role"`
    OutletName string `json:"outlet_name"`
}

type LoginResponse struct {
	Message string       `json:"message,omitempty"`
	Token   string       `json:"token"`
	User    UserResponse `json:"user"`
}

type RegisterResponse struct {
	Message string       `json:"message"`
	Token   string       `json:"token"`
	User    UserResponse `json:"user"`
}

// ==================== LOGIN CONTROLLER ====================
// @Summary Login user
// @Description Authenticate user and return JWT token with role
// @Tags Auth
// @Accept json
// @Produce json
// @Param request body LoginRequest true "Login credentials"
// @Success 200 {object} LoginResponse
// @Failure 400 {object} map[string]interface{}
// @Failure 401 {object} map[string]interface{}
// @Router /api/login [post]
func Login(c *gin.Context) {
    var req LoginRequest

    // Validate request body
    if err := c.ShouldBindJSON(&req); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{
            "error":   "Validation failed",
            "details": err.Error(),
        })
        return
    }

    // Find user by email
    var user models.User
    if err := database.DB.Where("email = ?", req.Email).First(&user).Error; err != nil {
        c.JSON(http.StatusUnauthorized, gin.H{
            "error": "Invalid email or password",
        })
        return
    }

    // Check password
    if !utils.CheckPasswordHash(req.Password, user.Password) {
        c.JSON(http.StatusUnauthorized, gin.H{
            "error": "Invalid email or password",
        })
        return
    }

        outletName := ""
    if user.OutletID != nil && user.Outlet.ID != 0 {
        outletName = user.Outlet.Name
    }

    // Generate JWT token with user ID, email, and role
    token, err := utils.GenerateToken(user.ID, user.Email, user.Role)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{
            "error": "Failed to generate token",
        })
        return
    }

    // Return success response with token and user data (including role)
    c.JSON(http.StatusOK, LoginResponse{
        Message: "Login successful",
        Token:   token,
        User: UserResponse{
            ID:    user.ID,
            Name:  user.Name,
            Email: user.Email,
            Role:  user.Role,
            OutletName: outletName,
        },
    })
}

// ==================== REGISTER CONTROLLER ====================
// @Summary Register new user
// @Description Create new user account (default role: karyawan)
// @Tags Auth
// @Accept json
// @Produce json
// @Param request body RegisterRequest true "User data"
// @Success 201 {object} RegisterResponse
// @Failure 400 {object} map[string]interface{}
// @Failure 409 {object} map[string]interface{}
// @Router /api/register [post]
func Register(c *gin.Context) {
    var req RegisterRequest

    // Validate request body
    if err := c.ShouldBindJSON(&req); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{
            "error":   "Validation failed",
            "details": err.Error(),
        })
        return
    }

    // Check if user already exists
    var existingUser models.User
    if err := database.DB.Where("email = ?", req.Email).First(&existingUser).Error; err == nil {
        c.JSON(http.StatusConflict, gin.H{
            "error": "Email already registered",
        })
        return
    }

    // Hash password
    hashedPassword, err := utils.HashPassword(req.Password)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{
            "error": "Failed to hash password",
        })
        return
    }

    // Create new user (default role: karyawan)
    user := models.User{
        Name:     req.Name,
        Email:    req.Email,
        Password: hashedPassword,
        Role:     "karyawan", // Default role for new registrations
    }

    if err := database.DB.Create(&user).Error; err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{
            "error": "Failed to create user",
        })
        return
    }

    // Generate JWT token
    token, err := utils.GenerateToken(user.ID, user.Email, user.Role)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{
            "error": "Failed to generate token",
        })
        return
    }

    // Return success response
    c.JSON(http.StatusCreated, RegisterResponse{
        Message: "Registration successful",
        Token:   token,
        User: UserResponse{
            ID:    user.ID,
            Name:  user.Name,
            Email: user.Email,
            Role:  user.Role,
        },
    })
}