#!/usr/bin/env bash
set -euo pipefail # makes pipeline fail on any error

LAMBDA_VERSION="$1"
ECR_REPO="$2"
REGISTRY="$3"
LAMBDA_PATH="$4"

echo "Using tag: $LAMBDA_VERSION"
echo "Using repo: $ECR_REPO"
echo "Registry: $REGISTRY"

# Check if image exists
if aws ecr describe-images --repository-name "$ECR_REPO" --image-ids imageTag="$LAMBDA_VERSION"; then
  echo "Image already exists. Skipping build and push."
else
  echo "Building image..."
  docker build -t "$ECR_REPO:$LAMBDA_VERSION" "$LAMBDA_PATH"
  docker tag "$ECR_REPO:$LAMBDA_VERSION" "$REGISTRY/$ECR_REPO:$LAMBDA_VERSION"
  echo "Pushing image to ECR..."
  docker push "$REGISTRY/$ECR_REPO:$LAMBDA_VERSION"
fi

# Export the image URI for GitHub Actions
echo "$IMAGE_URI=$REGISTRY/$ECR_REPO:$LAMBDA_VERSION" >> "$GITHUB_ENV"
