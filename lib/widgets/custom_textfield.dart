import 'package:flutter/material.dart';
import 'package:todo_list_app/utils/style_util.dart';

class CustomTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String value) onChange;
  final String? errorText;

  const CustomTextfield({
    required this.controller,
    required this.hintText,
    required this.onChange,
    required this.errorText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        maxLines: 1,
        cursorColor: StyleUtil.c_97,
        controller: controller,
        style: StyleUtil.text_xl_Regular.copyWith(
          color: StyleUtil.c_200,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: StyleUtil.text_xl_Regular.copyWith(
            color: StyleUtil.c_89,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 25),
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 1,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          errorText: errorText,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 1,
              color: StyleUtil.c_97,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onChanged: onChange,
      ),
    );
  }
}
