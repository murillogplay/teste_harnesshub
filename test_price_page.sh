#!/bin/bash
# Testes para a página price.html (planos de pagamento)

HTML_FILE="/workspace/repo/price.html"

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

echo "=== Testes da página Price (Preços) ==="

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

# 2. Tem título da página price no <title>
assert_contains "Title contém 'Preços'" "Preços"

# 3. Tem header com navegação
assert_contains "Tem <header>" "<header>"
assert_contains "Tem <nav> dentro do header" "<nav>"
assert_contains "Link Home no menu" 'href="index.html"'
assert_contains "Link Sobre no menu" 'href="sobre.html"'
assert_contains "Link Price no menu" 'href="price.html"'

# 4. Tem container principal com id price
assert_contains "Tem div.container com id='price'" 'id="price"'

# 5. Tem heading h1 com texto sobre preços
assert_contains "Tem <h1> na página" "<h1>"
assert_contains "H1 contém 'Plano' ou 'Preço'" "Plano"

# 6. PLANO BÁSICO - R$ 29,99
assert_contains "Tem plano Básico" "Básico"
assert_contains "Preço R$ 29,99 no plano Básico" "R\$ 29,99"
assert_contains "Plano Básico tem descrição" "começando"

# 7. PLANO PRO - R$ 49,99 (destaque/featured)
assert_contains "Tem plano Pro/Popular" "Popular"
assert_contains "Preço R$ 49,99 no plano Popular" "R\$ 49,99"
assert_contains "Plano Popular tem classe featured" "featured"

# 8. PLANO ENTERPRISE - R$ 99,99
assert_contains "Tem plano Enterprise" "Enterprise"
assert_contains "Preço R$ 99,99 no plano Enterprise" "R\$ 99,99"

# 9. Todos os 3 planos têm classe plan-card (inclui featured)
PLAN_COUNT=$(grep -c 'plan-card' "$HTML_FILE")
if [ "$PLAN_COUNT" -ge 3 ]; then
    echo "PASS: Existem $PLAN_COUNT referência(s) a plan-card (esperado: pelo menos 3)"
    PASS_COUNT=$((PASS_COUNT + 1))
else
    echo "FAIL: Encontradas $PLAN_COUNT referência(s) a plan-card (esperado: pelo menos 3)"
    FAIL_COUNT=$((FAIL_COUNT + 1))
fi

# 10. Cada plano tem botão de assinatura (btn-plan)
BTN_COUNT=$(grep -c 'btn-plan' "$HTML_FILE")
if [ "$BTN_COUNT" -ge 3 ]; then
    echo "PASS: Existem $BTN_COUNT referência(s) a btn-plan (esperado: pelo menos 3)"
    PASS_COUNT=$((PASS_COUNT + 1))
else
    echo "FAIL: Encontradas $BTN_COUNT referência(s) a btn-plan (esperado: pelo menos 3)"
    FAIL_COUNT=$((FAIL_COUNT + 1))
fi

# 11. Tem lista de features (ul.plan-features)
assert_contains "Tem lista de features" 'class="plan-features"'

# 12. Footer com links
assert_contains "Tem <footer>" "<footer>"
assert_contains "Footer tem link Google" 'href="https://www.google.com"'
assert_contains "Footer tem link GitHub" 'href="https://github.com"'
assert_contains "Footer tem link Facebook" 'facebook\.com'

# 13. Tem grid de preços (pricing-grid)
assert_contains "Tem container pricing-grid" "pricing-grid"

# 14. Tem <ul> para features nos planos
UL_PLAN_COUNT=$(grep -c 'class="plan-features"' "$HTML_FILE")
if [ "$UL_PLAN_COUNT" -ge 3 ]; then
    echo "PASS: Existem $UL_PLAN_COUNT lista(s) de features (esperado: pelo menos 3)"
    PASS_COUNT=$((PASS_COUNT + 1))
else
    echo "FAIL: Encontrados $UL_PLAN_COUNT lista(s) de features (esperado: pelo menos 3)"
    FAIL_COUNT=$((FAIL_COUNT + 1))
fi

# 15. Tem pelo menos um link de Assinatura funcional
assert_contains "Tem botão Assinar" "Assinar"

# 16. O plano featured tem borda estilizada (border-color: #e040fb)
assert_contains "Plano featured tem estilo de borda" "border-color: #e040fb"

# 17. Tem span com /mês nos preços
assert_contains "Preços têm indicação /mês" "/mês"

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
