# Changelog - ASCLABS Pro

Todas as mudanças notáveis neste projeto serão documentadas aqui.

## [1.0.0] - 2026-04-12

### 🚀 Novidades
*   **Gerador de PDF v3**: Novo motor de layout unificado para página única A4.
*   **Diagrama Técnico Inteligente**: Implementação de tangentes externas para desenho matemático perfeito de polias e correias.
*   **Web Native Loader**: Integração com JavaScript para exibição de spinner de carregamento persistente durante processamento pesado.

### 🛠️ Correções e Melhorias
*   **Fim do UI Freeze (Web)**: Geração de PDF movida para Isolate com delay de sincronização.
*   **Compatibilidade Multiplataforma**: Implementação de Imports Condicionais para resolver erros de compilação `dart:js` no Android.
*   **Branding Sincronizado**: Padronização de logotipos e títulos entre Web e Mobile.
*   **Correção de Fontes (Web)**: Resolução do erro `NoSuchMethodError: fontData` através de carregamento resiliente.
*   **Análise de Código**: Resolução de 10 problemas de lint (Naming conventions, Unused imports).

### 🎨 UI/UX
*   Aumento da área do esquema técnico para 160px.
*   Implementação de fundo preto total (Full Bleed) nos relatórios PDF.
*   Adição de InfoBox de orientação técnica em layouts Desktop.

---
© 2026 ASCLABS - Versionamento Semântico
