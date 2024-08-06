import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/todo.dart';
import '../../../../values/data.dart';

part 'todo_list_event.dart';
part 'todo_list_state.dart';

class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  TodoListBloc() : super(TodoListInitial()) {
    on<AddTodoListEvent>(_addTodo);

    on<UpdateTodoListEvent>(_updateTodo);

    on<DeleteTodoListEvent>(_deleteTodo);

    on<RefreshTodoListEvent>(_refreshTodo);
    
    on<SetIsError>(_setIsError);
  }

  void _addTodo(AddTodoListEvent event, Emitter<TodoListState> emit) {
    state.todoList.add(event.todo);
    emit(TodoListLoaded(todoList: state.todoList));
  }

  void _updateTodo(UpdateTodoListEvent event, Emitter<TodoListState> emit){
    for(int i = 0; i < state.todoList.length; i++){
      if(state.todoList[i].id == event.todo.id){
        state.todoList[i] = event.todo;
      }
    }
    emit(TodoListLoaded(todoList: state.todoList));
  }

  void _deleteTodo(DeleteTodoListEvent event, Emitter<TodoListState> emit){
    state.todoList.remove(event.todo);
    emit(TodoListLoaded(todoList: state.todoList));
  }

  void _refreshTodo(RefreshTodoListEvent event, Emitter<TodoListState> emit){
    emit(TodoListLoaded(todoList: event.todoList));
  }

  void _setIsError (SetIsError event, Emitter<TodoListState> emit) {
    emit(TodoListLoaded(todoList: state.todoList));
  }
}
