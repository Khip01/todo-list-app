import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_app/screens/home/blocs/setting/setting_bloc.dart';
import 'package:todo_list_app/widgets/custom_checkbox.dart';
import 'package:todo_list_app/widgets/custom_edit_icon.dart';
import 'package:todo_list_app/widgets/spacing_widget.dart';

import '../models/todo.dart';
import '../utils/style_util.dart';

class ListTileItem extends StatelessWidget {
  final Todo todo;
  final bool? isWidgetDummy;
  final int? listItemIndex;
  final GlobalKey<AnimatedListState> listKey;
  final Function()? onTap;

  const ListTileItem({
    super.key,
    required this.todo,
    this.isWidgetDummy,
    this.listItemIndex,
    required this.listKey,
    this.onTap,
  }) : assert(isWidgetDummy != null || listItemIndex != null,
            "there must be at least 1 atribute declared");

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(
      builder: (settingBlocContext, settingBlocState) {
        return IgnorePointer(
          ignoring: isWidgetDummy == null ? false : true,
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            height: 70,
            width: double.maxFinite,
            // padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            decoration: BoxDecoration(
              color: StyleUtil.c13,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Leading
                Visibility(
                  visible: !settingBlocState.isSettingMode,
                  child: CustomCheckbox(
                    listItemIndex:
                        isWidgetDummy == false ? null : listItemIndex,
                    checkIsAlwaysFalse:
                        isWidgetDummy == false ? null : isWidgetDummy,
                  ),
                ),
                Visibility(
                  visible: settingBlocState.isSettingMode,
                  child: CustomEditIcon(
                    editedTodo: todo,
                    listKey: listKey,
                  ),
                ),
                // const SpacingWidget(horizontal: 22),
                // Body
                Flexible(
                  fit: FlexFit.tight,
                  child: GestureDetector(
                    onTap: onTap,
                    child: Container(
                      color: Colors.transparent,
                      width: double.maxFinite,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            todo.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: StyleUtil.textXLMedium.copyWith(
                              color: isTodoChecked(
                                StyleUtil.c200,
                                StyleUtil.c255,
                              ),
                              decoration: isTodoChecked(
                                TextDecoration.lineThrough,
                                null,
                              ),
                              decorationColor: StyleUtil.c255,
                              decorationThickness: 2,
                            ),
                          ),
                          Text(
                            todo.desc,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: StyleUtil.textBaseRegular.copyWith(
                              color: isTodoChecked(
                                StyleUtil.c200,
                                StyleUtil.c200,
                              ),
                              decoration: isTodoChecked(
                                TextDecoration.lineThrough,
                                null,
                              ),
                              decorationColor: StyleUtil.c255,
                              decorationThickness: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  dynamic isTodoChecked(dynamic ifCondition, dynamic elseCondition) {
    if (todo.check) {
      return ifCondition;
    } else {
      return elseCondition;
    }
  }
}
