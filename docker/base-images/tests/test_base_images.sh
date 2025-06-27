#!/usr/bin/env bash

set -euo pipefail

# Helper functions
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

error() {
    log "ERROR: $*" >&2
    exit 1
}

check_command() {
    command -v "$1" >/dev/null 2>&1 || error "Required command '$1' not found"
}

test_image() {
    local image_name=$1
    local test_command=$2
    local expected_exit_code=${3:-0}

    log "Testing $image_name..."
    
    # Run container with test command
    if docker run --rm "$image_name" $test_command; then
        if [ "$expected_exit_code" -eq 0 ]; then
            log "✅ $image_name test passed"
            return 0
        else
            log "❌ $image_name test failed: Expected non-zero exit code"
            return 1
        fi
    else
        if [ "$expected_exit_code" -ne 0 ]; then
            log "✅ $image_name test passed (expected failure)"
            return 0
        else
            log "❌ $image_name test failed"
            return 1
        fi
    fi
}

# Check required commands
check_command docker
check_command grep

# Build all images
log "Building Python base image..."
docker build -t perihelion/python-base:latest python/

log "Building Node.js base image..."
docker build -t perihelion/node-base:latest node/

log "Building Java base image..."
docker build -t perihelion/java-base:latest java/

# Test Python image
test_image "perihelion/python-base:latest" "python3 --version" || error "Python test failed"
test_image "perihelion/python-base:latest-development" "poetry --version" || error "Python development test failed"

# Test Node.js image
test_image "perihelion/node-base:latest" "node --version" || error "Node.js test failed"
test_image "perihelion/node-base:latest-development" "npm --version" || error "Node.js development test failed"

# Test Java image
test_image "perihelion/java-base:latest" "java --version" || error "Java test failed"
test_image "perihelion/java-base:latest-development" "gradle --version" || error "Java development test failed"

# Test security
log "Testing security configuration..."

# Test non-root user
for image in perihelion/python-base:latest perihelion/node-base:latest perihelion/java-base:latest; do
    log "Testing non-root user for $image..."
    if docker run --rm "$image" id | grep -q "uid=10001(appuser)"; then
        log "✅ $image running as non-root user"
    else
        error "$image not running as non-root user"
    fi
done

# Test file permissions
for image in perihelion/python-base:latest perihelion/node-base:latest perihelion/java-base:latest; do
    log "Testing file permissions for $image..."
    if docker run --rm "$image" ls -la /app | grep -q "drwxr-x---"; then
        log "✅ $image has correct file permissions"
    else
        error "$image has incorrect file permissions"
    fi
done

log "All tests passed! 🎉"
