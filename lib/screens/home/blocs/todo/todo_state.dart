part of 'todo_bloc.dart';

@immutable
sealed class TodoState {
  final List<Todo> todoList;

  const TodoState(this.todoList);
}

final class TodoInitial extends TodoState {
  TodoInitial() : super(Data.dummyTodoList);
}

final class TodoLoaded extends TodoState {
  const TodoLoaded({required List<Todo> todoList}) : super(todoList);
}