import 'package:flutter/material.dart';
import 'package:malontest/utils/constants.dart';

//Widget for bottom Navigation bar
class BottomNavigationItem extends StatelessWidget {
  final Icon icon;
  final double iconSize;
  final Function? onPressed;
  Color? color;

  BottomNavigationItem({
    required this.icon,
    required this.iconSize,
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
        iconSize: iconSize,
        color: color ?? kInactiveButtonColor,
        onPressed: () => onPressed!(),
        icon: icon);
  }
}
