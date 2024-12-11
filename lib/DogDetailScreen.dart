import 'dart:io';
import 'package:flutter/material.dart';
import 'Dog.dart';

class DogDetailScreen extends StatelessWidget {
  final Dog dog;

  DogDetailScreen({required this.dog});

  Widget buildImage(String imagePath) {
    if (imagePath.startsWith('/')) {
      final file = File(imagePath);
      if (file.existsSync()) {
        return Image.file(
          file,
          height: 300,
          fit: BoxFit.cover,
        );
      } else {
        return Icon(Icons.broken_image, size: 300);
      }
    } else {
      return Image.asset(
        imagePath,
        height: 300,
        fit: BoxFit.cover,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(dog.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildImage(dog.imageUrl),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dog.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${dog.age} years | ${dog.gender} | ${dog.color}",
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Distance: ${dog.distance}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    dog.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Owner: ${dog.owner.name}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Owner Bio: ${dog.owner.bio}",
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
