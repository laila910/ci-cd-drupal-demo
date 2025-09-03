
## **How to Use:**

### **For New Installations:**
```bash

chmod +x setup.sh

# Run the setup script
./setup.sh  # Linux/macOS
# or
.\setup.ps1  # Windows PowerShell
```

### **For Existing Installations:**
```bash

chmod +x migrate-to-src.sh

# Run the migration script first
./migrate-to-src.sh  # Linux/macOS
# or
.\migrate-to-src.ps1  # Windows PowerShell

# Then start services
docker-compose up -d --build
```

### **Manual Installation:**
```bash
# Create src directory
mkdir -p src

# Install Drupal using Composer
docker run --rm -v $(pwd):/app composer create-project drupal/recommended-project:^10 src/drupal

# Set permissions
sudo chown -R $USER:$USER src/drupal/
chmod -R 755 src/drupal/

# Start services
docker-compose up -d --build
```

## **Working with Drupal:**

```bash
# Navigate to Drupal directory
cd src/drupal

# Run Composer commands locally
composer install
composer require drupal/admin_toolbar

# Run Drush commands
./vendor/bin/drush cr
./vendor/bin/drush status
```