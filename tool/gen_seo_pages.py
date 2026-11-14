#!/usr/bin/env python3
"""Gera as páginas estáticas de SEO em web/<slug>/index.html, sitemap e ads.txt.

Uso: python tool/gen_seo_pages.py
Contato público opcional no rodapé: defina SEO_CONTACT_EMAIL antes de rodar.
Cada página é HTML puro (sem framework) com uma mini calculadora em JS, para
carregar rápido, ser indexável e manter o visitante na página.
"""
import json
import os
from html import escape

SITE = "https://calculadora-polias.asclabs.com.br"
PUB = "ca-pub-3590770249573148"
PLAY = "https://play.google.com/store/apps/details?id=br.com.asclabs.calculadorapolias"
CONTACT = os.environ.get("SEO_CONTACT_EMAIL", "").strip()
ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "web")

PAGES = [
    {
        "slug": "rpm-polia",
        "title": "Calculadora de RPM de Polia (Motor e Movida) | ASCLABS",
        "desc": "Calcule o RPM da polia movida, o diâmetro das polias ou o RPM do motor. Fórmula N1×D1 = N2×D2 com exemplo resolvido, grátis e sem cadastro.",
        "h1": "Calculadora de RPM de polia",
        "intro": "Descubra a rotação da polia movida (ou o diâmetro que você precisa) a partir do motor e do diâmetro das polias. Preencha os campos e o resultado é calculado na hora.",
        "calc": {
            "fields": [("n1", "RPM do motor (N1)", "1750"), ("d1", "Diâmetro da polia motora (D1, mm)", "100"), ("d2", "Diâmetro da polia movida (D2, mm)", "200")],
            "js": "var r=n1*d1/d2;out('RPM da polia movida (N2)', fmt(r)+' RPM');",
        },
        "sections": [
            ("Fórmula do RPM de polias", "<p>Em uma transmissão por correia sem escorregamento, a velocidade linear da correia é a mesma nas duas polias. Isso gera a relação:</p><p class=\"formula\">N1 × D1 = N2 × D2</p><p>Onde <strong>N1</strong> é o RPM da polia motora, <strong>D1</strong> o diâmetro dela, <strong>N2</strong> o RPM da polia movida e <strong>D2</strong> o diâmetro dela. Isolando cada termo:</p><ul><li>N2 = N1 × D1 / D2</li><li>N1 = N2 × D2 / D1</li><li>D2 = N1 × D1 / N2</li><li>D1 = N2 × D2 / N1</li></ul>"),
            ("Exemplo resolvido", "<p>Motor de <strong>1750 RPM</strong> com polia de <strong>100 mm</strong> acionando uma polia de <strong>200 mm</strong>:</p><p class=\"formula\">N2 = 1750 × 100 / 200 = 875 RPM</p><p>A polia maior gira mais devagar: a rotação cai pela metade e o torque disponível aumenta na mesma proporção (desprezando perdas).</p>"),
            ("Como escolher o diâmetro das polias", "<p>Para reduzir a rotação, use uma polia movida maior que a motora. Para aumentar, faça o contrário. Respeite o diâmetro mínimo recomendado pelo fabricante da correia, pois polias muito pequenas reduzem a vida útil. Na prática, o escorregamento da correia faz o RPM real ficar 1% a 3% abaixo do teórico em correias em V.</p>"),
        ],
        "faq": [
            ("Como calcular o RPM da polia movida?", "Multiplique o RPM do motor pelo diâmetro da polia motora e divida pelo diâmetro da polia movida: N2 = N1 × D1 / D2."),
            ("Polia maior gira mais rápido ou mais devagar?", "Mais devagar. Quanto maior a polia movida em relação à motora, menor o RPM de saída e maior o torque."),
            ("Posso usar polegadas em vez de milímetros?", "Pode, desde que use a mesma unidade nas duas polias. A relação depende apenas da proporção entre os diâmetros."),
        ],
        "related": ["comprimento-correia", "relacao-transmissao"],
    },
    {
        "slug": "comprimento-correia",
        "title": "Calculadora de Comprimento de Correia e Distância entre Centros | ASCLABS",
        "desc": "Calcule o comprimento da correia a partir dos diâmetros das polias e da distância entre centros, ou o inverso. Fórmula aberta com exemplo resolvido.",
        "h1": "Calculadora de comprimento de correia",
        "intro": "Informe o diâmetro das duas polias e a distância entre os centros para obter o comprimento aproximado da correia aberta. No app você também descobre a distância ou um diâmetro a partir do comprimento.",
        "calc": {
            "fields": [("D", "Polia maior (D, mm)", "200"), ("d", "Polia menor (d, mm)", "100"), ("C", "Distância entre centros (C, mm)", "500")],
            "js": "var L=2*C+1.57*(D+d)+Math.pow(D-d,2)/(4*C);out('Comprimento da correia (L)', fmt(L)+' mm');",
        },
        "sections": [
            ("Fórmula do comprimento da correia", "<p>Para correia aberta (as duas polias girando no mesmo sentido), a fórmula aproximada mais usada é:</p><p class=\"formula\">L = 2C + 1,57 × (D + d) + (D − d)² / (4C)</p><p>Onde <strong>L</strong> é o comprimento da correia, <strong>C</strong> a distância entre os centros dos eixos, <strong>D</strong> o diâmetro da polia maior e <strong>d</strong> o da menor. A fórmula vale quando a distância entre centros é bem maior que a diferença entre os diâmetros.</p>"),
            ("Exemplo resolvido", "<p>Polias de <strong>200 mm</strong> e <strong>100 mm</strong> com <strong>500 mm</strong> entre centros:</p><p class=\"formula\">L = 2×500 + 1,57×(200+100) + (200−100)² / (4×500)<br>L = 1000 + 471 + 5 = 1476 mm</p><p>Escolha a correia padronizada de comprimento mais próximo e ajuste a distância entre centros para tensionar.</p>"),
            ("Distância entre centros mínima e máxima", "<p>Como regra prática, mantenha a distância entre centros entre <strong>0,7 × (D + d)</strong> e <strong>2 × (D + d)</strong>. Muito curta reduz o ângulo de abraçamento e a correia escorrega; muito longa causa vibração. Deixe sempre folga de ajuste para instalar e esticar a correia.</p>"),
        ],
        "faq": [
            ("Como calcular o comprimento de uma correia?", "Use L = 2C + 1,57(D + d) + (D − d)² / 4C, com C a distância entre centros e D e d os diâmetros das polias."),
            ("A fórmula serve para correia em V e correia dentada?", "Serve como aproximação para ambas. O comprimento final deve ser arredondado para o tamanho padronizado do fabricante, e para dentada confira o passo."),
            ("Como achar a distância entre centros conhecendo a correia?", "Isole C na fórmula do comprimento. O aplicativo faz esse cálculo deixando o campo de distância em branco."),
        ],
        "related": ["rpm-polia", "relacao-transmissao"],
    },
    {
        "slug": "relacao-transmissao",
        "title": "Calculadora de Relação de Transmissão de Polias | ASCLABS",
        "desc": "Calcule a relação de transmissão (i = D2/D1 = N1/N2) entre duas polias. Entenda redução e multiplicação de velocidade com exemplo resolvido.",
        "h1": "Calculadora de relação de transmissão",
        "intro": "A relação de transmissão mostra quantas voltas a polia motora dá para cada volta da movida. Informe os dois diâmetros e veja a relação e o tipo de transmissão.",
        "calc": {
            "fields": [("d1", "Diâmetro da polia motora (D1, mm)", "100"), ("d2", "Diâmetro da polia movida (D2, mm)", "200")],
            "js": "var i=d2/d1;out('Relação de transmissão (i)', '1 : '+fmt(i)+(i>1?' (redução)':i<1?' (multiplicação)':' (direta)'));",
        },
        "sections": [
            ("Fórmula da relação de transmissão", "<p class=\"formula\">i = D2 / D1 = N1 / N2</p><p>Quando <strong>i &gt; 1</strong> a polia movida é maior: há <em>redução</em> de velocidade e ganho de torque. Quando <strong>i &lt; 1</strong> há <em>multiplicação</em> de velocidade e perda de torque. Com <strong>i = 1</strong> as duas polias giram na mesma rotação.</p>"),
            ("Exemplo resolvido", "<p>Polia motora de <strong>100 mm</strong> e movida de <strong>200 mm</strong>:</p><p class=\"formula\">i = 200 / 100 = 2, ou seja, 1 : 2</p><p>Com um motor de 1750 RPM, a saída é 1750 / 2 = <strong>875 RPM</strong>, e o torque na saída é cerca de duas vezes o do motor, descontadas as perdas.</p>"),
            ("Transmissões em estágios", "<p>Quando a redução necessária é grande (acima de 6:1 ou 8:1 em correias), divida em dois estágios. A relação total é o produto das relações de cada estágio: <strong>i total = i1 × i2</strong>. Isso mantém as polias com tamanho razoável e preserva o ângulo de abraçamento.</p>"),
        ],
        "faq": [
            ("O que significa relação de transmissão 1:2?", "A polia motora dá duas voltas para cada volta da movida: a velocidade cai pela metade e o torque dobra, sem considerar perdas."),
            ("Qual a diferença entre redução e multiplicação?", "Na redução a polia movida é maior (i > 1) e gira mais devagar. Na multiplicação a movida é menor (i < 1) e gira mais rápido."),
            ("Como calcular a relação de transmissão pelo RPM?", "Divida o RPM da polia motora pelo RPM da movida: i = N1 / N2."),
        ],
        "related": ["rpm-polia", "comprimento-correia"],
    },
]

