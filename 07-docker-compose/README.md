# Docker Compose

## What is Docker Compose?

Docker Compose is a tool for defining and running multi-container Docker applications. With Compose, you use a YAML file to configure your application's services, networks, and volumes.

## Benefits of Docker Compose

- **Multi-container orchestration** in a single file
- **Environment consistency** across development, testing, and production
- **Easy service management** with simple commands
- **Network and volume management** automatically handled
- **Scalability** with service scaling capabilities
- **Development workflow** optimization

## Installation

### Docker Desktop (Windows/Mac)
Docker Compose is included with Docker Desktop.

### Linux Installation
```bash
# Download Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Make executable
sudo chmod +x /usr/local/bin/docker-compose

# Verify installation
docker-compose --version
```

### Alternative Installation (pip)
```bash
pip install docker-compose
```

## Basic Docker Compose File

### Simple Example
```yaml
# docker-compose.yml
version: '3.8'

services:
  web:
    image: nginx:latest
    ports:
      - "8080:80"
    volumes:
      - ./html:/usr/share/nginx/html

  database:
    image: postgres:13
    environment:
      POSTGRES_DB: myapp
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
    volumes:
      - db_data:/var/lib/postgresql/data

volumes:
  db_data:
```

### File Structure Explanation
```yaml
version: '3.8'          # Compose file format version

services:               # Define containers
  service_name:         # Service name (becomes container name)
    image: image_name   # Docker image to use
    build: .           # Or build from Dockerfile
    ports:             # Port mappings
      - "host:container"
    volumes:           # Volume mounts
      - "host:container"
    environment:       # Environment variables
      KEY: value
    depends_on:        # Service dependencies
      - other_service

networks:              # Custom networks (optional)
  network_name:

volumes:               # Named volumes (optional)
  volume_name:
```

## Docker Compose Commands

### Basic Commands
```bash
# Start services (detached mode)
docker-compose up -d

# Start services (foreground)
docker-compose up

# Stop services
docker-compose down

# Stop and remove volumes
docker-compose down -v

# View running services
docker-compose ps

# View service logs
docker-compose logs

# Follow logs for specific service
docker-compose logs -f web

# Restart services
docker-compose restart

# Restart specific service
docker-compose restart web
```

### Build and Management Commands
```bash
# Build or rebuild services
docker-compose build

# Build without cache
docker-compose build --no-cache

# Pull latest images
docker-compose pull

# Push images to registry
docker-compose push

# Validate compose file
docker-compose config

# Scale services
docker-compose up -d --scale web=3

# Execute command in service
docker-compose exec web bash

# Run one-off command
docker-compose run web python manage.py migrate
```

## Service Configuration

### Image vs Build
```yaml
services:
  # Using pre-built image
  web:
    image: nginx:latest
  
  # Building from Dockerfile
  app:
    build: .
  
  # Building with context and dockerfile
  api:
    build:
      context: ./api
      dockerfile: Dockerfile.prod
      args:
        - VERSION=1.0
```

### Port Mapping
```yaml
services:
  web:
    ports:
      - "8080:80"           # host:container
      - "8443:443"          # multiple ports
      - "127.0.0.1:8080:80" # bind to specific interface
      - "3000-3005:3000-3005" # port range
```

### Environment Variables
```yaml
services:
  app:
    environment:
      - NODE_ENV=production
      - DATABASE_URL=postgresql://user:pass@db:5432/mydb
      - DEBUG=true
    
    # Or using env_file
    env_file:
      - .env
      - .env.local
```

### Volume Mounts
```yaml
services:
  app:
    volumes:
      # Named volume
      - app_data:/app/data
      
      # Bind mount
      - ./src:/app/src
      
      # Read-only mount
      - ./config:/app/config:ro
      
      # Anonymous volume
      - /app/node_modules

volumes:
  app_data:
```

### Dependencies
```yaml
services:
  web:
    depends_on:
      - database
      - redis
    
  database:
    image: postgres:13
  
  redis:
    image: redis:alpine
```

