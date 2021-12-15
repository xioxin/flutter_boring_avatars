// Copyright (c) 2016, SlickTech. All rights reserved. Use of this source code
// is governed by a MIT license that can be found in the LICENSE file.

import 'dart:math';

import 'matrix.dart';

const epsilon = 0.0000000001;

// To convert degree in radians
const torad = pi / 180;

class Ellipse {
  num rx;
  num ry;
  num ax;

  Ellipse(this.rx, this.ry, this.ax);

  // Apply a linear transform m to the ellipse
  // m is an array representing a matrix :
  //    -         -
  //   | m[0] m[2] |
  //   | m[1] m[3] |
  //    -         -
  void transform(List<num> m) {
    // We consider the current ellipse as image of the unit circle
    // by first scale(rx,ry) and then rotate(ax) ...
    // So we apply ma =  m x rotate(ax) x scale(rx,ry) to the unit circle.
    var c = cos(ax * torad);
    var s = sin(ax * torad);
    var ma = [
      rx * (m[0] * c + m[2] * s),
      rx * (m[1] * c + m[3] * s),
      ry * (-m[0] * s + m[2] * c),
      ry * (-m[1] * s + m[3] * c)
    ];

    // ma * transpose(ma) = [ J L ]
    //                      [ L K ]
    // L is calculated later (if the image is not a circle)
    var J = ma[0] * ma[0] + ma[2] * ma[2];
    var K = ma[1] * ma[1] + ma[3] * ma[3];

    // the discriminant of the characteristic polynomial of ma * transpose(ma)
    var D = ((ma[0] - ma[3]) * (ma[0] - ma[3]) +
            (ma[2] + ma[1]) * (ma[2] + ma[1])) *
        ((ma[0] + ma[3]) * (ma[0] + ma[3]) + (ma[2] - ma[1]) * (ma[2] - ma[1]));

    // the "mean eigenvalue"
    var JK = (J + K) / 2;

    // check if the image is (almost) a circle
    if (D < epsilon * JK) {
      // if it is
      rx = ry = fixInt(sqrt(JK));
      ax = 0;
      return;
    }

    // if it is not a circle
    var L = ma[0] * ma[1] + ma[2] * ma[3];

    D = sqrt(D);

    // {l1,l2} = the two eigen values of ma * transpose(ma)
    var l1 = JK + D / 2;
    var l2 = JK - D / 2;

    // the x - axis - rotation angle is the argument of the l1 - eigenvector
    ax = (L.abs() < epsilon && (l1 - K).abs() < epsilon)
        ? 90
        : fixInt(atan(L.abs() > (l1 - K).abs() ? (l1 - J) / L : L / (l1 - K)) *
            180 /
            pi);

    // if ax > 0 => rx = sqrt(l1), ry = sqrt(l2), else exchange axes and ax += 90
    if (ax >= 0) {
      // if ax in [0,90]
      rx = fixInt(sqrt(l1));
      ry = fixInt(sqrt(l2));
    } else {
      // if ax in ]-90,0[ => exchange axes
      ax += 90;
      rx = fixInt(sqrt(l2));
      ry = fixInt(sqrt(l1));
    }
  }

  bool get isDegenerate => rx < epsilon * ry || ry < epsilon * rx;
}
