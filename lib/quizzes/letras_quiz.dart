import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LetrasQuizScreen extends StatefulWidget {
  const LetrasQuizScreen({super.key});

  @override
  State<LetrasQuizScreen> createState() => _LetrasQuizScreenState();
}

class _LetrasQuizScreenState extends State<LetrasQuizScreen> {
  int preguntaActual = 0;
  int correctas = 0;

  final List<Map<String, dynamic>> preguntas = [
    {
      "pregunta": "¿Qué letra es? A",
      "respuesta": "A",
      "opciones": ["A", "B", "C"],
    },
    {
      "pregunta": "¿Qué letra es? B",
      "respuesta": "B",
      "opciones": ["B", "D", "P"],
    },
    {
      "pregunta": "¿Qué letra es? C",
      "respuesta": "C",
      "opciones": ["C", "O", "G"],
    },
    {
      "pregunta": "¿Qué letra es? D",
      "respuesta": "D",
      "opciones": ["D", "B", "Q"],
    },
    {
      "pregunta": "¿Qué letra es? E",
      "respuesta": "E",
      "opciones": ["E", "F", "A"],
    },
    {
      "pregunta": "¿Qué letra es? F",
      "respuesta": "F",
      "opciones": ["F", "T", "P"],
    },
    {
      "pregunta": "¿Qué letra es? G",
      "respuesta": "G",
      "opciones": ["G", "C", "Q"],
    },
    {
      "pregunta": "¿Qué letra es? H",
      "respuesta": "H",
      "opciones": ["H", "N", "M"],
    },
    {
      "pregunta": "¿Qué letra es? I",
      "respuesta": "I",
      "opciones": ["I", "L", "J"],
    },
    {
      "pregunta": "¿Qué letra es? J",
      "respuesta": "J",
      "opciones": ["J", "I", "Y"],
    },
    {
      "pregunta": "¿Qué letra es? K",
      "respuesta": "K",
      "opciones": ["K", "X", "R"],
    },
    {
      "pregunta": "¿Qué letra es? L",
      "respuesta": "L",
      "opciones": ["L", "I", "T"],
    },
    {
      "pregunta": "¿Qué letra es? M",
      "respuesta": "M",
      "opciones": ["M", "N", "W"],
    },
    {
      "pregunta": "¿Qué letra es? N",
      "respuesta": "N",
      "opciones": ["N", "M", "H"],
    },
    {
      "pregunta": "¿Qué letra es? O",
      "respuesta": "O",
      "opciones": ["O", "Q", "C"],
    },
    {
      "pregunta": "¿Qué letra es? P",
      "respuesta": "P",
      "opciones": ["P", "R", "B"],
    },
    {
      "pregunta": "¿Qué letra es? Q",
      "respuesta": "Q",
      "opciones": ["Q", "O", "G"],
    },
    {
      "pregunta": "¿Qué letra es? R",
      "respuesta": "R",
      "opciones": ["R", "P", "K"],
    },
    {
      "pregunta": "¿Qué letra es? S",
      "respuesta": "S",
      "opciones": ["S", "Z", "X"],
    },
    {
      "pregunta": "¿Qué letra es? T",
      "respuesta": "T",
      "opciones": ["T", "F", "L"],
    },
  ];

  void responder(String opcion) {
    if (opcion == preguntas[preguntaActual]["respuesta"]) {
      correctas++;
    }

    if (preguntaActual < preguntas.length - 1) {
      setState(() {
        preguntaActual++;
      });
    } else {
      mostrarResultado();
    }
  }

  Future<void> mostrarResultado() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    int porcentaje = ((correctas / preguntas.length) * 100).round();

    if (user != null) {
      final existe = await supabase
          .from('progreso')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      if (existe == null) {
        await supabase.from('progreso').insert({
          'user_id': user.id,
          'letras': porcentaje,
        });
      } else {
        await supabase
            .from('progreso')
            .update({
              'letras': porcentaje,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('user_id', user.id);
      }
    }

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Resultado"),
        content: Text("Tu puntuación es $porcentaje%"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pregunta = preguntas[preguntaActual];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz de Letras"),
        backgroundColor: const Color(0xFFA1C1EB),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              pregunta["pregunta"],
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 30),

            ...pregunta["opciones"].map<Widget>((opcion) {
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10),
                child: ElevatedButton(
                  onPressed: () => responder(opcion),
                  child: Text(opcion),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
