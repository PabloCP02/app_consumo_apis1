class User {
  // Atributos
  final String username;
  final String email;
  final String password;

  // Constructor
  User ({required this.username, required this.email, required this.password});

  // Método para convertir los atributos en formato JSON
  Map<String, dynamic> toJson()=>{
    "username" : username,
    "email" : email,
    "password" : password,
  };
}