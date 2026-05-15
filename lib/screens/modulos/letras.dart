import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class LetrasScreen extends StatelessWidget {
  final AudioPlayer player = AudioPlayer();

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

  LetrasScreen({super.key});

  void reproducir(String letra) {
    player.play(AssetSource('audios/$letra.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC5D5FF),

      appBar: AppBar(
        title: Text('Letras'),
        backgroundColor: Color(0xFFA1C1EB),
        elevation: 0,
        centerTitle: true,
      ),

      body: GridView.builder(
        padding: EdgeInsets.all(20),

        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),

        itemCount: letras.length,

        itemBuilder: (context, index) {
          String letra = letras[index];

          List<Color> colores = [
            Color(0xFFBC93F6),
            Color(0xFFFFF599),
            Color(0xFF81DAB9),
            Color(0xFF79A6E2),
          ];

          Color colorCard = colores[index % colores.length];

          return GestureDetector(
            onTap: () {
              reproducir(letra);
            },

            child: Container(
              decoration: BoxDecoration(
                color: colorCard,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(4, 4),
                    blurRadius: 6,
                  ),
                ],
              ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/imagenes/$letra.png', height: 60),

                  SizedBox(height: 10),

                  Text(
                    letra.toUpperCase(),
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
