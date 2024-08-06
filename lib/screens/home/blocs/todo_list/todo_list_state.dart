part of 'todo_list_bloc.dart';

@immutable
sealed class TodoListState {
  final List<Todo> todoList;

  const TodoListState(
      {required this.todoList});
}

final class TodoListInitial extends TodoListState {
  TodoListInitial()
      : super(todoList: Data.dummyTodoList);
}

final class TodoListLoaded extends TodoListState {
  const TodoListLoaded({required List<Todo> todoList})
      : super(todoList: todoList);
}
