import 'dart:math';

int getNumber(String name) => name.codeUnits.reduce((a, b) => a + b);
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

String getRandomColor(int number, List<String> colors, int range) {
  return colors[(number) % range];
}

String getContrast(String hexcolor) {
  if (hexcolor[0] == '#') {
    hexcolor = hexcolor.substring(1);
  }
  final r = int.parse(hexcolor.substring(0, 2), radix: 16);
  final g = int.parse(hexcolor.substring(2, 4), radix: 16);
  final b = int.parse(hexcolor.substring(4, 6), radix: 16);
  final yiq = ((r * 299) + (g * 587) + (b * 114)) / 1000;
  return yiq >= 128 ? 'black' : 'white';
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
