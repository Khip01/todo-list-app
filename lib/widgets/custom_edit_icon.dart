import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_app/widgets/modal_bottom_sheet.dart';

import '../models/todo.dart';
import '../screens/home/blocs/setting/setting_bloc.dart';
import '../utils/style_util.dart';

class CustomEditIcon extends StatelessWidget {
  final Todo editedTodo;

  const CustomEditIcon({
    super.key,
    required this.editedTodo,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(
      builder: (todoBlocContext, todoBlocState) {
        return SizedBox(
          height: 32,
          width: 32,
          child: Center(
            child: GestureDetector(
              onTap: () {
                showCustomModalBottomSheet(
                    context: context,
                    editedTodo: editedTodo,
                    todoBlocContext: todoBlocContext,
                );
              },
              child: const Icon(
                Icons.edit,
                color: StyleUtil.c_255,
              ),
            ),
          ),
        );
      },
    );
  }
}
