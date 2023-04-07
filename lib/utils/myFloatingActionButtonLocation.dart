import 'package:flutter/material.dart';

class MyFloatingActionButtonLocation extends FloatingActionButtonLocation {
  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // Adjust the X and Y values to position the button as desired
    return Offset(scaffoldGeometry.scaffoldSize.width / 2 - 22,
        scaffoldGeometry.scaffoldSize.height - 100.0);
  }
}
