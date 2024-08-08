import 'package:flutter/material.dart';
import 'package:todo_list_app/utils/style_util.dart';

class CustomDragIcon extends StatelessWidget {
  const CustomDragIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SizedBox(
        height: 8,
        width: 40,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: StyleUtil.c_200,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
