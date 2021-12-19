import 'dart:math';

import 'dart:ui';

import 'package:flutter/material.dart';

List<Color> defaultBoringAvatarsColors = [
  const Color(0xffA3A948),
  const Color(0xffEDB92E),
  const Color(0xffF85931),
  const Color(0xffCE1836),
  const Color(0xff009989)
];

int getNumber(String name) {
  if(name.codeUnits.isEmpty) return 0;
  return name.codeUnits.reduce((a, b) => a + b);
}
int getModulus(int num, int max) => num % max;
int getDigit(int number, int ntn) => (number / pow(10, ntn) % 10).floor();
bool getBoolean(int number, int ntn) => getDigit(number, ntn) % 2 == 0;
double getAngle(double x, double y) => atan2(y, x) * 180 / pi;
double getUnit(int number, int range, [int index = 0]) {
  int value = number % range;
  if (index > 0 && (getDigit(number, index) % 2) == 0) {
    return (-value).toDouble();
  } else {
    return (value).toDouble();
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

double lerpDouble(double a, double b, double t) {
  return (a + (b - a) * t );
}

double lerpRotate(double a, double b, double t) {
  a = a % 360;
  b = b % 360;
  if(a < 0) a = 360 + a;
  if(b < 0) b = 360 + b;
  if(a == b) return a;
  if(b - a > 180) {
    b = b - 360;
  }
  if(a - b > 180) {
    a = a - 360;
  }
  return (a + (b - a) * t );
}

double lerpRotate180(double a, double b, double t) {
  a = a % 180;
  b = b % 180;
  if(a < 0) a = 180 + a;
  if(b < 0) b = 180 + b;
  if(a == b) return a;
  if(b - a > 90) {
    b = b - 180;
  }
  if(a - b > 90) {
    a = a - 180;
  }
  return (a + (b - a) * t );
}