#!/usr/bin/env python3
"""Gera as páginas estáticas de SEO (pt, es, en), sitemap, robots e ads.txt.

Uso: python tool/gen_seo_pages.py
Contato público opcional no rodapé: defina SEO_CONTACT_EMAIL antes de rodar.
Saída: web/<slug>/ (pt), web/es/<slug>/, web/en/<slug>/.
Cada página é HTML puro com uma mini calculadora em JS: leve, indexável e
com hreflang ligando as três versões.
"""
import json
import os
from html import escape

SITE = "https://calculadora-polias.asclabs.com.br"
PUB = "ca-pub-3590770249573148"
PLAY = "https://play.google.com/store/apps/details?id=br.com.asclabs.calculadorapolias"
CONTACT = os.environ.get("SEO_CONTACT_EMAIL", "").strip()
ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "web")

# --------------------------------------------------------------------------
# Textos de interface por idioma
# --------------------------------------------------------------------------
UI = {
    "pt": dict(html="pt-BR", num="pt-BR", prefix="", brand="Calculadora de Polias", app="App Android",
               calc="Calcular", fill="Preencha todos os campos com valores maiores que zero.",
               open="Abrir a calculadora completa", play="Baixar na Play Store", faq="Perguntas frequentes",
               other="Outros cálculos", contact="Contato",
               foot="© 2026 ASCLABS. Cálculos teóricos: valide com um engenheiro responsável antes de aplicar em projeto."),
    "es": dict(html="es", num="es", prefix="es/", brand="Calculadora de Poleas", app="App Android",
               calc="Calcular", fill="Completa todos los campos con valores mayores que cero.",
               open="Abrir la calculadora completa", play="Descargar en Google Play", faq="Preguntas frecuentes",
               other="Otros cálculos", contact="Contacto",
               foot="© 2026 ASCLABS. Cálculos teóricos: valídalos con un ingeniero responsable antes de aplicarlos en un proyecto."),
    "en": dict(html="en", num="en-US", prefix="en/", brand="Pulley Calculator", app="Android app",
               calc="Calculate", fill="Fill in every field with values greater than zero.",
               open="Open the full calculator", play="Get it on Google Play", faq="Frequently asked questions",
               other="More calculators", contact="Contact",
               foot="© 2026 ASCLABS. Theoretical calculations: have a qualified engineer verify them before using in a project."),
}

