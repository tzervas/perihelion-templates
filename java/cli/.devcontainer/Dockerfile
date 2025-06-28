FROM ghcr.io/tzervas/perihelion-templates/java-dev-base:latest

# Install additional CLI-specific tools
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
        jq \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Configure additional security measures for CLI applications
ENV JAVA_TOOL_OPTIONS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75 \
    -Djava.security.egd=file:/dev/./urandom \
    -Dfile.encoding=UTF-8 \
    -Duser.timezone=UTC"

# Label the image with CLI-specific metadata
LABEL org.opencontainers.image.description="Java CLI application development container"
