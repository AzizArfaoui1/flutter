import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddDogScreen extends StatefulWidget {
  @override
  _AddDogScreenState createState() => _AddDogScreenState();
}

class _AddDogScreenState extends State<AddDogScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  int? age;
  String gender = '';
  String color = '';
  double? weight;
  String distance = '';
  String description = '';
  String ownerName = '';
  String ownerBio = '';
  String? imageUrl; // For web image URL

  // Submit form
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final response = await _uploadDogData();
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dog added successfully!')),
        );
        Navigator.pop(context); // Return to the list screen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add dog: ${response.body}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields including the image URL.')),
      );
    }
  }

  // HTTP request to upload data
  Future<http.Response> _uploadDogData() async {
    final uri = Uri.parse('http://10.0.2.2:3000/dogs'); // Replace with your API URL

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'age': age,
        'imageUrl': imageUrl, //
        'gender': gender,
        'color': color,
        'weight': weight,
        'distance': distance,
        'description': description,
        'owner': {
          'name': ownerName,
          'bio': ownerBio,
        },
      }),
    );

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Dog')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
                  onSaved: (value) => name = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Please enter an age' : null,
                  onSaved: (value) => age = int.parse(value!),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Gender'),
                  validator: (value) => value!.isEmpty ? 'Please enter gender' : null,
                  onSaved: (value) => gender = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Color'),
                  validator: (value) => value!.isEmpty ? 'Please enter color' : null,
                  onSaved: (value) => color = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Weight'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Please enter weight' : null,
                  onSaved: (value) => weight = double.parse(value!),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Distance'),
                  validator: (value) => value!.isEmpty ? 'Please enter distance' : null,
                  onSaved: (value) => distance = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) => value!.isEmpty ? 'Please enter description' : null,
                  onSaved: (value) => description = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Owner Name'),
                  validator: (value) => value!.isEmpty ? 'Please enter owner\'s name' : null,
                  onSaved: (value) => ownerName = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Owner Bio'),
                  validator: (value) => value!.isEmpty ? 'Please enter owner\'s bio' : null,
                  onSaved: (value) => ownerBio = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Image URL'),
                  validator: (value) => value!.isEmpty ? 'Please enter an image URL' : null,
                  onSaved: (value) => imageUrl = value!,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
