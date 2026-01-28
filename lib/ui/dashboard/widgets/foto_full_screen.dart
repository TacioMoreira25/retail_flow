import 'dart:io';
import 'package:flutter/material.dart';

class FotoFullScreen extends StatelessWidget {
  final String imagePath;

  const FotoFullScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ), // Seta de voltar branca
        title: const Text(
          "Visualizar Comprovante",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        // InteractiveViewer permite dar zoom com os dedos (pinça)
        child: InteractiveViewer(
          panEnabled: true, // Arrastar
          minScale: 0.5,
          maxScale: 4.0, // Zoom de até 4x
          child: Image.file(File(imagePath), fit: BoxFit.contain),
        ),
      ),
    );
  }
}
