import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_list_app/screens/home/blocs/dialog_builder/dialog_builder_bloc.dart';
import 'package:todo_list_app/screens/home/blocs/setting/setting_bloc.dart';
import 'package:todo_list_app/screens/home/blocs/todo/todo_bloc.dart';
import 'package:todo_list_app/screens/home/blocs/todo_list/todo_list_bloc.dart';
import 'package:todo_list_app/screens/home/views/home_screen.dart';
import 'package:todo_list_app/utils/style_util.dart';
import 'package:todo_list_app/widgets/default_transition_screen.dart';

class MainApp extends StatelessWidget {
  late final GoRouter _router;

  MainApp({super.key}) {
    _router = GoRouter(
      routes: [
        GoRoute(
          path: "/",
          name: "home_screen",
          pageBuilder: (context, state) {
            return buildScreenWithDefaultTransition(
                context: context, state: state, child: HomeScreen());
          },
        ),
      ],
      initialLocation: "/",
      debugLogDiagnostics: kDebugMode,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => TodoListBloc()),
        BlocProvider(create: (context) => TodoBloc()),
        BlocProvider(create: (context) => SettingBloc()),
        BlocProvider(create: (context) => DialogBuilderBloc()),
      ],
      child: MaterialApp.router(
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.green,
            selectionColor: StyleUtil.c73,
            selectionHandleColor: StyleUtil.c97,
          ),
        ),
      ),
    );
  }
}
