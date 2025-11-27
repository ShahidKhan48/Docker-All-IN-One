# Docker Storage

## Storage Overview

Docker provides several storage options for persisting data:
- **Volumes** (Recommended)
- **Bind Mounts**
- **tmpfs Mounts** (Linux only)

```
┌─────────────────────────────────────────────────────────────┐
│                    Docker Host                              │
│  ┌─────────────────────────────────────────────────────────┐ │
│  │                Container                                │ │
│  │  ┌─────────────┐ ┌─────────────┐ ┌─────────────────────┐ │ │
│  │  │   Volume    │ │ Bind Mount  │ │     tmpfs Mount     │ │ │
│  │  │   Mount     │ │             │ │                     │ │ │
│  │  └─────────────┘ └─────────────┘ └─────────────────────┘ │ │
│  └─────────────────────────────────────────────────────────┘ │
│           │               │                       │           │
│  ┌─────────▼─────────┐    │              ┌────────▼────────┐  │
│  │  Docker Volumes   │    │              │   Host Memory   │  │
│  │   (/var/lib/      │    │              │                 │  │
│  │   docker/volumes) │    │              └─────────────────┘  │
│  └───────────────────┘    │                                   │
│                           │                                   │
│  ┌────────────────────────▼─────────────────────────────────┐ │
│  │              Host Filesystem                             │ │
│  │           (/host/directory/path)                         │ │
│  └──────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

## Docker Volumes

### What are Volumes?
- Managed by Docker
- Stored in Docker's directory (`/var/lib/docker/volumes/`)
- Can be shared between containers
- Persist even when containers are removed
- Can be backed up and restored easily

### Volume Commands

#### Creating Volumes
```bash
# Create a named volume
docker volume create my-volume

# Create volume with driver options
docker volume create --driver local \
    --opt type=nfs \
    --opt o=addr=192.168.1.1,rw \
    --opt device=:/path/to/dir \
    my-nfs-volume

# Create volume with labels
docker volume create --label environment=production my-volume
```

#### Listing and Inspecting Volumes
```bash
# List all volumes
docker volume ls

# List volumes with filters
docker volume ls --filter dangling=true
docker volume ls --filter driver=local
docker volume ls --filter label=environment=production

# Inspect volume details
docker volume inspect my-volume

# Get volume mountpoint
docker volume inspect my-volume --format '{{ .Mountpoint }}'
```

#### Using Volumes with Containers
```bash
# Mount named volume
docker run -v my-volume:/app/data nginx

# Mount volume with read-only access
docker run -v my-volume:/app/data:ro nginx

# Mount multiple volumes
docker run -v vol1:/app/data -v vol2:/app/logs nginx

# Create and mount volume in one command
docker run -v my-new-volume:/app/data nginx
```

#### Volume Management
```bash
# Remove volume
docker volume rm my-volume

# Remove multiple volumes
docker volume rm vol1 vol2 vol3

# Remove all unused volumes
docker volume prune

# Remove volumes with filter
docker volume prune --filter label=environment=test

# Force remove volume (even if in use)
docker volume rm -f my-volume
```

### Volume Examples

#### Database with Persistent Storage
```bash
# MySQL with volume
docker run -d \
    --name mysql-db \
    -e MYSQL_ROOT_PASSWORD=secret \
    -v mysql-data:/var/lib/mysql \
    mysql:8.0

# PostgreSQL with volume
docker run -d \
    --name postgres-db \
    -e POSTGRES_PASSWORD=secret \
    -v postgres-data:/var/lib/postgresql/data \
    postgres:13
```

#### Web Application with Shared Storage
```bash
# Create shared volume
docker volume create shared-data

# Web server container
docker run -d \
    --name web-server \
    -v shared-data:/usr/share/nginx/html \
    -p 8080:80 \
    nginx

# Content management container
docker run -it \
    --name content-manager \
    -v shared-data:/app/content \
    ubuntu bash
