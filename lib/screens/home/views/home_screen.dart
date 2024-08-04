import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_app/utils/style_util.dart';

import '../../../models/todo.dart';
import '../../../values/images.dart';
import '../blocs/todo/todo_bloc.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

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
                height: 115,
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
                    ],
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

  Widget _customFloatingButton() {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        return Container(
          height: 48,
          width: 48,
          margin: const EdgeInsets.only(right: 14, top: 14),
          child: ElevatedButton(
            onPressed: () {
              context.read<TodoBloc>().add(
                  RefreshTodoEvent(todoList: state.todoList.reversed.toList()));
            },
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
              color: _styleUtil.c_255,
              size: 18,
            ),
          ),
        );
      },
    );
  }
}

class CustomAppBar extends StatelessWidget {
  CustomAppBar({super.key});

  final StyleUtil _styleUtil = StyleUtil();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
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
                  style: _styleUtil.text_xl_Medium.copyWith(
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
  late final double deviceWidth;

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.sizeOf(context).width;

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        color: _styleUtil.c_16,
      ),
      child: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state.todoList.isNotEmpty) {
            final todoList = state.todoList;
            return _listViewBody(
              todoList: todoList,
            );
          } else {
            return Center(
              child: Text(
                "Empty",
                style:
                    _styleUtil.text_xl_Medium.copyWith(color: _styleUtil.c_245),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _listViewBody({required List<Todo> todoList}) {
    return Stack(
      children: [
        ListView.builder(
          padding: const EdgeInsets.only(left: 14, right: 14, top: 14, bottom: 100),
          itemCount: todoList.length,
          itemBuilder: (context, index) {
            final todo = todoList[index];
            return _listTileItem(todo: todo);
          },
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: 24,
            width: deviceWidth,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _styleUtil.c_16.withOpacity(1),
                  _styleUtil.c_16.withOpacity(0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _listTileItem({required Todo todo}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 19),
      height: 70,
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      decoration: BoxDecoration(
        color: _styleUtil.c_13,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Leading
          Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              color: _styleUtil.c_97,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.check,
              color: _styleUtil.c_255,
              size: 14,
            ),
          ),
          const SizedBox(width: 22),
          // Body
          Flexible(
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  todo.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _styleUtil.text_xl_Medium
                      .copyWith(color: _styleUtil.c_255),
                ),
                Text(
                  todo.desc,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _styleUtil.text_Base_Regular
                      .copyWith(color: _styleUtil.c_200),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
