import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  // Atributo que representa el URL base del backend
  final String baseURL = 'http://172.31.99.23:3000/api'; // IP local (localhost)

  // Método registro de usuarios
  Future<bool> register(User user) async {
    final response = await http.post(
      Uri.parse("$baseURL/register"),
      headers: {"Content-Type":"application/json"},
      body: jsonEncode(user.toJson())
    );
    return response.statusCode == 201;
  }

  // Método login del usuario
  Future<String?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseURL/login"),
      headers: {"Content-type":"application/json"},
      body: jsonEncode({
        "email" : email,
        "password" : password,
      })
    );

    // Comparar si tuvo acceso correcto y si se recibe datos de respuesta
    if(response.statusCode == 200){
      return jsonDecode(response.body)["token"];
    }else{
      return null;
    }
  }

  // Método para cerrar sesión
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
  }
}