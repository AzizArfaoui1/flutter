import 'package:flutter/material.dart';
import 'package:projectadopet/DogDetailScreen.dart';
import 'Dog.dart';
import 'dog_list_data.dart'; // Your updated data source file

class DogListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adopt a Dog'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: dogList.length,
        itemBuilder: (context, index) {
          final dog = dogList[index];
          return GestureDetector(
            onTap: () {
              // Navigate to the Dog Details Screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DogDetailScreen(dog: dog),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.all(10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        dog.imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dog.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${dog.age} years | ${dog.gender}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dog.distance,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
