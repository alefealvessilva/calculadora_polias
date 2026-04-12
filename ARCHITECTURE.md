# Documentação de Arquitetura - ASCLABS Pro

Este projeto utiliza uma adaptação dos princípios de **Clean Architecture** e **SOLID**, focada em testabilidade e escalabilidade multiplataforma.

## 🏛️ Camadas do Sistema

### 1. Camada de Domínio (`lib/domain/`)
A camada mais interna, contendo as regras de negócio puras, sem dependências de pacotes externos ou de UI.
*   **Models**: Entidades de dados (ex: `CalculationResult`).
*   **Usecases**: Lógica de cálculo puramente matemática (ex: `CalculateTransmission`).

### 2. Camada de Apresentação (`lib/presentation/`)
Responsável pela interface do usuário e gerenciamento de estado.
*   **Pages**: Telas que utilizam `ConsumerWidget` para ouvir o estado.
*   **Providers**: Implementados com `Riverpod` para injeção de dependência e reatividade.
*   **Widgets**: Componentes visuais atômicos.

### 3. Camada de Infraestrutura/Core (`lib/core//`)
Contém implementações transversais ao sistema.
*   **Utils (PDF Engine)**: Motor de PDF desacoplado que utiliza processamento em isoladas.
*   **Theme**: Centralização de tokens de design (Cores, Fontes).
*   **Ads**: Wrapper para o Google Mobile Ads.

## 🔄 Fluxo de Dados
A comunicação segue o fluxo unidirecional:
1.  **Usuário** interage com a UI (`Presentation`).
2.  **Provider** intercepta a ação e chama um **Usecase** (`Domain`).
3.  **Usecase** realiza o processamento matemático e retorna o resultado.
4.  **Provider** atualiza o estado e a **UI** reflete a mudança.

## 🌐 Estratégia Web vs Mobile
Para lidar com as limitações de threads na Web, utilizamos:
*   **Isolates (Compute)**: Para evitar bloqueios de UI durante a geração de PDF.
*   **JS Interop**: Para prover feedback visual (Native Loader) direto na engine do navegador.
*   **Conditional Imports**: Separação de arquivos por plataforma para evitar erros de compilação em dispositivos móveis.

---
© 2026 ASCLABS - Engenharia de Software
