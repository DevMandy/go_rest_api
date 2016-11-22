package main

import (
    "fmt"
    "net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
    fmt.Fprintf(w, "{ \"message\" : \"Hello, World\"}")
}

func main() {
    http.HandleFunc("/", handler)
    http.ListenAndServe(":8123", nil)
}