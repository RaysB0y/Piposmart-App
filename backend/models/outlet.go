// backend/models/outlet.go
package models

import (
	"time"
)

type Outlet struct {
    ID        uint      `json:"id" gorm:"primaryKey"`
    Name      string    `json:"name" gorm:"not null"`
    Address   string    `json:"address"`
    Phone     string    `json:"phone"`
    OwnerID   uint      `json:"owner_id"`
    // Owner     User      `json:"owner" gorm:"foreignKey:OwnerID;constraint:OnUpdate:CASCADE,OnDelete:SET NULL;"`
    CreatedAt time.Time `json:"created_at"`
    UpdatedAt time.Time `json:"updated_at"`
}