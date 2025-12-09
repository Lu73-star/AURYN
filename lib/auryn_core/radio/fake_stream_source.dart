/// lib/auryn_core/radio/fake_stream_source.dart
/// Simulação de fonte de streaming local/placeholder.
/// Não faz conexão externa real, apenas simula o comportamento de um stream.
/// 
/// FUTURO: Este módulo pode ser estendido para:
/// - Integrar streaming real de áudio
/// - Conectar com APIs de rádio online
/// - Implementar buffer de áudio
/// - Adicionar integração com captura de voz/microfone

import 'dart:async';

/// Interface para fonte de stream de rádio
abstract class IStreamSource {
  /// Inicia o stream
  Future<void> start();

  /// Para o stream
  Future<void> stop();

  /// Pausa o stream
  Future<void> pause();

  /// Retoma o stream
  Future<void> resume();

  /// Verifica se está tocando
  bool get isPlaying;

  /// Stream de eventos de status
  Stream<String> get statusStream;
}

/// Implementação fake de fonte de streaming (placeholder)
/// Esta classe simula o comportamento de um stream sem fazer conexões reais.
class FakeStreamSource implements IStreamSource {
  bool _isPlaying = false;
  bool _isPaused = false;
  Timer? _simulationTimer;

  final StreamController<String> _statusController =
      StreamController<String>.broadcast();

  @override
  bool get isPlaying => _isPlaying && !_isPaused;

  @override
  Stream<String> get statusStream => _statusController.stream;

  /// Simula início do stream
  @override
  Future<void> start() async {
    _emitStatus('Iniciando stream fake...');
    
    // Simula um pequeno delay de carregamento
    await Future.delayed(const Duration(milliseconds: 500));
    
    _isPlaying = true;
    _isPaused = false;
    
    _emitStatus('Stream iniciado (simulado)');
    
    // Simula atividade periódica do stream
    _startSimulation();
  }

  /// Simula parada do stream
  @override
  Future<void> stop() async {
    _emitStatus('Parando stream...');
    
    _isPlaying = false;
    _isPaused = false;
    _simulationTimer?.cancel();
    _simulationTimer = null;
    
    _emitStatus('Stream parado');
  }

  /// Simula pausa do stream
  @override
  Future<void> pause() async {
    if (!_isPlaying) return;
    
    _emitStatus('Pausando stream...');
    _isPaused = true;
    _simulationTimer?.cancel();
    _emitStatus('Stream pausado');
  }

  /// Simula retomada do stream
  @override
  Future<void> resume() async {
    if (!_isPlaying || !_isPaused) return;
    
    _emitStatus('Retomando stream...');
    _isPaused = false;
    _startSimulation();
    _emitStatus('Stream retomado');
  }

  /// Simula atividade do stream (para demonstração)
  void _startSimulation() {
    _simulationTimer?.cancel();
    _simulationTimer = Timer.periodic(
      const Duration(seconds: 5),
      (timer) {
        if (_isPlaying && !_isPaused) {
          _emitStatus('Stream ativo (simulado)');
        }
      },
    );
  }

  /// Emite evento de status
  void _emitStatus(String status) {
    if (!_statusController.isClosed) {
      _statusController.add(status);
    }
  }

  /// Libera recursos
  void dispose() {
    _simulationTimer?.cancel();
    _statusController.close();
  }
}

// NOTA PARA FUTURO:
// Para integrar captura de voz/microfone, considere:
// 1. Adicionar método getAudioInput() que retorna Stream<AudioData>
// 2. Integrar com lib/voice/ para processar áudio capturado
// 3. Implementar mixer de áudio (rádio + voz do usuário)
// 4. Adicionar controle de volume independente para cada fonte
