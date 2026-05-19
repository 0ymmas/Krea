import 'package:flutter/material.dart';

class ModuloAnimado extends StatefulWidget {
  final String texto;
  final String imagen;
  final Color color;
  final Widget pantalla;

  const ModuloAnimado({
    super.key,
    required this.texto,
    required this.imagen,
    required this.color,
    required this.pantalla,
  });

  @override
  State<ModuloAnimado> createState() => _ModuloAnimadoState();
}

class _ModuloAnimadoState extends State<ModuloAnimado> {
  double escala = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          escala = 0.95;
        });
      },

      onTapUp: (_) {
        setState(() {
          escala = 1;
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => widget.pantalla),
        );
      },

      onTapCancel: () {
        setState(() {
          escala = 1;
        });
      },

      child: AnimatedScale(
        scale: escala,

        duration: const Duration(milliseconds: 120),

        child: Container(
          decoration: BoxDecoration(
            color: widget.color,
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
              Image.asset(widget.imagen, height: 55),

              const SizedBox(height: 10),

              Text(
                widget.texto,

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
      ),
    );
  }
}
