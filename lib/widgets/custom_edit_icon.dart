import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_app/widgets/modal_bottom_sheet.dart';

import '../models/todo.dart';
import '../screens/home/blocs/setting/setting_bloc.dart';
import '../utils/style_util.dart';

class CustomEditIcon extends StatelessWidget {
  final Todo editedTodo;
  final GlobalKey<AnimatedListState> listKey;

  const CustomEditIcon({
    super.key,
    required this.editedTodo,
    required this.listKey,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(
      builder: (todoBlocContext, todoBlocState) {
        return InkWell(
          onTap: () {
            showCustomModalBottomSheet(
              context: context,
              editedTodo: editedTodo,
              todoBlocContext: todoBlocContext,
              listKey: listKey,
            );
          },
          child: const DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28),
                bottomLeft: Radius.circular(28),
              ),
            ),
            child: SizedBox(
              height: 70,
              width: 80,
              // height: 35,
              // width: 35,
              child: Icon(
                Icons.edit,
                color: StyleUtil.c255,
              ),
            ),
          ),
        );
      },
    );
  }
}
