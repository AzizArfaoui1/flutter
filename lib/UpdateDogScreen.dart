import 'package:flutter/material.dart';
import 'Dog.dart';
import 'dog_api_service.dart';

class UpdateDogScreen extends StatefulWidget {
  final Dog dog;

  UpdateDogScreen({required this.dog});

  @override
  _UpdateDogScreenState createState() => _UpdateDogScreenState();
}

class _UpdateDogScreenState extends State<UpdateDogScreen> {
  final _formKey = GlobalKey<FormState>();
  final DogApiService dogApiService = DogApiService();

  late String name;
  late double age;
  late String gender;
  late String color;
  late double weight;
  late String distance;
  late String imageUrl;
  late String description;
  late String ownerName;
  late String ownerBio;

  @override
  void initState() {
    super.initState();
    // Initialize fields with data from the passed Dog object
    name = widget.dog.name;
    age = widget.dog.age;
    gender = widget.dog.gender;
    color = widget.dog.color;
    weight = widget.dog.weight;
    distance = widget.dog.distance;
    imageUrl = widget.dog.imageUrl;
    description = widget.dog.description;
    ownerName = widget.dog.owner.name;
    ownerBio = widget.dog.owner.bio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Dog'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: name,
                decoration: InputDecoration(labelText: 'Dog Name'),
                validator: (value) => value!.isEmpty ? 'Enter a name' : null,
                onSaved: (value) => name = value!,
              ),
              TextFormField(
                initialValue: age.toString(),
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty || double.tryParse(value) == null
                        ? 'Enter a valid age'
                        : null,
                onSaved: (value) => age = double.parse(value!),
              ),
              TextFormField(
                initialValue: gender,
                decoration: InputDecoration(labelText: 'Gender'),
                validator: (value) => value!.isEmpty ? 'Enter gender' : null,
                onSaved: (value) => gender = value!,
              ),
              TextFormField(
                initialValue: color,
                decoration: InputDecoration(labelText: 'Color'),
                validator: (value) => value!.isEmpty ? 'Enter color' : null,
                onSaved: (value) => color = value!,
              ),
              TextFormField(
                initialValue: weight.toString(),
                decoration: InputDecoration(labelText: 'Weight'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty || double.tryParse(value) == null
                        ? 'Enter a valid weight'
                        : null,
                onSaved: (value) => weight = double.parse(value!),
              ),
              TextFormField(
                initialValue: distance,
                decoration: InputDecoration(labelText: 'Distance'),
                validator: (value) => value!.isEmpty ? 'Enter distance' : null,
                onSaved: (value) => distance = value!,
              ),
              TextFormField(
                initialValue: imageUrl,
                decoration: InputDecoration(labelText: 'Image URL'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter a valid image URL' : null,
                onSaved: (value) => imageUrl = value!,
              ),
              TextFormField(
                initialValue: description,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) =>
                    value!.isEmpty ? 'Enter a description' : null,
                onSaved: (value) => description = value!,
              ),
              TextFormField(
                initialValue: ownerName,
                decoration: InputDecoration(labelText: 'Owner Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter owner name' : null,
                onSaved: (value) => ownerName = value!,
              ),
              TextFormField(
                initialValue: ownerBio,
                decoration: InputDecoration(labelText: 'Owner Bio'),
                maxLines: 3,
                validator: (value) => value!.isEmpty ? 'Enter owner bio' : null,
                onSaved: (value) => ownerBio = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Update Dog'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Dog updatedDog = Dog(
        id: widget.dog.id,
        name: name,
        age: age,
        gender: gender,
        color: color,
        weight: weight,
        distance: distance,
        imageUrl: imageUrl,
        description: description,
        owner: Owner(
          name: ownerName,
          bio: ownerBio,
        ),
      );

      try {
        await dogApiService.updateDog(widget.dog.id, updatedDog);
        Navigator.pop(context); // Go back to DogListScreen
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update dog: $e')),
        );
      }
    }
  }
}
