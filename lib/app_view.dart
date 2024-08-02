import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_app/screens/home/blocs/todo/todo_bloc.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        child: BlocBuilder<TodoBloc, TodoState>(
          builder: (context, state) {
            if (state is TodoLoaded && state.todoList.isNotEmpty){
              final todoList = state.todoList;
              return ListView.builder(
                itemCount: todoList.length,
                itemBuilder: (context, index) {
                  final todo = todoList[index];
                  return ListTile(
                    title: Text(todo.title),
                    subtitle: Text(todo.desc),
                    leading: const Icon(Icons.delete, color: Colors.red,),
                  );
                },
              );
            } else {
              return const Center(
                child: Text("Empty"),
              );
            }
          },
        ),
      ),
    );
  }
}
