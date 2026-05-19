import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProgresoScreen extends StatefulWidget {
  const ProgresoScreen({super.key});

  @override
  State<ProgresoScreen> createState() => _ProgresoScreenState();
}

class _ProgresoScreenState extends State<ProgresoScreen> {
  int letras = 0;
  int sonidos = 0;
  int silabas = 0;
  int palabras = 0;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    cargarProgreso();
  }

  Future<void> cargarProgreso() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      setState(() => loading = false);
      return;
    }

    final data = await supabase
        .from('progreso')
        .select()
        .eq('user_id', user.id)
        .maybeSingle();

    if (!mounted) return;

    setState(() {
      letras = data?['letras'] ?? 0;
      sonidos = data?['sonidos'] ?? 0;
      silabas = data?['silabas'] ?? 0;
      palabras = data?['palabras'] ?? 0;
      loading = false;
    });
  }

  Widget buildBarra(String titulo, int valor, Color color) {
    final progreso = (valor / 100).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        Container(
          height: 22,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(20),
          ),
          child: FractionallySizedBox(
            widthFactor: progreso,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),

        const SizedBox(height: 5),
        Text("$valor%"),
        const SizedBox(height: 15),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mi Progreso"),
        backgroundColor: const Color(0xFFA1C1EB),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: cargarProgreso,
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildBarra("Letras", letras, Colors.green),
                  buildBarra("Sonidos", sonidos, Colors.orange),
                  buildBarra("Sílabas", silabas, Colors.purple),
                  buildBarra("Palabras", palabras, Colors.blue),
                ],
              ),
            ),
    );
  }
}
