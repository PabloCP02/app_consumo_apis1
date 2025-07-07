import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class ProductService {
  // Atributo que representa el URL base del backend
  final String baseURL = "http://192.168.1.175:3000/api";

  // Método para consumir la API que obtiene la lista de productos
  Future<List<Product>> getProducts() async {
    // Obtener el token activo
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    // Consumir la API que nos regresa la lista de productos
    final response = await http.get(
      Uri.parse("$baseURL/products"),
      headers: {"Authorization": "Bearer $token"},
    );

    // Validar el acceso a la API, si se accedió correctamente y regresa un resultado
    if(response.statusCode == 200){
      final List list = jsonDecode(response.body);
      return list.map((e) => Product.fromJson(e)).toList();
    }else{
      throw Exception("Error al obtener productos");
    }
  }

  // Método para consumir la API para registar un nuevo producto
  Future<bool> createProduct({
    required String code,
    required String description,
    required double price,
    required int quantity,
  }) async {
    // Obtener la variable global del token
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    // Acceder a la API
    final response = await http.post(
      Uri.parse("$baseURL/products"),
      headers:{
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "code": code,
        "description": description,
        "price": price,
        "quantity": quantity,
      }),
    );

    // Comparar si se accedio correctamente y se obtuvo respuesta favorable
    return response.statusCode == 200 || response.statusCode == 201;
  }

  // Método para editar un producto
  Future<bool> updateProduct({
    required int id,
    required String code,
    required String description,
    required double price,
    required int quantity,
  }) async{
    // Obtener el tokem
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    // Consumir la API de edición de un produtco
    final response = await http.patch(
      Uri.parse("$baseURL/product/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "code": code,
        "description": description,
        "price": price,
        "quantity": quantity,
      }),
    );

    // Retornar true o false si se ejecuto correctamente o no
    return response.statusCode == 200;
  } 
}