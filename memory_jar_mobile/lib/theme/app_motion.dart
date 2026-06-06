import 'package:flutter/material.dart';

class AppMotion {
  static const fast = Duration(milliseconds: 120);
  static const normal = Duration(milliseconds: 240);
  static const slow = Duration(milliseconds: 400);
  static const deliberate = Duration(milliseconds: 600);
  static const cinematic = Duration(milliseconds: 1000);

  static const standard = Curves.easeInOutCubic;
  static const decelerate = Curves.easeOutCubic;
  static const accelerate = Curves.easeInCubic;
  static const emphasized = Curves.easeInOutCubicEmphasized;
}
