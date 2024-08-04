part of 'todo_bloc.dart';

@immutable
sealed class TodoEvent {}

class AddTodoEvent extends TodoEvent {
  final Todo todo;

  AddTodoEvent({required this.todo});
}

class UpdateTodoEvent extends TodoEvent {
  final Todo todo;

  UpdateTodoEvent({required this.todo});
}

class DeleteTodoEvent extends TodoEvent {
  final Todo todo;

  DeleteTodoEvent({required this.todo});
}

class RefreshTodoEvent extends TodoEvent {
  final List<Todo> todoList;

  RefreshTodoEvent({required this.todoList});
}