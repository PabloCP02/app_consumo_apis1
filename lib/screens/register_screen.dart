import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final usernameController = TextEditingController();
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

  void showDialogMessage(String title, String message, {bool isSuccess = false}){
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.pop(context);
              if(isSuccess){
                Navigator.pushReplacementNamed(context, "/login");
              }
            },
            child: const Text("Ok"),
            )
        ],
      ),
    );
  }

  void register() async {
    // Obtener el contenido dde los campos del formulario
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      showError("Todos los campos son obligatorios.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Crear instancia de la clase User
    final user = User(username: username, email: email, password: password);
    // Consumir la API de registro de usuario
    final success = await AuthService().register(user);
    setState(() {
      isLoading = false;
    });

    // Comparar si el registro fue exitoso 
    if(success){
      showDialogMessage("Registro exitoso", "Ya puedes iniciar sesión", isSuccess: true);
      Navigator.pushReplacementNamed(context, "/login");
    }else{
      showDialogMessage("Fallo al registrar usuario", "No se pudo registrar el usuario");
    }

    Navigator.pushReplacementNamed(context, "/login");
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrarse")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: "Nombre de usuario"),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Correo electrónico"),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Contraseña"),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: register, child: const Text("Registrarse")),
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, "/login"),
              child: const Text("¿Ya tienes cuenta? Inicia sesión"),
            )
          ],
        ),
      ),
    );
  }
}
