#!/bin/bash
# Teste de regressão: valida se existem pelo menos 3 links do Facebook
# (incluindo o existente e os adicionados) com fundo azul (#1877f2) e letra branca

HTML_FILE="/workspace/repo/index.html"

if [ ! -f "$HTML_FILE" ]; then
    echo "FAIL: $HTML_FILE não encontrado"
    exit 1
fi

# Conta quantos links apontam para facebook.com no HTML (com ou sem www)
FACEBOOK_LINKS_COUNT=$(grep -c 'facebook\.com' "$HTML_FILE")

if [ "$FACEBOOK_LINKS_COUNT" -ge 3 ]; then
    echo "PASS: Existem $FACEBOOK_LINKS_COUNT links do Facebook (mínimo esperado: 3)"
else
    echo "FAIL: Existem apenas $FACEBOOK_LINKS_COUNT link(s) do Facebook (esperado: pelo menos 3)"
    exit 1
fi

# Valida que a classe .facebook-link existe e tem fundo azul (#1877f2)
if grep -q '\.facebook-link' "$HTML_FILE" && grep -A3 '\.facebook-link' "$HTML_FILE" | grep -q '#1877f2'; then
    echo "PASS: Classe .facebook-link com fundo azul (#1877f2) encontrada"
else
    echo "FAIL: Classe .facebook-link com fundo azul não encontrada"
    exit 1
fi

# Valida que footer tem cor branca (#ffffff) para letra branca nos links
if grep -q 'color: #ffffff' "$HTML_FILE"; then
    echo "PASS: Cor branca (#ffffff) encontrada no HTML"
else
    echo "FAIL: Cor branca não encontrada"
    exit 1
fi

echo "ALL TESTS PASSED"
exit 0
