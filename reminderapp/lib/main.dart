import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:reminderapp/db/db_helper.dart';
import 'package:reminderapp/services/notification_services.dart';
import 'package:reminderapp/services/theme_service.dart';
import 'package:reminderapp/ui/home_page.dart';
import 'package:reminderapp/ui/theme.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    // Burada zamanlanmış görevinizi çalıştırabilirsiniz.
    // Bildirim gönderme işlemleri burada yapılabilir.
    return Future.value(true);
  });
}
Future<void> main() async {
 // await Workmanager().initialize(callbackDispatcher);
  WidgetsFlutterBinding.ensureInitialized();
   tzdata.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Europe/Istanbul'));
  await NotificationHelper.initialize();
   NotificationHelper().selectNotification(null);
  await DbHelper.initDb();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme:Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeService().theme,
      home: const HomePage(),
    );
  }
}


