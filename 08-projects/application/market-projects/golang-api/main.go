package main

import (
    "encoding/json"
    "fmt"
    "log"
    "net/http"
    "strconv"
    "github.com/gorilla/mux"
)

type Product struct {
    ID    int     `json:"id"`
    Name  string  `json:"name"`
    Price float64 `json:"price"`
}

var products []Product
var nextID = 1

func main() {
    // Initialize with sample data
    products = append(products, Product{ID: nextID, Name: "Laptop", Price: 999.99})
    nextID++
    products = append(products, Product{ID: nextID, Name: "Phone", Price: 599.99})
    nextID++

    r := mux.NewRouter()
    
    r.HandleFunc("/", homeHandler).Methods("GET")
    r.HandleFunc("/products", getProducts).Methods("GET")
    r.HandleFunc("/products", createProduct).Methods("POST")
    r.HandleFunc("/products/{id}", getProduct).Methods("GET")
    r.HandleFunc("/health", healthHandler).Methods("GET")

    fmt.Println("Golang API Server starting on port 8080")
    log.Fatal(http.ListenAndServe(":8080", r))
}

func homeHandler(w http.ResponseWriter, r *http.Request) {
    response := map[string]interface{}{
        "message": "Golang REST API",
        "version": "1.0.0",
        "endpoints": []string{"/products", "/products/{id}", "/health"},
    }
    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(response)
}

func getProducts(w http.ResponseWriter, r *http.Request) {
    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(products)
}

func createProduct(w http.ResponseWriter, r *http.Request) {
    var product Product
    json.NewDecoder(r.Body).Decode(&product)
    product.ID = nextID
    nextID++
    products = append(products, product)
    
    w.Header().Set("Content-Type", "application/json")
    w.WriteHeader(http.StatusCreated)
    json.NewEncoder(w).Encode(product)
}

func getProduct(w http.ResponseWriter, r *http.Request) {
    params := mux.Vars(r)
    id, _ := strconv.Atoi(params["id"])
    
    for _, product := range products {
        if product.ID == id {
            w.Header().Set("Content-Type", "application/json")
            json.NewEncoder(w).Encode(product)
            return
        }
    }
    
    w.WriteHeader(http.StatusNotFound)
    json.NewEncoder(w).Encode(map[string]string{"error": "Product not found"})
}

func healthHandler(w http.ResponseWriter, r *http.Request) {
    response := map[string]string{
        "status": "healthy",
        "service": "golang-api",
    }
    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(response)
}