### Health Checks
```yaml
services:
  web:
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
```

## Real-World Examples

### LAMP Stack
```yaml
version: '3.8'

services:
  web:
    image: httpd:2.4
    ports:
      - "8080:80"
    volumes:
      - ./html:/usr/local/apache2/htdocs
      - ./httpd.conf:/usr/local/apache2/conf/httpd.conf
    depends_on:
      - php
      - database

  php:
    image: php:7.4-fpm
    volumes:
      - ./html:/var/www/html

  database:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: myapp
      MYSQL_USER: user
      MYSQL_PASSWORD: password
    volumes:
      - mysql_data:/var/lib/mysql

  phpmyadmin:
    image: phpmyadmin:latest
    ports:
      - "8081:80"
    environment:
      PMA_HOST: database
      PMA_USER: user
      PMA_PASSWORD: password
    depends_on:
      - database

volumes:
  mysql_data:
```

### MEAN Stack
```yaml
version: '3.8'

services:
  frontend:
    build: ./frontend
    ports:
      - "4200:4200"
    volumes:
      - ./frontend:/app
      - /app/node_modules
    depends_on:
      - backend

  backend:
    build: ./backend
    ports:
      - "3000:3000"
    environment:
      - MONGODB_URI=mongodb://database:27017/myapp
      - NODE_ENV=development
    volumes:
      - ./backend:/app
      - /app/node_modules
    depends_on:
      - database

  database:
    image: mongo:4.4
    ports:
      - "27017:27017"
    volumes:
      - mongo_data:/data/db

volumes:
  mongo_data:
```

### WordPress with MySQL
```yaml
version: '3.8'

services:
  wordpress:
    image: wordpress:latest
    ports:
      - "8080:80"
    environment:
      WORDPRESS_DB_HOST: database:3306
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress
      WORDPRESS_DB_NAME: wordpress
    volumes:
      - wordpress_data:/var/www/html
    depends_on:
      - database

  database:
    image: mysql:5.7
    environment:
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: wordpress
      MYSQL_ROOT_PASSWORD: rootpassword
    volumes:
      - mysql_data:/var/lib/mysql

volumes:
  wordpress_data:
  mysql_data:
```

## Networking in Docker Compose

### Default Network
```yaml
# Docker Compose automatically creates a default network
# All services can communicate using service names
version: '3.8'

services:
  web:
    image: nginx
  
  api:
    image: node:16
    # Can reach nginx using hostname 'web'
```

### Custom Networks
```yaml
version: '3.8'

services:
  frontend:
    image: nginx
    networks:
      - frontend_network
  
  backend:
    image: node:16
    networks:
      - frontend_network
      - backend_network
  
  database:
    image: postgres:13
    networks:
      - backend_network

networks:
  frontend_network:
  backend_network:
```

### Network Configuration
```yaml
networks:
  custom_network:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/16
          gateway: 172.20.0.1
```

## Environment Management

### Multiple Environment Files
```yaml
# docker-compose.yml (base)
version: '3.8'
services:
  app:
    build: .
    ports:
      - "3000:3000"

# docker-compose.override.yml (development)
version: '3.8'
services:
  app:
    volumes:
      - ./src:/app/src
    environment:
      - NODE_ENV=development

# docker-compose.prod.yml (production)
version: '3.8'
services:
  app:
    environment:
      - NODE_ENV=production
    restart: always
```

### Using Different Compose Files
```bash
# Development (uses override automatically)
docker-compose up

# Production
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up

# Testing
docker-compose -f docker-compose.yml -f docker-compose.test.yml up
```

### Environment Variables in Compose
```yaml
# Using .env file
version: '3.8'
services:
  app:
    image: myapp:${VERSION}
    ports:
      - "${PORT}:3000"
    environment:
      - DATABASE_URL=${DATABASE_URL}
```

```bash
# .env file
VERSION=1.0
PORT=8080
DATABASE_URL=postgresql://user:pass@localhost:5432/mydb
```

