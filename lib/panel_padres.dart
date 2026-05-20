import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PanelPadresScreen extends StatefulWidget {
  const PanelPadresScreen({super.key});

  @override
  State<PanelPadresScreen> createState() => _PanelPadresScreenState();
}

class _PanelPadresScreenState extends State<PanelPadresScreen> {
  int letras = 0;
  int sonidos = 0;
  int silabas = 0;
  int palabras = 0;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      setState(() => loading = false);
      return;
    }

    try {
      final data = await supabase
          .from('progreso')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      setState(() {
        letras = data?['letras'] ?? 0;
        sonidos = data?['sonidos'] ?? 0;
        silabas = data?['silabas'] ?? 0;
        palabras = data?['palabras'] ?? 0;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
    }
  }

  Widget tarjetaProgreso(
    String titulo,
    int valor,
    Color color,
    IconData icono,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.18),
                child: Icon(icono, color: color),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Text(
                "$valor%",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: valor / 100,
              minHeight: 12,
              backgroundColor: Colors.grey.shade200,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String obtenerConsejo() {
    int promedio = ((letras + sonidos + silabas + palabras) / 4).round();

    if (promedio >= 80) {
      return "Excelente progreso. Continúe reforzando las actividades diariamente.";
    }

    if (promedio >= 50) {
      return "Buen avance. Se recomienda practicar sílabas y palabras.";
    }

    return "Es recomendable realizar sesiones cortas todos los días.";
  }

  @override
  Widget build(BuildContext context) {
    int promedio = ((letras + sonidos + silabas + palabras) / 4).round();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF4F5FB),
        foregroundColor: Colors.black,
        title: const Text(
          "Panel para Padres",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // RESUMEN GENERAL
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),

                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFD6C0E9), Color(0xFFB7F3E8)],
                      ),

                      borderRadius: BorderRadius.circular(28),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Resumen general",
                          style: TextStyle(fontSize: 18, color: Colors.black54),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          "$promedio%",
                          style: const TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: LinearProgressIndicator(
                            value: promedio / 100,
                            minHeight: 12,
                            backgroundColor: Colors.white54,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    "Áreas de aprendizaje",
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 18),

                  tarjetaProgreso(
                    "Letras",
                    letras,
                    Colors.blue,
                    Icons.text_fields_rounded,
                  ),

                  const SizedBox(height: 16),

                  tarjetaProgreso(
                    "Sonidos",
                    sonidos,
                    Colors.orange,
                    Icons.volume_up_rounded,
                  ),

                  const SizedBox(height: 16),

                  tarjetaProgreso(
                    "Sílabas",
                    silabas,
                    Colors.purple,
                    Icons.menu_book_rounded,
                  ),

                  const SizedBox(height: 16),

                  tarjetaProgreso(
                    "Palabras",
                    palabras,
                    Colors.teal,
                    Icons.spellcheck_rounded,
                  ),

                  const SizedBox(height: 28),

                  // CONSEJO
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),

                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.lightbulb_rounded,
                          color: Colors.amber,
                          size: 30,
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Recomendación",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                obtenerConsejo(),
                                style: const TextStyle(
                                  color: Colors.black54,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }
}
