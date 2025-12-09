# Módulo Rádio Falante - AURYN

## Visão Geral

O módulo **Rádio Falante** fornece funcionalidades de rádio simuladas para a AURYN. Este é um módulo placeholder/mockado que simula comportamento de streaming sem fazer conexões externas reais.

## Estrutura

```
lib/auryn_core/radio/
├── auryn_radio.dart           # Ponto de entrada (exports)
├── radio_state.dart           # Estados do rádio
├── fake_stream_source.dart    # Simulação de streaming
├── radio_service.dart         # Lógica de negócio
└── radio_controller.dart      # Controller para UI

lib/ui/screens/radio/
└── radio_screen.dart          # Interface de usuário
```

## Componentes

### 1. RadioState (Enum)

Define os estados possíveis:
- `loading` - Carregando stream
- `playing` - Reproduzindo
- `paused` - Pausado
- `offline` - Modo offline
- `error` - Erro

### 2. FakeStreamSource

Simula fonte de streaming:
- `start()` - Inicia stream
- `stop()` - Para stream
- `pause()` - Pausa stream
- `resume()` - Retoma stream
- `isPlaying` - Verifica se está tocando
- `statusStream` - Stream de eventos

### 3. RadioService

Gerencia lógica de negócio:
- Coordena stream source
- Gerencia estados
- Trata erros
- Notifica mudanças

### 4. RadioController

Controller para UI (ChangeNotifier):
- Métodos de controle (play, pause, stop)
- Getters de estado
- Notificação de mudanças
- Integração com Provider

### 5. RadioScreen

Interface de usuário:
- Indicador visual de estado
- Controles de play/pause/stop
- Mensagens de status
- Design minimalista

## Uso Rápido

### Básico

```dart
// Importar módulo
import 'package:auryn_offline/auryn_core/radio/auryn_radio.dart';

// Criar controller
final controller = RadioController();

// Iniciar reprodução
await controller.play();

// Pausar
await controller.pause();

// Parar
await controller.stop();

// Alternar play/pause
await controller.togglePlayPause();
```

### Com Provider (Recomendado)

```dart
import 'package:provider/provider.dart';
import 'package:auryn_offline/auryn_core/radio/radio_controller.dart';

// No build da sua app
ChangeNotifierProvider(
  create: (_) => RadioController(),
  child: MyRadioWidget(),
)

// No widget
class MyRadioWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RadioController>();
    
    return Column(
      children: [
        Text(controller.statusMessage),
        ElevatedButton(
          onPressed: controller.togglePlayPause,
          child: Text(controller.isPlaying ? 'Pause' : 'Play'),
        ),
      ],
    );
  }
}
```

### Ouvindo Mudanças

```dart
final controller = RadioController();

// Adicionar listener
controller.addListener(() {
  print('Estado: ${controller.currentState}');
  print('Status: ${controller.statusMessage}');
  
  if (controller.isPlaying) {
    print('Rádio está tocando!');
  }
});
```

### Verificando Estados

```dart
final controller = RadioController();

// Verificações
if (controller.isPlaying) {
  print('Tocando');
}

if (controller.isPaused) {
  print('Pausado');
}

if (controller.isLoading) {
  print('Carregando...');
}

if (controller.hasError) {
  print('Erro!');
}

if (controller.isOffline) {
  print('Offline');
}
```

## Navegação para Tela do Rádio

```dart
import 'package:auryn_offline/ui/screens/radio/radio_screen.dart';

// Navegar
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const RadioScreen(),
  ),
);
```

## Integração com Outros Módulos

### Com AurynStates

```dart
import 'package:auryn_offline/auryn_core/states/auryn_states.dart';

final controller = RadioController();
final states = AurynStates();

// Sincronizar estado do rádio
controller.addListener(() {
  states.set('radio_playing', controller.isPlaying);
  states.set('radio_state', controller.currentState.name);
});
```

### Com Emotion Core

```dart
import 'package:auryn_offline/auryn_core/emotion/auryn_emotion.dart';

final controller = RadioController();
final emotion = AurynEmotion();

// Ajustar música baseado em emoção (futuro)
controller.addListener(() {
  if (controller.isPlaying) {
    final mood = states.get('mood');
    // Lógica para sugerir músicas baseadas no humor
  }
});
```

### Com Personality

```dart
import 'package:auryn_offline/auryn_core/personality/auryn_personality.dart';

final controller = RadioController();
final personality = AurynPersonality();

// AURYN pode comentar sobre o rádio (futuro)
if (controller.isPlaying) {
  // Gerar comentário baseado na personalidade
  print('AURYN: Que música boa!');
}
```

## Testando

### Mock do Service

```dart
// Criar mock para testes
class MockRadioService implements IRadioService {
  RadioState _state = RadioState.offline;
  final StreamController<RadioState> _controller = StreamController.broadcast();
  
  @override
  RadioState get currentState => _state;
  
  @override
  Stream<RadioState> get stateStream => _controller.stream;
  
  @override
  Future<void> play() async {
    _state = RadioState.playing;
    _controller.add(_state);
  }
  
  // ... outros métodos
}

// Usar no teste
final mockService = MockRadioService();
final controller = RadioController(radioService: mockService);
```

## Extensões Futuras

Este módulo foi projetado para ser facilmente estendido:

### 1. Streaming Real
```dart
// Criar RealStreamSource
class RealStreamSource implements IStreamSource {
  final AudioPlayer _player;
  // Implementar com package de áudio real
}
```

### 2. Lista de Estações
```dart
class RadioStation {
  final String id;
  final String name;
  final String url;
  final String genre;
}

class RadioService {
  List<RadioStation> _stations = [];
  
  void selectStation(RadioStation station) {
    // Trocar para nova estação
  }
}
```

### 3. Comandos de Voz
```dart
// Integrar com módulo de voz
voiceController.onCommand((command) {
  if (command.contains('toque o rádio')) {
    radioController.play();
  } else if (command.contains('pause')) {
    radioController.pause();
  }
});
```

### 4. Metadados
```dart
class RadioMetadata {
  final String? artist;
  final String? song;
  final String? album;
}

class RadioService {
  Stream<RadioMetadata> get metadataStream;
}
```

## Convenções

- **Estados**: Use o enum `RadioState` para representar estados
- **Interfaces**: Sempre use interfaces (`IRadioService`, `IStreamSource`) para extensibilidade
- **ChangeNotifier**: Use `ChangeNotifier` para controllers de UI
- **Provider**: Use `Provider` para gerenciamento de estado na UI
- **Async**: Todos os métodos de controle são async

## Recursos

- [Documentação Completa](../../docs/PHASE_10_RADIO_FALANTE.md)
- [RadioState](radio_state.dart)
- [RadioController](radio_controller.dart)
- [RadioService](radio_service.dart)
- [RadioScreen](../../ui/screens/radio/radio_screen.dart)

## Suporte

Para dúvidas ou problemas, consulte a documentação completa em `docs/PHASE_10_RADIO_FALANTE.md`.
