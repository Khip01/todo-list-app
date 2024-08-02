import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_app/app_view.dart';
import 'package:todo_list_app/screens/home/blocs/todo/todo_bloc.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => TodoBloc()),
      ],
      child: const MaterialApp(
        home: AppView(),
      ),
    );
  }
}
