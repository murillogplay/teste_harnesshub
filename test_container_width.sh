#!/bin/bash
# Teste de regressão: valida se o container está com max-width de 1024px
# Este teste deve PASSAR com a correção (1024px) e FALHAR sem ela (800px)

HTML_FILE="/workspace/repo/index.html"
EXPECTED_WIDTH="1024"

if [ ! -f "$HTML_FILE" ]; then
    echo "FAIL: $HTML_FILE não encontrado"
    exit 1
fi

# Extrai o valor de max-width da classe .container
ACTUAL_WIDTH=$(grep -A5 '\.container' "$HTML_FILE" | grep -oP 'max-width:\s*\K[0-9]+')

if [ "$ACTUAL_WIDTH" = "$EXPECTED_WIDTH" ]; then
    echo "PASS: Container está com max-width de ${ACTUAL_WIDTH}px (esperado: ${EXPECTED_WIDTH}px)"
    exit 0
else
    echo "FAIL: Container tem max-width de ${ACTUAL_WIDTH}px (esperado: ${EXPECTED_WIDTH}px)"
    exit 1
fi
