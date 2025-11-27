# Docker Containers

## What are Docker Containers?

Docker containers are **running instances** of Docker images. They are:
- Lightweight and portable
- Isolated from the host system
- Share the host OS kernel
- Can be started, stopped, moved, and deleted
- Ephemeral by default (data is lost when container is removed)

## Container Lifecycle

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Created   │───▶│   Running   │───▶│   Stopped   │───▶│   Removed   │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
       ▲                   │                   ▲                   
       │                   ▼                   │                   
       │            ┌─────────────┐            │                   
       └────────────│   Paused    │────────────┘                   
                    └─────────────┘                                
```

## Basic Container Commands

### Running Containers

#### Basic Run Command
```bash
# Run a container
docker run hello-world

# Run container in background (detached)
docker run -d nginx

# Run container with custom name
docker run --name my-nginx nginx

# Run container with port mapping
docker run -p 8080:80 nginx

# Run container interactively
docker run -it ubuntu bash
```

#### Advanced Run Options
```bash
# Run with environment variables
docker run -e NODE_ENV=production -e PORT=3000 node-app

# Run with volume mounting
docker run -v /host/path:/container/path nginx

# Run with resource limits
docker run --memory=512m --cpus=1.5 nginx

# Run with restart policy
docker run --restart=always nginx

# Run with custom network
docker run --network=my-network nginx
```

### Container Management

#### Listing Containers
```bash
# List running containers
docker ps

# List all containers (including stopped)
docker ps -a

# List container IDs only
docker ps -q

# List with custom format
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# List containers with size
docker ps -s
```

#### Starting and Stopping
```bash
# Start a stopped container
docker start container_name

# Stop a running container
docker stop container_name

# Restart a container
docker restart container_name

# Pause a container
docker pause container_name

# Unpause a container
docker unpause container_name

# Kill a container (force stop)
docker kill container_name
```

#### Container Information
```bash
# Inspect container details
docker inspect container_name

# View container logs
docker logs container_name

# Follow log output
docker logs -f container_name

# View last 100 lines of logs
docker logs --tail 100 container_name

# View logs with timestamps
docker logs -t container_name

# View container processes
docker top container_name

# View container resource usage
docker stats container_name
```

## Interactive Container Operations

### Executing Commands in Containers
```bash
# Execute command in running container
docker exec container_name ls -la

# Execute interactive bash session
docker exec -it container_name bash

# Execute command as specific user
docker exec -u root container_name whoami

# Execute command with environment variables
docker exec -e VAR=value container_name env
```

### Copying Files
```bash
# Copy file from host to container
docker cp /host/file.txt container_name:/path/file.txt

# Copy file from container to host
docker cp container_name:/path/file.txt /host/file.txt

# Copy directory
docker cp /host/directory container_name:/path/

# Copy with archive mode (preserve permissions)
docker cp -a /host/file.txt container_name:/path/
```

## Container Networking

### Port Mapping
```bash
# Map single port
docker run -p 8080:80 nginx

# Map multiple ports
docker run -p 8080:80 -p 8443:443 nginx

# Map to specific host interface
docker run -p 127.0.0.1:8080:80 nginx

# Map random host port
docker run -P nginx

# View port mappings
docker port container_name
```

### Network Commands
```bash
# List networks
docker network ls

# Create custom network
docker network create my-network

# Run container on custom network
docker run --network=my-network nginx

# Connect container to network
docker network connect my-network container_name

# Disconnect container from network
docker network disconnect my-network container_name

# Inspect network
docker network inspect my-network
```

## Container Storage

### Volume Mounting
```bash
# Mount host directory
docker run -v /host/path:/container/path nginx

# Mount named volume
docker run -v my-volume:/container/path nginx

# Mount read-only
docker run -v /host/path:/container/path:ro nginx

# Mount with specific options
docker run -v /host/path:/container/path:rw,Z nginx
```

### Working with Volumes
```bash
# List volumes
docker volume ls

# Create volume
docker volume create my-volume

# Inspect volume
docker volume inspect my-volume

# Remove volume
docker volume rm my-volume

# Remove unused volumes
docker volume prune
```

## Container Resource Management

### Resource Limits
```bash
# Memory limit
docker run --memory=512m nginx

# CPU limit
docker run --cpus=1.5 nginx

# CPU shares (relative weight)
docker run --cpu-shares=512 nginx

# Disk I/O limit
docker run --device-read-bps /dev/sda:1mb nginx

# Process limit
docker run --pids-limit=100 nginx
```

### Monitoring Resources
```bash
# Real-time resource usage
docker stats

# Resource usage for specific container
docker stats container_name

# Resource usage without streaming
docker stats --no-stream

