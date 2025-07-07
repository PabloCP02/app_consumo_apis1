import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/product_edit_screen.dart';
import 'screens/register_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/product_create_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Productos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/products/create': (context) => const ProductCreateScreen(),
        '/products/view': (context) => const ProductDetailScreen(),
        '/products/edit': (context) => const ProductEditScreen(),
      },
    );
  }
}
