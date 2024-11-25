import 'package:flutter/material.dart';
import 'DogListScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dog Adoption App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: DogListScreen(),
      
    );
    
  }
}
