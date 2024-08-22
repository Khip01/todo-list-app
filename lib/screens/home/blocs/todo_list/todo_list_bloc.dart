import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_app/data/repository/todo_repository.dart';

import '../../../../models/todo.dart';

part 'todo_list_event.dart';
part 'todo_list_state.dart';

class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  TodoListBloc() : super(TodoListInitial()) {
    on<AddTodoListEvent>(_addTodo);

    on<UpdateTodoListEvent>(_updateTodo);

    on<DeleteTodoListEvent>(_deleteTodo);

    on<LoadTodoList>(_loadTodoList);
    
    on<SetIsError>(_setIsError);
  }

  void _addTodo(AddTodoListEvent event, Emitter<TodoListState> emit) {
    state.todoList.insert(0, event.todo);
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

  Future<void> _loadTodoList(LoadTodoList event, Emitter<TodoListState> emit) async {
    try{
      emit(TodoListLoading());
      final List<Todo> todoList = await TodoRepository().getTodoList();
      if(todoList.isEmpty){
        emit(TodoListInitial());
      } else {
        emit(TodoListLoaded(todoList: todoList.reversed.toList()));
      }
    } catch (error) {
      emit(TodoListError(todoList: [], message: "Error Bro\nLog: $error"));
    }
  }

  void _setIsError (SetIsError event, Emitter<TodoListState> emit) {
    emit(TodoListLoaded(todoList: state.todoList));
  }
}
