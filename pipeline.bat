@echo off
echo 🚀 Starting Weather App CI/CD Pipeline
if "%BUILD_NUMBER%"=="" set BUILD_NUMBER=1
echo Build Number: %BUILD_NUMBER%

REM Check if docker-compose.yml exists
if not exist "Backend\docker-compose.yml" (
    echo ❌ Error: Backend\docker-compose.yml not found!
    echo Current directory: %CD%
    dir
    exit /b 1
)

REM ========================================
REM Build Stage
REM ========================================
echo 🔨 Building Docker images...
docker-compose -f Backend\docker-compose.yml build

REM ========================================
REM Deploy Stage
REM ========================================
echo 🚀 Deploying to production...
REM Stop existing containers to ensure clean state
docker-compose -f Backend\docker-compose.yml down

REM Start services in detached mode
docker-compose -f Backend\docker-compose.yml up -d

echo ⏳ Waiting for services to initialize (45 seconds)...
ping 127.0.0.1 -n 46 > nul

REM ========================================
REM Verification
REM ========================================
echo 🔍 Verifying deployment...

echo 1. Checking Backend Health (Port 6384)...
curl -f http://localhost:6384/actuator/health
if %errorlevel% neq 0 (
    echo ❌ Backend health check failed
    echo 📜 Backend Logs:
    docker-compose -f Backend\docker-compose.yml logs backend
    exit /b 1
)
echo.
echo ✅ Backend is healthy

echo 2. Checking Frontend Accessibility (Port 4836)...
curl -f http://localhost:4836/health
if %errorlevel% neq 0 (
    echo ❌ Frontend health check failed
    echo 📜 Frontend Logs:
    docker-compose -f Backend\docker-compose.yml logs frontend
    exit /b 1
)
echo.
echo ✅ Frontend is accessible

REM ========================================
REM Cleanup (Optional - usually we keep prod running)
REM ========================================
REM echo 🧹 Cleaning up unused images...
REM docker image prune -f

echo ✅ CI/CD Pipeline completed successfully!
echo 🌐 Frontend: http://localhost:4836
echo 🔌 Backend:  http://localhost:6384
