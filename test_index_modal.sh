#!/bin/bash
# Testes TDD para a página index.html — validação da mensagem do modal/alert

HTML_FILE="/workspace/repo/index.html"

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

echo "=== Testes da página Index (Modal) ==="

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

# 2. Tem título da página index no <title>
assert_contains "Title contém 'teste'" "teste"

# 3. Tem header com navegação
assert_contains "Tem <header>" "<header>"
assert_contains "Tem <nav> dentro do header" "<nav>"
assert_contains "Link Home no menu" 'href="index.html"'
assert_contains "Link Sobre no menu" 'href="sobre.html"'
assert_contains "Link Price no menu" 'href="price.html"'

# 4. Tem container principal com id home
assert_contains "Tem div.container com id='home'" 'id="home"'

# 5. Tem heading h1
assert_contains "Tem <h1> na página" "<h1>"
assert_contains "H1 contém 'Bem-vindo'" "Bem-vindo"

# 6. Tem parágrafo de descrição
assert_contains "Tem pelo menos um <p>" "<p>"

# 7. O botão do modal existe e tem texto "Abrir Modal"
assert_contains "Tem botão com onclick alert" "Abrir Modal"

# 8. A mensagem do modal/alert é "Japoneis safado sem vergonha!"
assert_contains "Modal/alert contém a mensagem correta" "Japoneis safado sem vergonha!"

# 9. Footer com links
assert_contains "Tem <footer>" "<footer>"
assert_contains "Footer tem link Google" 'href="https://www.google.com"'
assert_contains "Footer tem link GitHub" 'href="https://github.com"'
assert_contains "Footer tem link Facebook" 'facebook\.com'

# 10. Container com max-width 1024px
assert_contains "Container tem max-width: 1024px" "max-width: 1024px"

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