# --------------------------------------------------------------------------
# Páginas. "id" liga as traduções; "js" usa T (textos) e fmt().
# --------------------------------------------------------------------------
PAGES = [
    {
        "id": "rpm",
        "defaults": {"n1": "1750", "d1": "100", "d2": "200"},
        "js": "var r=n1*d1/d2;out(T.r,fmt(r)+' RPM');",
        "related": ["belt", "ratio"],
        "pt": {
            "slug": "rpm-polia",
            "title": "Calculadora de RPM de Polia (Motor e Movida) | ASCLABS",
            "desc": "Calcule o RPM da polia movida, o diâmetro das polias ou o RPM do motor. Fórmula N1×D1 = N2×D2 com exemplo resolvido, grátis e sem cadastro.",
            "h1": "Calculadora de RPM de polia",
            "intro": "Descubra a rotação da polia movida (ou o diâmetro que você precisa) a partir do motor e do diâmetro das polias. Preencha os campos e o resultado é calculado na hora.",
            "labels": {"n1": "RPM do motor (N1)", "d1": "Diâmetro da polia motora (D1, mm)", "d2": "Diâmetro da polia movida (D2, mm)"},
            "T": {"r": "RPM da polia movida (N2)"},
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
        },
        "es": {
            "slug": "rpm-polea",
            "title": "Calculadora de RPM de Polea (Motor y Conducida) | ASCLABS",
            "desc": "Calcula las RPM de la polea conducida, el diámetro de las poleas o las RPM del motor. Fórmula N1×D1 = N2×D2 con ejemplo resuelto, gratis y sin registro.",
            "h1": "Calculadora de RPM de polea",
            "intro": "Descubre las revoluciones de la polea conducida (o el diámetro que necesitas) a partir del motor y del diámetro de las poleas. Completa los campos y el resultado se calcula al instante.",
            "labels": {"n1": "RPM del motor (N1)", "d1": "Diámetro de la polea motriz (D1, mm)", "d2": "Diámetro de la polea conducida (D2, mm)"},
            "T": {"r": "RPM de la polea conducida (N2)"},
            "sections": [
                ("Fórmula de las RPM en poleas", "<p>En una transmisión por correa sin deslizamiento, la velocidad lineal de la correa es la misma en ambas poleas. De ahí sale la relación:</p><p class=\"formula\">N1 × D1 = N2 × D2</p><p>Donde <strong>N1</strong> son las RPM de la polea motriz, <strong>D1</strong> su diámetro, <strong>N2</strong> las RPM de la polea conducida y <strong>D2</strong> su diámetro. Despejando cada término:</p><ul><li>N2 = N1 × D1 / D2</li><li>N1 = N2 × D2 / D1</li><li>D2 = N1 × D1 / N2</li><li>D1 = N2 × D2 / N1</li></ul>"),
                ("Ejemplo resuelto", "<p>Motor de <strong>1750 RPM</strong> con polea de <strong>100 mm</strong> que mueve una polea de <strong>200 mm</strong>:</p><p class=\"formula\">N2 = 1750 × 100 / 200 = 875 RPM</p><p>La polea mayor gira más despacio: la rotación se reduce a la mitad y el par disponible aumenta en la misma proporción (sin contar pérdidas).</p>"),
                ("Cómo elegir el diámetro de las poleas", "<p>Para reducir la velocidad, usa una polea conducida mayor que la motriz; para aumentarla, haz lo contrario. Respeta el diámetro mínimo que recomienda el fabricante de la correa, porque poleas muy pequeñas acortan su vida útil. En la práctica, el deslizamiento hace que las RPM reales queden entre 1% y 3% por debajo de las teóricas en correas en V.</p>"),
            ],
            "faq": [
                ("¿Cómo calcular las RPM de la polea conducida?", "Multiplica las RPM del motor por el diámetro de la polea motriz y divide entre el diámetro de la polea conducida: N2 = N1 × D1 / D2."),
                ("¿Una polea más grande gira más rápido o más despacio?", "Más despacio. Cuanto mayor es la polea conducida respecto a la motriz, menores son las RPM de salida y mayor el par."),
                ("¿Puedo usar pulgadas en lugar de milímetros?", "Sí, siempre que uses la misma unidad en las dos poleas. La relación depende solo de la proporción entre los diámetros."),
            ],
        },
        "en": {
            "slug": "pulley-rpm",
            "title": "Pulley RPM Calculator (Motor and Driven) | ASCLABS",
            "desc": "Calculate the driven pulley RPM, pulley diameters or motor RPM. Formula N1×D1 = N2×D2 with a worked example. Free, no sign-up.",
            "h1": "Pulley RPM calculator",
            "intro": "Find the speed of the driven pulley (or the diameter you need) from the motor speed and the pulley diameters. Fill in the fields and the result updates instantly.",
            "labels": {"n1": "Motor RPM (N1)", "d1": "Driver pulley diameter (D1, mm)", "d2": "Driven pulley diameter (D2, mm)"},
            "T": {"r": "Driven pulley RPM (N2)"},
            "sections": [
                ("Pulley RPM formula", "<p>In a belt drive without slip, the belt's linear speed is the same on both pulleys. That gives:</p><p class=\"formula\">N1 × D1 = N2 × D2</p><p>Where <strong>N1</strong> is the driver pulley RPM, <strong>D1</strong> its diameter, <strong>N2</strong> the driven pulley RPM and <strong>D2</strong> its diameter. Solving for each term:</p><ul><li>N2 = N1 × D1 / D2</li><li>N1 = N2 × D2 / D1</li><li>D2 = N1 × D1 / N2</li><li>D1 = N2 × D2 / N1</li></ul>"),
                ("Worked example", "<p>A <strong>1750 RPM</strong> motor with a <strong>100 mm</strong> pulley driving a <strong>200 mm</strong> pulley:</p><p class=\"formula\">N2 = 1750 × 100 / 200 = 875 RPM</p><p>The larger pulley turns slower: speed is halved and available torque rises by the same factor (ignoring losses).</p>"),
                ("How to choose pulley diameters", "<p>To reduce speed, use a driven pulley larger than the driver; to increase it, do the opposite. Respect the minimum pulley diameter recommended by the belt maker, since very small pulleys shorten belt life. In practice, belt slip puts the real RPM 1% to 3% below the theoretical value on V-belts.</p>"),
            ],
            "faq": [
                ("How do I calculate the driven pulley RPM?", "Multiply the motor RPM by the driver pulley diameter and divide by the driven pulley diameter: N2 = N1 × D1 / D2."),
                ("Does a bigger pulley turn faster or slower?", "Slower. The larger the driven pulley relative to the driver, the lower the output RPM and the higher the torque."),
                ("Can I use inches instead of millimetres?", "Yes, as long as both pulleys use the same unit. The ratio depends only on the proportion between the diameters."),
            ],
        },
    },
    {
        "id": "belt",
        "defaults": {"D": "200", "d": "100", "C": "500"},
        "js": "var L=2*C+1.57*(D+d)+Math.pow(D-d,2)/(4*C);out(T.r,fmt(L)+' mm');",
        "related": ["rpm", "ratio"],
        "pt": {
            "slug": "comprimento-correia",
            "title": "Calculadora de Comprimento de Correia e Distância entre Centros | ASCLABS",
            "desc": "Calcule o comprimento da correia a partir dos diâmetros das polias e da distância entre centros, ou o inverso. Fórmula aberta com exemplo resolvido.",
            "h1": "Calculadora de comprimento de correia",
            "intro": "Informe o diâmetro das duas polias e a distância entre os centros para obter o comprimento aproximado da correia aberta. No app você também descobre a distância ou um diâmetro a partir do comprimento.",
            "labels": {"D": "Polia maior (D, mm)", "d": "Polia menor (d, mm)", "C": "Distância entre centros (C, mm)"},
            "T": {"r": "Comprimento da correia (L)"},
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
        },
        "es": {
            "slug": "longitud-correa",
            "title": "Calculadora de Longitud de Correa y Distancia entre Centros | ASCLABS",
            "desc": "Calcula la longitud de la correa a partir de los diámetros de las poleas y la distancia entre centros, o al revés. Fórmula de correa abierta con ejemplo resuelto.",
            "h1": "Calculadora de longitud de correa",
            "intro": "Indica el diámetro de las dos poleas y la distancia entre centros para obtener la longitud aproximada de la correa abierta. En la app también puedes hallar la distancia o un diámetro a partir de la longitud.",
            "labels": {"D": "Polea mayor (D, mm)", "d": "Polea menor (d, mm)", "C": "Distancia entre centros (C, mm)"},
            "T": {"r": "Longitud de la correa (L)"},
            "sections": [
                ("Fórmula de la longitud de la correa", "<p>Para correa abierta (las dos poleas giran en el mismo sentido), la fórmula aproximada más usada es:</p><p class=\"formula\">L = 2C + 1,57 × (D + d) + (D − d)² / (4C)</p><p>Donde <strong>L</strong> es la longitud de la correa, <strong>C</strong> la distancia entre los centros de los ejes, <strong>D</strong> el diámetro de la polea mayor y <strong>d</strong> el de la menor. Es válida cuando la distancia entre centros es mucho mayor que la diferencia entre diámetros.</p>"),
                ("Ejemplo resuelto", "<p>Poleas de <strong>200 mm</strong> y <strong>100 mm</strong> con <strong>500 mm</strong> entre centros:</p><p class=\"formula\">L = 2×500 + 1,57×(200+100) + (200−100)² / (4×500)<br>L = 1000 + 471 + 5 = 1476 mm</p><p>Elige la correa estándar de longitud más cercana y ajusta la distancia entre centros para tensarla.</p>"),
                ("Distancia entre centros mínima y máxima", "<p>Como regla práctica, mantén la distancia entre centros entre <strong>0,7 × (D + d)</strong> y <strong>2 × (D + d)</strong>. Si es muy corta, se reduce el ángulo de abrazamiento y la correa patina; si es muy larga, aparecen vibraciones. Deja siempre margen de ajuste para instalar y tensar la correa.</p>"),
            ],
            "faq": [
                ("¿Cómo calcular la longitud de una correa?", "Usa L = 2C + 1,57(D + d) + (D − d)² / 4C, donde C es la distancia entre centros y D y d los diámetros de las poleas."),
                ("¿La fórmula sirve para correa en V y correa dentada?", "Sirve como aproximación para ambas. La longitud final se redondea al tamaño estándar del fabricante y, en la dentada, hay que revisar el paso."),
                ("¿Cómo hallar la distancia entre centros conociendo la correa?", "Despeja C en la fórmula de la longitud. La aplicación lo calcula dejando en blanco el campo de la distancia."),
            ],
        },
        "en": {
            "slug": "belt-length",
            "title": "Belt Length and Center Distance Calculator | ASCLABS",
            "desc": "Calculate belt length from pulley diameters and center distance, or the reverse. Open-belt formula with a worked example.",
            "h1": "Belt length calculator",
            "intro": "Enter both pulley diameters and the center distance to get the approximate open-belt length. In the app you can also solve for the center distance or a diameter from the belt length.",
            "labels": {"D": "Large pulley (D, mm)", "d": "Small pulley (d, mm)", "C": "Center distance (C, mm)"},
            "T": {"r": "Belt length (L)"},
            "sections": [
                ("Belt length formula", "<p>For an open belt (both pulleys turning the same way), the most common approximate formula is:</p><p class=\"formula\">L = 2C + 1.57 × (D + d) + (D − d)² / (4C)</p><p>Where <strong>L</strong> is the belt length, <strong>C</strong> the distance between shaft centers, <strong>D</strong> the large pulley diameter and <strong>d</strong> the small one. It holds when the center distance is much larger than the difference between the diameters.</p>"),
                ("Worked example", "<p>Pulleys of <strong>200 mm</strong> and <strong>100 mm</strong> with <strong>500 mm</strong> between centers:</p><p class=\"formula\">L = 2×500 + 1.57×(200+100) + (200−100)² / (4×500)<br>L = 1000 + 471 + 5 = 1476 mm</p><p>Pick the standard belt with the closest length and adjust the center distance to tension it.</p>"),
                ("Minimum and maximum center distance", "<p>As a rule of thumb, keep the center distance between <strong>0.7 × (D + d)</strong> and <strong>2 × (D + d)</strong>. Too short reduces the wrap angle and the belt slips; too long causes vibration. Always leave adjustment travel to install and tension the belt.</p>"),
            ],
            "faq": [
                ("How do I calculate belt length?", "Use L = 2C + 1.57(D + d) + (D − d)² / 4C, where C is the center distance and D and d are the pulley diameters."),
                ("Does the formula work for V-belts and timing belts?", "It is a good approximation for both. Round the result to the manufacturer's standard length, and check the pitch for timing belts."),
                ("How do I find the center distance from a known belt?", "Solve the length formula for C. The app does this when you leave the distance field blank."),
            ],
        },
    },
    {
        "id": "ratio",
        "defaults": {"d1": "100", "d2": "200"},
        "js": "var i=d2/d1;out(T.r,'1 : '+fmt(i)+(i>1?' ('+T.red+')':i<1?' ('+T.mul+')':' ('+T.dir+')'));",
        "related": ["rpm", "belt"],
        "pt": {
            "slug": "relacao-transmissao",
            "title": "Calculadora de Relação de Transmissão de Polias | ASCLABS",
            "desc": "Calcule a relação de transmissão (i = D2/D1 = N1/N2) entre duas polias. Entenda redução e multiplicação de velocidade com exemplo resolvido.",
            "h1": "Calculadora de relação de transmissão",
            "intro": "A relação de transmissão mostra quantas voltas a polia motora dá para cada volta da movida. Informe os dois diâmetros e veja a relação e o tipo de transmissão.",
            "labels": {"d1": "Diâmetro da polia motora (D1, mm)", "d2": "Diâmetro da polia movida (D2, mm)"},
            "T": {"r": "Relação de transmissão (i)", "red": "redução", "mul": "multiplicação", "dir": "direta"},
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
        },
        "es": {
            "slug": "relacion-transmision",
            "title": "Calculadora de Relación de Transmisión de Poleas | ASCLABS",
            "desc": "Calcula la relación de transmisión (i = D2/D1 = N1/N2) entre dos poleas. Entiende la reducción y la multiplicación de velocidad con un ejemplo resuelto.",
            "h1": "Calculadora de relación de transmisión",
            "intro": "La relación de transmisión indica cuántas vueltas da la polea motriz por cada vuelta de la conducida. Introduce los dos diámetros y verás la relación y el tipo de transmisión.",
            "labels": {"d1": "Diámetro de la polea motriz (D1, mm)", "d2": "Diámetro de la polea conducida (D2, mm)"},
            "T": {"r": "Relación de transmisión (i)", "red": "reducción", "mul": "multiplicación", "dir": "directa"},
            "sections": [
                ("Fórmula de la relación de transmisión", "<p class=\"formula\">i = D2 / D1 = N1 / N2</p><p>Cuando <strong>i &gt; 1</strong> la polea conducida es mayor: hay <em>reducción</em> de velocidad y ganancia de par. Cuando <strong>i &lt; 1</strong> hay <em>multiplicación</em> de velocidad y pérdida de par. Con <strong>i = 1</strong> ambas poleas giran a la misma velocidad.</p>"),
                ("Ejemplo resuelto", "<p>Polea motriz de <strong>100 mm</strong> y conducida de <strong>200 mm</strong>:</p><p class=\"formula\">i = 200 / 100 = 2, es decir, 1 : 2</p><p>Con un motor de 1750 RPM, la salida es 1750 / 2 = <strong>875 RPM</strong> y el par de salida es aproximadamente el doble del del motor, descontando pérdidas.</p>"),
                ("Transmisiones en etapas", "<p>Cuando la reducción necesaria es grande (más de 6:1 u 8:1 en correas), divídela en dos etapas. La relación total es el producto de las relaciones de cada etapa: <strong>i total = i1 × i2</strong>. Así las poleas mantienen un tamaño razonable y se conserva el ángulo de abrazamiento.</p>"),
            ],
            "faq": [
                ("¿Qué significa una relación de transmisión 1:2?", "La polea motriz da dos vueltas por cada vuelta de la conducida: la velocidad se reduce a la mitad y el par se duplica, sin contar pérdidas."),
                ("¿Qué diferencia hay entre reducción y multiplicación?", "En la reducción la polea conducida es mayor (i > 1) y gira más despacio. En la multiplicación es menor (i < 1) y gira más rápido."),
                ("¿Cómo calcular la relación de transmisión con las RPM?", "Divide las RPM de la polea motriz entre las de la conducida: i = N1 / N2."),
            ],
        },
        "en": {
            "slug": "drive-ratio",
            "title": "Pulley Drive Ratio Calculator | ASCLABS",
            "desc": "Calculate the drive ratio (i = D2/D1 = N1/N2) between two pulleys. Understand speed reduction and speed increase with a worked example.",
            "h1": "Pulley drive ratio calculator",
            "intro": "The drive ratio tells you how many turns the driver pulley makes for each turn of the driven one. Enter both diameters to see the ratio and the type of drive.",
            "labels": {"d1": "Driver pulley diameter (D1, mm)", "d2": "Driven pulley diameter (D2, mm)"},
            "T": {"r": "Drive ratio (i)", "red": "reduction", "mul": "speed increase", "dir": "direct"},
            "sections": [
                ("Drive ratio formula", "<p class=\"formula\">i = D2 / D1 = N1 / N2</p><p>When <strong>i &gt; 1</strong> the driven pulley is larger: speed is <em>reduced</em> and torque increases. When <strong>i &lt; 1</strong> speed <em>increases</em> and torque drops. With <strong>i = 1</strong> both pulleys turn at the same speed.</p>"),
                ("Worked example", "<p>Driver pulley of <strong>100 mm</strong> and driven pulley of <strong>200 mm</strong>:</p><p class=\"formula\">i = 200 / 100 = 2, that is, 1 : 2</p><p>With a 1750 RPM motor, the output is 1750 / 2 = <strong>875 RPM</strong>, and output torque is roughly twice the motor torque, minus losses.</p>"),
                ("Multi-stage drives", "<p>When the required reduction is large (above 6:1 or 8:1 for belts), split it into two stages. The overall ratio is the product of each stage's ratio: <strong>total i = i1 × i2</strong>. This keeps pulleys a reasonable size and preserves the wrap angle.</p>"),
            ],
            "faq": [
                ("What does a 1:2 drive ratio mean?", "The driver pulley makes two turns for every turn of the driven one: speed is halved and torque doubles, ignoring losses."),
                ("What is the difference between reduction and speed increase?", "In a reduction the driven pulley is larger (i > 1) and turns slower. In a speed increase it is smaller (i < 1) and turns faster."),
                ("How do I calculate the drive ratio from RPM?", "Divide the driver pulley RPM by the driven pulley RPM: i = N1 / N2."),
            ],
        },
    },
]

