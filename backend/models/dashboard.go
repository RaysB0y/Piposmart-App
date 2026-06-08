// backend/models/dashboard.go
package models

type DashboardStats struct {
    TotalIncome      int64 `json:"total_income"`      
    TotalExpense     int64 `json:"total_expense"`     
    TotalOrders      int64 `json:"total_orders"`      
    TotalCustomers   int64 `json:"total_customers"`   
    TotalItems       int64 `json:"total_items"`        
    PendingOrders    int64 `json:"pending_orders"`    
    CompletedOrders  int64 `json:"completed_orders"`  
}