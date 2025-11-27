Tunneling service to connect local to internet:

brew install ngrok


# 🚀 Jenkins Docker Container

Custom Jenkins container with Docker, Git, and curl pre-installed for CI/CD pipelines.

## 📦 What's Included

- **Jenkins LTS** - Latest stable version
- **Docker CLI** - For building and running containers
- **Git** - Version control integration
- **curl** - HTTP requests and API calls
- **Jenkins Plugins**: Git, Docker Workflow, Pipeline, BlueOcean

## 🚀 Quick Start

### Method 1: Using Setup Script
```bash
cd jenkins-docker
./jenkins-setup.sh
```

### Method 2: Manual Setup
```bash
# Build and start
docker-compose up -d

# Get admin password
docker-compose exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

## 🔧 Access Jenkins

- **URL**: http://localhost:8080
- **Admin Password**: Run setup script or check container logs
- **Agent Port**: 50000

## 📁 Volume Mounts

- `jenkins_home` - Jenkins configuration and data
- `/var/run/docker.sock` - Docker socket for Docker-in-Docker
- `./jenkins_data` - Workspace directory

## 🛠️ Installed Tools

```bash
# Check installed versions
docker-compose exec jenkins git --version
docker-compose exec jenkins docker --version  
docker-compose exec jenkins curl --version
```

## 🔄 Common Commands

```bash
# Start Jenkins
docker-compose up -d

# Stop Jenkins
docker-compose down

# View logs
docker-compose logs -f jenkins

# Access Jenkins shell
docker-compose exec jenkins bash

# Restart Jenkins
docker-compose restart jenkins

# Build Docker images from Jenkins
docker-compose exec jenkins docker build -t myapp .

# Run Git commands
docker-compose exec jenkins git clone <repo-url>
```

## 🔧 Jenkins Pipeline Example

```groovy
pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/your-repo.git'
            }
        }
        
        stage('Build') {
            steps {
                sh 'docker build -t myapp .'
            }
        }
        
        stage('Test') {
            steps {
                sh 'curl -f http://localhost:3000/health'
            }
        }
        
        stage('Deploy') {
            steps {
                sh 'docker run -d -p 3000:3000 myapp'
            }
        }
    }
}
```

## 🔒 Security Notes

- Jenkins runs with Docker socket access
- Change default admin password after setup
- Configure proper authentication
- Use secrets for sensitive data

## 🐛 Troubleshooting

### Docker Permission Issues
```bash
# Fix docker socket permissions
sudo chmod 666 /var/run/docker.sock
```

### Jenkins Won't Start
```bash
# Check logs
docker-compose logs jenkins

# Restart with fresh data
docker-compose down -v
docker-compose up -d
```

### Plugin Installation Issues
```bash
# Access Jenkins container
docker-compose exec jenkins bash

# Install plugins manually
jenkins-plugin-cli --plugins git docker-workflow
```