CSS = """:root{--bg:#0e1014;--sf:#161a20;--bd:#262b34;--ac:#22d3ee;--tx:#f1f5f9;--mu:#8a94a6}
*{box-sizing:border-box}body{margin:0;background:var(--bg);color:var(--tx);font:16px/1.65 system-ui,-apple-system,Segoe UI,Roboto,sans-serif}
a{color:var(--ac)}main,footer{max-width:760px;margin:0 auto;padding:0 16px}
header{border-bottom:1px solid var(--bd)}header div{max-width:760px;margin:0 auto;display:flex;justify-content:space-between;align-items:center;padding:14px 16px;gap:12px}
.brand{font-weight:700;color:var(--tx);text-decoration:none}.lang a{margin-left:10px;text-decoration:none;font-size:14px}h1{font-size:28px;line-height:1.25;margin:28px 0 8px}h2{font-size:20px;margin:32px 0 8px}
p{margin:8px 0}.lead{color:var(--mu)}.card{background:var(--sf);border:1px solid var(--bd);border-radius:12px;padding:16px;margin:20px 0}
label{display:block;font-size:13px;color:var(--mu);margin:10px 0 4px}input{width:100%;padding:12px;border-radius:10px;border:1px solid var(--bd);background:var(--bg);color:var(--tx);font-size:16px}
button,.btn{display:inline-block;margin-top:14px;padding:13px 18px;border-radius:10px;border:0;background:var(--ac);color:#0e1014;font-weight:700;font-size:15px;text-decoration:none;cursor:pointer}
.btn.alt{background:transparent;color:var(--tx);border:1px solid var(--bd)}#res{margin-top:14px;min-height:24px}#res small{display:block;color:var(--mu)}#res b{font-size:26px;color:var(--ac)}
.formula{background:var(--sf);border:1px solid var(--bd);border-radius:10px;padding:12px 14px;font-family:ui-monospace,Menlo,Consolas,monospace;overflow-x:auto}
.cta{display:flex;gap:10px;flex-wrap:wrap}details{border-bottom:1px solid var(--bd);padding:10px 0}summary{cursor:pointer;font-weight:600}
nav.rel a{display:block;padding:8px 0}footer{color:var(--mu);font-size:13px;padding-top:28px;padding-bottom:40px}"""

