import 'package:flutter/material.dart';

void main() {
  runApp(const ProgressWidget());
}

class ProgressWidget extends StatelessWidget {
  const ProgressWidget({super.key});

  @override
  Widget build(context) => const MaterialApp(
      home: Scaffold(body: Center(child: CircularProgressIndicator())));
}
