FROM phpmyadmin/phpmyadmin

# Copy custom configuration
COPY config.user.inc.php /etc/phpmyadmin/config.user.inc.php

# Expose port 80
EXPOSE 80

# Start phpMyAdmin
CMD ["/docker-entrypoint.sh", "apache2-foreground"]
