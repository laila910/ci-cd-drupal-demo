#!/bin/bash

echo "Migrating Drupal to src folder structure"
echo "=========================================="

# Check if old drupal directory exists
if [ -d "drupal" ]; then
    echo "Found existing Drupal installation in root directory"
    
    # Create src directory if it doesn't exist
    if [ ! -d "src" ]; then
        echo "Creating src directory..."
        mkdir -p src
    fi
    
    # Move Drupal to src directory
    echo "Moving Drupal to src/drupal..."
    mv drupal src/
    
    # Set proper permissions
    echo "Setting proper permissions..."
    if command -v sudo &> /dev/null; then
        sudo chown -R $USER:$USER src/drupal/
    fi
    chmod -R 755 src/drupal/
    
    echo "Migration completed successfully!"
    echo "Drupal is now located at: src/drupal/"
    
    # Update docker-compose if needed
    if grep -q "./drupal:/var/www/html" docker-compose.yml; then
        echo "Updating docker-compose.yml..."
        sed -i 's|./drupal:/var/www/html|./src/drupal:/var/www/html|g' docker-compose.yml
        echo "docker-compose.yml updated!"
    fi
    
else
    echo "No existing Drupal installation found in root directory"
    echo "Creating src directory structure..."
    mkdir -p src
    echo "Ready for new Drupal installation in src/drupal/"
fi

echo ""
echo "Next steps:"
echo "1. Run setup script: ./setup.sh"
echo "2. Or manually install Drupal in src/drupal/"
echo "3. Start services: docker-compose up -d --build"
