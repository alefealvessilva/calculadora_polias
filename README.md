# Cálculo de RPM, Polias e Correias - ASCLABS Pro

Calculadora profissional desenvolvida em Flutter para engenharia mecânica e manutenção industrial. O aplicativo permite dimensionar sistemas de transmissão por polias e correias com precisão técnica e geração de relatórios PDF de alta qualidade.

## 🚀 Funcionalidades Principais

*   **Cálculo de Transmissão**: Determine RPM de saída, diâmetros de polias e relações de transmissão (N1, D1, N2, D2).
*   **Cálculo de Comprimento de Correia**: Calcule o comprimento ideal da correia ou a distância entre centros (L, C, D, d).
*   **Relatórios PDF Premium**: Geração de relatórios com layout "Dark Mode", esquema técnico desenhado matematicamente e memória de cálculo.
*   **Design Industrial**: Interface moderna baseada em Material Design 3 com estética industrial e branding ASCLABS.
*   **Multiplataforma**: Suporte completo para Web (Chrome, Edge) e Mobile (Android, iOS).

## 🛠️ Tecnologias e Arquitetura

O projeto segue os princípios de **Clean Architecture**, **SOLID** e **Clean Code**.

*   **Linguagem**: Dart 3.x
*   **Framework**: Flutter 3.x
*   **Gerenciamento de Estado**: Flutter Riverpod
*   **Estilização**: Material 3 com temas customizados
*   **Relatórios**: Pacotes `pdf` e `printing` para geração e visualização
*   **Anúncios**: Google Mobile Ads (Placeholders prontos)

## 📁 Estrutura de Pastas

```text
lib/
├── core/               # Utilitários, temas, widgets globais e ads
│   ├── ads/            # Lógica de integração com AdMob
│   ├── theme/          # Sistema de design (Cores, fontes, estilos)
│   ├── utils/          # Geradores de PDF, Conversores e Utils Web
│   └── widgets/        # Componentes reutilizáveis
├── domain/             # Regras de negócio pura (Usecases e Models)
├── presentation/       # Camada de UI (Providers, Pages e Widgets)
│   ├── pages/          # Telas principais (Home, Calculadoras, Histórico)
│   ├── providers/      # Gerenciamento de estado (Riverpod)
│   └── widgets/        # Widgets específicos de UI
└── main.dart           # Ponto de entrada
```

## ⚙️ Configurações Técnicas Importantes

*   **Geração de PDF (Web)**: Utiliza uma Isolate (via `compute`) e um Overlay nativo em JavaScript para garantir que a UI não trave durante o processamento.
*   **Unidades**: Suporte dinâmico para Milímetros (mm), Centímetros (cm) e Polegadas (in).

---
© 2026 ASCLABS - Todos os direitos reservados.
