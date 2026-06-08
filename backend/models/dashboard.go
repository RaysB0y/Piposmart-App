// backend/models/dashboard.go
package models

type DashboardStats struct {
    TotalIncome      int64 `json:"total_income"`       // Total pendapatan
    TotalExpense     int64 `json:"total_expense"`      // Total pengeluaran
    TotalOrders      int64 `json:"total_orders"`       // Total pesanan
    TotalCustomers   int64 `json:"total_customers"`    // Total pelanggan
    TotalItems       int64 `json:"total_items"`        // Total layanan
    PendingOrders    int64 `json:"pending_orders"`     // Pesanan pending (diterima + diproses)
    CompletedOrders  int64 `json:"completed_orders"`   // Pesanan selesai
}