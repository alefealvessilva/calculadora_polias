// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:js_interop';

@JS('eval')
external void _eval(String script);

class WebUtils {
  static void showNativeLoader() {
    _eval("""
      (function() {
        if (document.getElementById('asclabs-loader')) return;
        
        const style = document.createElement('style');
        style.id = 'asclabs-loader-style';
        style.innerHTML = `
          #asclabs-loader {
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(5, 5, 9, 0.8);
            display: flex; flex-direction: column;
            justify-content: center; align-items: center;
            z-index: 999999;
            color: #00E5FF;
            font-family: sans-serif;
          }
          .spinner {
            width: 50px; height: 50px;
            border: 5px solid rgba(0, 229, 255, 0.1);
            border-top: 5px solid #00E5FF;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin-bottom: 20px;
          }
          @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
          }
          .loader-text { font-weight: bold; letter-spacing: 2px; font-size: 14px; }
        `;
        document.head.appendChild(style);

        const loader = document.createElement('div');
        loader.id = 'asclabs-loader';
        loader.innerHTML = `
          <div class="spinner"></div>
          <div class="loader-text">GERANDO RELATÓRIO PDF...</div>
        `;
        document.body.appendChild(loader);
      })()
    """);
  }

  static void hideNativeLoader() {
    _eval("""
      (function() {
        const loader = document.getElementById('asclabs-loader');
        if (loader) loader.remove();
        const style = document.getElementById('asclabs-loader-style');
        if (style) style.remove();
      })()
    """);
  }
}
