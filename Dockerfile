# syntax=docker/dockerfile:1.7

FROM maven:3.9.9-eclipse-temurin-21 AS build
WORKDIR /workspace
COPY pom.xml .
RUN --mount=type=cache,target=/root/.m2 mvn -B -q dependency:go-offline
COPY src ./src
# Tests run in CI before the image build; skip them here to keep the image build deterministic.
RUN --mount=type=cache,target=/root/.m2 mvn -B -DskipTests package

FROM eclipse-temurin:21-jre-alpine
ARG BUILD_COMMIT=local
ARG BUILD_TIME=local
LABEL org.opencontainers.image.title="sonali-intellect-demo-cicd-gitops"
LABEL org.opencontainers.image.description="A step-by-step CI/CD and GitOps training lab for Sonali Intellect."
LABEL org.opencontainers.image.source="https://github.com/AmjadHossainRahat/sonali-intellect-demo-cicd-gitops"

RUN addgroup -S app && adduser -S app -G app
WORKDIR /app
COPY --from=build /workspace/target/*.jar /app/app.jar
RUN chown -R app:app /app

USER app
EXPOSE 8080
ENV JAVA_OPTS="-XX:MaxRAMPercentage=75.0"
ENV BUILD_COMMIT="${BUILD_COMMIT}"
ENV BUILD_TIME="${BUILD_TIME}"
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar /app/app.jar"]
