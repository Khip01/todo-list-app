part of 'todo_bloc.dart';

@immutable
sealed class TodoState {
  final Todo todo;
  final TodoRequirement todoRequirement;

  const TodoState({required this.todo, required this.todoRequirement});
}

final class TodoInitial extends TodoState {
  static final Todo _initTodo = Todo(
    id: "",
    check: false,
    title: "Todo Title",
    desc: "Some Todo Description",
    scheduledTime: null,
  );

  TodoInitial()
      : super(
            todo: _initTodo,
            todoRequirement: TodoRequirement(
              titleIsError: false,
              descIsError: false,
            ),
  );
}

final class TodoLoaded extends TodoState {
  const TodoLoaded({required super.todo, required super.todoRequirement});
}
