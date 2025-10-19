# -----------------------------
# Stage 1: Build
# -----------------------------
FROM eclipse-temurin:21-jdk AS build
WORKDIR /app

# Install Maven (if not already installed)
RUN apt-get update && apt-get install -y maven && rm -rf /var/lib/apt/lists/*

# Copy only pom.xml first to cache dependencies
COPY pom.xml ./

# Pre-download dependencies (cached if pom.xml doesn't change)
RUN mvn dependency:go-offline -B

# Copy the rest of the source code
COPY src ./src

# Build the JAR (skip tests for speed; tests can run in CI)
RUN mvn package -DskipTests -B

# -----------------------------
# Stage 2: Runtime (optional)
# -----------------------------
# This stage is optional since you only want the JAR
FROM eclipse-temurin:21-jdk
WORKDIR /app

# Copy the built JAR from build stage
COPY --from=build /app/target/Order-1.0-SNAPSHOT.jar app.jar

# Java options (memory tuning)
ENV JAVA_OPTS="-Xms256m -Xmx512m"

# Entry point to run the JAR (not required if you only build/package)
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
