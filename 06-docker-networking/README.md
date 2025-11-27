# Docker Networking

## Networking Overview

Docker networking allows containers to communicate with each other and the outside world. Docker provides several network drivers and networking options.

```
┌─────────────────────────────────────────────────────────────┐
│                    Docker Host                              │
│                                                             │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────────┐  │
│  │ Container A │    │ Container B │    │   Container C   │  │
│  │   (Web)     │    │    (API)    │    │   (Database)    │  │
│  └──────┬──────┘    └──────┬──────┘    └────────┬────────┘  │
│         │                  │                    │           │
│  ┌──────▼──────────────────▼────────────────────▼────────┐  │
│  │              Docker Bridge Network                   │  │
│  │                   (docker0)                          │  │
│  └───────────────────────┬───────────────────────────────┘  │
│                          │                                  │
│  ┌───────────────────────▼───────────────────────────────┐  │
│  │                Host Network                           │  │
│  └───────────────────────┬───────────────────────────────┘  │
│                          │                                  │
└──────────────────────────┼──────────────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────────────┐
│                 External Network                            │
│                   (Internet)                               │
└─────────────────────────────────────────────────────────────┘
```

## Network Drivers

### 1. Bridge (Default)
- Default network driver
- Containers can communicate with each other
- Isolated from host network
- Best for single-host deployments

### 2. Host
- Container uses host's network directly
- No network isolation
- Better performance
- Port conflicts possible

### 3. None
- No networking
- Complete network isolation
- Container has only loopback interface

### 4. Overlay
- Multi-host networking
- Used in Docker Swarm
- Encrypted by default

### 5. Macvlan
- Assign MAC address to container
- Container appears as physical device
- Direct connection to physical network

## Basic Network Commands

### Listing Networks
```bash
# List all networks
docker network ls

# List networks with filters
docker network ls --filter driver=bridge
docker network ls --filter name=my-network

# List network IDs only
docker network ls -q
```

### Network Information
```bash
# Inspect network details
docker network inspect bridge

# Get network gateway
docker network inspect bridge --format='{{range .IPAM.Config}}{{.Gateway}}{{end}}'

# Get network subnet
docker network inspect bridge --format='{{range .IPAM.Config}}{{.Subnet}}{{end}}'

# List containers in network
docker network inspect bridge --format='{{range $k,$v := .Containers}}{{$k}} {{$v.Name}} {{end}}'
```

## Working with Bridge Networks

### Default Bridge Network
```bash
# Run container on default bridge
docker run -d --name web nginx

# Check container IP
docker inspect web --format='{{.NetworkSettings.IPAddress}}'

# Test connectivity between containers
docker run --rm alpine ping web  # This won't work with default bridge
```

### Custom Bridge Networks
```bash
# Create custom bridge network
docker network create my-network

# Create bridge with custom subnet
docker network create --subnet=172.20.0.0/16 my-custom-network

# Create bridge with custom gateway
docker network create --subnet=172.20.0.0/16 --gateway=172.20.0.1 my-network

# Run containers on custom network
docker run -d --name web --network my-network nginx
docker run -d --name api --network my-network node-api

# Test connectivity (works with custom networks)
docker exec web ping api
```

### Network Configuration Options
```bash
# Create network with DNS options
docker network create \
    --driver bridge \
    --subnet=172.20.0.0/16 \
    --ip-range=172.20.240.0/20 \
    --gateway=172.20.0.1 \
    --dns=8.8.8.8 \
    --dns=8.8.4.4 \
    my-network

# Create network with custom MTU
docker network create --opt com.docker.network.driver.mtu=1450 my-network
```

## Container Network Management

### Connecting Containers to Networks
```bash
# Connect running container to network
docker network connect my-network container_name

# Connect with specific IP
docker network connect --ip 172.20.0.10 my-network container_name

# Connect with alias
docker network connect --alias web-server my-network container_name

# Disconnect container from network
docker network disconnect my-network container_name
```

