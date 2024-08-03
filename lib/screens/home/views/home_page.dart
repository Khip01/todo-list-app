import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_app/utils/style_util.dart';

import '../../../values/images.dart';
import '../blocs/todo/todo_bloc.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final StyleUtil _styleUtil = StyleUtil();

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.sizeOf(context).height;
    double deviceWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: _styleUtil.c_24,
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: deviceHeight,
              width: deviceWidth,
              child: Column(
                children: [
                  CustomAppBar(),
                  Flexible(
                    fit: FlexFit.tight,
                    child: ContentBody(),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 125,
                width: deviceWidth,
                padding: const EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      _styleUtil.c_16.withOpacity(1),
                      _styleUtil.c_16.withOpacity(0),
                    ],
                    stops: const [
                      .7,
                      1,
                    ]
                  ),
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _customFloatingButton(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _customFloatingButton(){
    return Container(
      height: 56,
      width: 56,
      margin: const EdgeInsets.only(right: 14, top: 14),
      child: ElevatedButton(
        onPressed: (){},
        style: ElevatedButton.styleFrom(
          elevation: 1,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          overlayColor: _styleUtil.c_245,
          backgroundColor: _styleUtil.c_97,
          shadowColor: _styleUtil.c_97,
          alignment: Alignment.center,
        ),
        child: Icon(
          Icons.add,
          color: _styleUtil.c_245,
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  CustomAppBar({super.key});

  final StyleUtil _styleUtil = StyleUtil();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      width: double.maxFinite,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 39),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Image.asset(ImagePath.todoListLogo, width: 24),
                ),
                Text(
                  "Todolist",
                  style: TextStyle(
                    fontFamily: 'Jost',
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: _styleUtil.c_245,
                  ),
                ),
              ],
            ),
            Icon(Icons.settings, size: 24, color: _styleUtil.c_73),
          ],
        ),
      ),
    );
  }
}

class ContentBody extends StatelessWidget {
  ContentBody({super.key});

  final StyleUtil _styleUtil = StyleUtil();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(48),
          topRight: Radius.circular(48),
        ),
        color: _styleUtil.c_16,
      ),
      child: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoaded && state.todoList.isNotEmpty) {
            final todoList = state.todoList;
            return ListView.builder(
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                final todo = todoList[index];
                return ListTile(
                  title: Text(todo.title),
                  subtitle: Text(todo.desc),
                  leading: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text(
                "Empty",
                style: TextStyle(
                  fontFamily: 'Jost',
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: _styleUtil.c_245,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}