NAMES = {p["slug"]: p["h1"] for p in PAGES}

CSS = """:root{--bg:#0e1014;--sf:#161a20;--bd:#262b34;--ac:#22d3ee;--tx:#f1f5f9;--mu:#8a94a6}
*{box-sizing:border-box}body{margin:0;background:var(--bg);color:var(--tx);font:16px/1.65 system-ui,-apple-system,Segoe UI,Roboto,sans-serif}
a{color:var(--ac)}main,footer{max-width:760px;margin:0 auto;padding:0 16px}
header{border-bottom:1px solid var(--bd)}header div{max-width:760px;margin:0 auto;display:flex;justify-content:space-between;align-items:center;padding:14px 16px}
.brand{font-weight:700;color:var(--tx);text-decoration:none}h1{font-size:28px;line-height:1.25;margin:28px 0 8px}h2{font-size:20px;margin:32px 0 8px}
p{margin:8px 0}.lead{color:var(--mu)}.card{background:var(--sf);border:1px solid var(--bd);border-radius:12px;padding:16px;margin:20px 0}
label{display:block;font-size:13px;color:var(--mu);margin:10px 0 4px}input{width:100%;padding:12px;border-radius:10px;border:1px solid var(--bd);background:var(--bg);color:var(--tx);font-size:16px}
button,.btn{display:inline-block;margin-top:14px;padding:13px 18px;border-radius:10px;border:0;background:var(--ac);color:#0e1014;font-weight:700;font-size:15px;text-decoration:none;cursor:pointer}
.btn.alt{background:transparent;color:var(--tx);border:1px solid var(--bd)}#res{margin-top:14px;min-height:24px}#res small{display:block;color:var(--mu)}#res b{font-size:26px;color:var(--ac)}
.formula{background:var(--sf);border:1px solid var(--bd);border-radius:10px;padding:12px 14px;font-family:ui-monospace,Menlo,Consolas,monospace;overflow-x:auto}
.cta{display:flex;gap:10px;flex-wrap:wrap}details{border-bottom:1px solid var(--bd);padding:10px 0}summary{cursor:pointer;font-weight:600}
nav.rel a{display:block;padding:8px 0}footer{color:var(--mu);font-size:13px;padding-top:28px;padding-bottom:40px}"""


