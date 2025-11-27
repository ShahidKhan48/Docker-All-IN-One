# Docker Images

## What are Docker Images?

Docker images are **read-only templates** used to create containers. They contain:
- Application code
- Runtime environment
- System tools and libraries
- Environment variables
- Configuration files

## Types of Docker Images

### 1. Pre-built Images (Docker Registry)

#### Official Images
```bash
# Popular official images
docker pull ubuntu:20.04
docker pull nginx:latest
docker pull node:18-alpine
docker pull python:3.9
docker pull mysql:8.0
docker pull redis:7-alpine
```

#### Community Images
```bash
# Community maintained images
docker pull bitnami/nginx
docker pull jenkins/jenkins
docker pull grafana/grafana
```

### 2. Custom Images (Built from Dockerfile)

#### Basic Dockerfile Example
```dockerfile
# Use official Python runtime as base image
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Copy requirements file
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Expose port
EXPOSE 5000

# Define command to run application
CMD ["python", "app.py"]
```

## Working with Pre-built Images

### Searching Images
```bash
# Search Docker Hub
docker search nginx
docker search python
docker search --limit 5 ubuntu

# Search with filters
docker search --filter stars=100 nginx
docker search --filter is-official=true python
```

### Pulling Images
```bash
# Pull latest version
docker pull nginx

# Pull specific version
docker pull nginx:1.21

# Pull from specific registry
docker pull gcr.io/google-containers/nginx
docker pull registry.redhat.io/ubi8/ubi
```

### Listing Images
```bash
# List all images
docker images
docker image ls

# List with specific format
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"

# List image IDs only
docker images -q

# List dangling images
docker images --filter "dangling=true"
```

### Image Information
```bash
# Inspect image details
docker inspect nginx:latest

# View image history
docker history nginx:latest

# Check image layers
docker image inspect nginx:latest | jq '.[0].RootFS.Layers'
```

## Building Custom Images

### Dockerfile Basics

#### Essential Instructions
```dockerfile
# Base image
FROM ubuntu:20.04

# Maintainer information
LABEL maintainer="your-email@example.com"

# Update package list and install packages
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV PYTHONPATH=/app
ENV FLASK_APP=app.py

# Create and set working directory
WORKDIR /app

# Copy files
COPY requirements.txt .
COPY . .

# Install Python dependencies
RUN pip3 install -r requirements.txt

# Create non-root user
RUN useradd -m appuser && chown -R appuser:appuser /app
USER appuser

# Expose port
EXPOSE 5000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:5000/health || exit 1

# Default command
CMD ["python3", "app.py"]
```

### Building Images
```bash
# Build image with tag
docker build -t myapp:1.0 .

# Build with different Dockerfile
docker build -f Dockerfile.prod -t myapp:prod .

# Build with build arguments
docker build --build-arg VERSION=1.0 -t myapp:1.0 .

# Build without cache
docker build --no-cache -t myapp:1.0 .

# Build and show progress
docker build --progress=plain -t myapp:1.0 .
```

### Multi-stage Builds
```dockerfile
# Build stage
FROM node:16-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

# Production stage
FROM node:16-alpine AS production
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY . .
EXPOSE 3000
CMD ["node", "server.js"]
```

## Advanced Dockerfile Techniques

### Optimizing Image Size
```dockerfile
# Use alpine base images
FROM python:3.9-alpine

# Combine RUN commands
RUN apk add --no-cache \
    gcc \
    musl-dev \
    && pip install --no-cache-dir -r requirements.txt \
    && apk del gcc musl-dev

# Use .dockerignore file
# .dockerignore
node_modules
.git
.gitignore
README.md
Dockerfile
.dockerignore
```

### Build Arguments
```dockerfile
# Define build argument
ARG VERSION=latest
ARG ENVIRONMENT=production

# Use build argument
FROM node:${VERSION}
ENV NODE_ENV=${ENVIRONMENT}

# Build with arguments
# docker build --build-arg VERSION=16 --build-arg ENVIRONMENT=staging -t myapp .
```

### Environment Variables
```dockerfile
# Set environment variables
ENV NODE_ENV=production
ENV PORT=3000
ENV DATABASE_URL=postgresql://localhost/myapp

# Use environment variables
EXPOSE ${PORT}
```

## Image Management

### Tagging Images
```bash
# Tag existing image
docker tag myapp:1.0 myapp:latest
docker tag myapp:1.0 myregistry.com/myapp:1.0

# Tag during build
docker build -t myapp:1.0 -t myapp:latest .
```

### Removing Images
```bash
# Remove single image
docker rmi nginx:latest

# Remove multiple images
docker rmi nginx:latest ubuntu:20.04

# Remove by image ID
docker rmi abc123def456

# Force remove
docker rmi -f myapp:1.0

# Remove all unused images
docker image prune

# Remove all images
docker rmi $(docker images -q)
```

### Saving and Loading Images
```bash
# Save image to tar file
docker save -o myapp.tar myapp:1.0

# Load image from tar file
docker load -i myapp.tar

# Export container as image
docker export container_name > myapp.tar

# Import container as image
docker import myapp.tar myapp:imported
```

## Working with Registries

### Docker Hub
```bash
# Login to Docker Hub
docker login

# Push image
docker push username/myapp:1.0

# Pull private image
docker pull username/private-repo:latest

# Logout
docker logout
```

### Private Registries
```bash
# Login to private registry
docker login myregistry.com

# Tag for private registry
docker tag myapp:1.0 myregistry.com/myapp:1.0

# Push to private registry
docker push myregistry.com/myapp:1.0

# Pull from private registry
docker pull myregistry.com/myapp:1.0
```

### AWS ECR Example
```bash
# Get login token
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 123456789012.dkr.ecr.us-east-1.amazonaws.com

# Tag image
docker tag myapp:latest 123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:latest

# Push image
docker push 123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:latest
```

## Best Practices

### Dockerfile Best Practices
1. **Use official base images**
2. **Use specific tags, not 'latest'**
3. **Minimize layers by combining RUN commands**
4. **Use .dockerignore to exclude unnecessary files**
5. **Don't install unnecessary packages**
6. **Use multi-stage builds for smaller images**
7. **Run as non-root user when possible**
8. **Use COPY instead of ADD unless you need ADD features**

### Security Best Practices
```dockerfile
# Use specific versions
FROM node:16.14.2-alpine

# Don't run as root
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001
USER nextjs

# Use secrets for sensitive data
RUN --mount=type=secret,id=api_key \
    API_KEY=$(cat /run/secrets/api_key) && \
    # Use API_KEY here
```

### Image Optimization
```dockerfile
# Multi-stage build example
FROM node:16-alpine AS deps
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

FROM node:16-alpine AS runner
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
USER node
CMD ["node", "server.js"]
```

## Troubleshooting

### Common Issues
```bash
# Build context too large
# Use .dockerignore to exclude files

# Layer caching issues
docker build --no-cache -t myapp .

# Permission issues
# Check file permissions and user context

# Image not found
docker pull myapp:1.0  # Ensure image exists

# Registry authentication
docker login  # Re-authenticate if needed
```

### Debugging Images
```bash
# Run interactive shell in image
docker run -it myapp:1.0 /bin/bash

# Check image contents
docker run --rm myapp:1.0 ls -la /app

# View image layers
docker history myapp:1.0

# Inspect image configuration
docker inspect myapp:1.0
```

## Next Steps

Now that you understand Docker images:
1. Practice building custom images with Dockerfiles
2. Learn about container management and lifecycle
3. Explore Docker networking and storage
4. Use Docker Compose for multi-container applications
5. Implement CI/CD pipelines with Docker images