# syntax=docker/dockerfile:1.4

# Base build stage
FROM eclipse-temurin:21-jdk-jammy as build-base

# Build arguments
ARG JAVA_VERSION=21
ARG DEBIAN_FRONTEND=noninteractive
ARG APP_USER=appuser
ARG APP_GROUP=appgroup
ARG APP_ROOT=/app
ARG APP_UID=10001
ARG APP_GID=10001

# Security: Update base system and install security packages
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        gnupg \
        tini \
        && \
    # Create non-root user
    groupadd -g ${APP_GID} ${APP_GROUP} && \
    useradd -u ${APP_UID} -g ${APP_GROUP} -s /bin/bash -m ${APP_USER} && \
    # Create app directory and set permissions
    mkdir -p ${APP_ROOT} && \
    chown -R ${APP_USER}:${APP_GROUP} ${APP_ROOT} && \
    # Cleanup
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR ${APP_ROOT}

# Development stage with build tools
FROM build-base as development

# Install development dependencies
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        procps \
        unzip \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Gradle
ENV GRADLE_VERSION=8.5
ENV GRADLE_HOME=/opt/gradle
ENV PATH=${GRADLE_HOME}/bin:${PATH}

RUN curl -L https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -o gradle.zip && \
    unzip gradle.zip -d /opt && \
    ln -s /opt/gradle-${GRADLE_VERSION} ${GRADLE_HOME} && \
    rm gradle.zip

# Production stage
FROM build-base as production

# Set environment variables
ENV JAVA_TOOL_OPTIONS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0" \
    SPRING_OUTPUT_ANSI_ENABLED=NEVER

# Copy JAR layers for better caching (assuming Spring Boot layered JARs)
COPY --chown=${APP_USER}:${APP_GROUP} \
     target/layers/dependencies/ ./
COPY --chown=${APP_USER}:${APP_GROUP} \
     target/layers/spring-boot-loader/ ./
COPY --chown=${APP_USER}:${APP_GROUP} \
     target/layers/snapshot-dependencies/ ./
COPY --chown=${APP_USER}:${APP_GROUP} \
     target/layers/application/ ./

# Switch to non-root user
USER ${APP_USER}:${APP_GROUP}

# Set secure file permissions
RUN umask 027

# Set the entrypoint to Tini
ENTRYPOINT ["/usr/bin/tini", "--"]

# Default command
CMD ["java", "-jar", "app.jar"]

# Labels
LABEL org.opencontainers.image.title="Java Base Image" \
      org.opencontainers.image.description="Secure Java base image with Gradle" \
      org.opencontainers.image.vendor="Tyler Zervas" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.version="1.0.0" \
      org.opencontainers.image.base.name="eclipse-temurin:21-jdk-jammy"
