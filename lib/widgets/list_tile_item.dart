import 'package:flutter/material.dart';
import 'package:todo_list_app/widgets/custom_checkbox.dart';
import 'package:todo_list_app/widgets/spacing_widget.dart';

import '../models/todo.dart';
import '../utils/style_util.dart';

class ListTileItem extends StatelessWidget {
  final Todo todo;
  final bool? isWidgetDummy;
  final int? listItemIndex;

  const ListTileItem({
    super.key,
    required this.todo,
    this.isWidgetDummy,
    this.listItemIndex,
  }) : assert(isWidgetDummy != null || listItemIndex != null,
            "there must be at least 1 atribute declared");

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 70,
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      decoration: BoxDecoration(
        color: StyleUtil.c_13,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Leading
          CustomCheckbox(
            listItemIndex: isWidgetDummy == false ? null : listItemIndex,
            checkIsAlwaysFalse: isWidgetDummy == false ? null : isWidgetDummy,
          ),
          const SpacingWidget(horizontal: 22),
          // Body
          Flexible(
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  todo.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      StyleUtil.text_xl_Medium.copyWith(color: StyleUtil.c_255),
                ),
                Text(
                  todo.desc,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: StyleUtil.text_Base_Regular
                      .copyWith(color: StyleUtil.c_200),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
