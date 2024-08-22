import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_list_app/data/repository/todo_repository.dart';
import 'package:todo_list_app/utils/helper/local_notification_helper.dart';
import 'package:todo_list_app/utils/helper_class/todo_form_controller.dart';
import 'package:todo_list_app/widgets/custom_textfield_datetime.dart';
import 'package:todo_list_app/widgets/textfield_section_clear_button.dart';
import 'package:timezone/timezone.dart' as timezone;

import '../models/todo.dart';
import '../screens/home/blocs/setting/setting_bloc.dart';
import '../screens/home/blocs/todo/todo_bloc.dart';
import '../screens/home/blocs/todo_list/todo_list_bloc.dart';
import '../utils/helper/datetime_formatter.dart';
import '../utils/helper/generate_todo_index.dart';
import '../utils/style_util.dart';
import 'custom_button.dart';
import 'custom_drag_icon.dart';
import 'custom_textfield.dart';
import 'list_tile_item.dart';

void showCustomModalBottomSheet({
  required BuildContext context,
  required GlobalKey<AnimatedListState> listKey,
  Todo? editedTodo,
  required BuildContext todoBlocContext,
}) {
  final TodoFormController prop = TodoFormController(
    todoTitleTextController: TextEditingController(),
    todoTitleFocusNode: FocusNode(),
    todoDescTextController: TextEditingController(),
    todoDescFocusNode: FocusNode(),
    todoScheduledTextController: TextEditingController(),
    todoScheduledFocusNode: FocusNode(),
  );

  // Update Field with existing todo
  if (editedTodo != null) {
    prop.todoTitleTextController.text = editedTodo.title;
    prop.todoDescTextController.text = editedTodo.desc;
    prop.todoScheduledTextController.text = editedTodo.scheduledTime ?? "";

    todoBlocContext.read<TodoBloc>().add(
          TodoUpdateAll(todo: editedTodo),
        );
  } else {
    prop.todoTitleTextController.clear();
    prop.todoDescTextController.clear();
    prop.todoScheduledTextController.clear();

    todoBlocContext.read<TodoBloc>().add(
          ClearTodoState(),
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
                  if (editedTodo == null || !settingBlocState.isSettingMode) {
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
                            listKey: listKey,
                          ),
                          // Inpiut field
                          TextFieldSectionWithClearButton(
                            controller: prop.todoTitleTextController,
                            focusNode: prop.todoTitleFocusNode,
                            textOnRemove: (value) => _onChangeTextField(
                              todoBlocContext: todoBlocContext,
                              eventUpdate: UpdateTitle(
                                todoTitle: prop.todoTitleTextController.text,
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
                            textFieldChild: CustomTextfield(
                              controller: prop.todoTitleTextController,
                              focusNode: prop.todoTitleFocusNode,
                              hintText: "Todo Title",
                              onChange: (value) => _onChangeTextField(
                                todoBlocContext: todoBlocContext,
                                eventUpdate: UpdateTitle(
                                  todoTitle: prop.todoTitleTextController.text,
                                ),
                                stateFieldError:
                                    todoBlocState.todoRequirement.titleIsError,
                                eventValidation: TodoValidation(
                                  todoRequirement: TodoRequirement(
                                    titleIsError: false,
                                    descIsError: todoBlocState
                                        .todoRequirement.descIsError,
                                  ),
                                ),
                              ),
                              errorText:
                                  todoBlocState.todoRequirement.titleIsError
                                      ? "title can't be empty"
                                      : null,
                            ),
                          ),
                          TextFieldSectionWithClearButton(
                            controller: prop.todoDescTextController,
                            focusNode: prop.todoDescFocusNode,
                            textOnRemove: (value) => _onChangeTextField(
                              todoBlocContext: todoBlocContext,
                              eventUpdate: UpdateDesc(
                                todoDesc: prop.todoDescTextController.text,
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
                            textFieldChild: CustomTextfield(
                              controller: prop.todoDescTextController,
                              focusNode: prop.todoDescFocusNode,
                              hintText: "Some Todo Description",
                              onChange: (value) => _onChangeTextField(
                                todoBlocContext: todoBlocContext,
                                eventUpdate: UpdateDesc(
                                  todoDesc: prop.todoDescTextController.text,
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
                              errorText:
                                  todoBlocState.todoRequirement.descIsError
                                      ? "description can't be empty"
                                      : null,
                            ),
                          ),
                          CustomTextfieldDatetime(
                            controller: prop.todoScheduledTextController,
                            focusNode: prop.todoScheduledFocusNode,
                            hintText: "Scheduled Notification (optional)",
                            onChange: (_) {},
                          ),
                          CustomButton(
                            onPressed: () => _validateSubmitedTodo(
                              todo: Todo(
                                id: previewNewTodo.id,
                                title: prop.todoTitleTextController.text,
                                desc: prop.todoDescTextController.text,
                                check: previewNewTodo.check,
                                scheduledTime:
                                    prop.todoScheduledTextController.text,
                              ),
                              todoBlocContext: todoBlocContext,
                              todoListBlocContext: todoListBlocContext,
                              settingBlocState: settingBlocState,
                              widgetContext: context,
                              listKey: listKey,
                              todoTitleTextController:
                                  prop.todoTitleTextController,
                              todoDescTextController:
                                  prop.todoDescTextController,
                            ),
                            buttonText: settingBlocState.isSettingMode
                                ? "Update The Todo!"
                                : "Create New Todo!",
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
  required GlobalKey<AnimatedListState> listKey,
  required TextEditingController todoTitleTextController,
  required TextEditingController todoDescTextController,
}) async {
  TodoRequirement requirement = TodoRequirement(
    titleIsError: todoTitleTextController.text.isEmpty,
    descIsError: todoDescTextController.text.isEmpty,
  );
  final eventValidation = TodoValidation(todoRequirement: requirement);
  todoBlocContext.read<TodoBloc>().add(eventValidation);

  if (requirement.titleIsError || requirement.descIsError) {
    return;
  }

  if (settingBlocState.isSettingMode) {
    // Update Todo -> SQFlite
    await TodoRepository().updateTodo(todo: todo);
    // Update State
    if (!todoListBlocContext.mounted) return;
    todoListBlocContext.read<TodoListBloc>().add(
          UpdateTodoListEvent(todo: todo),
        );
    // Update Schedule Notification
    if (todo.scheduledTime != null && todo.scheduledTime!.isNotEmpty) {
      // Update Schedule Notification Where id
      LocalNotificationHelper.updateScheduledNotification(
        id: todo.id,
        title: todo.title,
        body: todo.desc,
        tzDateScheduled: timezone.TZDateTime.from(
          DateTimeFormatter.formatToDateTime(dateTimeStr: todo.scheduledTime!),
          timezone.local,
        ),
      );
    }
  } else {
    // Add Todo -> SQLFlite
    await TodoRepository().addTodo(todo: todo);
    // Add State
    if (!todoListBlocContext.mounted) return;
    todoListBlocContext.read<TodoListBloc>().add(
          AddTodoListEvent(todo: todo),
        );
    // Add Schedule Notification (if any)
    if (todo.scheduledTime != null && todo.scheduledTime!.isNotEmpty) {
      // Add Schedule Notification
      LocalNotificationHelper.showScheduledNotification(
        id: todo.id,
        title: todo.title,
        body: todo.desc,
        tzDateScheduled: timezone.TZDateTime.from(
          DateTimeFormatter.formatToDateTime(dateTimeStr: todo.scheduledTime!),
          timezone.local,
        ),
      );
    }
    // Animation insertItem
    if (listKey.currentState != null) {
      listKey.currentState!.insertItem(0);
    }
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
  todoTitleTextController.clear();
  todoBlocContext.read<TodoBloc>().add(
        UpdateTitle(
          todoTitle: todoTitleTextController.text,
        ),
      );
  todoDescTextController.clear();
  todoBlocContext.read<TodoBloc>().add(
        UpdateDesc(
          todoDesc: todoDescTextController.text,
        ),
      );
}
