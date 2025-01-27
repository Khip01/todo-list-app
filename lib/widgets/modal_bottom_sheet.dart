import 'dart:io';

import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_list_app/data/repository/calendar_repository.dart';
import 'package:todo_list_app/data/repository/event_repository.dart';
import 'package:todo_list_app/data/repository/todo_repository.dart';
import 'package:todo_list_app/utils/constants.dart';

import 'package:todo_list_app/utils/helper_class/todo_form_controller.dart';
import 'package:todo_list_app/widgets/custom_switch.dart';
import 'package:todo_list_app/widgets/custom_textfield_datetime.dart';
import 'package:todo_list_app/widgets/textfield_section_clear_button.dart';

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
    prop.todoScheduledTextController.clear();

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
    backgroundColor: StyleUtil.c16,
    builder: (context) {
      final keyboardBottomPadding = MediaQuery.of(context).viewInsets.bottom;
      final DeviceCalendarPlugin deviceCalendarPlugin = DeviceCalendarPlugin();

      return FutureBuilder<Event?>(
          future: EventRepository.getEventFromCalendar(
            deviceCalendarPlugin: deviceCalendarPlugin,
            calendarName: Constants.CALENDAR_NAME,
            eventId: editedTodo?.eventId ?? "",
          ),
          builder: (context, snapshot) {
            if (editedTodo != null &&
                editedTodo.eventId != null &&
                snapshot.data != null) {
              String scheduledTimeStr = DateTimeFormatter.formatToString(
                dateTime: snapshot.data!.start,
              );
              prop.todoScheduledTextController.text = scheduledTimeStr;
            }

            return BlocBuilder<SettingBloc, SettingState>(
              builder: (settingBlocContext, settingBlocState) {
                return BlocBuilder<TodoListBloc, TodoListState>(
                  builder: (todoListBlocContext, todoListBlocState) {
                    return BlocBuilder<TodoBloc, TodoState>(
                      builder: (todoBlocContext, todoBlocState) {
                        late Todo previewNewTodo;
                        if (editedTodo == null ||
                            !settingBlocState.isSettingMode) {
                          previewNewTodo = Todo(
                            id: generateTodoIndex(todoListBlocContext)
                                .toString(),
                            title: todoBlocState.todo.title,
                            desc: todoBlocState.todo.desc,
                            check: todoBlocState.todo.check,
                            isUsingAlarm: todoBlocState.todo.isUsingAlarm,
                          );
                        } else {
                          previewNewTodo = Todo(
                            id: todoBlocState.todo.id,
                            title: todoBlocState.todo.title,
                            desc: todoBlocState.todo.desc,
                            check: todoBlocState.todo.check,
                            isUsingAlarm: todoBlocState.todo.isUsingAlarm,
                          );
                        }

                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: keyboardBottomPadding,
                              left: 14,
                              right: 14),
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
                                  textOnRemove: (_) => _onChangeTextField(
                                    todoBlocContext: todoBlocContext,
                                    eventUpdate: UpdateTitle(
                                      todoTitle:
                                          prop.todoTitleTextController.text,
                                    ),
                                    stateFieldError: todoBlocState
                                        .todoRequirement.titleIsError,
                                    eventValidation: TodoValidation(
                                      todoRequirement: TodoRequirement(
                                        titleIsError: false,
                                        descIsError: todoBlocState
                                            .todoRequirement.descIsError,
                                      ),
                                    ),
                                  ),
                                  textFieldChild: CustomTextfield(
                                    controller: prop.todoTitleTextController,
                                    focusNode: prop.todoTitleFocusNode,
                                    hintText: "Todo Title",
                                    onChange: (_) => _onChangeTextField(
                                      todoBlocContext: todoBlocContext,
                                      eventUpdate: UpdateTitle(
                                        todoTitle:
                                            prop.todoTitleTextController.text,
                                      ),
                                      stateFieldError: todoBlocState
                                          .todoRequirement.titleIsError,
                                      eventValidation: TodoValidation(
                                        todoRequirement: TodoRequirement(
                                          titleIsError: false,
                                          descIsError: todoBlocState
                                              .todoRequirement.descIsError,
                                        ),
                                      ),
                                    ),
                                    errorText: todoBlocState
                                            .todoRequirement.titleIsError
                                        ? "title can't be empty"
                                        : null,
                                  ),
                                ),
                                TextFieldSectionWithClearButton(
                                  controller: prop.todoDescTextController,
                                  focusNode: prop.todoDescFocusNode,
                                  textOnRemove: (_) => _onChangeTextField(
                                    todoBlocContext: todoBlocContext,
                                    eventUpdate: UpdateDesc(
                                      todoDesc:
                                          prop.todoDescTextController.text,
                                    ),
                                    stateFieldError: todoBlocState
                                        .todoRequirement.descIsError,
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
                                    customMaxLine: 10,
                                    onChange: (_) => _onChangeTextField(
                                      todoBlocContext: todoBlocContext,
                                      eventUpdate: UpdateDesc(
                                        todoDesc:
                                            prop.todoDescTextController.text,
                                      ),
                                      stateFieldError: todoBlocState
                                          .todoRequirement.descIsError,
                                      eventValidation: TodoValidation(
                                        todoRequirement: TodoRequirement(
                                          titleIsError: todoBlocState
                                              .todoRequirement.titleIsError,
                                          descIsError: false,
                                        ),
                                      ),
                                    ),
                                    errorText: todoBlocState
                                            .todoRequirement.descIsError
                                        ? "description can't be empty"
                                        : null,
                                  ),
                                ),
                                CustomTextfieldDatetime(
                                  controller: prop.todoScheduledTextController,
                                  focusNode: prop.todoScheduledFocusNode,
                                  hintText: "Scheduled Notification (optional)",
                                  textOnRemoveChange: (_) {
                                    _onChangeFilledDateTimeField(
                                      todoBlocContext: todoBlocContext,
                                      eventUpdate: UpdateDateField(
                                        isFilledDateField: false,
                                      ),
                                    );
                                    _onChangeSwitch(
                                      todoBlocContext: todoBlocContext,
                                      eventUpdate:
                                          UpdateAlarm(todoAlarm: false),
                                    );
                                  },
                                  dateButtonOnConfirm: (date) {
                                    prop.todoScheduledFocusNode.requestFocus();
                                    prop.todoScheduledTextController.text =
                                        DateTimeFormatter.formatToString(
                                      dateTime: date,
                                    );
                                    _onChangeFilledDateTimeField(
                                      // Change filledDateTime state
                                      todoBlocContext: todoBlocContext,
                                      eventUpdate: UpdateDateField(
                                        isFilledDateField: true,
                                      ),
                                    );
                                  },
                                ),
                                if (Platform.isAndroid &&
                                    !settingBlocState.isSettingMode)
                                  CustomSwitch(
                                    isVisible: todoBlocState.isFilledDate,
                                    value: todoBlocState.todo.isUsingAlarm,
                                    onChanged: (value) => _onChangeSwitch(
                                      todoBlocContext: todoBlocContext,
                                      eventUpdate:
                                          UpdateAlarm(todoAlarm: value),
                                    ),
                                  ),
                                CustomButton(
                                  onPressed: () => _validateSubmitedTodo(
                                    todo: Todo(
                                      id: previewNewTodo.id,
                                      title: prop.todoTitleTextController.text,
                                      desc: prop.todoDescTextController.text,
                                      check: previewNewTodo.check,
                                      isUsingAlarm: previewNewTodo.isUsingAlarm,
                                      // scheduledTime:
                                      //     prop.todoScheduledTextController.text,
                                    ),
                                    scheduledTime:
                                        prop.todoScheduledTextController.text,
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
          });
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

void _onChangeFilledDateTimeField({
  required BuildContext todoBlocContext,
  required TodoEvent eventUpdate,
}) {
  todoBlocContext.read<TodoBloc>().add(
        eventUpdate,
      );
}

void _onChangeSwitch({
  required BuildContext todoBlocContext,
  required TodoEvent eventUpdate,
}) {
  todoBlocContext.read<TodoBloc>().add(
        eventUpdate,
      );
}

void _validateSubmitedTodo({
  required Todo todo,
  required String scheduledTime,
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
    if (scheduledTime != "" || scheduledTime.isNotEmpty) {
      try {
        String updatedIdEvent = await _addOrUpdateScheduledToDoHandler(
          scheduledTime: scheduledTime,
          todo: todo,
          widgetContext: widgetContext,
          todoBlocContext: todoBlocContext,
          todoTitleTextController: todoTitleTextController,
          todoDescTextController: todoDescTextController,
        );
        todo.eventId = updatedIdEvent;
      } catch (error) {
        if (!widgetContext.mounted) return;
        _showSnackbarMessage(widgetContext, error.toString(), isError: true);
        _clearStateAndField(
          todoBlocContext: todoBlocContext,
          widgetContext: widgetContext,
          todoTitleTextController: todoTitleTextController,
          todoDescTextController: todoDescTextController,
        );
      }
    }
  } else {
    // ----------- Add Schedule Notification (if any)
    if (scheduledTime != "" || scheduledTime.isNotEmpty) {
      try {
        String createdIdEvent = await _addOrUpdateScheduledToDoHandler(
          scheduledTime: scheduledTime,
          todo: todo,
          widgetContext: widgetContext,
          todoBlocContext: todoBlocContext,
          todoTitleTextController: todoTitleTextController,
          todoDescTextController: todoDescTextController,
        );
        todo.eventId = createdIdEvent;
        // Is Using Alarm ?
        if (todo.isUsingAlarm) {
          EventRepository.setAlarm(
            eventStartDate: DateTimeFormatter.formatToDateTime(
              dateTimeStr: scheduledTime,
            ),
            message: todo.title,
          );
        }
      } catch (err) {
        if (!widgetContext.mounted) return;
        _showSnackbarMessage(widgetContext, err.toString(), isError: true);
        _clearStateAndField(
          todoBlocContext: todoBlocContext,
          widgetContext: widgetContext,
          todoTitleTextController: todoTitleTextController,
          todoDescTextController: todoDescTextController,
        );
        return;
      }
    }
    // ----------- Add Todo -> SQFlite
    await TodoRepository().addTodo(todo: todo);
    // ----------- Add State
    if (!todoListBlocContext.mounted) return;
    todoListBlocContext.read<TodoListBloc>().add(
          AddTodoListEvent(todo: todo),
        );
    // ----------- Animation insertItem
    if (listKey.currentState != null) {
      listKey.currentState!.insertItem(0);
    }
  }
  if (!widgetContext.mounted) return;
  _showSnackbarMessage(
    widgetContext,
    "ToDo ${settingBlocState.isSettingMode ? "updated" : "added"} successfully!",
    isError: false,
  );
  _clearStateAndField(
    todoBlocContext: todoBlocContext,
    widgetContext: widgetContext,
    todoTitleTextController: todoTitleTextController,
    todoDescTextController: todoDescTextController,
  );
}

Future<String> _addOrUpdateScheduledToDoHandler({
  required String scheduledTime,
  required Todo todo,
  required BuildContext widgetContext,
  required BuildContext todoBlocContext,
  required TextEditingController todoTitleTextController,
  required TextEditingController todoDescTextController,
}) async {
  try {
    DeviceCalendarPlugin deviceCalendarPlugin = DeviceCalendarPlugin();
    DateTime scheduledTimeDT = DateTimeFormatter.formatToDateTime(
      dateTimeStr: scheduledTime,
    );
    String calendarId = await CalendarRepository.getOrCreateCalendarId(
      calendarName: Constants.CALENDAR_NAME,
      deviceCalendarPlugin: deviceCalendarPlugin,
    );
    String createdIdEvent = await EventRepository.addOrUpdateEventToCalendar(
      deviceCalendarPlugin: deviceCalendarPlugin,
      calendarId: calendarId,
      eventId: todo.eventId,
      title: todo.title,
      start: scheduledTimeDT,
      end: null,
    );
    return createdIdEvent;
  } catch (error) {
    rethrow;
  }
}

void _clearStateAndField({
  required BuildContext todoBlocContext,
  required BuildContext widgetContext,
  required TextEditingController todoTitleTextController,
  required TextEditingController todoDescTextController,
}) {
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

void _showSnackbarMessage(BuildContext context, String msg,
    {required bool isError}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor:
          isError ? StyleUtil.cDeleteInactive : StyleUtil.cSuccessActive,
      content: Text(
        msg,
        style: StyleUtil.textXLRegular.copyWith(
          color: StyleUtil.c200,
        ),
      ),
    ),
  );
}
