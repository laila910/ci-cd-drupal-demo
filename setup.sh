#!/bin/bash

echo "Setting up Drupal with Docker and Docker Compose"
echo "=================================================="

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Docker is not running. Please start Docker and try again."
    exit 1
fi

# Check if Docker Compose is available
if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose is not installed. Please install Docker Compose and try again."
    exit 1
fi

echo "Docker and Docker Compose are available"

# Create necessary directories
echo "Creating necessary directories..."
mkdir -p app/nginx
mkdir -p app/php
mkdir -p app/mysql/init
mkdir -p app/phpmyadmin
mkdir -p src

# Check if Drupal directory exists
if [ ! -d "src/drupal" ]; then
    echo "Drupal directory not found. Installing Drupal..."
    
    # Try to use Composer first
    if command -v composer &> /dev/null; then
        echo " Using Composer to install Drupal..."
        composer create-project drupal/recommended-project:^10 src/drupal --no-interaction
    else
        echo "Composer not found. Downloading Drupal manually..."
        wget https://www.drupal.org/download-latest/tar.gz -O drupal.tar.gz
        tar -xzf drupal.tar.gz
        mv drupal-* src/drupal
        rm drupal.tar.gz
    fi
    
    # Set permissions
    echo "Setting proper permissions..."
    if command -v sudo &> /dev/null; then
        sudo chown -R $USER:$USER src/drupal/
    fi
    chmod -R 755 src/drupal/
    echo "Drupal installed successfully"
else
    echo "Drupal directory already exists"
fi

# Build and start services
echo "Building and starting Docker services..."
docker-compose up -d --build

# Wait for services to be ready
echo "Waiting for services to be ready..."
sleep 10

# Check service status
echo "Checking service status..."
docker-compose ps

echo ""
echo "Setup complete!"
echo "=================="
echo "Drupal Site: http://localhost:8080"
echo "phpMyAdmin: http://localhost:8081"
echo "MySQL: localhost:3306"
echo ""
echo "Next steps:"
echo "1. Open http://localhost:8080 in your browser"
echo "2. Follow the Drupal installation wizard"
echo "3. Use these database settings:"
echo "   - Database type: MySQL"
echo "   - Database name: drupal"
echo "   - Username: drupal"
echo "   - Password: drupal_password"
echo "   - Host: db"
echo "   - Port: 3306"
echo ""
echo "
Useful commands:"
echo "   docker-compose logs -f    # View logs"
echo "   docker-compose down       # Stop services"
echo "   docker-compose up -d      # Start services"
