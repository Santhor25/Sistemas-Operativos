# Taller Vagrant + Provisionamiento con Shell
Repositorio del taller (fork de jmaquin0) realizado por Santiago Torralba.  
Se crean 2 maquinas virtuales (web y db) con **Vagrant + VirtualBox** y se provisionan con **Shell**.

## IPs
 **web**: 192.168.56.10 Apache2 + PHP 7.4 + `php-pgsql`
- **db** : 192.168.56.11 PostgreSQL 12 (BD user 'vagrant')

## Como Ejecutar
git clone https://github.com/Santhor25/Sistemas-Operativos.git
cd vagrant-web
vagrant up
