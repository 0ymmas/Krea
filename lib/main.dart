import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/inicio.dart';
import 'screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://kaoarwclmzohbutrkdyc.supabase.co',
    anonKey: 'sb_publishable_O0SoW6kfYO6hjIiC2pqLJQ_9F9E5GDO',
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final supabase = Supabase.instance.client;

  Widget pantallaActual = const InicioScreen();

  @override
  void initState() {
    super.initState();
    verificarSesion();
  }

  Future<void> verificarSesion() async {
    final session = supabase.auth.currentSession;

    if (session != null) {
      final data = await supabase
          .from('usuarios')
          .select('nombre')
          .eq('id', session.user.id)
          .maybeSingle();

      String nombre = data?['nombre'] ?? 'Usuario';

      setState(() {
        pantallaActual = HomeScreen(nombre: nombre);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: pantallaActual);
  }
}
