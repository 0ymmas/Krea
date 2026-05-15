import 'package:flutter/material.dart';

import 'modulos/letras.dart';
import 'cuenta.dart';

class HomeScreen extends StatelessWidget {
  final String nombre;

  const HomeScreen({super.key, required this.nombre});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5FB),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // BOTON PERFIL
              Align(
                alignment: Alignment.topRight,

                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CuentaScreen()),
                    );
                  },

                  icon: const Icon(
                    Icons.person_rounded,
                    size: 32,
                    color: Colors.black87,
                  ),
                ),
              ),

              // LOGO
              Center(
                child: Container(
                  padding: const EdgeInsets.all(14),

                  decoration: BoxDecoration(
                    color: const Color(0xFFDDE6FF),
                    borderRadius: BorderRadius.circular(25),
                  ),

                  child: Image.asset('assets/logo.png', height: 90),
                ),
              ),

              const SizedBox(height: 25),

              // SALUDO
              Text(
                'Hola "$nombre" 👋',

                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 30),

              // MODULOS
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,

                  children: [
                    moduloCuadrado(
                      context,
                      'Letras',
                      'assets/icon.png',
                      const Color.fromARGB(255, 94, 192, 234),
                      LetrasScreen(),
                    ),

                    moduloCuadrado(
                      context,
                      'Sonidos',
                      'assets/Sonidos.png',
                      const Color(0xFFFFE58F),
                      Container(),
                    ),

                    moduloCuadrado(
                      context,
                      'Silabas',
                      'assets/silabas.png',
                      const Color(0xFFE3B7FF),
                      Container(),
                    ),

                    moduloCuadrado(
                      context,
                      'Palabras',
                      'assets/Palabras.png',
                      const Color(0xFFB7F3E8),
                      Container(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget moduloCuadrado(
    BuildContext context,
    String texto,
    String imagen,
    Color color,
    Widget pantalla,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => pantalla));
      },

      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),

          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Image.asset(imagen, height: 55),

            const SizedBox(height: 10),

            Text(
              texto,

              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
