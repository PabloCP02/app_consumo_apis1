import 'package:flutter/material.dart';
import '../services/product_service.dart';

class ProductCreateScreen extends StatefulWidget {
  const ProductCreateScreen({super.key});

  @override
  _ProductCreateScreenState createState() => _ProductCreateScreenState();
}

class _ProductCreateScreenState extends State<ProductCreateScreen> {
  final codeController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();

  bool isLoading = false;

  // Método para mostrar los mensajes personalizados del formualario
  void showMessage(String title, String message, {bool success=false}){
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.pop(context);
              if(success){
                Navigator.pushReplacementNamed(context, "/dashboard");
              }
            },
            child: const Text("OK")
          )
        ],
      )
    );
  }

  // Método submit para el envio y guardado del producto
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

    setState(()=>isLoading=true);
    
    // Llamar al método en el controlador para crear un producto
    final success = await ProductService().createProduct(
      code: codeController.text,
      description: descriptionController.text,
      price: double.tryParse(priceController.text) ?? 0,
      quantity: int.tryParse(quantityController.text) ?? 0
    );

    setState(()=>isLoading=false);
    
    // Comparar si el registro fue exitoso
    if(success){
      showMessage("Éxito", "Producto registrado correctamente", success: true);
    }else{
      showMessage("Error", "No se pudo registrar el producto");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nuevo Producto")),
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
                    label: Text("Guardar"),
                  ),
          ],
        ),
      ),
    );
  }
}
