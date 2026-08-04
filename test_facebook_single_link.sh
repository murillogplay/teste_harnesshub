#!/bin/bash
# Teste TDD: valida se existe exatamente 1 link do Facebook no footer
# apontando para a página principal, e que os outros links (Google, GitHub) estão preservados.

HTML_FILE="/workspace/repo/index.html"

if [ ! -f "$HTML_FILE" ]; then
    echo "FAIL: $HTML_FILE não encontrado"
    exit 1
fi

# --- Teste 1: Conta quantos links apontam para facebook.com no HTML ---
FACEBOOK_LINKS_COUNT=$(grep -c 'facebook\.com' "$HTML_FILE")

if [ "$FACEBOOK_LINKS_COUNT" -eq 1 ]; then
    echo "PASS: Existe exatamente $FACEBOOK_LINKS_COUNT link do Facebook"
else
    echo "FAIL: Existem $FACEBOOK_LINKS_COUNT link(s) do Facebook (esperado: 1)"
    exit 1
fi

# --- Teste 2: O link do Facebook aponta para a página principal (harnesshub) ---
if grep -q 'href="https://www\.facebook\.com/harnesshub"' "$HTML_FILE"; then
    echo "PASS: Link do Facebook aponta para a página principal do harnesshub"
else
    echo "FAIL: Link do Facebook não aponta corretamente para a página principal"
    exit 1
fi

# --- Teste 3: O link do Google ainda existe ---
if grep -q 'href="https://www.google.com"' "$HTML_FILE"; then
    echo "PASS: Link do Google preservado"
else
    echo "FAIL: Link do Google foi removido indevidamente"
    exit 1
fi

# --- Teste 4: O link do GitHub ainda existe ---
if grep -q 'href="https://github.com"' "$HTML_FILE"; then
    echo "PASS: Link do GitHub preservado"
else
    echo "FAIL: Link do GitHub foi removido indevidamente"
    exit 1
fi

# --- Teste 5: Total de links no footer é exatamente 3 (Google + GitHub + Facebook) ---
FOOTER_LINKS_COUNT=$(sed -n '/<footer>/,/<\/footer>/p' "$HTML_FILE" | grep -c '<a ')

if [ "$FOOTER_LINKS_COUNT" -eq 3 ]; then
    echo "PASS: Footer tem exatamente $FOOTER_LINKS_COUNT links (esperado: 3)"
else
    echo "FAIL: Footer tem $FOOTER_LINKS_COUNT links (esperado: 3)"
    exit 1
fi

# --- Teste 6: Classe .facebook-link existe e tem fundo azul (#1877f2) ---
if grep -q '\.facebook-link' "$HTML_FILE" && grep -A3 '\.facebook-link' "$HTML_FILE" | grep -q '#1877f2'; then
    echo "PASS: Classe .facebook-link com fundo azul (#1877f2) encontrada"
else
    echo "FAIL: Classe .facebook-link com fundo azul não encontrada"
    exit 1
fi

# --- Teste 7: Cor branca (#ffffff) está presente para links do footer ---
if grep -q 'color: #ffffff' "$HTML_FILE"; then
    echo "PASS: Cor branca (#ffffff) encontrada no HTML"
else
    echo "FAIL: Cor branca não encontrada"
    exit 1
fi

echo "ALL TESTS PASSED"
exit 0
