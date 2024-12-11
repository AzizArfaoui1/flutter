import 'dart:io';
import 'package:flutter/material.dart';
import 'package:projectadopet/AddDogScreen.dart';
import 'package:projectadopet/DogDetailScreen.dart';
import 'package:projectadopet/UpdateDogScreen.dart';
import 'Dog.dart';
import 'dog_api_service.dart';

class DogListScreen extends StatefulWidget {
  @override
  _DogListScreenState createState() => _DogListScreenState();
}

class _DogListScreenState extends State<DogListScreen> {
  final DogApiService dogApiService = DogApiService();

  // Updated buildImage to handle network URLs
  Widget buildImage(String? imageUrl) {
  if (imageUrl == null || imageUrl.isEmpty) {
    return Icon(Icons.pets, size: 80); // Placeholder if no image
  } else if (imageUrl.startsWith('http') || imageUrl.startsWith('https')) {
    // Network URL
    return Image.network(
      imageUrl,
      width: 80,
      height: 80,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    (loadingProgress.expectedTotalBytes ?? 1)
                : null,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        // Show broken image icon if network image fails to load
        return Icon(Icons.broken_image, size: 80);
      },
    );
  } else {
    // Local asset or file path
    if (imageUrl.startsWith('/')) {
      // Check if the file exists
      final file = File(imageUrl);
      if (file.existsSync()) {
        return Image.file(
          file,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
        );
      } else {
        return Icon(Icons.broken_image, size: 80); // Broken image icon for invalid file path
      }
    } 
  }
      return Icon(Icons.broken_image, size: 80); // Handle invalid cases
    
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adopt a Dog'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddDogScreen()),
              ).then((_) {
                setState(() {});
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                icon: Icon(Icons.add),
                label: Text('Add New Dog'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddDogScreen()),
                  ).then((_) {
                    setState(() {});
                  });
                },
              ),
            ),
            FutureBuilder<List<Dog>>(
              future: dogApiService.fetchDogs(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No dogs found.'));
                }

                final dogList = snapshot.data!;
                return Column(
                  children: dogList.map((dog) {
                    return Card(
                      margin: const EdgeInsets.all(10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: buildImage(dog.imageUrl),
                              ),
                              title: Text(
                                dog.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                "${dog.age} years | ${dog.gender}\nDistance: ${dog.distance}",
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DogDetailScreen(dog: dog),
                                  ),
                                );
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton.icon(
                                  icon: Icon(Icons.edit),
                                  label: Text('Update'),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            UpdateDogScreen(dog: dog),
                                      ),
                                    ).then((_) {
                                      setState(() {});
                                    });
                                  },
                                ),
                                ElevatedButton.icon(
                                  icon: Icon(Icons.delete),
                                  label: Text('Delete'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: () => _deleteDog(dog.id),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _deleteDog(String id) async {
    try {
      await dogApiService.deleteDog(id);
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete dog: $e')),
      );
    }
  }
}
