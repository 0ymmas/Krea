import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class SilabasScreen extends StatefulWidget {
  const SilabasScreen({super.key});

  @override
  State<SilabasScreen> createState() => _SilabasScreenState();
}

class _SilabasScreenState extends State<SilabasScreen> {
  final AudioPlayer player = AudioPlayer();

  int? silabaActiva;

  final List<String> silabas = ['ma', 'me', 'mi', 'mo', 'mu'];

  Future<void> reproducir(String silaba, int index) async {
    setState(() {
      silabaActiva = index;
    });

    await player.play(AssetSource('audios/silabas/$silaba.mp3'));

    await Future.delayed(const Duration(milliseconds: 250));

    setState(() {
      silabaActiva = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5FB),

      appBar: AppBar(
        title: const Text('Sílabas'),
        backgroundColor: const Color(0xFFE3B7FF),
        elevation: 0,
        centerTitle: true,
      ),

      body: GridView.builder(
        padding: const EdgeInsets.all(20),

        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
          childAspectRatio: 0.9,
        ),

        itemCount: silabas.length,

        itemBuilder: (context, index) {
          String silaba = silabas[index];

          List<Color> colores = [
            const Color(0xFFBC93F6),
            const Color(0xFFFFE58F),
            const Color(0xFF81DAB9),
            const Color(0xFF79A6E2),
          ];

          Color colorCard = colores[index % colores.length];

          bool activa = silabaActiva == index;

          return GestureDetector(
            onTap: () {
              reproducir(silaba, index);
            },

            child: AnimatedScale(
              scale: activa ? 0.92 : 1,

              duration: const Duration(milliseconds: 150),

              curve: Curves.easeOut,

              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),

                decoration: BoxDecoration(
                  color: activa ? Colors.white : colorCard,

                  borderRadius: BorderRadius.circular(24),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: activa ? 12 : 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    AnimatedScale(
                      scale: activa ? 1.15 : 1,

                      duration: const Duration(milliseconds: 180),

                      child: Text(
                        silaba.toUpperCase(),

                        style: const TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    AnimatedScale(
                      scale: activa ? 1.2 : 1,

                      duration: const Duration(milliseconds: 150),

                      child: const Icon(
                        Icons.volume_up,
                        size: 32,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