### Running Containers with Network Options
```bash
# Run on specific network
docker run -d --name web --network my-network nginx

# Run with specific IP
docker run -d --name web --network my-network --ip 172.20.0.10 nginx

# Run with hostname
docker run -d --name web --network my-network --hostname webserver nginx

# Run with network alias
docker run -d --name web --network my-network --network-alias frontend nginx

# Run with multiple networks
docker run -d --name web --network net1 nginx
docker network connect net2 web
```

## Port Mapping and Exposure

### Port Mapping
```bash
# Map single port
docker run -p 8080:80 nginx

# Map multiple ports
docker run -p 8080:80 -p 8443:443 nginx

# Map to specific interface
docker run -p 127.0.0.1:8080:80 nginx

# Map random port
docker run -P nginx

# Map UDP port
docker run -p 8080:80/udp nginx

# Map port range
docker run -p 8080-8090:8080-8090 nginx
```

### Exposing Ports
```dockerfile
# In Dockerfile
EXPOSE 80 443
EXPOSE 8080/tcp
EXPOSE 8080/udp
```

```bash
# Check port mappings
docker port container_name

# Check specific port mapping
docker port container_name 80
```

## Host Networking

### Using Host Network
```bash
# Run container with host networking
docker run -d --network host nginx

# Container uses host's network interface directly
# No port mapping needed
# Better performance but less isolation
```

### Host Network Use Cases
- High-performance applications
- Network monitoring tools
- When you need access to host network interfaces
- Legacy applications that bind to specific interfaces

## Container Communication

### Communication Methods

#### 1. Container Names (Custom Networks)
```bash
# Create network and containers
docker network create app-network
docker run -d --name database --network app-network postgres
docker run -d --name backend --network app-network myapi
docker run -d --name frontend --network app-network nginx

# Containers can communicate using names
docker exec backend ping database
docker exec frontend curl http://backend:3000/api
```

#### 2. Service Discovery
```bash
# Using network aliases
docker run -d --name db1 --network app-network --network-alias database postgres
docker run -d --name db2 --network app-network --network-alias database postgres

# Both containers respond to 'database' name
docker exec backend nslookup database
```

#### 3. Environment Variables
```bash
# Pass connection information via environment
docker run -d --name backend \
    --network app-network \
    -e DATABASE_HOST=database \
    -e DATABASE_PORT=5432 \
    myapi
```

### Multi-Container Application Example
```bash
# Create network
docker network create todo-network

# Run database
docker run -d \
    --name todo-db \
    --network todo-network \
    -e POSTGRES_DB=todos \
    -e POSTGRES_USER=user \
    -e POSTGRES_PASSWORD=password \
    postgres:13

# Run backend API
docker run -d \
    --name todo-api \
    --network todo-network \
    -e DATABASE_URL=postgresql://user:password@todo-db:5432/todos \
    -p 3000:3000 \
    todo-backend

# Run frontend
docker run -d \
    --name todo-web \
    --network todo-network \
    -e API_URL=http://todo-api:3000 \
    -p 8080:80 \
    todo-frontend
```

## Advanced Networking

### Overlay Networks (Docker Swarm)
```bash
# Initialize swarm
docker swarm init

# Create overlay network
docker network create --driver overlay my-overlay

# Deploy service on overlay network
docker service create --name web --network my-overlay --replicas 3 nginx
```

### Macvlan Networks
```bash
# Create macvlan network
docker network create -d macvlan \
    --subnet=192.168.1.0/24 \
    --gateway=192.168.1.1 \
    -o parent=eth0 \
    my-macvlan

# Run container with macvlan
docker run -d --name web --network my-macvlan nginx

# Container gets IP from physical network
```

### Custom Network Plugins
```bash
# Install third-party network plugin
docker plugin install store/weaveworks/net-plugin:latest

# Create network with custom plugin
docker network create --driver weave my-weave-network
```

## Network Security