# Resource usage with custom format
docker stats --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}"
```

## Container Security

### Running as Non-Root User
```bash
# Run as specific user
docker run -u 1000:1000 nginx

# Run as user by name
docker run -u nginx nginx

# Check current user in container
docker exec container_name whoami
```

### Security Options
```bash
# Run with read-only filesystem
docker run --read-only nginx

# Run with no new privileges
docker run --security-opt=no-new-privileges nginx

# Run with AppArmor profile
docker run --security-opt apparmor:my-profile nginx

# Run with SELinux options
docker run --security-opt label:type:container_t nginx
```

## Container Cleanup

### Removing Containers
```bash
# Remove stopped container
docker rm container_name

# Force remove running container
docker rm -f container_name

# Remove multiple containers
docker rm container1 container2

# Remove all stopped containers
docker container prune

# Remove all containers (including running)
docker rm -f $(docker ps -aq)
```

### System Cleanup
```bash
# Remove unused containers, networks, images
docker system prune

# Remove everything including volumes
docker system prune -a --volumes

# Remove containers older than 24 hours
docker container prune --filter "until=24h"

# View disk usage
docker system df
```

## Advanced Container Operations

### Container Commit
```bash
# Create image from container changes
docker commit container_name new-image:tag

# Commit with message and author
docker commit -m "Added new feature" -a "Author Name" container_name new-image:tag

# Commit with Dockerfile instructions
docker commit --change='CMD ["nginx", "-g", "daemon off;"]' container_name new-image:tag
```

### Container Export/Import
```bash
# Export container filesystem
docker export container_name > container.tar

# Import container as image
docker import container.tar new-image:tag

# Import from URL
docker import http://example.com/container.tar new-image:tag
```

### Container Diff
```bash
# Show changes made to container filesystem
docker diff container_name

# Output explanation:
# A - Added file/directory
# D - Deleted file/directory  
# C - Changed file/directory
```

## Health Checks

### Defining Health Checks
```dockerfile
# In Dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/ || exit 1
```

```bash
# At runtime
docker run --health-cmd="curl -f http://localhost/ || exit 1" \
           --health-interval=30s \
           --health-timeout=3s \
           --health-retries=3 \
           nginx
```

### Checking Health Status
```bash
# View health status
docker ps

# Inspect health check details
docker inspect --format='{{json .State.Health}}' container_name

# View health check logs
docker inspect --format='{{range .State.Health.Log}}{{.Output}}{{end}}' container_name
```

## Container Orchestration Basics

### Docker Compose Preview
```yaml
# docker-compose.yml
version: '3.8'
services:
  web:
    image: nginx
    ports:
      - "8080:80"
    volumes:
      - ./html:/usr/share/nginx/html
  
  app:
    build: .
    depends_on:
      - db
    environment:
      - DATABASE_URL=postgresql://user:pass@db:5432/mydb
  
  db:
    image: postgres:13
    environment:
      - POSTGRES_DB=mydb
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=pass
    volumes:
      - db_data:/var/lib/postgresql/data

volumes:
  db_data:
```

## Troubleshooting Containers

### Common Issues and Solutions

#### Container Won't Start
```bash
# Check container logs
docker logs container_name

# Check container configuration
docker inspect container_name

# Try running interactively
docker run -it image_name bash
```

#### Port Already in Use
```bash
# Find process using port
lsof -i :8080
netstat -tulpn | grep 8080

# Use different port
docker run -p 8081:80 nginx
```

#### Permission Issues
```bash
# Check file permissions
ls -la /host/path

# Run as specific user
docker run -u $(id -u):$(id -g) image_name

# Fix ownership
sudo chown -R $(id -u):$(id -g) /host/path
```

#### Out of Disk Space
```bash
# Check disk usage
docker system df

# Clean up unused resources
docker system prune -a

# Remove specific containers/images
docker rm $(docker ps -aq)
docker rmi $(docker images -q)
```

## Best Practices

### Container Design
1. **One process per container**
2. **Use official base images**
3. **Keep containers stateless**
4. **Use environment variables for configuration**
5. **Don't store data in containers**
6. **Use health checks**
7. **Run as non-root user**
8. **Keep containers small and focused**

### Operational Best Practices
1. **Use meaningful container names**
2. **Tag images properly**
3. **Monitor resource usage**
4. **Implement proper logging**
5. **Use restart policies appropriately**
6. **Regular cleanup of unused resources**
7. **Backup important data**
8. **Use container orchestration for production**

## Next Steps

Now that you understand Docker containers:
1. Learn about Docker storage and volumes
2. Explore Docker networking in detail
3. Use Docker Compose for multi-container applications
4. Implement container monitoring and logging
5. Deploy containers to production environments