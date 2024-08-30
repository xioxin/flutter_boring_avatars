import 'package:flutter/material.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('BoringAvatarPalette operator == & hashCode', () {
    const palette1 = BoringAvatarPalette([
      Color(0xffA3A948),
      Color(0xffEDB92E),
      Color(0xffF85931),
      Color(0xffCE1836),
      Color(0xff009989)
    ]);
    const palette2 = BoringAvatarPalette([
      Color(0xffA3A948),
      Color(0xffEDB92E),
      Color(0xffF85931),
      Color(0xffCE1836),
      Color(0xff009989)
    ]);
    const palette3 = BoringAvatarPalette([
      Color(0xffA3A948),
      Color(0xffEDB92E),
      Color(0xffF85931),
      Color(0xffCE1836),
      Color(0xff009988)
    ]);
    expect(palette1 == palette2, true);
    expect(palette1 == palette3, false);

    expect(palette1.hashCode == palette2.hashCode, true);
    expect(palette1.hashCode == palette3.hashCode, false);
  });

  for (final type in BoringAvatarType.values) {
    test('BoringAvatarData $type operator == & hashCode', () {
      final data1 = BoringAvatarData.generate(
        name: 'Maya Angelou',
        type: type,
      );
      final data2 = BoringAvatarData.generate(
        name: 'Maya Angelou',
        type: type,
      );
      final data3 = BoringAvatarData.generate(
        name: 'Margaret Bourke',
        type: type,
      );
      expect(data1 == data2, true, reason: '== true');
      expect(data1 == data3, false, reason: '== false');
      expect(data1.hashCode == data2.hashCode, true, reason: 'hashCode true');
      expect(data1.hashCode == data3.hashCode, false, reason: 'hashCode false');
    });
  }

  for (final type in BoringAvatarType.values) {
    test('BoringAvatarData $type shape operator == & hashCode', () {
      final data1 = BoringAvatarData.generate(
        name: 'Maya Angelou',
        type: type,
        shape: const CircleBorder(),
      );
      final data2 = BoringAvatarData.generate(
        name: 'Maya Angelou',
        type: type,
      );
      expect(data1 == data2, false, reason: '== false');
      expect(data1.hashCode == data2.hashCode, false, reason: 'hashCode false');
    });
  }
}
