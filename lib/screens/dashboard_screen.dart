import 'package:flutter/material.dart';
import '../widgets/drawer_menu.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  // Variables auxiliares para manejar los campos obtenidos de la API
  List<Product> _products = [];
  List<Product> _filtered = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  // Método que actualiza el estado de la pantalla, en este caso recarga la lista de productos
  @override
  void initState(){
    super.initState();
    loadProducts();
  }

  // Método de carga de la lista de products
  Future<void> loadProducts() async{
    try{
      // Consumir la API para obtener la lista de productos
      List<Product> products = await ProductService().getProducts();
      setState(() {
        _products = products;
        _filtered = products;
        isLoading = false;
      });
    }catch(e){
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error al cargar productos")));
    }
  }

  // Método para hacer el filtrado o búsqueda de productos
  void filterProducts(String value){
    setState((){
      _filtered = _products
        .where((p) =>
          p.code.toLowerCase().contains(value.toLowerCase()) ||
          p.description.toLowerCase().contains(value.toLowerCase())
        ).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Productos")),
      drawer: DrawerMenu(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onChanged: filterProducts,
                    decoration: InputDecoration(
                      hintText: "Buscar producto...",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, "/products/create");
                  },
                  icon: Icon(Icons.add),
                  label: Text("Nuevo"),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.separated(
                      itemCount: _filtered.length,
                      separatorBuilder: (_, __) => Divider(),
                      itemBuilder: (context, index) {
                        final p = _filtered[index];
                        return ListTile(
                          title: Text("${p.code} - ${p.description}"),
                          subtitle: Text("Precio: \$${p.price}, Cantidad: ${p.quantity}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  icon: Icon(Icons.visibility),
                                  onPressed: () => Navigator.pushNamed(context, "/products/view", arguments: p)),
                              IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () => Navigator.pushNamed(context, "/products/edit", arguments: p)),
                              IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    // se agregará en el próximo paso
                                  }),
                            ],
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
