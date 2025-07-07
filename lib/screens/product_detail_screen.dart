import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    // Recibir el objeto Producct, enviado desde la tabla de la lista de productos
    final Product product = ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      appBar: AppBar(title: Text("Detalle del Producto")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: double.infinity, // 🔧 Esto hace que el Card ocupe todo el ancho disponible
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Código:", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(product.code),
                  SizedBox(height: 12),
                  Text("Descripción:", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(product.description),
                  SizedBox(height: 12),
                  Text("Precio:", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("\$${product.price.toStringAsFixed(2)}"),
                  SizedBox(height: 12),
                  Text("Cantidad:", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("${product.quantity} unidades"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
