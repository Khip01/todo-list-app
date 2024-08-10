import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../models/todo.dart';
import '../screens/home/blocs/setting/setting_bloc.dart';
import '../screens/home/blocs/todo/todo_bloc.dart';
import '../screens/home/blocs/todo_list/todo_list_bloc.dart';
import '../utils/helper/generate_todo_index.dart';
import '../utils/style_util.dart';
import 'custom_button.dart';
import 'custom_drag_icon.dart';
import 'custom_textfield.dart';
import 'list_tile_item.dart';

final TextEditingController _todoTitleTextController = TextEditingController();
final TextEditingController _todoDescTextController = TextEditingController();

void showCustomModalBottomSheet({
  required BuildContext context,
  Todo? editedTodo,
  BuildContext? todoBlocContext,
}) {

  // Update Field with existing todo
  if (editedTodo != null && todoBlocContext != null) {
    _todoTitleTextController.text = editedTodo.title;
    _todoDescTextController.text = editedTodo.desc;

    todoBlocContext.read<TodoBloc>().add(
      TodoUpdateAll(todo: editedTodo),
    );
  }

  showModalBottomSheet(
    clipBehavior: Clip.antiAlias,
    context: context,
    isScrollControlled: true,
    backgroundColor: StyleUtil.c_16,
    builder: (context) {
      final keyboardBottomPadding = MediaQuery.of(context).viewInsets.bottom;

      return BlocBuilder<SettingBloc, SettingState>(
        builder: (settingBlocContext, settingBlocState) {
          return BlocBuilder<TodoListBloc, TodoListState>(
            builder: (todoListBlocContext, todoListBlocState) {
              return BlocBuilder<TodoBloc, TodoState>(
                builder: (todoBlocContext, todoBlocState) {
                  late Todo previewNewTodo;
                  if(editedTodo == null || !settingBlocState.isSettingMode){
                    previewNewTodo = Todo(
                      id: generateTodoIndex(todoListBlocContext).toString(),
                      title: todoBlocState.todo.title,
                      desc: todoBlocState.todo.desc,
                      check: todoBlocState.todo.check,
                    );
                  } else {
                    previewNewTodo = Todo(
                      id: todoBlocState.todo.id,
                      title: todoBlocState.todo.title,
                      desc: todoBlocState.todo.desc,
                      check: todoBlocState.todo.check,
                    );
                  }

                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: keyboardBottomPadding, left: 14, right: 14),
                    child: SingleChildScrollView(
                      // controller: scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: CustomDragIcon(),
                          ),
                          // Preview
                          ListTileItem(
                            todo: previewNewTodo,
                            isWidgetDummy: true,
                          ),
                          // Inpiut field
                          CustomTextfield(
                            controller: _todoTitleTextController,
                            hintText: "Todo Title",
                            onChange: (value) => _onChangeTextField(
                              todoBlocContext: todoBlocContext,
                              eventUpdate: UpdateTitle(
                                todoTitle: _todoTitleTextController.text,
                              ),
                              stateFieldError:
                                  todoBlocState.todoRequirement.titleIsError,
                              eventValidation: TodoValidation(
                                todoRequirement: TodoRequirement(
                                  titleIsError: false,
                                  descIsError:
                                      todoBlocState.todoRequirement.descIsError,
                                ),
                              ),
                            ),
                            errorText:
                                todoBlocState.todoRequirement.titleIsError
                                    ? "title can't be empty"
                                    : null,
                          ),
                          CustomTextfield(
                            controller: _todoDescTextController,
                            hintText: "Some Todo Description",
                            onChange: (value) => _onChangeTextField(
                              todoBlocContext: todoBlocContext,
                              eventUpdate: UpdateDesc(
                                todoDesc: _todoDescTextController.text,
                              ),
                              stateFieldError:
                                  todoBlocState.todoRequirement.descIsError,
                              eventValidation: TodoValidation(
                                todoRequirement: TodoRequirement(
                                  titleIsError: todoBlocState
                                      .todoRequirement.titleIsError,
                                  descIsError: false,
                                ),
                              ),
                            ),
                            errorText: todoBlocState.todoRequirement.descIsError
                                ? "description can't be empty"
                                : null,
                          ),
                          CustomButton(
                            onPressed: () => _validateSubmitedTodo(
                              todo: Todo(
                                id: previewNewTodo.id,
                                title: _todoTitleTextController.text,
                                desc: _todoDescTextController.text,
                                check: previewNewTodo.check,
                              ),
                              todoBlocContext: todoBlocContext,
                              todoListBlocContext: todoListBlocContext,
                              settingBlocState: settingBlocState,
                              widgetContext: context,
                            ),
                            buttonText: settingBlocState.isSettingMode ? "Update The Todo!" : "Create New Todo!",
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      );
    },
  );
}

void _onChangeTextField({
  required BuildContext todoBlocContext,
  required TodoEvent eventUpdate,
  required bool stateFieldError,
  required TodoEvent eventValidation,
}) {
  todoBlocContext.read<TodoBloc>().add(
        eventUpdate,
      );
  if (stateFieldError) {
    todoBlocContext.read<TodoBloc>().add(
          eventValidation,
        );
  }
}

void _validateSubmitedTodo({
  required Todo todo,
  required BuildContext todoBlocContext,
  required BuildContext todoListBlocContext,
  required SettingState settingBlocState,
  required BuildContext widgetContext,
}) {
  TodoRequirement requirement = TodoRequirement(
    titleIsError: _todoTitleTextController.text.isEmpty,
    descIsError: _todoDescTextController.text.isEmpty,
  );
  final eventValidation = TodoValidation(todoRequirement: requirement);
  todoBlocContext.read<TodoBloc>().add(eventValidation);

  if (requirement.titleIsError || requirement.descIsError) {
    return;
  }

  if (settingBlocState.isSettingMode) {
    todoListBlocContext.read<TodoListBloc>().add(
          UpdateTodoListEvent(todo: todo),
        );
  } else {
    todoListBlocContext.read<TodoListBloc>().add(
          AddTodoListEvent(todo: todo),
        );
  }
  todoBlocContext.read<TodoBloc>().add(
        TodoValidation(
          todoRequirement: TodoRequirement(
            titleIsError: false,
            descIsError: false,
          ),
        ),
      );
  widgetContext.pop();
  _todoTitleTextController.clear();
  todoBlocContext.read<TodoBloc>().add(
        UpdateTitle(
          todoTitle: _todoTitleTextController.text,
        ),
      );
  _todoDescTextController.clear();
  todoBlocContext.read<TodoBloc>().add(
        UpdateDesc(
          todoDesc: _todoDescTextController.text,
        ),
      );
}
