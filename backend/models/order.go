// backend/models/order.go
package models

import "time"

type Order struct {
    ID          uint      `json:"id" gorm:"primaryKey"`
    OrderCode   string    `json:"order_code" gorm:"unique"`
    CustomerID  uint      `json:"customer_id"`
    Customer    Customer  `json:"customer" gorm:"foreignKey:CustomerID"`
    ItemID      uint      `json:"item_id"`
    Item        Item      `json:"item" gorm:"foreignKey:ItemID"`
    Quantity    int       `json:"quantity"`
    TotalPrice  int       `json:"total_price"`
    Status      string    `json:"status" gorm:"default:diterima"` 
    CreatedAt   time.Time `json:"created_at"`
    UpdatedAt   time.Time `json:"updated_at"`
}