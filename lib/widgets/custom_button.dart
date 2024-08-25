import 'package:flutter/material.dart';

import '../utils/style_util.dart';

class CustomButton extends StatelessWidget {
  final Function() onPressed;
  final String buttonText;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 14),
      child: SizedBox(
        height: 48,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: StyleUtil.c97,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            buttonText,
            style: StyleUtil.textXLMedium.copyWith(
              color: StyleUtil.c255,
            ),
          ),
        ),
      ),
    );
  }
}
