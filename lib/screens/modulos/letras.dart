import 'package:flutter/material.dart';

class LetrasScreen extends StatelessWidget {
  LetrasScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC5D5FF),

      appBar: AppBar(
        title: const Text('Letras'),
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

          return Container(
            decoration: BoxDecoration(
              color: colorCard,
              borderRadius: BorderRadius.circular(20),

              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: const Offset(4, 4),
                  blurRadius: 6,
                ),
              ],
            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Image.asset('assets/imagenes/$letra.png', height: 60),

                const SizedBox(height: 10),

                Text(
                  letra.toUpperCase(),

                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
