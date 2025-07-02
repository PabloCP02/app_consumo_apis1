// ignore_for_file: library_private_types_in_public_api
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  void showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text("OK"))
        ],
      ),
    );
  }

  void login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showError("Todos los campos son obligatorios.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Aquí se llamará la API (en la fase 2)
    final token = await AuthService().login(emailController.text, passwordController.text);

    setState(() {
      isLoading = false;
    });

    // Comparar si el token se creo correctamente, es decir, si es distinto de nullo
      if (token != null){
        // Crear la variable global token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", token);
        // Una vez creado el token, redirigimmos a la pantalla principal
        Navigator.pushReplacementNamed(context, "/dashboard");
      }else{
        showError("Credenciales invalidas. Intenta de nuevo");
      }

    // Future.delayed(const Duration(seconds: 2), () {
    //   setState(() {
    //     isLoading = false;
    //   });
    //   Navigator.pushReplacementNamed(context, "/dashboard");
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Iniciar Sesión")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "Correo")),
            TextField(controller: passwordController, decoration: const InputDecoration(labelText: "Contraseña"), obscureText: true),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(onPressed: login, child: const Text("Ingresar")),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, "/register"),
              child: const Text("¿No tienes cuenta? Regístrate"),
            )
          ],
        ),
      ),
    );
  }
}