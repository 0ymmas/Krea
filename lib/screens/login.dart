import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void entrar(BuildContext context) async {
    final supabase = Supabase.instance.client;

    String email = emailController.text.trim().toLowerCase();
    String password = passwordController.text.trim();

    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        final data = await supabase
            .from('usuarios')
            .select('nombre')
            .eq('id', response.user!.id)
            .maybeSingle();

        String nombre = data?['nombre'] ?? 'Usuario';

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen(nombre: nombre)),
        );
      }
    } catch (e) {
      print(e);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF4F5FB),
        foregroundColor: Colors.black,
        centerTitle: true,

        title: const Text(
          'INICIAR SESIÓN',

          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),

        child: Column(
          children: [
            const SizedBox(height: 60),

            campo(emailController, 'CORREO'),

            const SizedBox(height: 20),

            campo(passwordController, 'CONTRASEÑA'),

            const SizedBox(height: 50),

            SizedBox(
              width: 140,
              height: 45,

              child: ElevatedButton(
                onPressed: () => entrar(context),

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD6C0E9),
                  elevation: 0,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),

                child: const Text(
                  'ENTRAR',

                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget campo(TextEditingController controller, String hint) {
    return Container(
      height: 45,

      decoration: BoxDecoration(
        color: const Color(0xFFAEC8F5),
        borderRadius: BorderRadius.circular(20),
      ),

      child: TextField(
        controller: controller,
        obscureText: hint == 'CONTRASEÑA',

        decoration: InputDecoration(
          hintText: hint,

          hintStyle: const TextStyle(
            color: Colors.black54,
            letterSpacing: 2,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),

          border: InputBorder.none,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