```

## Bind Mounts

### What are Bind Mounts?
- Mount host directory/file into container
- Full path must be specified
- Host file/directory is created if it doesn't exist
- Changes are immediately visible on both host and container

### Bind Mount Syntax
```bash
# Basic bind mount
docker run -v /host/path:/container/path nginx

# Bind mount with options
docker run -v /host/path:/container/path:ro nginx  # read-only
docker run -v /host/path:/container/path:rw nginx  # read-write (default)

# Using --mount flag (more explicit)
docker run --mount type=bind,source=/host/path,target=/container/path nginx

# Bind mount with additional options
docker run --mount type=bind,source=/host/path,target=/container/path,readonly nginx
```

### Bind Mount Examples

#### Development Environment
```bash
# Mount source code for development
docker run -d \
    --name dev-server \
    -v $(pwd):/app \
    -v /app/node_modules \
    -p 3000:3000 \
    node:16 \
    npm start

# Mount configuration files
docker run -d \
    --name nginx-server \
    -v $(pwd)/nginx.conf:/etc/nginx/nginx.conf:ro \
    -v $(pwd)/html:/usr/share/nginx/html:ro \
    -p 8080:80 \
    nginx
```

#### Log Collection
```bash
# Mount log directory
docker run -d \
    --name app-server \
    -v /var/log/myapp:/app/logs \
    myapp:latest

# Mount Docker socket (for Docker-in-Docker)
docker run -d \
    --name docker-client \
    -v /var/run/docker.sock:/var/run/docker.sock \
    docker:latest
```

## tmpfs Mounts (Linux Only)

### What are tmpfs Mounts?
- Stored in host memory only
- Never written to host filesystem
- Temporary and fast
- Removed when container stops

### tmpfs Mount Usage
```bash
# Basic tmpfs mount
docker run --tmpfs /app/temp nginx

# tmpfs with size limit
docker run --tmpfs /app/temp:size=100m nginx

# Using --mount flag
docker run --mount type=tmpfs,destination=/app/temp,tmpfs-size=100m nginx

# tmpfs with additional options
docker run --mount type=tmpfs,destination=/app/temp,tmpfs-size=100m,tmpfs-mode=1777 nginx
```

### tmpfs Examples
```bash
# Temporary processing directory
docker run -d \
    --name processor \
    --tmpfs /tmp/processing:size=500m \
    myapp:latest

# Cache directory in memory
docker run -d \
    --name web-app \
    --tmpfs /app/cache:size=200m,mode=1777 \
    webapp:latest
```

## Storage Drivers

### Available Storage Drivers
- **overlay2** (Recommended for most cases)
- **aufs** (Legacy, Ubuntu/Debian)
- **devicemapper** (CentOS/RHEL 7)
- **btrfs** (SUSE)
- **zfs** (Ubuntu 16.04+)

### Checking Storage Driver
```bash
# Check current storage driver
docker info | grep "Storage Driver"

