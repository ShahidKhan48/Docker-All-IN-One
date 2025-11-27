package com.example.productservice;

import com.sun.net.httpserver.HttpServer;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpExchange;
import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;

public class ProductServiceApplication {
    public static void main(String[] args) throws IOException {
        HttpServer server = HttpServer.create(new InetSocketAddress(8082), 0);
        
        server.createContext("/products", new HttpHandler() {
            public void handle(HttpExchange exchange) throws IOException {
                String response = "{\"service\":\"product-service\",\"products\":[{\"id\":1,\"name\":\"Laptop\",\"price\":999.99},{\"id\":2,\"name\":\"Phone\",\"price\":599.99}]}";
                exchange.getResponseHeaders().set("Content-Type", "application/json");
                exchange.sendResponseHeaders(200, response.length());
                OutputStream os = exchange.getResponseBody();
                os.write(response.getBytes());
                os.close();
            }
        });
        
        server.createContext("/health", new HttpHandler() {
            public void handle(HttpExchange exchange) throws IOException {
                String response = "{\"status\":\"UP\",\"service\":\"product-service\"}";
                exchange.getResponseHeaders().set("Content-Type", "application/json");
                exchange.sendResponseHeaders(200, response.length());
                OutputStream os = exchange.getResponseBody();
                os.write(response.getBytes());
                os.close();
            }
        });
        
        server.setExecutor(null);
        server.start();
        System.out.println("Product Service started on port 8082");
    }
}