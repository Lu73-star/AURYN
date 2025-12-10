/// lib/auryn_core/radio/radio_state.dart
/// Define os estados possíveis do módulo Rádio Falante.
/// Estados incluem: carregamento, offline, erro, reproduzindo e pausado.

/// Enum representando os estados do rádio
enum RadioState {
  /// Estado inicial ou durante carregamento de stream
  loading,

  /// Rádio está reproduzindo o stream
  playing,

  /// Rádio está pausado
  paused,

  /// Sem conexão ou modo offline (simulado)
  offline,

  /// Estado de erro (stream indisponível, falha, etc)
  error,
}

/// Extensão para adicionar métodos úteis ao RadioState
extension RadioStateExtension on RadioState {
  /// Verifica se o rádio está em um estado ativo (não pausado nem com erro)
  bool get isActive => this == RadioState.playing;

  /// Verifica se o rádio está em um estado de erro ou offline
  bool get hasIssue => this == RadioState.error || this == RadioState.offline;

  /// Retorna uma mensagem descritiva do estado
  String get description {
    switch (this) {
      case RadioState.loading:
        return 'Carregando stream...';
      case RadioState.playing:
        return 'Reproduzindo';
      case RadioState.paused:
        return 'Pausado';
      case RadioState.offline:
        return 'Modo offline';
      case RadioState.error:
        return 'Erro no stream';
    }
  }
}
