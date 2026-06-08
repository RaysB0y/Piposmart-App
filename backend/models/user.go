package models

import (
	"time"
	// "gorm.io/gorm"
)

// backend/models/user.go
type User struct {
    ID        uint      `json:"id" gorm:"primaryKey"`
    Name      string    `json:"name" gorm:"not null"`
    Email     string    `json:"email" gorm:"unique;not null"`
    Password  string    `json:"-"`
    Role      string    `json:"role" gorm:"default:karyawan"`
    OutletID  *uint     `json:"outlet_id"`
    Outlet    *Outlet   `json:"outlet,omitempty" gorm:"foreignKey:OutletID"` // ← Relasi ke outlet
    CreatedAt time.Time `json:"created_at"`
    UpdatedAt time.Time `json:"updated_at"`
}