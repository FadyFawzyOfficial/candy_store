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

  //* 1. In the signature of the _block function, we changed the return type
  //* from void to Future<void> and marked it with the async keyword
  Future<void> _block() async {
    for (var i = 0; i < 100000; i++) {
      //* 2. Before printing the value of i, we used the await keyword and applied
      //* it to a Future.delayed constructor, passing Duration with 1ms as the
      //* delay duration.
      await Future.delayed(const Duration(microseconds: 1));
      // Don't try debugPrint which will be as asynchronous
      print('$i');
    }
  }
}
