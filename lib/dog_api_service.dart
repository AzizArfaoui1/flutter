import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Dog.dart';

class DogApiService {
  final apiUrl = 'http://10.0.2.2:3000/dogs'; // Access host machine from the emulator

  Future<List<Dog>> fetchDogs() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((dogData) => Dog.fromJson(dogData)).toList();
    } else {
      throw Exception('Failed to load dogs');
    }
  }

  Future<void> addDog(Dog dog) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(dog.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add dog');
    }
  }

  // Update an existing dog
  Future<Dog> updateDog(String id, Dog dog) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dog.toJson()),
    );

    if (response.statusCode == 200) {
      return Dog.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update dog');
    }
  }

  // Delete a dog
  Future<void> deleteDog(String id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete dog');
    }
  }
}
