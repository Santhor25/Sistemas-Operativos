#!/usr/bin/env bash

# Actualizar lista de paquetes
sudo apt-get update -y

# Instalar PostgreSQL y utilidades
sudo apt-get install -y postgresql postgresql-contrib

# Habilitar e iniciar el servicio
sudo systemctl enable postgresql
sudo systemctl start postgresql

# Variables de configuración
DB_USER="vagrant"
DB_PASS="vagrant"
DB_NAME="exampledb"

# Crear usuario, base de datos y tabla con datos de ejemplo
sudo -u postgres psql <<EOF
-- Crear usuario y base de datos
DO
\$do\$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = '$DB_USER') THEN
      CREATE ROLE $DB_USER LOGIN PASSWORD '$DB_PASS';
   END IF;
END
\$do\$;

CREATE DATABASE $DB_NAME OWNER $DB_USER;

-- Conectarse a la nueva base
\c $DB_NAME;

-- Crear tabla y datos
CREATE TABLE IF NOT EXISTS empleados (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(50),
  cargo VARCHAR(50)
);

TRUNCATE TABLE empleados;

INSERT INTO empleados (nombre, cargo) VALUES
('Santiago', 'Desarrollador'),
('Camila', 'Analista'),
('Mateo', 'Administrador')
ON CONFLICT DO NOTHING;

GRANT ALL PRIVILEGES ON TABLE empleados TO vagrant;
ALTER TABLE empleados OWNER TO vagrant;

EOF

# 🔧 Configurar PostgreSQL para aceptar conexiones remotas
PG_CONF="/etc/postgresql/12/main/postgresql.conf"
HBA_CONF="/etc/postgresql/12/main/pg_hba.conf"

# (Detectar versión si no es 12)
if [ ! -f "$PG_CONF" ]; then
  VERSION=$(ls /etc/postgresql)
  PG_CONF="/etc/postgresql/$VERSION/main/postgresql.conf"
  HBA_CONF="/etc/postgresql/$VERSION/main/pg_hba.conf"
fi

# Permitir escucha externa
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" "$PG_CONF"

# Permitir conexiones desde la red privada de Vagrant
if ! grep -q "192.168.56.0/24" "$HBA_CONF"; then
  echo "host    all             all             192.168.56.0/24          md5" | sudo tee -a "$HBA_CONF"
fi

# Reiniciar PostgreSQL para aplicar cambios
sudo systemctl restart postgresql

echo "PostgreSQL instalado y configurado correctamente"
echo "   Usuario: $DB_USER"
echo "   Base de datos: $DB_NAME"
echo "   Permitiendo acceso desde la red 192.168.56.0/24"
