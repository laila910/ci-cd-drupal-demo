# Drupal Docker Setup Script for Windows PowerShell
# Run this script as Administrator

Write-Host "Setting up Drupal with Docker and Docker Compose" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Green

# Check if Docker is running
try {
    docker info | Out-Null
    Write-Host "Docker is running" -ForegroundColor Green
} catch {
    Write-Host "Docker is not running. Please start Docker Desktop and try again." -ForegroundColor Red
    exit 1
}

# Check if Docker Compose is available
try {
    docker-compose --version | Out-Null
    Write-Host "Docker Compose is available" -ForegroundColor Green
} catch {
    Write-Host "Docker Compose is not available. Please ensure Docker Desktop is properly installed." -ForegroundColor Red
    exit 1
}

# Create necessary directories
Write-Host "Creating necessary directories..." -ForegroundColor Yellow
if (!(Test-Path "app\nginx")) { New-Item -ItemType Directory -Name "app\nginx" -Force }
if (!(Test-Path "app\php")) { New-Item -ItemType Directory -Name "app\php" -Force }
if (!(Test-Path "app\mysql\init")) { New-Item -ItemType Directory -Name "app\mysql\init" -Force }
if (!(Test-Path "app\phpmyadmin")) { New-Item -ItemType Directory -Name "app\phpmyadmin" -Force }
if (!(Test-Path "src")) { New-Item -ItemType Directory -Name "src" -Force }

# Check if Drupal directory exists
if (!(Test-Path "src\drupal")) {
    Write-Host "Drupal directory not found. Installing Drupal..." -ForegroundColor Yellow
    
    # Try to use Composer first
    try {
        composer --version | Out-Null
        Write-Host "Using Composer to install Drupal..." -ForegroundColor Yellow
        composer create-project drupal/recommended-project:^10 src\drupal --no-interaction
    } catch {
        Write-Host "Composer not found. Downloading Drupal manually..." -ForegroundColor Yellow
        
        # Download Drupal using PowerShell
        $drupalUrl = "https://www.drupal.org/download-latest/tar.gz"
        $drupalFile = "drupal.tar.gz"
        
        Write-Host "Downloading Drupal..." -ForegroundColor Yellow
        Invoke-WebRequest -Uri $drupalUrl -OutFile $drupalFile
        
        # Extract using 7-Zip if available, otherwise use built-in tar
        try {
            & "7z" x $drupalFile -o"." -y | Out-Null
        } catch {
            # Use built-in tar (Windows 10 1803+)
            tar -xzf $drupalFile
        }
        
        # Find and rename the extracted directory
        $extractedDir = Get-ChildItem -Directory | Where-Object { $_.Name -like "drupal-*" } | Select-Object -First 1
        if ($extractedDir) {
            Rename-Item $extractedDir.Name "drupal"
            Move-Item "drupal" "src\drupal"
        }
        
        # Clean up
        Remove-Item $drupalFile -ErrorAction SilentlyContinue
    }
    
    Write-Host "Drupal installed successfully" -ForegroundColor Green
} else {
    Write-Host "Drupal directory already exists" -ForegroundColor Green
}

# Build and start services
Write-Host "Building and starting Docker services..." -ForegroundColor Yellow
docker-compose up -d --build

# Wait for services to be ready
Write-Host "Waiting for services to be ready..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

# Check service status
Write-Host "Checking service status..." -ForegroundColor Yellow
docker-compose ps

Write-Host ""
Write-Host "Setup complete!" -ForegroundColor Green
Write-Host "==================" -ForegroundColor Green
Write-Host "Drupal Site: http://localhost:8080" -ForegroundColor Cyan
Write-Host "phpMyAdmin: http://localhost:8081" -ForegroundColor Cyan
Write-Host "MySQL: localhost:3306" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Open http://localhost:8080 in your browser" -ForegroundColor White
Write-Host "2. Follow the Drupal installation wizard" -ForegroundColor White
Write-Host "3. Use these database settings:" -ForegroundColor White
Write-Host "   - Database type: MySQL" -ForegroundColor White
Write-Host "   - Database name: drupal" -ForegroundColor White
Write-Host "   - Username: drupal" -ForegroundColor White
Write-Host "   - Password: drupal_password" -ForegroundColor White
Write-Host "   - Host: db" -ForegroundColor White
Write-Host "   - Port: 3306" -ForegroundColor White
Write-Host ""
Write-Host "Useful commands:" -ForegroundColor Yellow
Write-Host "   docker-compose logs -f    # View logs" -ForegroundColor White
Write-Host "   docker-compose down       # Stop services" -ForegroundColor White
Write-Host "   docker-compose up -d      # Start services" -ForegroundColor White
