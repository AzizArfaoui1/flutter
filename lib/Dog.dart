class Dog {
  final String id;
  final String name;
  final double age;
  final String gender;
  final String color;
  final double weight;
  final String distance;
  final String imageUrl;
  final String description;
  final Owner owner;

  Dog({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.color,
    required this.weight,
    required this.distance,
    required this.imageUrl,
    required this.description,
    required this.owner,
  });

  factory Dog.fromJson(Map<String, dynamic> json) {
    return Dog(
      id: json['_id'].toString(),
      name: json['name'],
      age: json['age'].toDouble(),
      gender: json['gender'],
      color: json['color'],
      weight: json['weight'].toDouble(),
      distance: json['distance'],
      imageUrl: json['imageUrl'],
      description: json['description'],
      owner: Owner.fromJson(json['owner']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'color': color,
      'weight': weight,
      'distance': distance,
      'imageUrl': imageUrl,
      'description': description,
      'owner': owner.toJson(),
    };
  }
}

class Owner {
  final String name;
  final String bio;
  

  Owner({
    required this.name,
    required this.bio,
    
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      name: json['name'],
      bio: json['bio'],
      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'bio': bio
    };
  }
}
