# Drupal with Docker and Docker Compose

This project provides a complete Drupal development environment using Docker and Docker Compose. It includes Nginx web server, PHP-FPM, MySQL database, and phpMyAdmin for database management.

## Features

- **Drupal 10** ready with PHP 8.2
- **Nginx** web server with optimized configuration
- **PHP-FPM** with all necessary extensions for Drupal
- **MySQL 8.0** database with custom configuration
- **phpMyAdmin** for database management
- **Optimized performance** with OPcache and Gzip compression
- **Security headers** and best practices
- **Clean URLs** support
- **File upload** support up to 100MB
- **Modular architecture** with separate Dockerfiles for each service
- **Clean separation** between infrastructure and source code

## Prerequisites

- Docker (version 20.10 or higher)
- Docker Compose (version 2.0 or higher)
- Git

## Installation

### 1. Clone or Download the Project

```bash
git clone <your-repo-url>
cd ci-cd-drupal-demo
```

### 2. Create Drupal Installation

You have two options for installing Drupal:

#### Option A: Using Composer (Recommended)

```bash
# Create Drupal project using Composer
docker run --rm -v $(pwd):/app composer create-project drupal/recommended-project:^10 src/drupal

# Set proper permissions
sudo chown -R $USER:$USER src/drupal/
chmod -R 755 src/drupal/
```

#### Option B: Download Drupal Manually

```bash
# Download Drupal 10
wget https://www.drupal.org/download-latest/tar.gz -O drupal.tar.gz
tar -xzf drupal.tar.gz
mv drupal-* src/drupal
rm drupal.tar.gz

# Set proper permissions
sudo chown -R $USER:$USER src/drupal/
chmod -R 755 src/drupal/
```

### 3. Start the Services

```bash
# Build and start all services
docker-compose up -d --build

# Or start without building (if already built)
docker-compose up -d
```

### 4. Install Drupal

1. Open your browser and navigate to `http://localhost:8080`
2. Follow the Drupal installation wizard
3. Use these database settings:
   - **Database type**: MySQL, MariaDB, Percona Server, or equivalent
   - **Database name**: `drupal`
   - **Database username**: `drupal`
   - **Database password**: `drupal_password`
   - **Database host**: `db`
   - **Database port**: `3306`

## Access Points

- **Drupal Site**: http://localhost:8080
- **phpMyAdmin**: http://localhost:8081
- **MySQL Database**: localhost:3306

## Project Structure

```
.
├── docker-compose.yml          # Docker Compose configuration
├── app/                        # Application services
│   ├── php/                   # PHP-FPM service
│   │   ├── Dockerfile        # PHP-FPM Docker image
│   │   └── php.ini           # PHP configuration
│   ├── nginx/                 # Nginx service
│   │   ├── Dockerfile        # Nginx Docker image
│   │   ├── nginx.conf        # Main Nginx configuration
│   │   └── default.conf      # Drupal server configuration
│   ├── mysql/                 # MySQL service
│   │   ├── Dockerfile        # MySQL Docker image
│   │   ├── my.cnf            # MySQL configuration
│   │   └── init/             # Database initialization scripts
│   │       └── 01-drupal-database.sql
│   └── phpmyadmin/           # phpMyAdmin service
│       ├── Dockerfile        # phpMyAdmin Docker image
│       └── config.user.inc.php # phpMyAdmin configuration
├── src/                       # Source code
│   └── drupal/               # Drupal installation (created during setup)
├── setup.sh                   # Linux/macOS setup script
├── setup.ps1                  # Windows PowerShell setup script
├── .dockerignore              # Docker build exclusions
├── .gitignore                 # Git exclusions
└── README.md                  # This file
```

## Configuration

### Service-Specific Configurations

Each service has its own configuration files in the `app/` directory:

- **PHP-FPM**: Custom PHP extensions, Composer, and optimized settings
- **Nginx**: Drupal-optimized configuration with security headers
- **MySQL**: Performance-optimized configuration with UTF8MB4 support
- **phpMyAdmin**: Secure configuration with custom settings

### Source Code Organization

The `src/` directory contains all your application source code:

- **`src/drupal/`**: Drupal core and custom modules/themes
- **`src/`**: Future applications or services can be added here
- Clean separation between infrastructure (Docker) and application code

### Environment Variables

You can customize the following environment variables in `docker-compose.yml`:

