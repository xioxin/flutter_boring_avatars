import 'dart:math';

import 'dart:ui';

import 'package:flutter/material.dart';

int getNumber(String name) {
  if(name.codeUnits.isEmpty) return 0;
  return name.codeUnits.reduce((a, b) => a + b);
}
int getModulus(int num, int max) => num % max;
int getDigit(int number, int ntn) => (number / pow(10, ntn) % 10).floor();
bool getBoolean(int number, int ntn) => getDigit(number, ntn) % 2 == 0;
double getAngle(double x, double y) => atan2(y, x) * 180 / pi;
int getUnit(int number, int range, [int index = 0]) {
  int value = number % range;
  if (index > 0 && (getDigit(number, index) % 2) == 0) {
    return -value;
  } else {
    return value;
  }
}

T getRandomColor<T>(int number, List<T> colors, int range) {
  return colors[(number) % range];
}

Color getContrast(Color color) {
  final r = color.red;
  final g = color.green;
  final b = color.blue;
  final yiq = ((r * 299) + (g * 587) + (b * 114)) / 1000;
  return yiq >= 128 ? Colors.black : Colors.white;
}

String translate(int x, int y) {
  return "translate($x $y)";
}

String rotate(int a, int x, int y) {
  return "rotate($a $x $y)";
}

String scale(double s) {
  return "scale($s)";
}
