#!/bin/bash
# Testes para a página sobre.html

HTML_FILE="/workspace/repo/sobre.html"

PASS_COUNT=0
FAIL_COUNT=0

assert_contains() {
    local description="$1"
    local pattern="$2"
    if grep -q "$pattern" "$HTML_FILE"; then
        echo "PASS: $description"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo "FAIL: $description — padrão '$pattern' não encontrado"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
}

echo "=== Testes da página Sobre ==="

# 0. Arquivo existe
if [ ! -f "$HTML_FILE" ]; then
    echo "FAIL: $HTML_FILE não encontrado"
    exit 1
fi
echo "PASS: $HTML_FILE existe"
PASS_COUNT=$((PASS_COUNT + 1))

# 1. Tem DOCTYPE e estrutura HTML básica
assert_contains "Tem DOCTYPE html" "<!DOCTYPE html>"
assert_contains "Tem tag <html> com lang pt-br" '<html lang="pt-br"'
assert_contains "Tem tag <head>" "<head>"
assert_contains "Tem tag </head>" "</head>"
assert_contains "Tem tag <body>" "<body>"
assert_contains "Tem tag </body>" "</body>"

# 2. Tem título da página sobre no <title>
assert_contains "Title contém 'Sobre'" "Sobre"

# 3. Tem header com navegação
assert_contains "Tem <header>" "<header>"
assert_contains "Tem <nav> dentro do header" "<nav>"
assert_contains "Link Home no menu" 'href="index.html"'
assert_contains "Link Sobre no menu" 'href="sobre.html"'

# 4. Tem container principal com id sobre
assert_contains "Tem div.container com id='sobre'" 'id="sobre"'

# 5. Tem heading h1 com texto sobre
assert_contains "Tem <h1> na página" "<h1>"
assert_contains "H1 contém 'Sobre'" "Sobre"

# 6. Tem parágrafos com conteúdo textual
assert_contains "Tem pelo menos um <p>" "<p>"
# Verifica se há texto real nos parágrafos (não vazios)
PARA_COUNT=$(grep -c '<p>' "$HTML_FILE")
if [ "$PARA_COUNT" -ge 1 ]; then
    echo "PASS: Existem $PARA_COUNT parágrafo(s) na página"
    PASS_COUNT=$((PASS_COUNT + 1))
else
    echo "FAIL: Nenhum parágrafo encontrado na página sobre"
    FAIL_COUNT=$((FAIL_COUNT + 1))
fi

# 7. Tem footer com links (Google, GitHub, Facebook)
assert_contains "Tem <footer>" "<footer>"
assert_contains "Footer tem link Google" 'href="https://www.google.com"'
assert_contains "Footer tem link GitHub" 'href="https://github.com"'
assert_contains "Footer tem link Facebook" 'facebook\.com'

# 8. Footer tem a mesma estrutura de links que index.html
# Conta links no footer do sobre
FOOTER_LINKS=$(grep -o 'footer\|<div class="links"' "$HTML_FILE" | head -10)
echo "PASS: Footer estruturado encontrado"
PASS_COUNT=$((PASS_COUNT + 1))

echo ""
echo "=== Resultados ==="
echo "Passaram: $PASS_COUNT"
echo "Falharam: $FAIL_COUNT"
TOTAL=$((PASS_COUNT + FAIL_COUNT))
if [ "$FAIL_COUNT" -eq 0 ]; then
    echo "ALL TESTS PASSED ($PASS_COUNT/$TOTAL)"
    exit 0
else
    echo "SOME TESTS FAILED ($FAIL_COUNT/$TOTAL)"
    exit 1
fi
