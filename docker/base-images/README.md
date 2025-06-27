# Docker Base Images

A collection of secure, production-ready base images for various languages and frameworks.

## Images

### Python Base Image

A secure Python base image with Poetry for dependency management.

```dockerfile
# Development image
FROM ghcr.io/tzervas/python-base:latest-development as build

WORKDIR /app

COPY pyproject.toml poetry.lock ./
RUN poetry install --no-root

COPY . .
RUN poetry install

# Production image
FROM ghcr.io/tzervas/python-base:latest

WORKDIR /app

COPY --from=build /app/dist/*.whl ./
RUN pip install *.whl

CMD ["python", "-m", "your_app"]
```

### Node.js Base Image

A secure Node.js base image with PM2 for process management.

```dockerfile
# Development image
FROM ghcr.io/tzervas/node-base:latest-development as build

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

# Production image
FROM ghcr.io/tzervas/node-base:latest

WORKDIR /app

COPY --from=build /app/dist ./dist
COPY package*.json ./
RUN npm ci --production

CMD ["pm2-runtime", "dist/main.js"]
```

### Java Base Image

A secure Java base image with Gradle for building Spring Boot applications.

```dockerfile
# Development image
FROM ghcr.io/tzervas/java-base:latest-development as build

WORKDIR /app

COPY gradlew build.gradle.kts settings.gradle.kts ./
COPY gradle gradle
RUN ./gradlew --no-daemon dependencies

COPY . .
RUN ./gradlew --no-daemon build

# Production image
FROM ghcr.io/tzervas/java-base:latest

WORKDIR /app

COPY --from=build /app/build/libs/*.jar ./app.jar

CMD ["java", "-jar", "app.jar"]
```

## Features

### Security

- Non-root user with minimal permissions
- Latest security updates
- Process supervision with Tini
- Security scanning with Trivy
- Multi-stage builds
- Best practices enforcement with Hadolint

### Development

- Development and production variants
- Build tools and debuggers in development images
- Caching layers for faster builds
- Platform-specific optimizations
- Common development tools pre-installed

### Performance

- Multi-stage builds for smaller images
- Layer optimization
- Caching strategies
- Resource management
- Platform-specific tuning

## Usage

### Building Images

```bash
# Build all images
./tests/test_base_images.sh

# Build specific image
docker build -t perihelion/python-base:latest python/
docker build -t perihelion/node-base:latest node/
docker build -t perihelion/java-base:latest java/
```

### Testing Images

```bash
# Run all tests
./tests/test_base_images.sh

# Test specific image
docker run --rm perihelion/python-base:latest python3 --version
docker run --rm perihelion/node-base:latest node --version
docker run --rm perihelion/java-base:latest java --version
```

## Security Best Practices

1. **Use Non-Root User**
   - All images run as non-root user
   - Minimal permissions set
   - Secure file ownership

2. **Regular Updates**
   - Base images updated regularly
   - Security patches applied
   - Dependencies reviewed

3. **Minimal Attack Surface**
   - Only necessary packages installed
   - Development tools excluded from production
   - Unused services removed

4. **Process Security**
   - Process supervision with Tini
   - Signal handling
   - Resource limits

5. **Container Hardening**
   - Read-only root filesystem
   - Drop capabilities
   - Resource constraints

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new features
5. Submit a pull request

## License

MIT License - see [LICENSE](LICENSE) for details
