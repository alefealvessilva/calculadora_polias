# Guia de Build - ASCLABS Pro

Este documento descreve como gerar as versões de distribuição (Release) para Web e Android.

## 🛠️ Pré-requisitos

*   Flutter SDK 3.12.x ou superior.
*   Java Development Kit (JDK) 11 ou 17 (para Android).
*   Chave de assinatura (Keystore) para Android (opcional para testes, obrigatória para Play Store).

---

## 🌐 Web (Produção)

Para garantir a melhor performance na geração de PDFs e estabilidade do esquema técnico, utilize o renderer **CanvasKit**.

### Comando de Build:
```bash
flutter build web --release --web-renderer canvaskit
```

### Dicas para Web:
*   Os arquivos gerados estarão em `build/web/`.
*   Certifique-se de que o servidor de hospedagem tenha suporte a HTTPS (necessário para o motor PDF).
*   Se for hospedar no **Firebase Hosting** ou **GitHub Pages**, lembre-se de configurar o `--base-href` se não for a raiz.

---

## 🤖 Android (APK e AAB)

### Gerar APK de Instalação Direta:
```bash
flutter build apk --release
```

### Gerar App Bundle (Para Google Play Store):
```bash
flutter build appbundle --release
```

### Dicas para Android:
*   O APK estará em `build/app/outputs/flutter-apk/app-release.apk`.
*   O `targetSdkVersion` está configurado para o nível 34 (Android 14) para total compatibilidade com a Play Store.
*   **Permissões**: O app solicita apenas permissão de Internet (para fontes e anúncios).

---

## 🔍 Solução de Problemas no Web

Se o app apresentar erro de `Field not initialized` ou `Context Lost` após o deploy:
1.  Verifique se o navegador suporta WebGL 2.0.
2.  Tente limpar o cache do Service Worker no navegador.
3.  Garanta que está servindo os arquivos com o MIME type correto para `.wasm` e `.js`.

---
© 2026 ASCLABS - Documentação Técnica
