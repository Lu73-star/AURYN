/// lib/auryn_core/radio/auryn_radio.dart
/// Módulo Rádio Falante da AURYN - Ponto de entrada principal
/// 
/// Este módulo fornece funcionalidades de rádio simuladas/mockadas
/// para a AURYN, incluindo controles de play/pause, estados e
/// simulação de streaming sem conexão externa.
///
/// Componentes:
/// - RadioState: Estados do rádio (playing, paused, loading, offline, error)
/// - RadioService: Lógica de negócio e gerenciamento de stream
/// - RadioController: Controlador para interações de UI
/// - FakeStreamSource: Simulação de fonte de streaming
/// - RadioScreen: Interface de usuário
///
/// Exemplo de uso:
/// ```dart
/// // Criar controller
/// final controller = RadioController();
/// 
/// // Iniciar reprodução
/// await controller.play();
/// 
/// // Pausar
/// await controller.pause();
/// 
/// // Parar
/// await controller.stop();
/// 
/// // Ouvir mudanças de estado
/// controller.addListener(() {
///   // Handle state changes
/// });
/// ```

library auryn_radio;

// Estados
export 'radio_state.dart';

// Fonte de stream
export 'fake_stream_source.dart';

// Serviço
export 'radio_service.dart';

// Controller
export 'radio_controller.dart';
