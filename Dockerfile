# Use the official OpenJDK 17 image from Docker Hub
FROM openjdk:17-jdk-slim AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the Maven or Gradle build files to the container
# (This is for Maven; adjust accordingly if using Gradle)
COPY pom.xml .

RUN apt-get update && apt-get install -y maven

# Download the project dependencies
RUN mvn dependency:go-offline

# Copy the source code to the container
COPY src /app/src

# Build the project and package it as a JAR file
RUN mvn clean package -DskipTests

# Use a smaller base image for running the app
FROM openjdk:17-jdk-slim

# Set the working directory for the application
WORKDIR /app

# Copy the JAR file from the builder image into the container
COPY --from=builder /app/target/*.jar /app/tpFoyer-17.jar

# Expose the application port (adjust as per your app's port)
EXPOSE 8083

# Command to run the JAR file when the container starts
ENTRYPOINT ["java", "-jar", "/app/tpFoyer-17.jar"]
