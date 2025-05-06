import 'package:flutter/material.dart';

void main() => runApp(const ProgressWidget());

class ProgressWidget extends StatelessWidget {
  const ProgressWidget({super.key});

  @override
  Widget build(context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: GestureDetector(
            onTap: _block,
            child: const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  void _block() {
    for (var i = 0; i < 1000000; i++) {
      // Don't try debugPrint which will be as asynchronous
      print('$i');
    }
  }
}
