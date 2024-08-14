import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_app/data/repository/todo_repository.dart';
import 'package:todo_list_app/screens/home/blocs/todo_list/todo_list_bloc.dart';

import '../models/todo.dart';
import '../utils/style_util.dart';

class CustomCheckbox extends StatelessWidget {
  final int? listItemIndex;
  final bool? checkIsAlwaysFalse;

  const CustomCheckbox({
    super.key,
    this.listItemIndex,
    this.checkIsAlwaysFalse,
  }) : assert(listItemIndex != null || checkIsAlwaysFalse != null,
            "there must be at least 1 atribute declared");

  @override
  Widget build(BuildContext context) {
    if (checkIsAlwaysFalse == null || checkIsAlwaysFalse == false) {
      return CheckBoxMain(
        onListIndex: listItemIndex!,
        childCallback: (isChecked) {
          return _checkbox(isChecked);
        },
      );
    } else {
      return CheckBoxDummy(
        childCallback: (isChecked) {
          return _checkbox(isChecked);
        },
      );
    }
  }

  Widget _checkbox(bool isChecked) {
    return Container(
      height: 32,
      width: 32,
      decoration: BoxDecoration(
        color: isChecked ? StyleUtil.c_97 : Colors.transparent,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: StyleUtil.c_97,
          width: 1,
        ),
      ),
      child: isChecked
          ? const Icon(
              Icons.check,
              color: StyleUtil.c_255,
              size: 14,
            )
          : const SizedBox(),
    );
  }
}

class CheckBoxMain extends StatelessWidget {
  final int onListIndex;
  final Function(bool isChecked) childCallback;

  const CheckBoxMain({
    super.key,
    required this.onListIndex,
    required this.childCallback,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoListBloc, TodoListState>(
      builder: (todoListContext, todoListState) {
        bool isChecked = todoListState.todoList[onListIndex].check;
        return GestureDetector(
          onTap: () async {
            final Todo updatedTodo =
                todoListState.todoList[onListIndex].copyWith(check: !isChecked);
            await TodoRepository().updateTodo(todo: updatedTodo);
            if(!todoListContext.mounted) return;
            todoListContext.read<TodoListBloc>().add(
                  UpdateTodoListEvent(
                    todo: updatedTodo,
                  ),
                );
          },
          child: childCallback(isChecked),
        );
      },
    );
  }
}

class CheckBoxDummy extends StatefulWidget {
  final Function(bool isChecked) childCallback;

  const CheckBoxDummy({
    super.key,
    required this.childCallback,
  });

  @override
  State<CheckBoxDummy> createState() => _CheckBoxDummyState();
}

class _CheckBoxDummyState extends State<CheckBoxDummy> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() {
        isChecked = !isChecked;
      }),
      child: widget.childCallback(isChecked),
    );
  }
}
