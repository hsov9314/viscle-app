import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget roundedWidgetTile({BuildContext context, Widget child, Color color=Colors.white}) {
  return Container(
    width: 400,
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 10,
      color: color,
      child: child,
    ),
  );
}
