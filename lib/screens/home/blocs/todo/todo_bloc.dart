import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/todo.dart';

part 'todo_event.dart';

part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoInitial()) {
    on<UpdateTitle>(_todoUpdateTitle);
    on<UpdateDesc>(_todoUpdateDesc);
    on<TodoValidation>(_todoValidation);
    on<TodoUpdateAll>(_todoUpdateAll);
    on<ClearTodoState>(_clearTodoState);
  }

  void _todoUpdateTitle(UpdateTitle event, Emitter<TodoState> emit) {
    final Todo updatedTodo = state.todo.copyWith(title: event.todoTitle);
    emit(TodoLoaded(todo: updatedTodo, todoRequirement: state.todoRequirement));
  }

  void _todoUpdateDesc(UpdateDesc event, Emitter<TodoState> emit) {
    final Todo updatedTodo = state.todo.copyWith(desc: event.todoDesc);
    emit(TodoLoaded(todo: updatedTodo, todoRequirement: state.todoRequirement));
  }

  void _todoValidation(TodoValidation event, Emitter<TodoState> emit) {
    emit(
      TodoLoaded(
        todo: state.todo,
        todoRequirement: TodoRequirement(
          titleIsError: event.todoRequirement.titleIsError,
          descIsError: event.todoRequirement.descIsError,
        ),
      ),
    );
  }

  void _todoUpdateAll(TodoUpdateAll event, Emitter<TodoState> emit){
    final Todo updatedTodo = event.todo;
    emit(TodoLoaded(todo: updatedTodo, todoRequirement: state.todoRequirement));
  }

  void _clearTodoState(ClearTodoState event, Emitter<TodoState> emit){
    emit(TodoInitial());
  }
}