BY_ID = {p["id"]: p for p in PAGES}
LANG_NAMES = {"pt": "PT", "es": "ES", "en": "EN"}


def path(lang, pid):
    return f"/{UI[lang]['prefix']}{BY_ID[pid][lang]['slug']}/"


def page_html(p, lang):
    ui, c = UI[lang], p[lang]
    url = SITE + path(lang, p["id"])
    fields = "".join(
        f'<label for="{k}">{escape(lbl)}</label><input id="{k}" inputmode="decimal" value="{p["defaults"][k]}" autocomplete="off">'
        for k, lbl in c["labels"].items()
    )
    ids = ",".join(f'"{k}"' for k in c["labels"])
    sections = "".join(f"<h2>{escape(t)}</h2>{body}" for t, body in c["sections"])
    faq_html = "".join(f"<details><summary>{escape(q)}</summary><p>{escape(a)}</p></details>" for q, a in c["faq"])
    related = "".join(f'<a href="{path(lang, r)}">{escape(BY_ID[r][lang]["h1"])}</a>' for r in p["related"])
    contact = f' <a href="mailto:{escape(CONTACT)}">{ui["contact"]}</a>' if CONTACT else ""
    alternates = "".join(
        f'<link rel="alternate" hreflang="{l}" href="{SITE}{path(l, p["id"])}">' for l in UI
    ) + f'<link rel="alternate" hreflang="x-default" href="{SITE}{path("pt", p["id"])}">'
    switch = "".join(
        f'<a href="{path(l, p["id"])}" hreflang="{l}">{LANG_NAMES[l]}</a>' for l in UI if l != lang
    )
    ld = [
        {
            "@context": "https://schema.org",
            "@type": "FAQPage",
            "mainEntity": [
                {"@type": "Question", "name": q, "acceptedAnswer": {"@type": "Answer", "text": a}}
                for q, a in c["faq"]
            ],
        },
        {
            "@context": "https://schema.org",
            "@type": "BreadcrumbList",
            "itemListElement": [
                {"@type": "ListItem", "position": 1, "name": ui["brand"], "item": SITE + "/"},
                {"@type": "ListItem", "position": 2, "name": c["h1"], "item": url},
            ],
        },
    ]
    return f"""<!DOCTYPE html>
<html lang="{ui['html']}">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>{escape(c['title'])}</title>
<meta name="description" content="{escape(c['desc'])}">
<link rel="canonical" href="{url}">
{alternates}
<meta property="og:type" content="website">
<meta property="og:title" content="{escape(c['title'])}">
<meta property="og:description" content="{escape(c['desc'])}">
<meta property="og:url" content="{url}">
<meta property="og:image" content="{SITE}/icons/Icon-512.png">
<meta name="theme-color" content="#0e1014">
<link rel="icon" type="image/png" href="/favicon.png">
<style>{CSS}</style>
<script type="application/ld+json">{json.dumps(ld, ensure_ascii=False)}</script>
<script async src="https://pagead2.googleapis.com/pagead/js/adsbygoogle.js?client={PUB}" crossorigin="anonymous"></script>
</head>
<body>
<header><div><a class="brand" href="/">{escape(ui['brand'])}</a><span class="lang">{switch}<a href="{PLAY}" rel="noopener">{escape(ui['app'])}</a></span></div></header>
<main>
<h1>{escape(c['h1'])}</h1>
<p class="lead">{escape(c['intro'])}</p>
<div class="card">
{fields}
<button id="go" type="button">{ui['calc']}</button>
<div id="res" aria-live="polite"></div>
</div>
<div class="cta">
<a class="btn" href="/">{escape(ui['open'])}</a>
<a class="btn alt" href="{PLAY}" rel="noopener">{escape(ui['play'])}</a>
</div>
{sections}
<h2>{escape(ui['faq'])}</h2>
{faq_html}
<h2>{escape(ui['other'])}</h2>
<nav class="rel">{related}</nav>
</main>
<footer>{escape(ui['foot'])}{contact}</footer>
<script>
(function(){{
var ids=[{ids}],T={json.dumps(c['T'], ensure_ascii=False)},MSG={json.dumps(ui['fill'], ensure_ascii=False)};
function fmt(x){{return isFinite(x)?(Math.round(x*100)/100).toLocaleString('{ui['num']}'):'—'}}
function out(l,v){{document.getElementById('res').innerHTML='<small>'+l+'</small><b>'+v+'</b>'}}
function run(){{
var v={{}};ids.forEach(function(k){{v[k]=parseFloat(String(document.getElementById(k).value).replace(',','.'))}});
for(var k in v){{if(!(v[k]>0)){{document.getElementById('res').textContent=MSG;return}}}}
var n1=v.n1,d1=v.d1,d2=v.d2,D=v.D,d=v.d,C=v.C;
{p['js']}
}}
document.getElementById('go').addEventListener('click',run);run();
}})();
</script>
</body>
</html>
"""


