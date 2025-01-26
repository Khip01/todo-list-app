part of 'todo_bloc.dart';

@immutable
sealed class TodoState {
  final Todo todo;
  final bool isFilledDate;
  final TodoRequirement todoRequirement;

  const TodoState({
    required this.todo,
    required this.isFilledDate,
    required this.todoRequirement,
  });
}

final class TodoInitial extends TodoState {
  static final Todo _initTodo = Todo(
    id: "",
    check: false,
    title: "Todo Title",
    desc: "Some Todo Description",
    event: null,
    isUsingAlarm: false,
  );

  TodoInitial()
      : super(
          todo: _initTodo,
          isFilledDate: false,
          todoRequirement: TodoRequirement(
            titleIsError: false,
            descIsError: false,
          ),
        );
}

final class TodoLoaded extends TodoState {
  const TodoLoaded({
    required super.todo,
    required super.isFilledDate,
    required super.todoRequirement,
  });
}
