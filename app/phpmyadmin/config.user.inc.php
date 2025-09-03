<?php
/**
 * Custom phpMyAdmin configuration
 */

// Security settings
$cfg['LoginCookieValidity'] = 3600;
$cfg['LoginCookieStore'] = 0;
$cfg['LoginCookieDeleteAll'] = true;

// Interface settings
$cfg['DefaultLang'] = 'en';
$cfg['ServerDefault'] = 1;
$cfg['UploadDir'] = '';
$cfg['SaveDir'] = '';

// Theme settings
$cfg['ThemeDefault'] = 'pmahomme';

// Export settings
$cfg['Export']['format'] = 'sql';
$cfg['Export']['compression'] = 'gzip';

// Import settings
$cfg['Import']['compression'] = 'gzip';

// Security headers
$cfg['SendErrorReports'] = 'never';
$cfg['ShowPhpInfo'] = false;
$cfg['ShowChgPassword'] = false;
$cfg['ShowCreateDb'] = false;
$cfg['ShowServerInfo'] = false;