def write(p, content):
    os.makedirs(os.path.dirname(p), exist_ok=True)
    with open(p, "w", encoding="utf-8", newline="\n") as f:
        f.write(content)


def main():
    sm = ['<?xml version="1.0" encoding="UTF-8"?>',
          '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:xhtml="http://www.w3.org/1999/xhtml">',
          f"  <url><loc>{SITE}/</loc></url>"]
    for p in PAGES:
        for lang in UI:
            write(os.path.join(ROOT, path(lang, p["id"]).strip("/"), "index.html"), page_html(p, lang))
            links = "".join(
                f'<xhtml:link rel="alternate" hreflang="{l}" href="{SITE}{path(l, p["id"])}"/>' for l in UI
            )
            sm.append(f"  <url><loc>{SITE}{path(lang, p['id'])}</loc>{links}</url>")
    sm.append("</urlset>\n")
    write(os.path.join(ROOT, "sitemap.xml"), "\n".join(sm))
    write(os.path.join(ROOT, "robots.txt"), f"User-agent: *\nAllow: /\n\nSitemap: {SITE}/sitemap.xml\n")
    write(os.path.join(ROOT, "ads.txt"), f"google.com, {PUB.replace('ca-', '')}, DIRECT, f08c47fec0942fa0\n")
    print("ok:", ", ".join(path(l, p["id"]) for p in PAGES for l in UI))


if __name__ == "__main__":
    main()
