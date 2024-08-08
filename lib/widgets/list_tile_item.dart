import 'package:flutter/material.dart';

import '../models/todo.dart';
import '../utils/style_util.dart';

class ListTileItem extends StatelessWidget {
  final Todo todo;

  const ListTileItem({
    super.key,
    required this.todo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 19),
      height: 70,
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      decoration: BoxDecoration(
        color: StyleUtil.c_13,
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
              color: StyleUtil.c_97,
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.check,
              color: StyleUtil.c_255,
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
                  style: StyleUtil.text_xl_Medium
                      .copyWith(color: StyleUtil.c_255),
                ),
                Text(
                  todo.desc,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: StyleUtil.text_Base_Regular
                      .copyWith(color: StyleUtil.c_200),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
