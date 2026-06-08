// backend/models/transaction.go
package models

import "time"

type Transaction struct {
	ID               uint      `json:"id" gorm:"primaryKey"`
	TransactionCode  string    `json:"transaction_code"`
	CustomerID       uint      `json:"customer_id"`
	Customer         Customer  `json:"customer" gorm:"foreignKey:CustomerID"`
	ItemID           uint      `json:"item_id"`
	Item             Item      `json:"item" gorm:"foreignKey:ItemID"`
	Quantity         int       `json:"quantity"`
	TotalPrice       int       `json:"total_price"`
	PaymentStatus    string    `json:"payment_status"` 
	OrderStatus      string    `json:"order_status"`  
	OutletName       string    `json:"outlet_name"`
	EstimatedAt      time.Time `json:"estimated_at"`
	CreatedAt        time.Time `json:"created_at"`
	UpdatedAt        time.Time `json:"updated_at"`
}