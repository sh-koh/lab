package main

import (
    "log"
    "io"
	  "net/http"
)

func main() {
    http.HandleFunc("/", test)

    err := http.ListenAndServe(":8080", nil)
    if err != nil {
        log.Fatal(err)
    }
}

func test(w http.ResponseWriter, r *http.Request) {
    io.WriteString(w, "test")
}
