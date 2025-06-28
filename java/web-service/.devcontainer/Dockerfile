FROM ghcr.io/tzervas/perihelion-templates/java-dev-base:latest

# Install additional web service specific tools
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
        postgresql-client \
        redis-tools \
        jq \
        curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Configure additional security measures for web services
ENV JAVA_TOOL_OPTIONS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75 \
    -Djava.security.egd=file:/dev/./urandom \
    -Dfile.encoding=UTF-8 \
    -Duser.timezone=UTC \
    -XX:+ExitOnOutOfMemoryError \
    -XX:+HeapDumpOnOutOfMemoryError \
    -XX:HeapDumpPath=/tmp"

# Install Spring Boot Dev Tools
RUN mkdir -p /home/vscode/.spring-boot-devtools

# Label the image with web service specific metadata
LABEL org.opencontainers.image.description="Java Spring Boot web service development container"
