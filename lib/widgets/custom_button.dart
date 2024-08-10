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
            backgroundColor: StyleUtil.c_97,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            buttonText,
            style: StyleUtil.text_xl_Medium.copyWith(
              color: StyleUtil.c_255,
            ),
          ),
        ),
      ),
    );
  }
}
