import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_app/screens/home/blocs/setting/setting_bloc.dart';
import 'package:todo_list_app/utils/style_util.dart';
import 'package:todo_list_app/widgets/list_tile_item.dart';
import 'package:todo_list_app/widgets/modal_bottom_sheet.dart';

import '../../../models/todo.dart';
import '../../../values/images.dart';
import '../blocs/todo_list/todo_list_bloc.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.sizeOf(context).height;
    double deviceWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: StyleUtil.c_24,
      body: SafeArea(
        child: BlocBuilder<SettingBloc, SettingState>(
          builder: (settingBlocContext, settingBlocState) {
            return Stack(
              children: [
                SizedBox(
                  height: deviceHeight,
                  width: deviceWidth,
                  child: Column(
                    children: [
                      const CustomAppBar(),
                      Flexible(
                        fit: FlexFit.tight,
                        child: ContentBody(),
                      ),
                    ],
                  ),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  bottom: settingBlocState.isSettingMode ? -115 : 0,
                  left: 0,
                  right: 0,
                  child: IgnorePointer(
                    ignoring: settingBlocState.isSettingMode,
                    child: Container(
                      height: 115,
                      width: deviceWidth,
                      padding: const EdgeInsets.only(top: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            StyleUtil.c_16.withOpacity(1),
                            StyleUtil.c_16.withOpacity(0),
                          ],
                          stops: const [
                            .7,
                            1,
                          ],
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: _customFloatingButton(context),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _customFloatingButton(BuildContext context) {
    return Container(
      height: 48,
      width: 48,
      margin: const EdgeInsets.only(right: 14, top: 14),
      child: ElevatedButton(
        onPressed: () {
          showCustomModalBottomSheet(
            context: context,
          );
        },
        style: ElevatedButton.styleFrom(
          elevation: 1,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          overlayColor: StyleUtil.c_245,
          backgroundColor: StyleUtil.c_97,
          shadowColor: StyleUtil.c_97,
          alignment: Alignment.center,
        ),
        child: const Icon(
          Icons.add,
          color: StyleUtil.c_255,
          size: 18,
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(
      builder: (settingBlocContext, settingBlocState) {
        bool isSettingMode = settingBlocState.isSettingMode;

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
                      style: StyleUtil.text_xl_Medium.copyWith(
                        color: StyleUtil.c_245,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    settingBlocContext.read<SettingBloc>().add(
                          UpdateSettingEvent(isSettingMode: !isSettingMode),
                        );
                  },
                  child: Icon(
                    Icons.settings,
                    size: 24,
                    color: settingBlocState.isSettingMode ? StyleUtil.c_97:  StyleUtil.c_73,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ContentBody extends StatelessWidget {
  ContentBody({super.key});

  late final double deviceWidth;

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.sizeOf(context).width;

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        color: StyleUtil.c_16,
      ),
      child: BlocBuilder<TodoListBloc, TodoListState>(
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
                    StyleUtil.text_xl_Medium.copyWith(color: StyleUtil.c_245),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _listViewBody({required List<Todo> todoList}) {
    return BlocBuilder<SettingBloc, SettingState>(
      builder: (settingBlocContext, settingBlocState) {
        return Stack(
          children: [
            ListView.builder(
              padding: EdgeInsets.only(
                left: 14,
                right: 14,
                top: 14,
                bottom: settingBlocState.isSettingMode ? 14 : 100,
              ),
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                final todo = todoList[index];
                return ListTileItem(todo: todo, listItemIndex: index);
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
                      StyleUtil.c_16.withOpacity(1),
                      StyleUtil.c_16.withOpacity(0),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
