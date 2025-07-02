class Product {
  // Atributos
  final int id;
  final String code;
  final String description;
  final double price;
  final int quantity;

  // Constructor
  Product({
    required this.id,
    required this.code,
    required this.description,
    required this.price,
    required this.quantity,
  });

  // Método para crear un objeto de tipo Product a partir de datos JSON
  factory Product.fromJson(Map<String, dynamic> json){
    return Product(
      id: json['id'],
      code: json['code'],
      description: json['description'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
    );
  }
}