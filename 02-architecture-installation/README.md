# Docker Architecture & Installation

## Docker Architecture

### High-Level Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    Docker Client                            │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────────────────┐ │
│  │ docker build│ │ docker pull │ │    docker run           │ │
│  └─────────────┘ └─────────────┘ └─────────────────────────┘ │
└─────────────────────┬───────────────────────────────────────┘
                      │ REST API
┌─────────────────────▼───────────────────────────────────────┐
│                 Docker Daemon                               │
│  ┌─────────────────────────────────────────────────────────┐ │
│  │              Container Management                       │ │
│  │  ┌─────────────┐ ┌─────────────┐ ┌─────────────────────┐ │ │
│  │  │ Container 1 │ │ Container 2 │ │    Container 3      │ │ │
│  │  └─────────────┘ └─────────────┘ └─────────────────────┘ │ │
│  └─────────────────────────────────────────────────────────┘ │
│  ┌─────────────────────────────────────────────────────────┐ │
│  │               Image Management                          │ │
│  │  ┌─────────────┐ ┌─────────────┐ ┌─────────────────────┐ │ │
│  │  │   Image 1   │ │   Image 2   │ │      Image 3        │ │ │
│  │  └─────────────┘ └─────────────┘ └─────────────────────┘ │ │
│  └─────────────────────────────────────────────────────────┘ │
└─────────────────────┬───────────────────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────────────────┐
│                Docker Registry                              │
│  ┌─────────────────────────────────────────────────────────┐ │
│  │  Docker Hub / Private Registry / ECR / GCR             │ │
│  └─────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

## Core Components Explained

### 1. Docker Client
- **Command-line interface** (CLI) that users interact with
- Sends commands to Docker daemon via REST API
- Can be on same machine or remote

**Common Commands:**
```bash
docker build    # Build images
docker run      # Run containers
docker pull     # Download images
docker push     # Upload images
docker ps       # List containers
```

### 2. Docker Daemon (dockerd)
- **Background service** running on host machine
- Manages Docker objects (images, containers, networks, volumes)
- Listens for Docker API requests
- Communicates with other daemons

**Key Responsibilities:**
- Container lifecycle management
- Image building and storage
- Network and volume management
- Registry communication

### 3. Docker Images
- **Read-only templates** used to create containers
- Built from Dockerfile instructions
- Stored in layers for efficiency
- Can be shared via registries

### 4. Docker Containers
- **Running instances** of Docker images
- Isolated processes with their own filesystem
- Can be started, stopped, moved, and deleted
- Share host OS kernel

### 5. Docker Registry
- **Storage and distribution** system for Docker images
- Docker Hub is the default public registry
- Can use private registries (AWS ECR, Google GCR, etc.)

## Detailed Architecture Flow

```
1. Developer writes Dockerfile
2. Docker Client sends build command to Daemon
3. Daemon builds image from Dockerfile
4. Image stored locally or pushed to Registry
5. Docker Client requests to run container
6. Daemon pulls image (if not local) from Registry
7. Daemon creates and starts container from image
```

## Installation Guide

### Docker Desktop (Recommended for Development)

#### Windows Installation
1. **System Requirements:**
   - Windows 10 64-bit: Pro, Enterprise, or Education
   - Hyper-V and Containers Windows features enabled
   - 4GB RAM minimum

2. **Installation Steps:**
   ```powershell
   # Download Docker Desktop from docker.com
   # Run Docker Desktop Installer.exe
   # Follow installation wizard
   # Restart computer when prompted
   ```

3. **Verification:**
   ```powershell
   docker --version
   docker run hello-world
   ```

#### macOS Installation
1. **System Requirements:**
   - macOS 10.14 or newer
   - 4GB RAM minimum
   - VirtualBox prior to version 4.3.30 must be uninstalled

2. **Installation Steps:**
   ```bash
   # Download Docker Desktop from docker.com
   # Drag Docker.app to Applications folder
   # Launch Docker from Applications
   # Follow setup assistant
   ```

3. **Verification:**
   ```bash
   docker --version
   docker run hello-world
   ```

### Linux Installation (Ubuntu/Debian)

#### Method 1: Using Repository
```bash
# Update package index
sudo apt-get update

# Install packages to allow apt to use repository over HTTPS
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker's official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Verify installation
sudo docker run hello-world
```

#### Method 2: Using Convenience Script
```bash
# Download and run Docker installation script
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user to docker group (optional)
sudo usermod -aG docker $USER
newgrp docker

# Verify installation
docker run hello-world
```

### CentOS/RHEL Installation
```bash
# Install required packages
sudo yum install -y yum-utils

# Add Docker repository
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

# Install Docker Engine
sudo yum install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Start Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Verify installation
sudo docker run hello-world
```

## Post-Installation Configuration

### Linux Post-Installation Steps

#### 1. Manage Docker as Non-Root User
```bash
# Create docker group
sudo groupadd docker

# Add user to docker group
sudo usermod -aG docker $USER

# Log out and back in, or run:
newgrp docker

# Verify you can run docker without sudo
docker run hello-world
```

#### 2. Configure Docker to Start on Boot
```bash
# Enable Docker service
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

# To disable:
# sudo systemctl disable docker.service
# sudo systemctl disable containerd.service
```

#### 3. Configure Docker Daemon
Create `/etc/docker/daemon.json`:
```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "storage-driver": "overlay2"
}
```

## Verification Commands

### Basic Verification
```bash
# Check Docker version
docker --version
docker version

# Check Docker info
docker info

# Run test container
docker run hello-world

# List running containers
docker ps

# List all containers
docker ps -a

# List images
docker images
```

### Advanced Verification
```bash
# Check Docker daemon status (Linux)
sudo systemctl status docker

# View Docker logs (Linux)
sudo journalctl -u docker.service

# Test container networking
docker run -d -p 8080:80 nginx
curl http://localhost:8080

# Clean up test container
docker stop $(docker ps -q)
docker rm $(docker ps -aq)
```

## Troubleshooting Common Issues

### Windows Issues
```powershell
# Hyper-V not enabled
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All

# WSL 2 issues
wsl --update
wsl --set-default-version 2
```

### macOS Issues
```bash
# Permission issues
sudo chown -R $(whoami) ~/.docker

# Port conflicts
lsof -i :80  # Check what's using port 80
```

### Linux Issues
```bash
# Permission denied
sudo usermod -aG docker $USER
newgrp docker

# Service not starting
sudo systemctl start docker
sudo systemctl status docker

# Storage issues
docker system prune -a  # Clean up unused data
```

## Docker Architecture Best Practices

1. **Use official base images** when possible
2. **Keep images small** by using multi-stage builds
3. **Don't run containers as root** unless necessary
4. **Use .dockerignore** to exclude unnecessary files
5. **Tag images properly** for version control
6. **Regularly update base images** for security
7. **Monitor resource usage** of containers
8. **Use health checks** for container monitoring

## Next Steps

Now that you have Docker installed and understand its architecture:
1. Learn about Docker images and how to work with them
2. Practice running and managing containers
3. Explore Docker networking and storage
4. Build your first custom Docker image
5. Use Docker Compose for multi-container applications