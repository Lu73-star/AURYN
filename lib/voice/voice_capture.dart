/// lib/voice/voice_capture.dart
/// Sistema de captura de voz da AURYN Falante.
/// Suporta Android (via package:record) e Web (via HTML MediaRecorder).
///
/// Esta é a base que permitirá AURYN ouvir você em tempo real.

import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:record/record.dart';

/// WEB imports (só existem no modo Web)
/// Ignorados automaticamente no Android.
import 'dart:html' as html
    if (dart.library.io) 'package:auryn/voice/empty_stub.dart';

class VoiceCapture {
  static final VoiceCapture _instance = VoiceCapture._internal();
  factory VoiceCapture() => _instance;

  VoiceCapture._internal();

  final _recorder = AudioRecorder();

  bool _isListening = false;
  bool get isListening => _isListening;

  Timer? _audioTimer;

  /// StreamController para enviar bytes de áudio capturado
  final StreamController<Uint8List> audioStream =
      StreamController<Uint8List>.broadcast();

  // ---------------------------
  // ANDROID / iOS / DESKTOP
  // ---------------------------

  Future<void> startNativeCapture() async {
    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) {
      throw Exception('Sem permissão de microfone.');
    }

    _isListening = true;

    // Use stream() method for real-time audio data in record 6.x
    final stream = await _recorder.startStream(
      const RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        sampleRate: 44100,
        numChannels: 1,
      ),
    );

    // Listen to the audio stream
    stream.listen((data) {
      audioStream.add(data);
    });
  }

  // ---------------------------
  // WEB MODE (PWA)
  // ---------------------------

  html.MediaStream? _webStream;
  html.MediaRecorder? _mediaRecorder;
  html.EventListener? _webDataListener;

  Future<void> startWebCapture() async {
    try {
      _webStream = await html.window.navigator.mediaDevices!
          .getUserMedia({'audio': true});

      _mediaRecorder = html.MediaRecorder(_webStream!);
      _mediaRecorder!.start();

      _isListening = true;

      _webDataListener = (event) {
        final blob = event is html.BlobEvent ? event.data : null;
        blob?.arrayBuffer().then((buffer) {
          audioStream.add(Uint8List.view(buffer));
        });
      };

      _mediaRecorder!.addEventListener('dataavailable', _webDataListener!);
    } catch (e) {
      throw Exception('Falha ao acessar microfone no Web: $e');
    }
  }

  // ---------------------------
  // START CAPTURE (unificado)
  // ---------------------------

  Future<void> start() async {
    if (_isListening) return;

    if (kIsWeb) {
      await startWebCapture();
    } else {
      await startNativeCapture();
    }
  }

  // ---------------------------
  // STOP CAPTURE
  // ---------------------------

  Future<void> stop() async {
    _isListening = false;

    _audioTimer?.cancel();
    _audioTimer = null;

    if (kIsWeb) {
      if (_mediaRecorder != null && _webDataListener != null) {
        _mediaRecorder!.removeEventListener('dataavailable', _webDataListener!);
        _webDataListener = null;
      }
      _mediaRecorder?.stop();
      _mediaRecorder = null;
      _webStream?.getTracks().forEach((t) => t.stop());
      _webStream = null;
      return;
    }

    await _recorder.stop();
  }

  // ---------------------------
  // DISPOSE
  // ---------------------------

  Future<void> dispose() async {
    await stop();
    _audioTimer?.cancel();
    _audioTimer = null;
    await _recorder.dispose();
    await audioStream.close();
  }
}
