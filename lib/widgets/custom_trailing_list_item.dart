import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';

import '../data/repository/event_repository.dart';
import '../models/todo.dart';
import '../screens/home/blocs/setting/setting_bloc.dart';
import '../utils/constants.dart';
import '../utils/helper/datetime_formatter.dart';
import '../utils/style_util.dart';

class CustomTrailingListItem extends StatelessWidget {
  final SettingState settingBlocState;
  final Todo todo;
  final Function(Event? event) scheduledEventCallback;

  CustomTrailingListItem({
    super.key,
    required this.settingBlocState,
    required this.todo,
    required this.scheduledEventCallback,
  });

  final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<(Event?, String?)>(
        future: _onLoadScheduledDate(),
        builder: (context, snapshot) {
          scheduledEventCallback(snapshot.data?.$1);
          return Visibility(
            visible: !settingBlocState.isSettingMode && snapshot.data?.$2 != null,
            child: Container(
              height: 70,
              padding: EdgeInsets.only(right: 12, left: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    snapshot.data?.$2 ?? "",
                    style: StyleUtil.textBaseRegular.copyWith(
                      color: StyleUtil.c200,
                      fontSize: 12,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Icon(
                      Icons.calendar_month,
                      size: 20,
                      color: StyleUtil.c200,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  Future<(Event?, String?)> _onLoadScheduledDate() async {
    // get DateScheduledEvent
    if (todo.eventId == null) {
      return (null, null);
    }
    Event? eventTodo = await EventRepository.getEventFromCalendar(
      deviceCalendarPlugin: _deviceCalendarPlugin,
      calendarName: Constants.CALENDAR_NAME,
      eventId: todo.eventId!,
    );

    if (eventTodo == null) {
      return (eventTodo, null);
    }
    String? scheduledDateStr = DateTimeFormatter.formatToSimpleString(
      dateTime: await DateTimeFormatter.toDateTime(eventTodo.start!),
      withTime: false,
    );

    return (eventTodo, scheduledDateStr);
  }
}
