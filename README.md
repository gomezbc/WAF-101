# WAF-101
## ¿Qué es un WAF?  
Un **Web Application Firewall (WAF)** es una herramienta de seguridad diseñada para proteger aplicaciones web al filtrar y monitorear el tráfico HTTP. Los WAFs actúan como una barrera entre los usuarios y las aplicaciones, protegiendo contra ataques como inyecciones SQL, Cross-Site Scripting (XSS) y otros exploits.  

## Objetivo del laboratorio

El objetivo de este laboratorio es proteger Juice Shop, una aplicación web desarrollada por OWASP que contiene numerosas vulnerabilidades comunes intencionales, como inyecciones, XSS y problemas de autenticación.

Durante el laboratorio, habrá varios servidores simulando ataques automatizados hacia Juice Shop. Nuestro desafío será observar cómo BunkerWeb, actuando como un WAF, detecta y bloquea estos ataques, protegiendo la aplicación. Esto permitirá explorar las capacidades de un WAF en un entorno controlado y entender cómo mitiga riesgos en aplicaciones web vulnerables.

## ¿Por qué hemos elegido BunkerWeb?  
Hemos optado por **BunkerWeb** porque es un WAF ligero y fácil de configurar, ideal para laboratorios. Sus principales ventajas incluyen:  
- Configuración simplificada a través de Docker.  
- Generación automática de certificados SSL auto-firmados.  
- Soporte para múltiples sitios y proxies inversos.  

Aunque los **Cloud Service Providers (CSP)** como AWS, Azure o GCP ofrecen soluciones WAF, para este laboratorio consideramos más práctico implementar BunkerWeb en local utilizando Docker. Esto permite mayor control y evita depender de servicios externos.

## Configurar el archivo `/etc/hosts`  
Para acceder a los dominios configurados en el laboratorio (`www.juiceshop.com` y `bunkerweb.juiceshop.com`), es necesario añadirlos al archivo `hosts` de tu sistema. Sigue las instrucciones según tu sistema operativo:

### **Windows**  
1. Abre un editor de texto como administrador (por ejemplo, Notepad).  
2. Ve a `C:\Windows\System32\drivers\etc\hosts`.  
3. Añade las siguientes líneas al final del archivo:  
   ```
   127.0.0.1 www.juiceshop.com
   127.0.0.1 bunkerweb.juiceshop.com
   ```
4. Guarda el archivo.

### **Linux/Mac**  
1. Abre una terminal.  
2. Edita el archivo `/etc/hosts` con un editor de texto (requiere permisos de administrador). Por ejemplo:  
   ```bash
   sudo nano /etc/hosts
   ```
3. Añade las siguientes líneas al final del archivo:  
   ```
   127.0.0.1 www.juiceshop.com
   127.0.0.1 bunkerweb.juiceshop.com
   ```
4. Guarda y cierra el archivo.

## Lanzar el Docker Compose  
1. Guarda el archivo `docker-compose.yml` proporcionado en tu sistema.  
2. Abre una terminal y navega al directorio donde guardaste el archivo.  
3. Ejecuta el siguiente comando para iniciar los servicios:  
   ```bash
   docker-compose up -d
   ```
   Este comando descargará las imágenes necesarias y arrancará los contenedores.

4. Verifica que los contenedores estén corriendo:  
   ```bash
   docker ps
   ```

## Acceder a las URLs  
Una vez que los servicios estén en ejecución:  
- **Interfaz de BunkerWeb**: Abre un navegador y accede a `http://bunkerweb.juiceshop.com`.  
  - Credenciales:  
    - Usuario: `admin`  
    - Contraseña: `Adm1nP4ssw0rd!`  
- **Juice Shop protegido**: Accede a `http://www.juiceshop.com`.  
