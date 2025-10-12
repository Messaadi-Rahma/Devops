# Stage 1: Build
FROM eclipse-temurin:21-jdk AS build
WORKDIR /app

# Copy project files
COPY . .

# Install Maven
RUN apt-get update && apt-get install -y maven && rm -rf /var/lib/apt/lists/*

# Build the JAR
RUN mvn clean package

# Stage 2: Runtime
FROM eclipse-temurin:21-jdk
WORKDIR /app

# Copy the built JAR from the build stage
COPY --from=build /app/target/Order-1.0-SNAPSHOT.jar app.jar

# Expose port (if needed)
EXPOSE 8181

# Run the application
CMD ["java", "-jar", "app.jar"]