## Advanced Features

### Scaling Services
```bash
# Scale web service to 3 replicas
docker-compose up -d --scale web=3

# Scale multiple services
docker-compose up -d --scale web=3 --scale worker=2
```

### Service Profiles
```yaml
version: '3.8'
services:
  web:
    image: nginx
  
  database:
    image: postgres:13
  
  debug:
    image: busybox
    profiles:
      - debug
    command: sleep infinity

# Run only main services
# docker-compose up

# Run with debug profile
# docker-compose --profile debug up
```

### Secrets Management
```yaml
version: '3.8'
services:
  app:
    image: myapp
    secrets:
      - db_password
      - api_key

secrets:
  db_password:
    file: ./secrets/db_password.txt
  api_key:
    external: true
```

### Resource Limits
```yaml
version: '3.8'
services:
  app:
    image: myapp
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 512M
        reservations:
          cpus: '0.25'
          memory: 256M
```

## Development Workflow

### Hot Reloading Setup
```yaml
version: '3.8'
services:
  frontend:
    build: ./frontend
    ports:
      - "3000:3000"
    volumes:
      - ./frontend/src:/app/src
      - /app/node_modules
    environment:
      - CHOKIDAR_USEPOLLING=true

  backend:
    build: ./backend
    ports:
      - "5000:5000"
    volumes:
      - ./backend:/app
      - /app/node_modules
    environment:
      - NODE_ENV=development
    command: npm run dev
```

### Database Initialization
```yaml
version: '3.8'
services:
  database:
    image: postgres:13
    environment:
      POSTGRES_DB: myapp
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
    volumes:
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

## Production Deployment

### Production Compose File
```yaml
version: '3.8'
services:
  web:
    image: myapp:${VERSION}
    restart: always
    ports:
      - "80:80"
    environment:
      - NODE_ENV=production
    depends_on:
      - database
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost/health"]
      interval: 30s
      timeout: 10s
      retries: 3

  database:
    image: postgres:13
    restart: always
    environment:
      POSTGRES_DB: ${DB_NAME}
      POSTGRES_USER: ${DB_USER}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    volumes:
      - postgres_data:/var/lib/postgresql/data

  nginx:
    image: nginx:alpine
    restart: always
    ports:
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - ./ssl:/etc/nginx/ssl
    depends_on:
      - web

volumes:
  postgres_data:
```

## Troubleshooting

### Common Issues
```bash
# View service logs
docker-compose logs service_name

# Check service status
docker-compose ps

# Validate compose file
docker-compose config

# Rebuild services
docker-compose build --no-cache

# Remove everything and start fresh
docker-compose down -v --remove-orphans
docker-compose up --build
```

### Debugging Services
```bash
# Execute shell in running service
docker-compose exec web bash

# Run one-off container
docker-compose run --rm web bash

# Check network connectivity
docker-compose exec web ping database

# View environment variables
docker-compose exec web env
```

## Best Practices

### File Organization
```
project/
├── docker-compose.yml
├── docker-compose.override.yml
├── docker-compose.prod.yml
├── .env
├── .env.example
├── services/
│   ├── web/
│   │   └── Dockerfile
│   └── api/
│       └── Dockerfile
└── data/
    └── init.sql
```

### Security Best Practices
1. **Don't store secrets in compose files**
2. **Use environment variables for configuration**
3. **Run containers as non-root users**
4. **Use specific image tags, not 'latest'**
5. **Implement health checks**
6. **Use secrets management for sensitive data**

### Performance Optimization
1. **Use multi-stage builds** for smaller images
2. **Implement proper caching** strategies
3. **Use .dockerignore** files
4. **Optimize volume mounts** for development
5. **Monitor resource usage**

## Next Steps

Now that you understand Docker Compose:
1. Build and deploy multi-container applications
2. Implement CI/CD pipelines with Docker Compose
3. Learn container orchestration with Docker Swarm or Kubernetes
4. Explore monitoring and logging solutions
5. Deploy production applications with proper security and scaling