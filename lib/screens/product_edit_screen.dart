import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductEditScreen extends StatefulWidget {
  const ProductEditScreen({super.key});

  @override
  _ProductEditScreenState createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  late Product product; // Garantizar que el objeto va a estar lleno
  final codeController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  bool isLoading = false;

  // Método que se ejecuta cuando se visualiza completamente la pantalla
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Obtiene el parámetro enviado desde el dashboard screen
    product = ModalRoute.of(context)!.settings.arguments as Product;
    // Visualiza los datos en los campos del formulario de edición
    codeController.text = product.code;
    descriptionController.text = product.description;
    priceController.text = product.price.toString();
    quantityController.text = product.quantity.toString();
  }

  // Método para crear mensajes de diálogo personalizados
  void showMessage(String title, String message, {bool success = false}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (success) {
                Navigator.pushReplacementNamed(context, "/dashboard");
              }
            },
            child: Text("OK"),
          )
        ],
      ),
    );
  }

  
  // Método submit, se ejecuta cuando damos clic en el btn Guardar del formulario
  void submit() async {
    // Validar que todos los campos estén llenos
    if(
      codeController.text.isEmpty ||
      descriptionController.text.isEmpty ||
      priceController.text.isEmpty ||
      quantityController.text.isEmpty
    ){
      showMessage("Error en la captura", "Todos los campos son obligatorios");
      return;
    }

    // Activar el efecto de loading
    setState(() => isLoading = true);

    // Llamar al método updateProduct de la clase ProductService
    final success = await ProductService().updateProduct(
      id: product.id,
      code: codeController.text,
      description: descriptionController.text,
      price: double.tryParse(priceController.text) ?? 0,
      quantity: int.tryParse(quantityController.text) ?? 0,
    );

    // Desactivar el efecto de loading
    setState(() => isLoading = false);

    // Comparar si se ejecuto correctamente la actualización
    if(success){
      showMessage("Éxito", "Producto actualizado correctamente", success: true);
    }else{
      showMessage("Error", "No se pudo actualizar el producto");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Editar Producto")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: codeController,
              decoration: InputDecoration(labelText: "Código"),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: "Descripción"),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: "Precio"),
            ),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Cantidad"),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton.icon(
                    onPressed: submit,
                    icon: Icon(Icons.save),
                    label: Text("Guardar cambios"),
                  ),
          ],
        ),
      ),
    );
  }
}
