import 'package:azkar/src/core/shared_widgets/system_windows_alert_dialog.dart';
import 'package:azkar/src/features/settings/settings_controller.dart';
import 'package:azkar/src/features/settings/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'src/app.dart';
import 'src/injection_container.dart' as di;

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await launchSystemAlertWindowsDialog();
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher);
  Workmanager().registerPeriodicTask(
      "com.fluttercommunity.customTaks", DateTime.now().toString(),
      initialDelay: const Duration(seconds: 10),
      frequency: const Duration(minutes: 15),
      inputData: {});
  di.init();
  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();
  runApp(MyApp(settingsController: settingsController));
}
