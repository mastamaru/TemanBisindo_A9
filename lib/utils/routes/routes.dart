import 'package:flutter/material.dart';
import 'package:temanbisindoa9/core/presentation/dictionary/dictionary.dart';
import 'package:temanbisindoa9/core/presentation/translate/translate.dart';
import 'package:temanbisindoa9/main.dart';

class Routes {
  static const String home = '/';
  static const String translate = '/translate';
  static const String dictionary = '/dictionary';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => Home());
      case translate:
        return MaterialPageRoute(builder: (_) => Translate());
      case dictionary:
        return MaterialPageRoute(builder: (_) => Dictionary());
      default:
        return MaterialPageRoute(builder: (_) => Home());
    }
  }
}
