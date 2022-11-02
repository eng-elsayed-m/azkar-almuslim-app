import 'package:azkar/src/core/shared_widgets/system_windows_alert_dialog.dart';
import 'package:azkar/src/features/settings/settings_controller.dart';
import 'package:azkar/src/features/settings/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher);
  Workmanager().registerPeriodicTask(
      DateTime.now().toIso8601String(), DateTime.now().toString(),
      initialDelay: const Duration(seconds: 10),
      frequency: const Duration(minutes: 15),
      inputData: {});
  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();
  runApp(MyApp(settingsController: settingsController));
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await launchSystemAlertWindowsDialog();
    return Future.value(true);
  });
}