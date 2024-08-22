import 'package:flutter/material.dart';

import '../utils/style_util.dart';

class TextFieldSectionWithClearButton extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Widget textFieldChild;
  final Function(String value) textOnRemove;

  const TextFieldSectionWithClearButton({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.textFieldChild,
    required this.textOnRemove,
  });

  @override
  State<TextFieldSectionWithClearButton> createState() =>
      _TextFieldSectionWithClearButtonState();
}

class _TextFieldSectionWithClearButtonState
    extends State<TextFieldSectionWithClearButton> {

  late bool _hasFocus;

  @override
  void initState() {
    super.initState();
    _hasFocus = widget.focusNode.hasFocus;
    widget.focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange(){
    setState(() {
      _hasFocus = widget.focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            widget.textFieldChild,
            widget.controller.text.isNotEmpty && _hasFocus
                ? SizedBox(
                    height: 48,
                    width: constraints.maxWidth,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => setState(() {
                          widget.controller.clear();
                          widget.textOnRemove("");
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12.5),
                          height: 48,
                          width: 48,
                          child: const Icon(
                            Icons.cancel_rounded,
                            color: StyleUtil.c_delete_inactive,
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        );
      },
    );
  }
}
