import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'inicio.dart';

class CuentaScreen extends StatefulWidget {
  const CuentaScreen({super.key});

  @override
  State<CuentaScreen> createState() => _CuentaScreenState();
}

class _CuentaScreenState extends State<CuentaScreen> {
  String nombre = 'Cargando...';

  @override
  void initState() {
    super.initState();
    obtenerNombre();
  }

  Future<void> obtenerNombre() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) return;

    final data = await Supabase.instance.client
        .from('usuarios')
        .select('nombre')
        .eq('id', user.id)
        .single();

    setState(() {
      nombre = data['nombre'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF4F5FB),
        foregroundColor: Colors.black,

        title: const Text(
          'MI CUENTA',

          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          children: [
            const SizedBox(height: 20),

            // FOTO PERFIL
            Container(
              width: 110,
              height: 110,

              decoration: BoxDecoration(
                color: const Color(0xFFDCCBFF),
                borderRadius: BorderRadius.circular(100),
              ),

              child: const Icon(Icons.person, size: 60, color: Colors.black87),
            ),

            const SizedBox(height: 30),

            // TARJETA
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),

              decoration: BoxDecoration(
                color: const Color(0xFFE5ECFF),
                borderRadius: BorderRadius.circular(25),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    'NOMBRE',

                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(nombre, style: const TextStyle(fontSize: 16)),

                  const SizedBox(height: 25),

                  const Text(
                    'ID DE USUARIO',

                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    user?.id ?? 'No disponible',

                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // BOTON CERRAR SESION
            SizedBox(
              width: double.infinity,
              height: 52,

              child: ElevatedButton(
                onPressed: () async {
                  await Supabase.instance.client.auth.signOut();

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const InicioScreen()),
                    (route) => false,
                  );
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFCACA),
                  elevation: 0,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),

                child: const Text(
                  'CERRAR SESIÓN',

                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
