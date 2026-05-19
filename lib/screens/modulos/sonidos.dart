import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class SonidosScreen extends StatefulWidget {
  const SonidosScreen({super.key});

  @override
  State<SonidosScreen> createState() => _SonidosScreenState();
}

class _SonidosScreenState extends State<SonidosScreen> {
  final AudioPlayer player = AudioPlayer();

  int? letraActiva;

  final List<String> letras = [
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    'ñ',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z',
  ];

  Future<void> reproducir(String letra, int index) async {
    setState(() {
      letraActiva = index;
    });

    await player.play(AssetSource('audios/$letra.mp3'));

    await Future.delayed(const Duration(milliseconds: 250));

    setState(() {
      letraActiva = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC5D5FF),

      appBar: AppBar(
        title: const Text('Sonidos'),
        backgroundColor: const Color(0xFFA1C1EB),
        elevation: 0,
        centerTitle: true,
      ),

      body: GridView.builder(
        padding: const EdgeInsets.all(20),

        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,

          // MÁS ALTURA PARA EVITAR OVERFLOW
          childAspectRatio: 0.75,
        ),

        itemCount: letras.length,

        itemBuilder: (context, index) {
          String letra = letras[index];

          List<Color> colores = [
            const Color(0xFFBC93F6),
            const Color(0xFFFFF599),
            const Color(0xFF81DAB9),
            const Color(0xFF79A6E2),
          ];

          Color colorCard = colores[index % colores.length];

          bool activa = letraActiva == index;

          return GestureDetector(
            onTap: () {
              reproducir(letra, index);
            },

            child: AnimatedScale(
              scale: activa ? 0.92 : 1,

              duration: const Duration(milliseconds: 150),

              curve: Curves.easeOut,

              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),

                decoration: BoxDecoration(
                  color: activa ? Colors.white : colorCard,

                  borderRadius: BorderRadius.circular(20),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: const Offset(4, 4),
                      blurRadius: activa ? 12 : 6,
                    ),
                  ],
                ),

                child: Padding(
                  padding: const EdgeInsets.all(8),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      AnimatedScale(
                        scale: activa ? 1.12 : 1,

                        duration: const Duration(milliseconds: 180),

                        child: Image.asset(
                          'assets/imagenes/$letra.png',
                          height: 50,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        letra.toUpperCase(),

                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      AnimatedScale(
                        scale: activa ? 1.2 : 1,

                        duration: const Duration(milliseconds: 150),

                        child: const Icon(
                          Icons.volume_up,
                          size: 24,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
