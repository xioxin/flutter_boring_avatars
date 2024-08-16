import 'dart:math';
import 'package:flutter/material.dart';

int boringAvatarHashCode(String name) {
  if (name.isEmpty) return 0;

  int hash = name.codeUnits.reduce((hash, character) {
    return (((hash << 5) - hash) + character) &
        0xFFFFFFFF; // Converted to 32bit integer
  });

  return hash.toSigned(32).abs();
}

int boringAvatarHashCodeOld(String name) {
  if (name.codeUnits.isEmpty) return 0;
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

Color getContrast(Color color) {
  final r = color.red;
  final g = color.green;
  final b = color.blue;
  final yiq = ((r * 299) + (g * 587) + (b * 114)) / 1000;
  return yiq >= 128 ? Colors.black : Colors.white;
}

double lerpDouble(double a, double b, double t) {
  return (a + (b - a) * t);
}

double lerpRotate(double a, double b, double t) {
  a = a % 360;
  b = b % 360;
  if (a < 0) a = 360 + a;
  if (b < 0) b = 360 + b;
  if (a == b) return a;
  if (b - a > 180) {
    b = b - 360;
  }
  if (a - b > 180) {
    a = a - 360;
  }
  return (a + (b - a) * t);
}

double lerpRotate180(double a, double b, double t) {
  a = a % 180;
  b = b % 180;
  if (a < 0) a = 180 + a;
  if (b < 0) b = 180 + b;
  if (a == b) return a;
  if (b - a > 90) {
    b = b - 180;
  }
  if (a - b > 90) {
    a = a - 180;
  }
  return (a + (b - a) * t);
}
