import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final nombreController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void registrar(BuildContext context) async {
    final supabase = Supabase.instance.client;

    String email = emailController.text.trim().toLowerCase();
    String password = passwordController.text.trim();
    String nombre = nombreController.text.trim();

    if (!email.contains('@') || !email.contains('.')) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Correo inválido')));
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Mínimo 6 caracteres')));
      return;
    }

    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        await supabase.from('usuarios').insert({
          'id': response.user!.id,
          'nombre': nombre,
          'email': email,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cuenta creada correctamente ✨')),
        );

        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo crear la cuenta')),
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
          'REGISTRO',

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
            const SizedBox(height: 50),

            campo(nombreController, 'NOMBRE'),

            const SizedBox(height: 18),

            campoEmail(emailController, 'CORREO'),

            const SizedBox(height: 18),

            campoPassword(passwordController, 'CONTRASEÑA'),

            const SizedBox(height: 50),

            SizedBox(
              width: 170,
              height: 45,

              child: ElevatedButton(
                onPressed: () => registrar(context),

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD6C0E9),
                  elevation: 0,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),

                child: const Text(
                  'REGISTRARSE',

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

  Widget campoEmail(TextEditingController controller, String hint) {
    return Container(
      height: 45,

      decoration: BoxDecoration(
        color: const Color(0xFFAEC8F5),
        borderRadius: BorderRadius.circular(20),
      ),

      child: TextField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        autocorrect: false,
        enableSuggestions: false,

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

  Widget campoPassword(TextEditingController controller, String hint) {
    return Container(
      height: 45,

      decoration: BoxDecoration(
        color: const Color(0xFFAEC8F5),
        borderRadius: BorderRadius.circular(20),
      ),

      child: TextField(
        controller: controller,
        obscureText: true,

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
