@echo off
echo ☸️  Starting Kubernetes Deployment...

REM ========================================
REM Helm Deployment
REM ========================================
echo 📦 Installing/Upgrading Helm Chart...
helm upgrade --install ecommerce-chart-deploy ./weather-chart

REM ========================================
REM Verification
REM ========================================
echo ⏳ Waiting for pods to be ready...
kubectl rollout status deployment/ecommerce-chart-deploy-backend
kubectl rollout status deployment/ecommerce-chart-deploy-frontend
kubectl rollout status deployment/ecommerce-chart-deploy-mysql

echo 🔍 Checking Services...
kubectl get svc

echo ✅ Kubernetes Deployment Completed!
echo 🌐 Access Frontend at: http://localhost:4837
