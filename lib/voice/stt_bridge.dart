/// lib/voice/stt_bridge.dart
/// Speech-to-Text para AURYN Falante - OFFLINE ONLY
/// Modo completamente offline, sem dependências de rede.
/// 
/// TODO: Future implementation with local STT models (e.g., Vosk, Whisper.cpp)

import 'dart:typed_data';

class STTBridge {
  static final STTBridge _instance = STTBridge._internal();
  factory STTBridge() => _instance;
  STTBridge._internal();

  /// Processa áudio e retorna texto (offline mode only)
  Future<String> transcribe(Uint8List audioBytes) async {
    // Offline fallback placeholder
    // In future modules, implement local STT models
    return _offlineFallback(audioBytes);
  }

  /// Offline fallback - returns placeholder
  String _offlineFallback(Uint8List audioBytes) {
    // Placeholder for offline STT
    // Future: Integrate local speech recognition models
    // Options: Vosk, Whisper.cpp, or speech_to_text plugin
    return "Processando sua fala...";
  }
}
