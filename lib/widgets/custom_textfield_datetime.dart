import 'package:flutter/material.dart';
import 'package:todo_list_app/utils/helper/datetime_formatter.dart';
import 'package:todo_list_app/utils/style_util.dart';
import 'package:todo_list_app/widgets/textfield_section_clear_button.dart';
import '../utils/helper/local_notification_helper.dart';
import 'custom_textfield.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;

class CustomTextfieldDatetime extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final Function(String value) onChange;

  const CustomTextfieldDatetime({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.onChange,
  });

  @override
  State<CustomTextfieldDatetime> createState() =>
      _CustomTextfieldDatetimeState();
}

class _CustomTextfieldDatetimeState extends State<CustomTextfieldDatetime> {
  Color backgroundColor = Color.fromARGB(255, 126, 126, 126);
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
            textOnRemove: widget.onChange,
            textFieldChild: CustomTextfield(
              controller: widget.controller,
              hintText: widget.hintText,
              onChange: widget.onChange,
              readOnly: true,
              customBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
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
              onFocus: (isFocus) => setState(() {
                if (isFocus) {
                  backgroundColor = StyleUtil.c97;
                } else {
                  backgroundColor = Color.fromARGB(255, 126, 126, 126);
                }
              }),
            ),
          ),
        ),
        CustomDateTimeButton(
          backgroundColor: backgroundColor,
          controller: widget.controller,
          textFieldFocusNode: textFieldFocusNode,
        ),
      ],
    );
  }
}

class CustomDateTimeButton extends StatelessWidget {
  final Color backgroundColor;
  final TextEditingController controller;
  final FocusNode textFieldFocusNode;

  const CustomDateTimeButton({
    super.key,
    required this.backgroundColor,
    required this.controller,
    required this.textFieldFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Ink(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(18),
            bottomRight: Radius.circular(18),
          ),
        ),
        child: InkWell(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(18),
            bottomRight: Radius.circular(18),
          ),
          overlayColor: WidgetStatePropertyAll(StyleUtil.c200.withOpacity(.5)),
          onTap: () async {
            // Get Permission First
            await LocalNotificationHelper.getLocalNotificationPermission();
            if (!await LocalNotificationHelper
                .isNotificationPermissionGranted()) {
              return;
            }
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
              minTime: DateTime.now(),
              maxTime: DateTime.now().add(const Duration(days: 360 * 2)),
              onCancel: () {},
              onChanged: (date) {
                // print('change $date in time zone ' +
                //     date.timeZoneOffset.inHours.toString());
              },
              onConfirm: (date) {
                textFieldFocusNode.requestFocus();
                controller.text =
                    DateTimeFormatter.formatToString(dateTime: date);
              },
              currentTime: DateTimeFormatter.dateIsTodayAndNullChecker(
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
                color: StyleUtil.c13,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
