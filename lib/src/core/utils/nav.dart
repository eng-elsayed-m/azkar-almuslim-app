import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NV {
  static void nextScreen(context, page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  static void nextScreenOS(context, page) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) => page));
  }

  static void nextScreenCloseOthers(context, page) {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => page), (route) => false);
  }

  static void nextScreenReplace(context, page) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => page));
  }

  // Named

  static void nextScreenNamed(context, routeName) {
    Navigator.pushNamed(context, routeName);
  }

  static void nextScreenOSNamed(context, routeName) {
    Navigator.pushNamed(context, routeName);
  }

  static void nextScreenCloseOthersNamed(context, routeName) {
    Navigator.restorablePushNamedAndRemoveUntil(
        context, routeName, (route) => false);
  }

  static void nextScreenReplaceNamed(context, routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  static void nextScreenPopup(context, page) {
    Navigator.push(
      context,
      MaterialPageRoute(fullscreenDialog: true, builder: (context) => page),
    );
  }
}