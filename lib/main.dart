import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:auryn/ui/auryn_app.dart';
import 'package:auryn/auryn_core/auryn_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o núcleo da IA antes de abrir o app
  // Se falhar, o app ainda abre mas com funcionalidade degradada
  try {
    await AURYNCore().init();
  } catch (e) {
    debugPrint('AURYN Core initialization failed: $e');
    // App continues to load with degraded functionality
  }

  runApp(const AurynApp());
}
