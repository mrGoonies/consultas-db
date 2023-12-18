# Consultas a bases de datos relaciones (Oracle)

En este repositorio encontrarás la solución al proyecto final del ramo con el mismo nombre al del título, en este caso haremos uso de el motor de bases de datos Oracle, específicamente a la versión express:latest.

Dentro del repositorio encontrarás la información necesaria para levantar el servidor de Oracle, info de las tablas y la problemática a resolver usando SQL.


# Setup

En este caso, este servidor está corriendo en local desde mi macbook, por ende considera lo siguiente:

1. Tener instalado SQL Developer (cliente oficial de oracle).

2. Docker instalado.

## Instrucciones de instalación

1. Levantar docker

2. Correr el siguiente comando:
```bash
docker run --name <nombre-contenedor> -p 1521:1521 -d --shm-size='8g' -e ORACLE_PWD=<contraseña> container-registry.oracle.com/database/express:latest
```

3. Establecer conexión
![login](./login-oracle.png)
