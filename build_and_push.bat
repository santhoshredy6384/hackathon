@echo off
echo 🐳 Starting Docker Build and Push Process...

REM ========================================
REM Build Stage
REM ========================================
echo 🔨 Building Backend Image...
docker build -f Dockerfile.backend -t santhosh6384/hackathon_backend_a:v1 .

echo 🔨 Building Frontend Image...
docker build -f Dockerfile.frontend -t santhosh6384/hackathon_frontend_a:v1 .

REM ========================================
REM Push Stage
REM ========================================
echo 🚀 Pushing Backend Image to Docker Hub...
docker push santhosh6384/hackathon_backend_a:v1

echo 🚀 Pushing Frontend Image to Docker Hub...
docker push santhosh6384/hackathon_frontend_a:v1

echo ✅ Docker Build and Push Completed Successfully!
