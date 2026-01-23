# ===== Stage 1: Build with Maven =====
FROM maven:3.9.9-eclipse-temurin-17 AS builder
WORKDIR /workspace
COPY . .
RUN mvn -B -pl hospitalerp-boot -am clean package -DskipTests

# Tag builder for debugging
LABEL stage=builder

# ===== Stage 2: Runtime =====
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app
COPY --from=builder /workspace/hospitalerp-boot/target/*.jar /app/app.jar
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
