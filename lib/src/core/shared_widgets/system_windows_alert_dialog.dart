import 'dart:convert';
import 'dart:math';
import 'package:assets_audio_player/assets_audio_player.dart';
import '../models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:system_alert_window/system_alert_window.dart';

Future launchSystemAlertWindowsDialog() async {
  final now = DateTime.now();
  final List<CategoryModel> list =
      await rootBundle.loadString("assets/json/azkar.json").then((data) {
    List<dynamic>? response = json.decode(data);
    print(response);
    final List<CategoryModel> res =
        response!.map((e) => CategoryModel.fromJson(e)).toList();
    return res;
  }).catchError((error) {
    return print(error.toString());
  });
  int catIndex = Random(0).nextInt(list.length - 1);

  // bool permitted = false;
  // while (!permitted) {
  //   permitted = await SystemAlertWindow.checkPermissions() ?? false;
  //   await
  // }
  if (list.isEmpty) return;
  list.shuffle();
  final cat = list.first;
  cat.array!.shuffle();
  final quote = cat.array!.first;
  await SystemAlertWindow.requestPermissions();
  SystemAlertWindow.closeSystemWindow();
  SystemWindowHeader header = SystemWindowHeader(
    decoration: SystemWindowDecoration(
        endColor: Colors.green.shade400, startColor: Colors.white),
    title: SystemWindowText(
      text: "أذكـــار",
      fontSize: 18,
      fontWeight: FontWeight.BOLD,
      textColor: Colors.black,
    ),
    padding: SystemWindowPadding.setSymmetricPadding(12, 12),
    subTitle: SystemWindowText(
        text: "${cat.category}",
        fontSize: 18,
        fontWeight: FontWeight.BOLD,
        textColor: Colors.black),
  );

  SystemWindowFooter footer = SystemWindowFooter(
    buttons: [],
  );

  SystemWindowBody body = SystemWindowBody(
    rows: [
      EachRow(
        columns: [
          EachColumn(
            text: SystemWindowText(
                text: "${quote.text}",
                fontSize: 21,
                fontWeight: FontWeight.BOLD,
                padding: SystemWindowPadding.setSymmetricPadding(5, 5),
                textColor: Colors.black),
          ),
        ],
        gravity: ContentGravity.CENTER,
      ),
    ],
  );

  SystemAlertWindow.showSystemWindow(
    header: header,
    body: body,
    footer: footer,
    margin: SystemWindowMargin(left: 8, right: 8, top: 100, bottom: 0),
    gravity: SystemWindowGravity.CENTER,
    notificationTitle: "أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ",
    notificationBody: "Azkar Almuslim  أذكار المسلم",
  );
  final AssetsAudioPlayer audioP = AssetsAudioPlayer();
  audioP.open(
    Audio(
      'assets${quote.audio}',
    ),
  );
}