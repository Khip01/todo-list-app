import 'package:flutter/material.dart';

import '../utils/style_util.dart';

class CustomSwitch extends StatelessWidget {
  final bool? isVisible;
  final bool value;
  final Function(bool value) onChanged;

  const CustomSwitch({
    super.key,
    this.isVisible,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible ?? true,
      child: Container(
        decoration: BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(
              color: StyleUtil.c89,
              width: 0.3,
            ),
          ),
        ),
        margin: EdgeInsets.only(bottom: 7),
        padding: EdgeInsets.symmetric(horizontal: 25),
        width: double.maxFinite,
        height: 52 + 12.5,
        // 12.5 padding
        child: LayoutBuilder(builder: (context, constraints) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: Icon(
                      Icons.alarm,
                      color: StyleUtil.c255,
                    ),
                  ),
                  Text(
                    "Set Reminder Alarm",
                    style: StyleUtil.textXLRegular.copyWith(
                      color: StyleUtil.c200,
                    ),
                  ),
                ],
              ),
              Switch(
                padding: EdgeInsets.zero,
                activeColor: StyleUtil.c97,
                activeTrackColor: StyleUtil.c73,
                // trackOutlineColor: WidgetStatePropertyAll(StyleUtil.c97),
                // inactiveTrackColor: StyleUtil.c200,
                inactiveThumbColor: StyleUtil.c89,
                trackOutlineWidth: WidgetStatePropertyAll(1),
                value: value,
                onChanged: onChanged,
              ),
            ],
          );
        }),
      ),
    );
  }
}
