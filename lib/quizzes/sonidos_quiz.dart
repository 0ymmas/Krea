import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SonidosQuizScreen extends StatefulWidget {
  const SonidosQuizScreen({super.key});

  @override
  State<SonidosQuizScreen> createState() => _SonidosQuizScreenState();
}

class _SonidosQuizScreenState extends State<SonidosQuizScreen> {
  final AudioPlayer player = AudioPlayer();

  int preguntaActual = 0;
  int correctas = 0;

  final List<Map<String, dynamic>> preguntas = [
    {
      "sonido": "a",
      "respuesta": "A",
      "opciones": ["A", "E", "O"],
    },
    {
      "sonido": "m",
      "respuesta": "M",
      "opciones": ["M", "N", "S"],
    },
    {
      "sonido": "p",
      "respuesta": "P",
      "opciones": ["P", "B", "D"],
    },
    {
      "sonido": "s",
      "respuesta": "S",
      "opciones": ["S", "Z", "X"],
    },
    {
      "sonido": "l",
      "respuesta": "L",
      "opciones": ["L", "R", "T"],
    },
    {
      "sonido": "d",
      "respuesta": "D",
      "opciones": ["D", "B", "P"],
    },
    {
      "sonido": "e",
      "respuesta": "E",
      "opciones": ["E", "I", "A"],
    },
    {
      "sonido": "o",
      "respuesta": "O",
      "opciones": ["O", "U", "A"],
    },
    {
      "sonido": "u",
      "respuesta": "U",
      "opciones": ["U", "I", "E"],
    },
    {
      "sonido": "r",
      "respuesta": "R",
      "opciones": ["R", "L", "T"],
    },
  ];

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 500), () {
      reproducirSonido();
    });
  }

  Future<void> reproducirSonido() async {
    String sonido = preguntas[preguntaActual]["sonido"];

    await player.stop();
    await player.play(AssetSource('audios/$sonido.mp3'));
  }

  void responder(String opcion) {
    String correcta = preguntas[preguntaActual]["respuesta"];

    if (opcion == correcta) {
      correctas++;
    }

    if (preguntaActual < preguntas.length - 1) {
      setState(() {
        preguntaActual++;
      });

      Future.delayed(const Duration(milliseconds: 400), () {
        reproducirSonido();
      });
    } else {
      mostrarResultado();
    }
  }

  Future<void> guardarProgreso() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) return;

    int porcentaje = ((correctas / preguntas.length) * 100).round();

    //  BUSCAR PROGRESO ACTUAL
    final data = await supabase
        .from('progreso')
        .select('sonidos')
        .eq('user_id', user.id)
        .maybeSingle();

    int progresoActual = data?['sonidos'] ?? 0;

    //  SOLO ACTUALIZA SI EL NUEVO ES MAYOR
    if (porcentaje > progresoActual) {
      await supabase
          .from('progreso')
          .update({'sonidos': porcentaje})
          .eq('user_id', user.id);
    }
  }

  Future<void> mostrarResultado() async {
    await guardarProgreso();

    int porcentaje = ((correctas / preguntas.length) * 100).round();

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),

        title: const Text(
          "¡Quiz completado!",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.emoji_events_rounded,
              color: Colors.amber,
              size: 80,
            ),

            const SizedBox(height: 18),

            Text(
              "Tu puntuación fue de $porcentaje%",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: Colors.black87),
            ),
          ],
        ),

        actions: [
          SizedBox(
            width: double.infinity,

            child: ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFBC93F6),
                padding: const EdgeInsets.symmetric(vertical: 16),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),

              child: const Text(
                "Volver al inicio",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pregunta = preguntas[preguntaActual];

    return Scaffold(
      backgroundColor: const Color(0xFFC5D5FF),

      appBar: AppBar(
        title: const Text("Quiz de Sonidos"),
        backgroundColor: const Color(0xFFA1C1EB),
        elevation: 0,
        centerTitle: true,
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              const Text(
                "¿Qué letra escuchas?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Pregunta ${preguntaActual + 1} de ${preguntas.length}",
                style: const TextStyle(fontSize: 15, color: Colors.black54),
              ),

              const SizedBox(height: 45),

              GestureDetector(
                onTap: reproducirSonido,

                child: Container(
                  padding: const EdgeInsets.all(36),

                  decoration: BoxDecoration(
                    color: const Color(0xFFBC93F6),
                    shape: BoxShape.circle,

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),

                  child: const Icon(
                    Icons.volume_up_rounded,
                    color: Colors.white,
                    size: 70,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                "Toca para repetir el sonido",
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),

              const SizedBox(height: 45),

              ...pregunta["opciones"].map<Widget>((opcion) {
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 14),

                  child: ElevatedButton(
                    onPressed: () => responder(opcion),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      elevation: 4,
                      padding: const EdgeInsets.symmetric(vertical: 18),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),

                    child: Text(
                      opcion,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