def page_html(p):
    url = f"{SITE}/{p['slug']}/"
    fields = "".join(
        f'<label for="{k}">{escape(lbl)}</label><input id="{k}" inputmode="decimal" value="{val}" autocomplete="off">'
        for k, lbl, val in p["calc"]["fields"]
    )
    ids = ",".join(f'"{k}"' for k, _, _ in p["calc"]["fields"])
    sections = "".join(f"<h2>{escape(t)}</h2>{body}" for t, body in p["sections"])
    faq_html = "".join(f"<details><summary>{escape(q)}</summary><p>{escape(a)}</p></details>" for q, a in p["faq"])
    related = "".join(f'<a href="/{s}/">{escape(NAMES[s])}</a>' for s in p["related"])
    contact = f' <a href="mailto:{escape(CONTACT)}">Contato</a>' if CONTACT else ""
    ld = [
        {
            "@context": "https://schema.org",
            "@type": "FAQPage",
            "mainEntity": [
                {"@type": "Question", "name": q, "acceptedAnswer": {"@type": "Answer", "text": a}}
                for q, a in p["faq"]
            ],
        },
        {
            "@context": "https://schema.org",
            "@type": "BreadcrumbList",
            "itemListElement": [
                {"@type": "ListItem", "position": 1, "name": "Calculadora de Polias", "item": SITE + "/"},
                {"@type": "ListItem", "position": 2, "name": p["h1"], "item": url},
            ],
        },
    ]
    return f"""<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>{escape(p['title'])}</title>
<meta name="description" content="{escape(p['desc'])}">
<link rel="canonical" href="{url}">
<meta property="og:type" content="website">
<meta property="og:title" content="{escape(p['title'])}">
<meta property="og:description" content="{escape(p['desc'])}">
<meta property="og:url" content="{url}">
<meta property="og:image" content="{SITE}/icons/Icon-512.png">
<meta name="theme-color" content="#0e1014">
<link rel="icon" type="image/png" href="/favicon.png">
<style>{CSS}</style>
<script type="application/ld+json">{json.dumps(ld, ensure_ascii=False)}</script>
<script async src="https://pagead2.googleapis.com/pagead/js/adsbygoogle.js?client={PUB}" crossorigin="anonymous"></script>
</head>
<body>
<header><div><a class="brand" href="/">Calculadora de Polias</a><a href="{PLAY}" rel="noopener">App Android</a></div></header>
<main>
<h1>{escape(p['h1'])}</h1>
<p class="lead">{escape(p['intro'])}</p>
<div class="card">
{fields}
<button id="go" type="button">Calcular</button>
<div id="res" aria-live="polite"></div>
</div>
<div class="cta">
<a class="btn" href="/">Abrir a calculadora completa</a>
<a class="btn alt" href="{PLAY}" rel="noopener">Baixar na Play Store</a>
</div>
{sections}
<h2>Perguntas frequentes</h2>
{faq_html}
<h2>Outros cálculos</h2>
<nav class="rel">{related}</nav>
</main>
<footer>© 2026 ASCLABS. Cálculos teóricos: valide com um engenheiro responsável antes de aplicar em projeto.{contact}</footer>
<script>
(function(){{
var ids=[{ids}];
function fmt(x){{return isFinite(x)?(Math.round(x*100)/100).toLocaleString('pt-BR'):'—'}}
function out(l,v){{document.getElementById('res').innerHTML='<small>'+l+'</small><b>'+v+'</b>'}}
function run(){{
var v={{}};ids.forEach(function(k){{v[k]=parseFloat(String(document.getElementById(k).value).replace(',','.'))}});
for(var k in v){{if(!(v[k]>0)){{document.getElementById('res').textContent='Preencha todos os campos com valores maiores que zero.';return}}}}
var n1=v.n1,d1=v.d1,d2=v.d2,D=v.D,d=v.d,C=v.C;
{p['calc']['js']}
}}
document.getElementById('go').addEventListener('click',run);run();
}})();
</script>
</body>
</html>
"""


def write(path, content):
    with open(path, "w", encoding="utf-8", newline="\n") as f:
        f.write(content)


def main():
    for p in PAGES:
        d = os.path.join(ROOT, p["slug"])
        os.makedirs(d, exist_ok=True)
        write(os.path.join(d, "index.html"), page_html(p))

    urls = [SITE + "/"] + [f"{SITE}/{p['slug']}/" for p in PAGES]
    sm = '<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n'
    sm += "".join(f"  <url><loc>{u}</loc></url>\n" for u in urls) + "</urlset>\n"
    write(os.path.join(ROOT, "sitemap.xml"), sm)
    write(os.path.join(ROOT, "robots.txt"), f"User-agent: *\nAllow: /\n\nSitemap: {SITE}/sitemap.xml\n")
    write(os.path.join(ROOT, "ads.txt"), f"google.com, {PUB.replace('ca-', '')}, DIRECT, f08c47fec0942fa0\n")
    print("ok:", ", ".join(p["slug"] for p in PAGES))


if __name__ == "__main__":
    main()
