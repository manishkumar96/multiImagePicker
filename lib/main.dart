import 'package:flutter/material.dart';
import 'package:multi_image_picker/ui/image_picker_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: ImagePickerScreen()),
    );
  }
}
