import 'package:flutter/material.dart';
import 'package:todo_list_app/utils/style_util.dart';

class CustomTextfield extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String value) onChange;
  final String? errorText;
  final bool? readOnly;
  final InputBorder? customBorder;
  final InputBorder? customFocusedBorder;
  final FocusNode? focusNode;
  final Function(bool value)? onFocus;

  const CustomTextfield({
    required this.controller,
    required this.hintText,
    required this.onChange,
    this.errorText,
    this.readOnly,
    this.customBorder,
    this.customFocusedBorder,
    this.focusNode,
    this.onFocus,
    super.key,
  });

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  late FocusNode? _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode;
    if (widget.focusNode != null) {
      _focusNode!.addListener(() {
        if (widget.onFocus != null) {
          widget.onFocus!(_focusNode!.hasFocus);
        }
      });
    }
  }

  @override
  void dispose() {
    if (widget.focusNode != null) {
      _focusNode!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        focusNode: _focusNode,
        readOnly: widget.readOnly ?? false,
        maxLines: 1,
        cursorColor: StyleUtil.c97,
        controller: widget.controller,
        style: StyleUtil.textXLRegular.copyWith(
          color: StyleUtil.c200,
        ),
        decoration: InputDecoration(
          // suffix: GestureDetector(
          //   onTap: () => widget.controller.clear(),
          //   child: SizedBox(
          //     height: 40,
          //     width: 40,
          //     child: const Icon(
          //       Icons.cancel_outlined,
          //       color: StyleUtil.c_delete_inactive,
          //     ),
          //   ),
          // ),
          hintText: widget.hintText,
          hintStyle: StyleUtil.textXLRegular.copyWith(
            color: StyleUtil.c89,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 25),
          border: widget.customBorder ??
              OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
          errorText: widget.errorText,
          focusedBorder: widget.customFocusedBorder ??
              OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 1,
                  color: StyleUtil.c97,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
        ),
        onChanged: widget.onChange,
      ),
    );
  }
}
