#!/bin/bash

echo "🚀 Docker Projects Push Script"
echo "==============================="

# Check if git is initialized
if [ ! -d ".git" ]; then
    echo "Initializing git repository..."
    git init
    git branch -m main
fi

# Add remote if not exists
if ! git remote get-url origin > /dev/null 2>&1; then
    echo "Adding GitHub remote..."
    git remote add origin https://github.com/ShahidKhan48/zoya.git
fi

# Stage all files
echo "Staging all files..."
git add .

# Commit changes
echo "Committing changes..."
git commit -m "Add comprehensive Docker projects collection

- Basic Docker apps: Python Flask, React/Node.js, Java, Static HTML/CSS/JS
- Market-ready projects: MERN E-commerce, Spring Boot Microservices, Django+Redis, Golang API  
- Multi-tier Docker Compose examples (2-tier, 3-tier, 4-tier)
- Full-stack project with all technologies integrated
- Comprehensive documentation with Docker commands, networking, volumes
- Production-ready configurations with proper port mappings and networking"

echo ""
echo "✅ Repository prepared for push!"
echo ""
echo "📋 Manual Steps Required:"
echo "1. Run: git push -u origin main"
echo "2. Enter your GitHub username when prompted"
echo "3. Enter your GitHub personal access token as password"
echo ""
echo "🔑 To create Personal Access Token:"
echo "1. Go to GitHub.com → Settings → Developer settings → Personal access tokens"
echo "2. Generate new token with 'repo' permissions"
echo "3. Copy and use as password when pushing"
echo ""
echo "📁 Repository URL: https://github.com/ShahidKhan48/zoya.git"