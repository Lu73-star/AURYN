import 'package:flutter/material.dart';
import 'package:auryn/ui/widgets/voice_button.dart';
import 'package:auryn/ui/screens/radio/radio_screen.dart';

class AurynHomeScreen extends StatelessWidget {
  const AurynHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "AURYN Falante",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 40),

            // 🔥 Botão de voz central
            const VoiceButton(),

            const SizedBox(height: 40),
            Text(
              "Toque para falar com a AURYN",
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 60),

            // Botão para navegar ao Rádio Falante
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RadioScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.radio),
              label: const Text('Rádio Falante'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.withOpacity(0.3),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
