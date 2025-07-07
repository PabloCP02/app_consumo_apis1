import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  void logout(BuildContext context) async {
    await AuthService().logout();
    Navigator.pushReplacementNamed(context, "/login");
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(child: Text("Menú")),
          ListTile(
            title: const Text("Registrar producto"),
            onTap: () => Navigator.pushNamed(context, "/products/create"),
          ),
          ListTile(
            title: const Text("Editar producto"),
            onTap: () => Navigator.pushNamed(context, "/"),
          ),
          ListTile(
            title: const Text("Consultar producto"),
            onTap: () => Navigator.pushNamed(context, "/"),
          ),
          ListTile(
            title: const Text("Eliminar producto"),
            onTap: () => Navigator.pushNamed(context, "/"),
          ),
          ListTile(
            title: const Text("Cerrar sesión"),
            onTap: () => logout(context),
          ),
        ],
      ),
    );
  }
}
