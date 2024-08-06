part of 'todo_bloc.dart';

@immutable
sealed class TodoEvent {}

class UpdateTitle extends TodoEvent {
  final String todoTitle;

  UpdateTitle._updateTodo(this.todoTitle);

  factory UpdateTitle({required String todoTitle}){
    if(todoTitle.isEmpty){
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

class TodoValidation extends TodoEvent {
  final TodoRequirement todoRequirement;

  TodoValidation({required this.todoRequirement});
}