import 'package:flutter/material.dart';

class BlankScreen extends StatelessWidget {
   const BlankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      width: double.infinity,
      height: double.infinity,
    );
  }
}
