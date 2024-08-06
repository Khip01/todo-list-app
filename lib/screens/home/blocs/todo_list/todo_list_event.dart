part of 'todo_list_bloc.dart';

@immutable
sealed class TodoListEvent {}

class AddTodoListEvent extends TodoListEvent {
  final Todo todo;

  AddTodoListEvent({required this.todo});
}

class UpdateTodoListEvent extends TodoListEvent {
  final Todo todo;

  UpdateTodoListEvent({required this.todo});
}

class DeleteTodoListEvent extends TodoListEvent {
  final Todo todo;

  DeleteTodoListEvent({required this.todo});
}

class RefreshTodoListEvent extends TodoListEvent {
  final List<Todo> todoList;

  RefreshTodoListEvent({required this.todoList});
}

class SetIsError extends TodoListEvent {
  final bool isError;

  SetIsError({required this.isError});
}