FROM openjdk:17-jdk-slim

WORKDIR /app

COPY src/ ./src/

RUN javac -d . src/main/java/com/example/App.java

EXPOSE 8080

CMD ["java", "com.example.App"]