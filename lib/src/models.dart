import 'package:flutter/material.dart';

class AdaptiveScaffoldDestination {
  final String title;
  final Icon icon;
  final Icon? activeIcon;
  final bool keepAlive;
  final WidgetBuilder bodyBuilder;
  final Function()? onTitleSelectedClick;

  const AdaptiveScaffoldDestination({
    required this.title,
    required this.icon,
    this.activeIcon,
    this.keepAlive = false,
    required this.bodyBuilder,
    this.onTitleSelectedClick,
  });
}
