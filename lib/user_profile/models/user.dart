class User{
  late String id;
  final String name;
  final String username;
  final String logo;

  User({required this.id, required this.name, required this.username, required this.logo});

  factory User.fromJson(String id, Map<String, dynamic> doc){
    return User(
      id: id, 
      name: doc['name'] as String,
      username: doc['username'] as String, 
      logo: doc['logo'] as String);
  }

  factory User.fromSPJson(Map<String, dynamic> doc){
    return User(
      id: doc['id'] as String, 
      name: doc['name'] as String,
      username: doc['username'] as String, 
      logo: doc['logo'] as String);
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'name' : name,
      'username' : username,
      'logo' : logo
    };
  }
}