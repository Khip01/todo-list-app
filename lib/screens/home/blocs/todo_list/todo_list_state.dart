part of 'todo_list_bloc.dart';

@immutable
sealed class TodoListState {
  final List<Todo> todoList;

  const TodoListState({required this.todoList});
}

final class TodoListInitial extends TodoListState {
  TodoListInitial() : super(todoList: []);
}

final class TodoListLoaded extends TodoListState {
  const TodoListLoaded({required List<Todo> todoList})
      : super(todoList: todoList);
}

final class TodoListLoading extends TodoListState {
  TodoListLoading() : super(todoList: []) ;
}

final class TodoListError extends TodoListState {
  final String? message;

  const TodoListError({required super.todoList, this.message});
}
