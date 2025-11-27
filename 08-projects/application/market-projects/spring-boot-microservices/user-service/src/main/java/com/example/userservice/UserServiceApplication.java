package com.example.userservice;

import com.sun.net.httpserver.HttpServer;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpExchange;
import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;

public class UserServiceApplication {
    public static void main(String[] args) throws IOException {
        HttpServer server = HttpServer.create(new InetSocketAddress(8081), 0);
        
        server.createContext("/users", new HttpHandler() {
            public void handle(HttpExchange exchange) throws IOException {
                String response = "{\"service\":\"user-service\",\"users\":[{\"id\":1,\"name\":\"John Doe\",\"email\":\"john@example.com\"}]}";
                exchange.getResponseHeaders().set("Content-Type", "application/json");
                exchange.sendResponseHeaders(200, response.length());
                OutputStream os = exchange.getResponseBody();
                os.write(response.getBytes());
                os.close();
            }
        });
        
        server.createContext("/health", new HttpHandler() {
            public void handle(HttpExchange exchange) throws IOException {
                String response = "{\"status\":\"UP\",\"service\":\"user-service\"}";
                exchange.getResponseHeaders().set("Content-Type", "application/json");
                exchange.sendResponseHeaders(200, response.length());
                OutputStream os = exchange.getResponseBody();
                os.write(response.getBytes());
                os.close();
            }
        });
        
        server.setExecutor(null);
        server.start();
        System.out.println("User Service started on port 8081");
    }
}