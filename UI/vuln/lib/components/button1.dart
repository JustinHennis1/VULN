import 'package:flutter/material.dart';

class Button1 extends StatelessWidget {
  const Button1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: ElevatedButton(
        onPressed: () {
          scanfiles();
        },
        child: const Text("Press Me"),
      ),
    );
  }
}

void scanfiles() {}
