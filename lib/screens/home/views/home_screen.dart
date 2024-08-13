import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_app/screens/home/blocs/setting/setting_bloc.dart';
import 'package:todo_list_app/utils/style_util.dart';
import 'package:todo_list_app/widgets/list_tile_item.dart';
import 'package:todo_list_app/widgets/modal_bottom_sheet.dart';

import '../../../models/todo.dart';
import '../../../values/images.dart';
import '../../../widgets/pressable_delete_button.dart';
import '../blocs/todo_list/todo_list_bloc.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.sizeOf(context).height;
    double deviceWidth = MediaQuery.sizeOf(context).width;

    final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

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
                        child: ContentBody(
                          listKey: listKey,
                        ),
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
                        child: _customFloatingButton(context, listKey),
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

  Widget _customFloatingButton(
      BuildContext context, GlobalKey<AnimatedListState> listKey) {
    return Container(
      height: 48,
      width: 48,
      margin: const EdgeInsets.only(right: 14, top: 14),
      child: ElevatedButton(
        onPressed: () {
          showCustomModalBottomSheet(
            context: context,
            listKey: listKey,
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
                CustomAnimatedSettingIcon(
                  settingBlocContext: settingBlocContext,
                  settingBlocState: settingBlocState,
                  isSettingMode: isSettingMode,
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
  final GlobalKey<AnimatedListState> listKey;

  ContentBody({
    super.key,
    required this.listKey,
  });

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
              listKey: listKey,
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

  Widget _listViewBody({
    required List<Todo> todoList,
    required GlobalKey<AnimatedListState> listKey,
  }) {
    return BlocBuilder<SettingBloc, SettingState>(
      builder: (settingBlocContext, settingBlocState) {
        return Stack(
          children: [
            AnimatedPadding(
              padding: EdgeInsets.only(
                bottom: settingBlocState.isSettingMode ? 14 : 100,
              ),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              child: AnimatedList(
                key: listKey,
                padding: const EdgeInsets.only(
                  left: 14,
                  right: 14,
                  top: 14,
                ),
                initialItemCount: todoList.length,
                itemBuilder: (context, index, anim) {
                  final todo = todoList[index];
                  return _listItem(
                    todo: todo,
                    index: index,
                    anim: anim,
                    listKey: listKey,
                    settingBlocState: settingBlocState,
                  );
                },
              ),
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

  Widget _listItem({
    required Todo todo,
    required int index,
    required Animation<double> anim,
    required GlobalKey<AnimatedListState> listKey,
    required SettingState settingBlocState,
  }) {
    return SizeTransition(
      sizeFactor: anim,
      child: SizedBox(
        height: 89,
        width: double.maxFinite,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                ListTileItem(
                  todo: todo,
                  listItemIndex: index,
                  listKey: listKey,
                  onTap: () => _dialogBuilder(
                    context: context,
                    title: todo.title,
                    desc: todo.desc,
                  ),
                ),
                Visibility(
                  visible: settingBlocState.isSettingMode,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: BlocBuilder<TodoListBloc, TodoListState>(
                      builder: (todoListContext, todoListState) {
                        return PressableDeleteButton(
                          height: 70,
                          initWidth: 80,
                          maxWidth: constraints.maxWidth - 80,
                          animDuration: const Duration(milliseconds: 3000),
                          onPressAct: () {
                            todoListContext.read<TodoListBloc>().add(
                                  DeleteTodoListEvent(todo: todo),
                                );
                            if (listKey.currentState != null) {
                              _deleteAnimationListHandler(
                                removedIndex: index,
                                todo: todo,
                                settingBlocState: settingBlocState,
                              );
                            }
                          },
                          child: const Align(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.delete_outline,
                              color: StyleUtil.c_200,
                            ),
                          ),
                        );
                      },
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

  void _deleteAnimationListHandler({
    required int removedIndex,
    required Todo todo,
    required SettingState settingBlocState,
  }) {
    // Animation
    listKey.currentState!.removeItem(
      removedIndex,
      (context, anim) {
        return _listItem(
          todo: todo,
          index: removedIndex,
          anim: anim,
          listKey: listKey,
          settingBlocState: settingBlocState,
        );
      },
    );
  }

  Future<void> _dialogBuilder({
    required BuildContext context,
    required String title,
    required String desc,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: StyleUtil.c_13,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          title: Container(
            constraints: const BoxConstraints(
              maxHeight: 125,
            ),
            child: SingleChildScrollView(
              child: Text(
                title,
                style: StyleUtil.text_xl_Medium.copyWith(
                  color: StyleUtil.c_255,
                ),
              ),
            ),
          ),
          content: SizedBox(
            height: 250,
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    desc,
                    style: StyleUtil.text_Base_Regular.copyWith(
                      color: StyleUtil.c_200,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomAnimatedSettingIcon extends StatefulWidget {
  final BuildContext settingBlocContext;
  final SettingState settingBlocState;
  final bool isSettingMode;

  const CustomAnimatedSettingIcon({
    super.key,
    required this.settingBlocContext,
    required this.settingBlocState,
    required this.isSettingMode,
  });

  @override
  State<CustomAnimatedSettingIcon> createState() =>
      _CustomAnimatedSettingIconState();
}

class _CustomAnimatedSettingIconState extends State<CustomAnimatedSettingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      upperBound: 0.5,
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _animation,
      child: GestureDetector(
        onTap: () {
          widget.settingBlocContext.read<SettingBloc>().add(
                UpdateSettingEvent(isSettingMode: !widget.isSettingMode),
              );
          if (!widget.isSettingMode) {
            _controller.forward();
          } else {
            _controller.reverse();
          }
        },
        child: Icon(
          Icons.settings,
          size: 24,
          color: widget.settingBlocState.isSettingMode
              ? StyleUtil.c_97
              : StyleUtil.c_73,
        ),
      ),
    );
  }
}
