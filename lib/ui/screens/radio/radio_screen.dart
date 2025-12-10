/// lib/ui/screens/radio/radio_screen.dart
/// RadioScreen - Interface do usuário para o módulo Rádio Falante.
/// Tela mockada/dummy para demonstração, com controles básicos de play/pause.
///
/// FUTURO: Esta tela pode ser estendida com:
/// - Lista de estações
/// - Visualização de metadados (música tocando, artista, etc.)
/// - Controles de volume e equalização
/// - Histórico de reprodução
/// - Favoritos
/// - Integração visual com estado emocional da AURYN

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auryn/auryn_core/radio/radio_controller.dart';
import 'package:auryn/auryn_core/radio/radio_state.dart';

/// Tela principal do módulo Rádio Falante
class RadioScreen extends StatelessWidget {
  const RadioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RadioController(),
      child: const _RadioScreenContent(),
    );
  }
}

class _RadioScreenContent extends StatelessWidget {
  const _RadioScreenContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Rádio Falante',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Indicador visual de estado
            const _StateIndicator(),
            
            const SizedBox(height: 40),
            
            // Mensagem de status
            const _StatusMessage(),
            
            const SizedBox(height: 60),
            
            // Controles de play/pause
            const _PlaybackControls(),
            
            const SizedBox(height: 40),
            
            // Texto informativo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Simulação de rádio local\nSem conexão externa',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Indicador visual do estado do rádio
class _StateIndicator extends StatelessWidget {
  const _StateIndicator();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RadioController>();
    
    Color indicatorColor;
    IconData indicatorIcon;
    
    switch (controller.currentState) {
      case RadioState.playing:
        indicatorColor = Colors.green;
        indicatorIcon = Icons.radio;
        break;
      case RadioState.paused:
        indicatorColor = Colors.orange;
        indicatorIcon = Icons.pause_circle_outline;
        break;
      case RadioState.loading:
        indicatorColor = Colors.blue;
        indicatorIcon = Icons.sync;
        break;
      case RadioState.error:
        indicatorColor = Colors.red;
        indicatorIcon = Icons.error_outline;
        break;
      case RadioState.offline:
      default:
        indicatorColor = Colors.grey;
        indicatorIcon = Icons.radio_button_off;
    }
    
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: indicatorColor.withOpacity(0.2),
        border: Border.all(
          color: indicatorColor,
          width: 3,
        ),
      ),
      child: Icon(
        indicatorIcon,
        size: 60,
        color: indicatorColor,
      ),
    );
  }
}

/// Mensagem de status do rádio
class _StatusMessage extends StatelessWidget {
  const _StatusMessage();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RadioController>();
    
    return Text(
      controller.statusMessage,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

/// Controles de reprodução (play/pause/stop)
class _PlaybackControls extends StatelessWidget {
  const _PlaybackControls();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RadioController>();
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Botão Stop
        _ControlButton(
          icon: Icons.stop,
          onPressed: controller.isOffline ? null : () => controller.stop(),
          color: Colors.red,
        ),
        
        const SizedBox(width: 20),
        
        // Botão Play/Pause
        _ControlButton(
          icon: controller.isPlaying ? Icons.pause : Icons.play_arrow,
          onPressed: controller.isLoading 
              ? null 
              : () => controller.togglePlayPause(),
          color: controller.isPlaying ? Colors.orange : Colors.green,
          size: 70,
        ),
      ],
    );
  }
}

/// Botão de controle individual
class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color color;
  final double size;

  const _ControlButton({
    required this.icon,
    required this.onPressed,
    required this.color,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(size / 2),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: onPressed == null 
                ? Colors.grey.withOpacity(0.3)
                : color.withOpacity(0.2),
            border: Border.all(
              color: onPressed == null ? Colors.grey : color,
              width: 2,
            ),
          ),
          child: Icon(
            icon,
            size: size * 0.5,
            color: onPressed == null ? Colors.grey : color,
          ),
        ),
      ),
    );
  }
}

// NOTAS PARA EXTENSÕES FUTURAS DA UI:
//
// 1. LISTA DE ESTAÇÕES:
//    - Adicionar ListView com estações disponíveis
//    - Favoritos destacados
//    - Busca/filtro de estações
//
// 2. VISUALIZAÇÃO DE METADADOS:
//    - Mostrar música atual, artista, álbum
//    - Capa do álbum (quando disponível)
//    - Histórico de músicas tocadas
//
// 3. CONTROLES AVANÇADOS:
//    - Slider de volume
//    - Equalizer visual
//    - Timer de desligamento
//
// 4. INTEGRAÇÃO COM AURYN:
//    - Mostrar estado emocional da AURYN
//    - Indicar quando AURYN está "ouvindo" junto
//    - Sugestões de músicas baseadas no humor
//
// 5. ANIMAÇÕES:
//    - Pulsar do indicador quando tocando
//    - Transições suaves entre estados
//    - Visualizador de áudio (spectrum analyzer)
//
// 6. ACESSIBILIDADE:
//    - Suporte a leitor de tela
//    - Atalhos de teclado
//    - Alto contraste
