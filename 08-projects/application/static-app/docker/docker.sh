#!/bin/bash

# --- Configuration ---
DOCKERHUB_USER="shahidkhan777"   # replace with your Docker Hub username
IMAGE_NAME="zoya-app"                         # image name
IMAGE_TAG="v1.0"                           # image tag
FULL_IMAGE="${DOCKERHUB_USER}/${IMAGE_NAME}:${IMAGE_TAG}"

# --- Login to Docker Hub ---
echo "🔐 Logging in to Docker Hub..."
docker login -u "${DOCKERHUB_USER}"

# --- Build Docker Image ---
echo "🐳 Building image: ${FULL_IMAGE}"
docker build -t "${FULL_IMAGE}" .

# --- Push Image to Docker Hub ---
echo "📤 Pushing image to Docker Hub..."
docker push "${FULL_IMAGE}"

# --- Run Containers ---
echo "▶️ Running containers..."
docker run -dit --name myapp_container "${FULL_IMAGE}"

# --- Done ---
echo "✅ Successfully pushed ${FULL_IMAGE} to Docker Hub"