### Network Isolation
```bash
# Create isolated networks
docker network create frontend-network
docker network create backend-network

# Web server only on frontend
docker run -d --name web --network frontend-network nginx

# Database only on backend
docker run -d --name db --network backend-network postgres

# API server on both networks
docker run -d --name api --network frontend-network myapi
docker network connect backend-network api
```

### Firewall Rules
```bash
# Docker automatically creates iptables rules
# View Docker's iptables rules
sudo iptables -L DOCKER

# Custom iptables rules
sudo iptables -I DOCKER-USER -s 172.17.0.0/16 -d 172.17.0.0/16 -j ACCEPT
```

### Encrypted Networks
```bash
# Overlay networks are encrypted by default
docker network create --driver overlay --opt encrypted my-secure-network
```

## Network Troubleshooting

### Debugging Network Issues
```bash
# Check container network configuration
docker exec container_name ip addr show

# Check routing table
docker exec container_name ip route

# Test connectivity
docker exec container_name ping google.com
docker exec container_name telnet database 5432

# Check DNS resolution
docker exec container_name nslookup database
docker exec container_name cat /etc/resolv.conf

# Check listening ports
docker exec container_name netstat -tlnp
docker exec container_name ss -tlnp
```

### Network Inspection
```bash
# Inspect network details
docker network inspect my-network

# Check which containers are connected
docker network inspect my-network --format='{{json .Containers}}'

# View network configuration
docker exec container_name cat /etc/hosts
docker exec container_name env | grep -i network
```

### Common Issues and Solutions

#### Container Can't Reach External Network
```bash
# Check DNS configuration
docker exec container_name cat /etc/resolv.conf

# Test DNS resolution
docker exec container_name nslookup google.com

# Check if container can reach gateway
docker exec container_name ping $(docker network inspect bridge --format='{{range .IPAM.Config}}{{.Gateway}}{{end}}')
```

#### Containers Can't Communicate
```bash
# Ensure containers are on same network
docker inspect container1 | grep NetworkMode
docker inspect container2 | grep NetworkMode

# Check if custom network allows communication
docker network ls
docker network inspect network_name
```

#### Port Mapping Issues
```bash
# Check if port is already in use
netstat -tlnp | grep :8080
lsof -i :8080

# Verify port mapping
docker port container_name

# Check if service is listening inside container
docker exec container_name netstat -tlnp
```

## Network Monitoring

### Monitoring Tools
```bash
# Monitor network traffic
docker exec container_name iftop
docker exec container_name nethogs

# Check network statistics
docker exec container_name cat /proc/net/dev

# Monitor connections
docker exec container_name ss -tuln
```

### Network Performance
```bash
# Test network performance between containers
docker exec container1 iperf3 -s
docker exec container2 iperf3 -c container1

# Monitor bandwidth usage
docker stats --format "table {{.Container}}\t{{.NetIO}}"
```

## Best Practices

### Network Design
1. **Use custom bridge networks** for container communication
2. **Isolate different tiers** (frontend, backend, database)
3. **Use meaningful network names**
4. **Implement proper security groups**
5. **Monitor network performance**
6. **Use overlay networks** for multi-host deployments

### Security Best Practices
1. **Principle of least privilege** - only necessary connections
2. **Network segmentation** - separate sensitive services
3. **Use encrypted networks** for sensitive data
4. **Regular security audits** of network configurations
5. **Monitor network traffic** for anomalies

### Performance Optimization
1. **Use host networking** for high-performance applications
2. **Optimize MTU settings** for your environment
3. **Use local networks** when possible
4. **Monitor and tune network buffers**
5. **Consider container placement** for network efficiency

## Next Steps

Now that you understand Docker networking:
1. Learn Docker Compose for multi-container networking
2. Explore container orchestration with Docker Swarm or Kubernetes
3. Implement service discovery and load balancing
4. Set up monitoring and logging for containerized applications
5. Deploy multi-tier applications with proper network architecture