import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/todo.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoInitial()) {
    on<AddTodoEvent>(_addTodo);

    on<UpdateTodoEvent>(_updateTodo);

    on<DeleteTodoEvent>(_deleteTodo);
  }

  void _addTodo(AddTodoEvent event, Emitter<TodoState> emit) {
    state.todoList.add(event.todo);
    emit(TodoLoaded(todoList: state.todoList));
  }

  void _updateTodo(UpdateTodoEvent event, Emitter<TodoState> emit){
    for(int i = 0; i < state.todoList.length; i++){
      if(state.todoList[i].id == event.todo.id){
        state.todoList[i] = event.todo;
      }
    }
    emit(TodoLoaded(todoList: state.todoList));
  }

  void _deleteTodo(DeleteTodoEvent event, Emitter<TodoState> emit){
    state.todoList.remove(event.todo);
    emit(TodoLoaded(todoList: state.todoList));
  }
}
