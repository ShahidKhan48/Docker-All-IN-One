# Docker All-IN-One 🐳

A comprehensive Docker learning repository with hands-on examples, projects, and best practices. This repository is structured to take you from Docker basics to advanced containerization concepts.

## 📚 Repository Structure

### 01. [Docker Fundamentals](./01-docker-fundamentals/)
- What is Docker and why use it?
- Virtualization concepts and history
- Docker benefits and use cases
- Container vs Virtual Machine comparison

### 02. [Architecture & Installation](./02-architecture-installation/)
- Docker architecture deep dive
- Component explanation (Client, Daemon, Registry)
- Installation guides for Windows, macOS, and Linux
- Post-installation configuration

### 03. [Docker Images](./03-docker-images/)
- Working with pre-built images from Docker Hub
- Building custom images with Dockerfiles
- Image management and optimization
- Registry operations and best practices

### 04. [Docker Containers](./04-docker-containers/)
- Complete container lifecycle management
- All container-related commands
- Interactive operations and debugging
- Resource management and security

### 05. [Docker Storage](./05-docker-storage/)
- Volumes, bind mounts, and tmpfs mounts
- Data persistence strategies
- Storage drivers and optimization
- Backup and restore procedures

### 06. [Docker Networking](./06-docker-networking/)
- Network drivers and types
- Container communication patterns
- Port mapping and exposure
- Network security and troubleshooting

### 07. [Docker Compose](./07-docker-compose/)
- Multi-container application orchestration
- YAML configuration and best practices
- Development and production workflows
- Service scaling and management

### 08. [Projects](./08-projects/)
- Hands-on examples and real-world projects
- Beginner to advanced implementations
- Production-ready application templates
- Market-ready project architectures

## 🚀 Quick Start

### Prerequisites
- Basic command line knowledge
- Understanding of software development concepts
- Computer with admin/sudo access

### Installation
1. **Choose your platform:**
   - [Windows](./02-architecture-installation/README.md#windows-installation)
   - [macOS](./02-architecture-installation/README.md#macos-installation)
   - [Linux](./02-architecture-installation/README.md#linux-installation)

2. **Verify installation:**
   ```bash
   docker --version
   docker run hello-world
   ```

3. **Start learning:**
   Begin with [Docker Fundamentals](./01-docker-fundamentals/) and progress through each section.

## 📖 Learning Path

### Beginner (Weeks 1-2)
- [ ] Complete Docker Fundamentals
- [ ] Install Docker on your system
- [ ] Learn Docker Images basics
- [ ] Practice basic container operations
- [ ] Try simple projects from examples/

### Intermediate (Weeks 3-4)
- [ ] Master container management
- [ ] Understand Docker storage
- [ ] Learn Docker networking
- [ ] Build custom images
- [ ] Work with multi-container applications

### Advanced (Weeks 5-6)
- [ ] Master Docker Compose
- [ ] Deploy production applications
- [ ] Implement monitoring and logging
- [ ] Practice with market-ready projects
- [ ] Learn orchestration basics

## 🛠️ Hands-On Projects

### Beginner Projects
- **Hello World App**: Simple containerized application
- **Static Website**: HTML/CSS/JS with Nginx
- **Python Flask App**: Web application with database

### Intermediate Projects
- **LAMP Stack**: Linux, Apache, MySQL, PHP
- **MEAN Stack**: MongoDB, Express, Angular, Node.js
- **WordPress**: Content management system

### Advanced Projects
- **Microservices**: Multi-service architecture
- **E-commerce Platform**: Full-stack application
- **Monitoring Stack**: Prometheus, Grafana, ELK

## 📋 Command Reference

### Essential Docker Commands
```bash
# Images
docker images                    # List images
docker pull nginx               # Pull image
docker build -t myapp .         # Build image
docker rmi image_name           # Remove image

# Containers
docker ps                       # List running containers
docker run -d -p 8080:80 nginx  # Run container
docker stop container_name      # Stop container
docker rm container_name        # Remove container

# Docker Compose
docker-compose up -d            # Start services
docker-compose down             # Stop services
docker-compose logs -f          # View logs
docker-compose build            # Build services
```

### Useful Aliases
```bash
# Add to your ~/.bashrc or ~/.zshrc
alias dps='docker ps'
alias dpa='docker ps -a'
alias di='docker images'
alias dcu='docker-compose up -d'
alias dcd='docker-compose down'
alias dcl='docker-compose logs -f'
```

## 🔧 Development Setup

### Recommended Tools
- **Docker Desktop**: GUI for Docker management
- **VS Code**: With Docker extension
- **Portainer**: Web-based Docker management
- **Dive**: Analyze Docker images
- **ctop**: Container monitoring

### Environment Configuration
```bash
# Create development directory
mkdir docker-projects
cd docker-projects

# Clone this repository
git clone <repository-url>
cd Docker-All-IN-One

# Start with fundamentals
cd 01-docker-fundamentals
```

## 📊 Progress Tracking

Track your learning progress:

- [ ] **Week 1**: Docker basics and installation
- [ ] **Week 2**: Images and containers
- [ ] **Week 3**: Storage and networking
- [ ] **Week 4**: Docker Compose
- [ ] **Week 5**: Advanced projects
- [ ] **Week 6**: Production deployment

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Add your improvements
4. Submit a pull request

### Contribution Guidelines
- Follow existing structure and naming conventions
- Include comprehensive documentation
- Add practical examples
- Test all code and configurations

## 📚 Additional Resources

### Official Documentation
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Docker Hub](https://hub.docker.com/)

### Learning Resources
- [Docker Official Tutorial](https://www.docker.com/101-tutorial)
- [Play with Docker](https://labs.play-with-docker.com/)
- [Docker Curriculum](https://docker-curriculum.com/)

### Community
- [Docker Community Forums](https://forums.docker.com/)
- [Docker Slack](https://dockercommunity.slack.com/)
- [Stack Overflow - Docker](https://stackoverflow.com/questions/tagged/docker)

## 🐛 Troubleshooting

### Common Issues
- **Permission denied**: Add user to docker group (Linux)
- **Port already in use**: Check running processes
- **Out of disk space**: Clean up unused containers/images
- **Build failures**: Check Dockerfile syntax and context

### Getting Help
1. Check the troubleshooting section in each module
2. Review Docker logs: `docker logs container_name`
3. Inspect containers: `docker inspect container_name`
4. Search community forums and Stack Overflow

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Docker community for excellent documentation
- Contributors who helped improve this repository
- Open source projects used in examples

---

**Happy Dockerizing! 🐳**

Start your journey with [Docker Fundamentals](./01-docker-fundamentals/) and build your way up to production-ready containerized applications.