- `MYSQL_ROOT_PASSWORD`: MySQL root password
- `MYSQL_DATABASE`: Database name
- `MYSQL_USER`: Database user
- `MYSQL_PASSWORD`: Database password
- `PMA_USER`: phpMyAdmin user
- `PMA_PASSWORD`: phpMyAdmin password

### Ports

- **8080**: Drupal website
- **8081**: phpMyAdmin
- **3306**: MySQL database

##  Common Commands

```bash
# Start services
docker-compose up -d

# Stop services
docker-compose down

# View logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f nginx
docker-compose logs -f php
docker-compose logs -f db

# Rebuild and start
docker-compose up -d --build

# Rebuild specific service
docker-compose up -d --build nginx

# Stop and remove volumes (WARNING: This will delete your database)
docker-compose down -v

# Access PHP container
docker-compose exec php bash

# Access MySQL container
docker-compose exec db mysql -u drupal -p drupal

# Run Composer commands
docker-compose exec php composer install
docker-compose exec php composer update
```

##  Development Workflow

### Adding Modules/Themes

```bash
# Install a module
docker-compose exec php composer require drupal/admin_toolbar

# Install a theme
docker-compose exec php composer require drupal/olivero

# Clear cache after installation
docker-compose exec php drush cr
```

### Database Operations

```bash
# Export database
docker-compose exec db mysqldump -u drupal -p drupal > backup.sql

# Import database
docker-compose exec -T db mysql -u drupal -p drupal < backup.sql
```

### Modifying Service Configurations

Each service can be customized by modifying files in the `app/` directory:

- **PHP**: Edit `app/php/php.ini` for PHP settings
- **Nginx**: Edit `app/nginx/default.conf` for server configuration
- **MySQL**: Edit `app/mysql/my.cnf` for database settings
- **phpMyAdmin**: Edit `app/phpmyadmin/config.user.inc.php` for interface settings

### Working with Source Code

The Drupal installation is now located in `src/drupal/`:

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

##  Security Features

- **Security headers** configured in Nginx
- **PHP security settings** optimized
- **File access restrictions** for sensitive files
- **Clean URLs** enforcement
- **OPcache** for performance and security
- **Custom MySQL configuration** with security best practices

##  Performance Optimizations

- **OPcache** enabled with optimized settings
- **Gzip compression** for static files
- **Static file caching** with proper headers
- **Nginx worker processes** optimized
- **PHP-FPM** with optimized pool settings
- **MySQL query cache** and InnoDB optimizations

## Troubleshooting

### Common Issues

1. **Permission Denied Errors**
   ```bash
   sudo chown -R $USER:$USER src/drupal/
   chmod -R 755 src/drupal/
   ```

2. **Database Connection Issues**
   - Ensure MySQL service is running: `docker-compose ps`
   - Check database credentials in Drupal settings
   - Verify database host is set to `db`

3. **Port Already in Use**
   - Change ports in `docker-compose.yml`
   - Stop conflicting services

4. **PHP Extensions Missing**
   - Rebuild the PHP container: `docker-compose up -d --build php`

5. **Service Build Issues**
   - Check Dockerfile syntax in `app/` directory
   - Verify file paths in Dockerfiles

6. **Source Code Path Issues**
   - Ensure Drupal is installed in `src/drupal/`
   - Check volume mappings in `docker-compose.yml`

### Logs

Check logs for specific issues:
```bash
# Nginx logs
docker-compose logs nginx

# PHP logs
docker-compose logs php

# MySQL logs
docker-compose logs db
```

## Updates

### Updating Drupal

```bash
# Update Drupal core
docker-compose exec php composer update drupal/core --with-dependencies

# Update all packages
docker-compose exec php composer update

# Clear cache after updates
docker-compose exec php drush cr
```

### Updating Docker Images

```bash
# Pull latest images
docker-compose pull

# Rebuild and restart
docker-compose up -d --build
```

### Updating Service Configurations

To update service configurations:

1. Modify the configuration files in the `app/` directory
2. Rebuild the specific service:
   ```bash
   docker-compose up -d --build [service_name]
   ```

##  Additional Resources

- [Drupal Documentation](https://www.drupal.org/docs)
- [Docker Documentation](https://docs.docker.com/)
- [Nginx Documentation](https://nginx.org/en/docs/)
- [PHP Documentation](https://www.php.net/docs.php)
- [MySQL Documentation](https://dev.mysql.com/doc/)

##  Contributing

Feel free to submit issues and enhancement requests!

##  License

This project is open source and available under the [MIT License](LICENSE).
