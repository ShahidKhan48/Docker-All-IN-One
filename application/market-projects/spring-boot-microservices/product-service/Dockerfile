FROM openjdk:17-jdk-slim

WORKDIR /app

COPY src/ ./src/

RUN javac -d . src/main/java/com/example/productservice/ProductServiceApplication.java

EXPOSE 8082

CMD ["java", "com.example.productservice.ProductServiceApplication"]