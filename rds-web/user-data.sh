#!/bin/bash
# Paso 3 del tutorial "Install a web server on your EC2 instance", automatizado.
set -e
dnf update -y
dnf install -y httpd php php-mysqli mariadb105
systemctl start httpd
systemctl enable httpd

# dbinfo.inc fuera de la carpeta pública (como recomienda el tutorial)
mkdir -p /var/www/inc
cat > /var/www/inc/dbinfo.inc <<'PHP'
<?php

define('DB_SERVER', '${db_endpoint}');
define('DB_USERNAME', '${db_usuario}');
define('DB_PASSWORD', '${db_clave}');
define('DB_DATABASE', '${db_nombre}');
?>
PHP

# Página de ejemplo del tutorial
echo '${pagina_b64}' | base64 -d > /var/www/html/SamplePage.php
chown -R apache:apache /var/www
systemctl restart httpd