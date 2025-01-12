# WAF-101
## ¿Qué es un WAF?  
Un **Web Application Firewall (WAF)** es una herramienta de seguridad diseñada para proteger aplicaciones web al filtrar y monitorear el tráfico HTTP. Los WAFs actúan como una barrera entre los usuarios y las aplicaciones, protegiendo contra ataques como inyecciones SQL, Cross-Site Scripting (XSS) y otros exploits.  

## Descripción del laboratorio
Este laboratorio está diseñado para aprender sobre seguridad web y la configuración de un WAF (Web Application Firewall) utilizando Nginx con ModSecurity. Simulamos un entorno de ataques y tráfico legítimo para evaluar la efectividad del WAF y su impacto en la protección de una aplicación vulnerable como Juice Shop. Además, se implementa un sistema de monitoreo con Elasticsearch, Logstash, y Grafana para analizar métricas en tiempo real.

## Objetivo del laboratorio

El objetivo de este laboratorio es proteger Juice Shop, una aplicación web desarrollada por OWASP que contiene numerosas vulnerabilidades comunes intencionales, como inyecciones, XSS y problemas de autenticación.

Durante el laboratorio, se simularán ataques automatizados hacia Juice Shop. El objetivo es observar cómo un WAF detecta y bloquea estos ataques, protegiendo la aplicación. Esto permitirá explorar las capacidades de un WAF en un entorno controlado y entender cómo mitiga riesgos en aplicaciones web vulnerables.

### Arquitectura del laboratorio
El laboratorio utiliza contenedores Docker para configurar un entorno controlado con los siguientes servicios:
+ Juice Shop: Aplicación web intencionalmente vulnerable, utilizada como objetivo para ataques.
+ Nginx-ModSecurity: WAF configurado con reglas de ModSecurity para proteger Juice Shop.
+ Simuladores de ataque y tráfico legítimo: Contenedores que ejecutan ataques como SQL Injection (SQLi) y Cross-Site + Scripting (XSS), además de tráfico genuino.
+ Elastic Stack + Grafana: Sistema de monitoreo que recolecta y visualiza métricas de seguridad y rendimiento.

### ¿Por qué hemos elegido Nginx y ModSecurity?  
ModSecurity es uno de los WAF más populares y ampliamente adoptados. Permite implementar reglas personalizadas o conjuntos predefinidos como OWASP CRS (Core Rule Set) para proteger aplicaciones web.
Nginx es ligero, rápido y compatible con ModSecurity, lo que lo convierte en una excelente opción para demostrar cómo implementar seguridad en una configuración moderna.

Aunque los **Cloud Service Providers (CSP)** como AWS, Azure o GCP ofrecen soluciones WAF, para este laboratorio consideramos más práctico implementar BunkerWeb en local utilizando Docker. Esto permite mayor control y evita depender de servicios externos.

### Métricas de monitoreo
Elastic Stack y Grafana permiten obtener una visión integral del entorno:
+ Cantidad de ataques detectados (por tipo: SQLi, XSS, etc.).
+ Tasa de falsos positivos (tráfico legítimo bloqueado por error).
+ Rendimiento del servidor y tiempos de respuesta.
+ Tráfico permitido vs. bloqueado.

Usamos Filebeat para recolectar logs de Nginx y ModSecurity y enviarlos a Logstash, donde se procesan y almacenan en Elasticsearch.

## Lanzar el Docker Compose  
1. Guarda el archivo `docker-compose.yml` proporcionado en tu sistema.  
2. Abre una terminal y navega al directorio donde guardaste el archivo.  
3. Ejecuta el siguiente comando para iniciar los servicios:  
```bash
  chmod go-w monitoring/filebeat.yml  
  docker-compose up -d
```
Este comando descargará las imágenes necesarias y arrancará los contenedores.

4. Verifica que los contenedores estén corriendo:  
```bash
  docker ps
```

### Simular una oleada de ataques
Se ha incluido un script de Python que simula una oleada de ataques a Juice Shop. Para ejecutarlo, sigue estos pasos:
```bash
   chmod +x attack.sh
  ./attack.sh
```

## Acceder a las URLs  
Una vez que los servicios estén en ejecución:  
- **Juice Shop protegido**: Accede a `http://localhost`.
- **Juice Shop desprotegido**: Accede a `http://10.10.10.100:3000`.
- **Grafana**: Accede a `http://localhost:3000` (usuario: `admin`, contraseña: `grafana`).

## Analizar los logs
Para visualizar los datos recolectados puede verlos de forma gráfica en Grafana.(`http://localhost:3000`)
Los paneles creados por defecto son los siguientes:
![DashboardImage](dashboard.png)

Para configurar un panel en Grafana:
1. Selecciona "Create Panel" y usa Elasticsearch como fuente de datos.
2. Configura una consulta que agrupe por algún campo relevante (por ejemplo, tipo de ataque).
3. Personaliza los colores y agrega etiquetas para facilitar la lectura.


También puedes añadir más paneles y métricas según tus necesidades al dashboard dado:
1. Selecciona "Edit" en el dashboard.
2. Selecciona "Add" y elige el tipo de "Visualzation".
3. Configura la consulta y el tipo de gráfico que deseas añadir.

## Referencias
- [OWASP Juice Shop](https://owasp.org/www-project-juice-shop/)
- [ModSecurity](https://modsecurity.org/)
- [Nginx](https://www.nginx.com/)
- [Elastic Stack](https://www.elastic.co/elastic-stack)
- [Grafana](https://grafana.com/)