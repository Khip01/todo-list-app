import 'package:flutter/material.dart';
import 'package:todo_list_app/utils/helper/local_notification_helper.dart';

import 'app.dart';

void main() async {
  // Init Notification And Local Timezone
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotificationHelper.initLocalNotification();

  runApp(MainApp());
}