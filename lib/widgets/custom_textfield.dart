import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final TextEditingController controller;
  final Function(String value) onChange;
  final String? errorText;

  const CustomTextfield({
    required this.controller,
    required this.onChange,
    required this.errorText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        errorText: errorText,
      ),
      onChanged: onChange,
    );
  }
}
