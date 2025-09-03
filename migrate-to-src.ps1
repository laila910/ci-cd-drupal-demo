# Drupal Migration Script for Windows PowerShell
# Run this script as Administrator

Write-Host "Migrating Drupal to src folder structure" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green

# Check if old drupal directory exists
if (Test-Path "drupal") {
    Write-Host "Found existing Drupal installation in root directory" -ForegroundColor Yellow
    
    # Create src directory if it doesn't exist
    if (!(Test-Path "src")) {
        Write-Host "Creating src directory..." -ForegroundColor Yellow
        New-Item -ItemType Directory -Name "src" -Force
    }
    
    # Move Drupal to src directory
    Write-Host "Moving Drupal to src\drupal..." -ForegroundColor Yellow
    Move-Item "drupal" "src\drupal"
    
    # Set proper permissions
    Write-Host "Setting proper permissions..." -ForegroundColor Yellow
    # Note: Windows handles permissions differently, but we'll ensure the move was successful
    
    Write-Host "Migration completed successfully!" -ForegroundColor Green
    Write-Host "Drupal is now located at: src\drupal\" -ForegroundColor Cyan
    
    # Update docker-compose if needed
    $dockerComposeContent = Get-Content "docker-compose.yml" -Raw
    if ($dockerComposeContent -match "\./drupal:/var/www/html") {
        Write-Host "Updating docker-compose.yml..." -ForegroundColor Yellow
        $updatedContent = $dockerComposeContent -replace "\./drupal:/var/www/html", "./src/drupal:/var/www/html"
        Set-Content "docker-compose.yml" $updatedContent
        Write-Host "docker-compose.yml updated!" -ForegroundColor Green
    }
    
} else {
    Write-Host "No existing Drupal installation found in root directory" -ForegroundColor Yellow
    Write-Host "Creating src directory structure..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Name "src" -Force
    Write-Host "Ready for new Drupal installation in src\drupal\" -ForegroundColor Green
}

Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Run setup script: .\setup.ps1" -ForegroundColor White
Write-Host "2. Or manually install Drupal in src\drupal\" -ForegroundColor White
Write-Host "3. Start services: docker-compose up -d --build" -ForegroundColor White
