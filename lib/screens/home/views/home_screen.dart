import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_list_app/screens/home/blocs/todo/todo_bloc.dart';
import 'package:todo_list_app/utils/helper/generate_todo_index.dart';
import 'package:todo_list_app/utils/style_util.dart';
import 'package:todo_list_app/widgets/custom_button.dart';
import 'package:todo_list_app/widgets/custom_drag_icon.dart';
import 'package:todo_list_app/widgets/custom_textfield.dart';
import 'package:todo_list_app/widgets/list_tile_item.dart';

import '../../../models/todo.dart';
import '../../../values/images.dart';
import '../blocs/todo_list/todo_list_bloc.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final TextEditingController _todoTitleTextController =
      TextEditingController();
  final TextEditingController _todoDescTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.sizeOf(context).height;
    double deviceWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: StyleUtil.c_24,
      body: SafeArea(
        child: Stack(
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
          ],
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
          _showModalBottomSheet(
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

  void _showModalBottomSheet({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      clipBehavior: Clip.antiAlias,
      context: context,
      isScrollControlled: true,
      backgroundColor: StyleUtil.c_16,
      builder: (context) {
        final keyboardBottomPadding = MediaQuery.of(context).viewInsets.bottom;

        return BlocBuilder<TodoListBloc, TodoListState>(
          builder: (todoListBlocContext, todoListBlocState) {
            return BlocBuilder<TodoBloc, TodoState>(
              builder: (todoBlocContext, todoBlocState) {
                // bool isError = false;

                Todo previewNewTodo = Todo(
                  id: generateTodoIndex(todoListBlocContext).toString(),
                  title: todoBlocState.todo.title,
                  desc: todoBlocState.todo.desc,
                  check: todoBlocState.todo.check,
                );

                return Padding(
                  padding: EdgeInsets.only(
                      bottom: keyboardBottomPadding, left: 14, right: 14),
                  child: SingleChildScrollView(
                    // controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: CustomDragIcon(),
                        ),
                        // Preview
                        ListTileItem(
                          todo: previewNewTodo,
                          isWidgetDummy: true,
                        ),
                        // Inpiut field
                        CustomTextfield(
                          controller: _todoTitleTextController,
                          hintText: "Todo Title",
                          onChange: (value) => _onChangeTextField(
                            todoBlocContext: todoBlocContext,
                            eventUpdate: UpdateTitle(
                              todoTitle: _todoTitleTextController.text,
                            ),
                            stateFieldError:
                                todoBlocState.todoRequirement.titleIsError,
                            eventValidation: TodoValidation(
                              todoRequirement: TodoRequirement(
                                titleIsError: false,
                                descIsError:
                                    todoBlocState.todoRequirement.descIsError,
                              ),
                            ),
                          ),
                          errorText: todoBlocState.todoRequirement.titleIsError
                              ? "title can't be empty"
                              : null,
                        ),
                        CustomTextfield(
                          controller: _todoDescTextController,
                          hintText: "Some Todo Description",
                          onChange: (value) => _onChangeTextField(
                            todoBlocContext: todoBlocContext,
                            eventUpdate: UpdateDesc(
                              todoDesc: _todoDescTextController.text,
                            ),
                            stateFieldError:
                                todoBlocState.todoRequirement.descIsError,
                            eventValidation: TodoValidation(
                              todoRequirement: TodoRequirement(
                                titleIsError:
                                    todoBlocState.todoRequirement.titleIsError,
                                descIsError: false,
                              ),
                            ),
                          ),
                          errorText: todoBlocState.todoRequirement.descIsError
                              ? "description can't be empty"
                              : null,
                        ),
                        CustomButton(
                          onPressed: () => _validateSubmitedTodo(
                            todo: Todo(
                              id: previewNewTodo.id,
                              title: _todoTitleTextController.text,
                              desc: _todoDescTextController.text,
                              check: previewNewTodo.check,
                            ),
                            todoBlocContext: todoBlocContext,
                            todoListBlocContext: todoListBlocContext,
                            widgetContext: context,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _onChangeTextField({
    required BuildContext todoBlocContext,
    required TodoEvent eventUpdate,
    required bool stateFieldError,
    required TodoEvent eventValidation,
  }) {
    todoBlocContext.read<TodoBloc>().add(
          eventUpdate,
        );
    if (stateFieldError) {
      todoBlocContext.read<TodoBloc>().add(
            eventValidation,
          );
    }
  }

  void _validateSubmitedTodo({
    required Todo todo,
    required BuildContext todoBlocContext,
    required BuildContext todoListBlocContext,
    required BuildContext widgetContext,
  }) {
    TodoRequirement requirement = TodoRequirement(
      titleIsError: _todoTitleTextController.text.isEmpty,
      descIsError: _todoDescTextController.text.isEmpty,
    );
    final eventValidation = TodoValidation(todoRequirement: requirement);
    todoBlocContext.read<TodoBloc>().add(eventValidation);

    if (requirement.titleIsError || requirement.descIsError) {
      return;
    }

    todoListBlocContext.read<TodoListBloc>().add(
          AddTodoListEvent(todo: todo),
        );
    todoBlocContext.read<TodoBloc>().add(
          TodoValidation(
            todoRequirement: TodoRequirement(
              titleIsError: false,
              descIsError: false,
            ),
          ),
        );
    widgetContext.pop();
    _todoTitleTextController.clear();
    todoBlocContext.read<TodoBloc>().add(
          UpdateTitle(
            todoTitle: _todoTitleTextController.text,
          ),
        );
    _todoDescTextController.clear();
    todoBlocContext.read<TodoBloc>().add(
          UpdateDesc(
            todoDesc: _todoDescTextController.text,
          ),
        );
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

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
                  style: StyleUtil.text_xl_Medium.copyWith(
                    color: StyleUtil.c_245,
                  ),
                ),
              ],
            ),
            const Icon(Icons.settings, size: 24, color: StyleUtil.c_73),
          ],
        ),
      ),
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
    return Stack(
      children: [
        ListView.builder(
          padding:
              const EdgeInsets.only(left: 14, right: 14, top: 14, bottom: 100),
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
  }
}
