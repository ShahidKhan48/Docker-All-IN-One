FROM openjdk:17-jdk-slim

WORKDIR /app

COPY src/ ./src/

RUN javac -d . src/main/java/com/example/userservice/UserServiceApplication.java

EXPOSE 8081

CMD ["java", "com.example.userservice.UserServiceApplication"]