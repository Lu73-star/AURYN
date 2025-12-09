/// lib/auryn_core/radio/radio_controller.dart
/// RadioController - Controlador para interações do usuário com o rádio.
/// Gerencia as ações de play, pause, stop e comunica com o RadioService.
/// Segue padrão de Controller para separação de concerns (UI <-> Lógica).

import 'package:flutter/foundation.dart';
import 'package:auryn/auryn_core/radio/radio_state.dart';
import 'package:auryn/auryn_core/radio/radio_service.dart';
import 'package:auryn/auryn_core/core_utils/auryn_logger.dart';

/// Controller para gerenciar interações com o rádio
/// Usa ChangeNotifier para notificar a UI de mudanças de estado
class RadioController extends ChangeNotifier {
  final IRadioService _radioService;
  RadioState _currentState = RadioState.offline;
  String _statusMessage = 'Rádio offline';

  RadioController({IRadioService? radioService})
      : _radioService = radioService ?? RadioService() {
    _initialize();
  }

  /// Estado atual do rádio
  RadioState get currentState => _currentState;

  /// Mensagem de status atual
  String get statusMessage => _statusMessage;

  /// Verifica se está tocando
  bool get isPlaying => _currentState == RadioState.playing;

  /// Verifica se está pausado
  bool get isPaused => _currentState == RadioState.paused;

  /// Verifica se está carregando
  bool get isLoading => _currentState == RadioState.loading;

  /// Verifica se está offline
  bool get isOffline => _currentState == RadioState.offline;

  /// Verifica se há erro
  bool get hasError => _currentState == RadioState.error;

  /// Inicializa o controller e escuta mudanças de estado
  void _initialize() {
    // Atualiza estado inicial
    _updateState(_radioService.currentState);

    // Escuta mudanças de estado do serviço
    _radioService.stateStream.listen(
      (state) {
        _updateState(state);
      },
      onError: (error) {
        AurynLogger().error('Radio service error', tag: 'RadioController', error: error);
        _updateState(RadioState.error);
        _statusMessage = 'Erro: $error';
        notifyListeners();
      },
    );
  }

  /// Inicia ou retoma reprodução
  Future<void> play() async {
    if (isPlaying) return;

    try {
      await _radioService.play();
    } catch (e) {
      AurynLogger().error('Falha ao iniciar reprodução', tag: 'RadioController', error: e);
      _updateState(RadioState.error);
      _statusMessage = 'Falha ao iniciar: $e';
      notifyListeners();
    }
  }

  /// Pausa reprodução
  Future<void> pause() async {
    if (!isPlaying) return;

    try {
      await _radioService.pause();
    } catch (e) {
      AurynLogger().error('Falha ao pausar reprodução', tag: 'RadioController', error: e);
      _updateState(RadioState.error);
      _statusMessage = 'Falha ao pausar: $e';
      notifyListeners();
    }
  }

  /// Para reprodução completamente
  Future<void> stop() async {
    if (isOffline) return;

    try {
      await _radioService.stop();
    } catch (e) {
      AurynLogger().error('Falha ao parar reprodução', tag: 'RadioController', error: e);
      _updateState(RadioState.error);
      _statusMessage = 'Falha ao parar: $e';
      notifyListeners();
    }
  }

  /// Alterna entre play e pause
  Future<void> togglePlayPause() async {
    if (isPlaying) {
      await pause();
    } else {
      await play();
    }
  }

  /// Atualiza o estado interno e notifica listeners
  void _updateState(RadioState state) {
    _currentState = state;
    _statusMessage = state.description;
    notifyListeners();
  }

  @override
  void dispose() {
    _radioService.dispose();
    super.dispose();
  }
}

// NOTAS PARA EXTENSÕES FUTURAS:
//
// 1. CONTROLE DE VOLUME:
//    - Adicionar setVolume(double volume)
//    - Persistir preferência de volume
//
// 2. EQUALIZER:
//    - Controles de equalização (graves, agudos, etc.)
//    - Presets de equalização
//
// 3. TIMER:
//    - Adicionar timer de desligamento automático
//    - setSleepTimer(Duration duration)
//
// 4. COMANDOS DE VOZ:
//    - Integrar com módulo de voz da AURYN
//    - Processar comandos como "play", "pause", "stop"
//    - Responder vocalmente status do rádio
//
// 5. ATALHOS:
//    - Adicionar suporte a atalhos de teclado
//    - Controle por botões de mídia do dispositivo
