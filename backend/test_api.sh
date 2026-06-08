#!/bin/bash

BASE_URL="http://localhost:8080/api"

echo "=========================================="
echo "1. TEST LOGIN"
echo "=========================================="
LOGIN_RESPONSE=$(curl -s -X POST $BASE_URL/login \
  -H "Content-Type: application/json" \
  -d '{"email":"owner@piposmart.com","password":"password123"}')

echo $LOGIN_RESPONSE
TOKEN=$(echo $LOGIN_RESPONSE | grep -o '"token":"[^"]*"' | cut -d'"' -f4)

echo ""
echo "Token: $TOKEN"
echo ""

echo "=========================================="
echo "2. TEST GET ITEMS"
echo "=========================================="
curl -s -X GET $BASE_URL/items \
  -H "Authorization: Bearer $TOKEN"

echo ""
echo ""

echo "=========================================="
echo "3. TEST GET CUSTOMERS"
echo "=========================================="
curl -s -X GET $BASE_URL/customers \
  -H "Authorization: Bearer $TOKEN"

echo ""
echo ""

echo "=========================================="
echo "4. TEST GET ORDERS"
echo "=========================================="
curl -s -X GET $BASE_URL/orders \
  -H "Authorization: Bearer $TOKEN"

echo ""
echo ""

echo "=========================================="
echo "5. TEST GET DASHBOARD STATS"
echo "=========================================="
curl -s -X GET $BASE_URL/dashboard/stats \
  -H "Authorization: Bearer $TOKEN"

echo ""
echo "=========================================="
echo "✅ ALL TESTS COMPLETED"
echo "=========================================="