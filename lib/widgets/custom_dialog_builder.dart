import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_list_app/widgets/spacing_widget.dart';

import '../models/todo.dart';
import '../screens/home/blocs/dialog_builder/dialog_builder_bloc.dart';
import '../utils/style_util.dart';

Future<void> customDialogBuilder({
  required BuildContext context,
  required Todo todo,
  required String? eventDateStart,
}) {
  final double deviceWidth = MediaQuery.sizeOf(context).width;
  final double deviceHeight = MediaQuery.sizeOf(context).height;
  final double maxWidth = 80 / 100 * deviceWidth;
  final double maxHeight = 60 / 100 * deviceHeight;

  return showDialog(
    context: context,
    builder: (context) {
      return BlocBuilder<DialogBuilderBloc, DialogBuilderState>(
        builder: (dialogBuilderContext, dialogBuilderState) {
          return Dialog(
            clipBehavior: Clip.antiAlias,
            insetPadding: EdgeInsets.zero,
            backgroundColor: StyleUtil.c13,
            shape: dialogBuilderState.isMinimized ? RoundedRectangleBorder(
              side: BorderSide(
                color: StyleUtil.c89,
                width: 0.3,
              ),
              borderRadius: BorderRadius.circular(6),
            ) : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCirc,
              constraints: BoxConstraints(
                maxHeight:
                    dialogBuilderState.isMinimized ? maxHeight : deviceHeight,
                maxWidth:
                    dialogBuilderState.isMinimized ? maxWidth : deviceWidth,
              ),
              // padding: EdgeInsets.all(26), // Padding dalam
              child: Column(
                children: [
                  DialogAppBar(
                    dialogBuilderState: dialogBuilderState,
                    onTapButtonSize: () {
                      _updateScreenSizeState(
                        dialogBuilderContext: dialogBuilderContext,
                        eventUpdate: UpdateDialogScreenSizeEvent(
                          isMinimized: !dialogBuilderState.isMinimized,
                        ),
                      );
                    },
                    onTapButtonClose: () {
                      _updateScreenSizeState(
                        dialogBuilderContext: dialogBuilderContext,
                        eventUpdate: UpdateDialogScreenSizeEvent(
                          isMinimized: true,
                        ),
                      );
                      context.pop();
                    },
                  ),
                  Expanded(
                    child: DialogContent(
                      todo: todo,
                      eventDateStart: eventDateStart,
                      dialogBuilderState: dialogBuilderState,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

void _updateScreenSizeState({
  required BuildContext dialogBuilderContext,
  required DialogBuilderEvent eventUpdate,
}) {
  dialogBuilderContext.read<DialogBuilderBloc>().add(
        eventUpdate,
      );
}

class DialogAppBar extends StatelessWidget {
  final Function() onTapButtonSize;
  final Function() onTapButtonClose;
  final DialogBuilderState dialogBuilderState;

  const DialogAppBar({
    super.key,
    required this.onTapButtonSize,
    required this.onTapButtonClose,
    required this.dialogBuilderState,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      width: double.maxFinite,
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 54,
            child: TextButton(
              onPressed: onTapButtonSize,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
                child: Icon(
                  dialogBuilderState.isMinimized ? Icons.fullscreen : Icons.fullscreen_exit,
                  key: ValueKey(dialogBuilderState.isMinimized),
                  size: 20,
                  color: StyleUtil.c255,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(right: 2),
            child: SizedBox(
              width: 54,
              child: TextButton(
                onPressed: onTapButtonClose,
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: StyleUtil.c255,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DialogContent extends StatelessWidget {
  final Todo todo;
  final String? eventDateStart;
  final DialogBuilderState dialogBuilderState;

  const DialogContent({
    super.key,
    required this.todo,
    required this.eventDateStart,
    required this.dialogBuilderState,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 26, right: 26, bottom: 26),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Section
          Container(
            constraints: const BoxConstraints(
              maxHeight: 122,
            ),
            width: double.maxFinite,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: StyleUtil.c89,
                  width: 0.3,
                ),
              ),
            ),
            padding: EdgeInsets.only(bottom: 11),
            margin: EdgeInsets.only(bottom: 12),
            child: SingleChildScrollView(
              child: SelectableText.rich(
                TextSpan(
                  children: [
                    if (todo.check)
                      TextSpan(
                        text: "[COMPLETED] ",
                        style: StyleUtil.textXLMedium.copyWith(
                          color: StyleUtil.c255,
                          height: 1.6,
                        ),
                      ),
                    TextSpan(
                      text: todo.title,
                      style: StyleUtil.textXLRegular.copyWith(
                        color: todo.check ? StyleUtil.c200 : StyleUtil.c255,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Body section
          Expanded(
            child: SelectionArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: dialogBuilderState.isMinimized ? 250 : null,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              todo.desc,
                              style: StyleUtil.textBaseRegular.copyWith(
                                color: StyleUtil.c200,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  eventDateStart != null && eventDateStart!.isNotEmpty
                      ? Container(
                          constraints: const BoxConstraints(
                            maxHeight: 125,
                          ),
                          width: double.maxFinite,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SpacingWidget(vertical: 20),
                              Text(
                                "Scheduled on ",
                                style: StyleUtil.textBaseMedium.copyWith(
                                  color: StyleUtil.c255,
                                ),
                              ),
                              const SpacingWidget(vertical: 5),
                              Text(
                                eventDateStart!,
                                style: StyleUtil.textBaseRegular.copyWith(
                                  color: StyleUtil.c200,
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
