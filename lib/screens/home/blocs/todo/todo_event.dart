part of 'todo_bloc.dart';

@immutable
sealed class TodoEvent {}

class UpdateTitle extends TodoEvent {
  final String todoTitle;

  UpdateTitle._updateTodo(this.todoTitle);

  factory UpdateTitle({required String todoTitle}) {
    if (todoTitle.isEmpty) {
      return UpdateTitle._updateTodo("Todo Title");
    }

    return UpdateTitle._updateTodo(todoTitle);
  }
}

class UpdateDesc extends TodoEvent {
  final String todoDesc;

  UpdateDesc._updateTodo(this.todoDesc);

  factory UpdateDesc({required String todoDesc}) {
    if (todoDesc.isEmpty) {
      return UpdateDesc._updateTodo("Some Todo Description");
    }

    return UpdateDesc._updateTodo(todoDesc);
  }
}

class UpdateAlarm extends TodoEvent {
  final bool todoAlarm;

  UpdateAlarm._updateAlarm(this.todoAlarm);

  factory UpdateAlarm({required bool todoAlarm}) {
    return UpdateAlarm._updateAlarm(todoAlarm);
  }
}

class UpdateDateField extends TodoEvent {
  final bool isFilledDateField;

  UpdateDateField._updateField(this.isFilledDateField);

  factory UpdateDateField({
    required bool isFilledDateField,
  }) {
    return UpdateDateField._updateField(isFilledDateField);
  }
}

class TodoValidation extends TodoEvent {
  final TodoRequirement todoRequirement;

  TodoValidation({required this.todoRequirement});
}

class TodoUpdateAll extends TodoEvent {
  final Todo todo;

  TodoUpdateAll({required this.todo});
}

class ClearTodoState extends TodoEvent {}
