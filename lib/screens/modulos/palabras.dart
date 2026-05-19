import 'dart:math';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PalabrasScreen extends StatefulWidget {
  const PalabrasScreen({super.key});

  @override
  State<PalabrasScreen> createState() => _PalabrasScreenState();
}

class _PalabrasScreenState extends State<PalabrasScreen> {
  int puntos = 0;
  int index = 0;

  final List<Map<String, dynamic>> ejercicios = [
    {
      "silabas": ["A", "VI", "ON"],
      "respuesta": "AVION",
      "imagen": "assets/palabras/avion.png",
      "opciones": ["AVION", "CARRO", "PERRO"],
    },
    {
      "silabas": ["CA", "RRO"],
      "respuesta": "CARRO",
      "imagen": "assets/palabras/carro.png",
      "opciones": ["CARRO", "GLOBO", "LAPIZ"],
    },
    {
      "silabas": ["DE", "DO"],
      "respuesta": "DEDO",
      "imagen": "assets/palabras/dedo.png",
      "opciones": ["DEDO", "RANA", "PELOTA"],
    },
    {
      "silabas": ["GLO", "BO"],
      "respuesta": "GLOBO",
      "imagen": "assets/palabras/globo.png",
      "opciones": ["GLOBO", "PAPA", "PERRO"],
    },
    {
      "silabas": ["LA", "PIZ"],
      "respuesta": "LAPIZ",
      "imagen": "assets/palabras/lapiz.png",
      "opciones": ["LAPIZ", "CARRO", "AVION"],
    },
    {
      "silabas": ["MA", "MA"],
      "respuesta": "MAMA",
      "imagen": "assets/palabras/mamá.png",
      "opciones": ["MAMA", "PAPA", "DEDO"],
    },
    {
      "silabas": ["PA", "PA"],
      "respuesta": "PAPA",
      "imagen": "assets/palabras/papa.png",
      "opciones": ["PAPA", "GLOBO", "RANA"],
    },
    {
      "silabas": ["PE", "LO", "TA"],
      "respuesta": "PELOTA",
      "imagen": "assets/palabras/pelota.png",
      "opciones": ["PELOTA", "CARRO", "AVION"],
    },
    {
      "silabas": ["PE", "RRO"],
      "respuesta": "PERRO",
      "imagen": "assets/palabras/perro.png",
      "opciones": ["PERRO", "LAPIZ", "DEDO"],
    },
    {
      "silabas": ["RA", "NA"],
      "respuesta": "RANA",
      "imagen": "assets/palabras/rana.png",
      "opciones": ["RANA", "MAMA", "PAPA"],
    },
  ];

  void responder(String opcion) {
    final correcta = ejercicios[index]["respuesta"];

    if (opcion == correcta) {
      puntos++;
    }

    if (index < ejercicios.length - 1) {
      setState(() {
        index++;
      });
    } else {
      mostrarResultado();
    }
  }

  Future<void> guardarProgreso() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) return;

    int porcentaje = ((puntos / ejercicios.length) * 100).round();

    await supabase.from('progreso').upsert({
      'user_id': user.id,
      'palabras': porcentaje,
    });
  }

  void mostrarResultado() async {
    await guardarProgreso();

    int porcentaje = ((puntos / ejercicios.length) * 100).round();

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Resultado"),
        content: Text("Obtuviste $porcentaje%"),
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
    final ejercicio = ejercicios[index];
    List<String> silabas = List<String>.from(ejercicio["silabas"]);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Palabras"),
        backgroundColor: const Color(0xFFB7F3E8),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Forma la palabra",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: silabas.map((s) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD6C0E9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    s,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            Image.asset(ejercicio["imagen"], height: 120),

            const SizedBox(height: 30),

            ...ejercicio["opciones"].map<Widget>((opcion) {
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10),
                child: ElevatedButton(
                  onPressed: () => responder(opcion),
                  child: Text(opcion),
                ),
              );
            }).toList(),

            const SizedBox(height: 20),

            Text("Puntos: $puntos"),
          ],
        ),
      ),
    );
  }
}