# Detailed storage information
docker system df
docker system df -v
```

### Configuring Storage Driver
```json
# /etc/docker/daemon.json
{
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
```

## Volume Drivers

### Local Driver (Default)
```bash
# Create volume with local driver
docker volume create --driver local my-volume

# Local driver with options
docker volume create \
    --driver local \
    --opt type=ext4 \
    --opt device=/dev/sdb1 \
    my-ext4-volume
```

### Third-Party Drivers
```bash
# NFS driver example
docker volume create \
    --driver local \
    --opt type=nfs \
    --opt o=addr=192.168.1.100,rw \
    --opt device=:/path/to/share \
    nfs-volume

# AWS EBS driver (with plugin)
docker volume create \
    --driver rexray/ebs \
    --opt size=10 \
    --opt volumetype=gp2 \
    ebs-volume
```

## Data Management Patterns

### Backup and Restore

#### Volume Backup
```bash
# Backup volume to tar file
docker run --rm \
    -v my-volume:/data \
    -v $(pwd):/backup \
    ubuntu tar czf /backup/backup.tar.gz -C /data .

# Restore volume from tar file
docker run --rm \
    -v my-volume:/data \
    -v $(pwd):/backup \
    ubuntu tar xzf /backup/backup.tar.gz -C /data
```

#### Database Backup
```bash
# MySQL backup
docker exec mysql-container \
    mysqldump -u root -p database_name > backup.sql

# PostgreSQL backup
docker exec postgres-container \
    pg_dump -U username database_name > backup.sql

# MongoDB backup
docker exec mongo-container \
    mongodump --out /backup
```

### Data Migration
```bash
# Copy data between volumes
docker run --rm \
    -v source-volume:/source \
    -v target-volume:/target \
    ubuntu cp -r /source/. /target/

# Migrate data to new container
docker run --rm \
    -v old-volume:/old \
    -v new-volume:/new \
    ubuntu sh -c "cp -r /old/. /new/ && chown -R 1000:1000 /new"
```

## Storage Best Practices

### Volume Best Practices
1. **Use named volumes** for persistent data
2. **Use bind mounts** for development only
3. **Use tmpfs** for temporary/sensitive data
4. **Regular backups** of important volumes
5. **Monitor disk usage** regularly
6. **Use appropriate volume drivers** for your use case

### Performance Optimization
```bash
# Use local SSD for better performance
docker volume create \
    --driver local \
    --opt type=ext4 \
    --opt device=/dev/nvme0n1p1 \
    fast-volume

# Use tmpfs for temporary high-performance storage
docker run --tmpfs /tmp:size=1g,mode=1777 myapp
```

### Security Considerations
```bash
# Read-only bind mounts
docker run -v /host/config:/app/config:ro myapp

# Specific user ownership
docker run -v my-volume:/data --user 1000:1000 myapp

# SELinux labels (on SELinux systems)
docker run -v /host/data:/data:Z myapp
```

## Troubleshooting Storage Issues

### Common Problems

#### Permission Issues
```bash
# Check volume permissions
docker run --rm -v my-volume:/data ubuntu ls -la /data

# Fix permissions
docker run --rm -v my-volume:/data ubuntu chown -R 1000:1000 /data

# Run as specific user
docker run --user $(id -u):$(id -g) -v my-volume:/data myapp
```

#### Disk Space Issues
```bash
# Check disk usage
docker system df
df -h /var/lib/docker

# Clean up unused volumes
docker volume prune

# Remove specific volumes
docker volume rm $(docker volume ls -q --filter dangling=true)
```

#### Mount Issues
```bash
# Check if volume exists
docker volume ls | grep my-volume

# Inspect volume details
docker volume inspect my-volume

# Check container mounts
docker inspect container_name | grep -A 10 "Mounts"
```

### Debugging Commands
```bash
# List all mounts in container
docker exec container_name mount | grep /data

# Check volume usage
docker exec container_name df -h

# View volume contents
docker run --rm -v my-volume:/data ubuntu ls -la /data

# Test volume write permissions
docker run --rm -v my-volume:/data ubuntu touch /data/test-file
```

## Advanced Storage Scenarios

### Multi-Container Data Sharing
```yaml
# docker-compose.yml
version: '3.8'
services:
  web:
    image: nginx
    volumes:
      - shared-data:/usr/share/nginx/html
  
  app:
    image: myapp
    volumes:
      - shared-data:/app/public
  
  backup:
    image: ubuntu
    volumes:
      - shared-data:/data:ro
    command: tar czf /backup/data.tar.gz -C /data .

volumes:
  shared-data:
```

### Cross-Host Volume Sharing
```bash
# Using NFS
docker volume create \
    --driver local \
    --opt type=nfs \
    --opt o=addr=nfs-server,rw \
    --opt device=:/shared/data \
    nfs-shared-volume

# Using cloud storage (AWS EFS)
docker volume create \
    --driver local \
    --opt type=nfs4 \
    --opt o=addr=fs-12345.efs.region.amazonaws.com,rw \
    --opt device=:/ \
    efs-volume
```

## Next Steps

Now that you understand Docker storage:
1. Learn about Docker networking
2. Use Docker Compose for multi-container applications
3. Implement backup and disaster recovery strategies
4. Explore container orchestration platforms
5. Deploy persistent applications to production