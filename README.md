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
- **Juice Shop protegido**: Accede a `http://localhost`.
- **Juice Shop desprotegido**: Accede a `http://10.10.10.100:3000`.

## Probar SQLi



## Analizar los logs

```sh
grep '"transaction"' nginx.log | jq 'select(.transaction.request.uri == "/rest/user/login") | {client_ip: .transaction.client_ip, uri: .transaction.request.uri, http_code: .transaction.response.http_code, messages: [.transaction.messages[] | {ruleId: .details.ruleId, message: .message}]}'
```

```json
{
  "client_ip": "10.10.10.1",
  "uri": "/rest/user/login",
  "http_code": 403,
  "messages": [
    {
      "ruleId": "942100",
      "message": "SQL Injection Attack Detected via libinjection"
    },
    {
      "ruleId": "949110",
      "message": "Inbound Anomaly Score Exceeded (Total Score: 5)"
    }
  ]
}
```

PARA QUE FUNCIONE HAY QUE PONER: 
chmod go-w monitoring/filebeat.yml  