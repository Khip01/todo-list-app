import 'package:flutter/material.dart';
import 'package:todo_list_app/utils/helper/datetime_formatter.dart';
import 'package:todo_list_app/utils/style_util.dart';
import 'package:todo_list_app/widgets/textfield_section_clear_button.dart';
import 'custom_textfield.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
as picker;

class CustomTextfieldDatetime extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final Function(String value) textOnRemoveChange;
  final Function(DateTime date) dateButtonOnConfirm;

  const CustomTextfieldDatetime({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.textOnRemoveChange,
    required this.dateButtonOnConfirm,
  });

  @override
  State<CustomTextfieldDatetime> createState() =>
      _CustomTextfieldDatetimeState();
}

class _CustomTextfieldDatetimeState extends State<CustomTextfieldDatetime> {
  Color backgroundColor = Color.fromARGB(255, 126, 126, 126);
  double borderRadiusVal = 6;
  late FocusNode textFieldFocusNode;

  @override
  void initState() {
    super.initState();
    textFieldFocusNode = widget.focusNode;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: TextFieldSectionWithClearButton(
            controller: widget.controller,
            focusNode: widget.focusNode,
            textOnRemove: widget.textOnRemoveChange,
            textFieldChild: CustomTextfield(
              controller: widget.controller,
              hintText: widget.hintText,
              onChange: (_) {},
              readOnly: true,
              customBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  width: 0.3,
                  color: StyleUtil.c89,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6),
                  bottomLeft: Radius.circular(6),
                ),
              ),
              customFocusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: StyleUtil.c97,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                ),
              ),
              focusNode: textFieldFocusNode,
              onFocus: (isFocus) =>
                  setState(() {
                    if (isFocus) {
                      backgroundColor = StyleUtil.c97;
                      borderRadiusVal = 18;
                    } else {
                      backgroundColor = Color.fromARGB(255, 126, 126, 126);
                      borderRadiusVal = 6;
                    }
                  }),
            ),
          ),
        ),
        CustomDateTimeButton(
          backgroundColor: backgroundColor,
          borderRadiusVal: borderRadiusVal,
          controller: widget.controller,
          dateButtonOnConfirm: widget.dateButtonOnConfirm,
        ),
      ],
    );
  }
}

class CustomDateTimeButton extends StatelessWidget {
  final Color backgroundColor;
  final double borderRadiusVal;
  final TextEditingController controller;
  final Function(DateTime date) dateButtonOnConfirm;

  const CustomDateTimeButton({
    super.key,
    required this.backgroundColor,
    required this.borderRadiusVal,
    required this.controller,
    required this.dateButtonOnConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Ink(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(borderRadiusVal),
            bottomRight: Radius.circular(borderRadiusVal),
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(borderRadiusVal),
            bottomRight: Radius.circular(borderRadiusVal),
          ),
          overlayColor: WidgetStatePropertyAll(
              StyleUtil.c200.withValues(alpha: .5)),
          onTap: () async {
            // Get Scheduled Permission First
            // await LocalNotificationHelper.getLocalNotificationPermission();
            // if (!await LocalNotificationHelper
            //     .isNotificationPermissionGranted()) {
            //   return;
            // }
            picker.DatePicker.showDateTimePicker(
              context,
              theme: picker.DatePickerTheme(
                containerHeight: 310,
                itemHeight: 38,
                cancelStyle: StyleUtil.textXLMedium.copyWith(
                  color: StyleUtil.c200,
                ),
                doneStyle: StyleUtil.textXLMedium.copyWith(
                  color: StyleUtil.c97,
                ),
                backgroundColor: StyleUtil.c13,
                itemStyle: StyleUtil.textXLMedium.copyWith(
                  color: StyleUtil.c255,
                ),
              ),
              showTitleActions: true,
              minTime: DateTime.now().add(const Duration(minutes: 3)),
              maxTime: DateTime.now().add(const Duration(days: 360 * 2)),
              onCancel: () {},
              onChanged: (_) {},
              onConfirm: dateButtonOnConfirm,
              currentTime: DateTimeFormatter.dateIsMinTimeAndNullChecker(
                minTime: DateTime.now().add(const Duration(minutes: 3)),
                dateTimeStr: controller.text,
              ),
            );
          },
          child: const SizedBox(
            height: 48,
            width: 48,
            child: Center(
              child: Icon(
                Icons.notification_add,
                color: StyleUtil.c255,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
