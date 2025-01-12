# WAF-101
## ¿Qué es un WAF?  
Un **Web Application Firewall (WAF)** es una herramienta de seguridad diseñada para proteger aplicaciones web al filtrar y monitorear el tráfico HTTP. Los WAFs actúan como una barrera entre los usuarios y las aplicaciones, protegiendo contra ataques como inyecciones SQL, Cross-Site Scripting (XSS) y otros exploits.  

A diferencia de los firewalls tradicionales que operan a nivel de red, los WAFs están diseñados para trabajar en el nivel de la aplicación, analizando el contenido y el contexto de las solicitudes y respuestas HTTP.

### ¿Por qué hemos elegido Nginx y ModSecurity?  
En este laboratorio, hemos optado por utilizar Nginx como servidor web junto con el módulo ModSecurity para implementar el WAF. Esta elección se debe a varias razones:

1. **ModSecurity como biblioteca de reglas:**
ModSecurity es una biblioteca ampliamente utilizada que permite definir y aplicar reglas para filtrar y analizar el tráfico HTTP. Estas reglas pueden ser personalizadas o basarse en conjuntos predefinidos como el [OWASP CRS (Core Rule Set)](https://owasp.org/www-project-modsecurity-core-rule-set/), que protege contra los ataques más comunes descritos en el OWASP Top 10.

2. **Conector oficial para Nginx:**
La organización detrás de ModSecurity también desarrolla un conector oficial para Nginx, que gestiona la comunicación entre la biblioteca de ModSecurity y el servidor web.

3. **Imagen Docker oficial**:
ModSecurity ofrece una imagen Docker oficial que configura directamente Nginx con el OWASP Core Rule Set (CRS). Esto simplifica enormemente el proceso de implementación.

En este laboratorio se ha utilizado la imagen de Docker oficial con el OWASP Core Rule Set (CRS) configurado.

Aunque los **Cloud Service Providers (CSP)** como AWS, Azure o GCP ofrecen soluciones WAF, muchas de estas son de pago, complejas de configurar y carecen de transparencia en cuanto a su funcionamiento interno. Esto puede dificultar la comprensión y el control sobre cómo se aplican las reglas y se gestiona el tráfico. 

Además, la mayoría de los WAF de terceros utilizan ModSecurity como base para implementar sus reglas y capacidades de protección. Esto se debe a que ModSecurity es una biblioteca ampliamente reconocida y flexible para la detección y mitigación de amenazas web. Por lo que en este laboratorio se ha optado por utilizar ModSecurity directamente, ya que proporciona una visión más clara y práctica de cómo funcionan los WAFs en su núcleo.

Sin embargo, es fundamental comprender las limitaciones de ModSecurity frente a otras soluciones WAF más completas. Mientras que ModSecurity es extremadamente eficaz para detectar y mitigar ataques basados en el OWASP Top 10, como inyecciones SQL y Cross-Site Scripting (XSS), no está diseñado para abordar otros tipos de amenazas comunes en el panorama de la ciberseguridad actual, tales como protección contra ataques DDoS, gestión de bots, scraping automatizado o una interfaz gráfica nativa para administrar y visualizar datos.



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