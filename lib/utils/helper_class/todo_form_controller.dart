import 'package:flutter/material.dart';

class TodoFormController {
  final TextEditingController todoTitleTextController;
  final FocusNode todoTitleFocusNode;
  final TextEditingController todoDescTextController;
  final FocusNode todoDescFocusNode;
  final TextEditingController todoScheduledTextController;
  final FocusNode todoScheduledFocusNode;


  TodoFormController({
    required this.todoTitleTextController,
    required this.todoTitleFocusNode,
    required this.todoDescTextController,
    required this.todoDescFocusNode,
    required this.todoScheduledTextController,
    required this.todoScheduledFocusNode,
  });
}
