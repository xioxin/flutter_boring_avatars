// Copyright (c) 2016, SlickTech. All rights reserved. Use of this source code
// is governed by a MIT license that can be found in the LICENSE file.

import 'dart:math';
import 'path_parse.dart';
import 'matrix.dart';
import 'ellipse.dart';
import 'a2c.dart';
import 'transform_parse.dart';
import 'bounding_box.dart';

export 'path_parse.dart' show ParseResult;

typedef Iterator(List s, int index, num x, num y);

class SvgPath {
  String? err;

  // Array of path segments.
  // Each segment is array [command, param1, param2, ...]
  late List<List<dynamic>> segments;

  // Transforms stack for lazy evaluation
  List _stack = [];

  BoundingBox? _bbox;

  SvgPath(String path) {
    var pr = parsePath(path);
    err = pr.err;
    segments = pr.segments;
  }

  SvgPath._clone(List<List<dynamic>> segs) {
    segments = [];
    for (var seg in segs) {
      segments.add([]);
      segments.last.addAll(seg);
    }
  }

  void _matrix(Matrix m) {
    if (m.queue.isEmpty) {
      return;
    }

    iterate((List s, int index, num x, num y) {
      var p, result;

      switch (s[0]) {
        case 'v':
          p = m.calc(0, s[1], isRelative: true);
          result = (p[0] == 0) ? ['v', p[1]] : ['l', p[0], p[1]];
          break;

        case 'V':
          p = m.calc(x, s[1]);
          result = (p[0] == m.calc(x, y)[0]) ? ['V', p[1]] : ['L', p[0], p[1]];
          break;

        case 'h':
          p = m.calc(s[1], 0, isRelative: true);
          result = (p[1] == 0) ? ['h', p[0]] : ['l', p[0], p[1]];
          break;

        case 'H':
          p = m.calc(s[1], y);
          result = (p[1] == m.calc(x, y)[1]) ? ['H', p[0]] : ['L', p[0], p[1]];
          break;

        case 'a':
        case 'A':
          // ARC is: ['A', rx, ry, x-axis-rotation, large-arc-flag, sweep-flag, x, y]

          // Drop segment if arc is empty (end point === start point)
          /* if ((s[0] == 'A' && s[6] == x && s[7] == y) ||
            (s[0] == 'a' && s[6] == 0 && s[7] == 0)) {
            return [];
          }*/

          // Transform rx, ry and the x-axis-rotation
          var ma = m.toArray();
          var ellipse = Ellipse(s[1], s[2], s[3]);
          ellipse.transform(ma);

          // flip sweep-flag if matrix is not orientation-preserving
          if (ma[0] * ma[3] - ma[1] * ma[2] < 0) {
            s[5] = s[5] != 0 ? '0' : '1';
          }

          // Transform end point as usual (without translation for relative notation)
          p = m.calc(s[6], s[7], isRelative: s[0] == 'a');

          // Empty arcs can be ignored by renderer, but should not be dropped
          // to avoid collisions with `S A S` and so on. Replace with empty line.
          if ((s[0] == 'A' && s[6] == x && s[7] == y) ||
              (s[0] == 'a' && s[6] == 0 && s[7] == 0)) {
            result = [s[0] == 'a' ? 'l' : 'L', p[0], p[1]];
            break;
          }

          // if the resulting ellipse is (almost) a segment ...
          if (ellipse.isDegenerate) {
            // replace the arc by a line
            result = [s[0] == 'a' ? 'l' : 'L', p[0], p[1]];
          } else {
            // if it is a real ellipse
            // s[0], s[4] and s[5] are not modified
            result = [
              s[0],
              ellipse.rx,
              ellipse.ry,
              ellipse.ax,
              s[4],
              s[5],
              p[0],
              p[1]
            ];
          }
          break;

        case 'm':
          // Edge case. The very first `m` should be processed as absolute, if happens.
          // Make sense for coord shift transforms.
          var isRelative = index > 0;

          p = m.calc(s[1], s[2], isRelative: isRelative);
          result = ['m', p[0], p[1]];
          break;

        default:
          var name = s[0];
          result = [name];
          var isRelative = name.toLowerCase() == name;

          // Apply transformations to the segment
          for (int i = 1; i < s.length; i += 2) {
            p = m.calc(s[i], s[i + 1], isRelative: isRelative);
            result.addAll([p[0], p[1]]);
          }
      }

      segments[index] = result;
    });
  }

  // Apply stacked commands
  void _evaluateStack() {
    if (_stack.isEmpty) {
      return;
    }

    if (_stack.length == 1) {
      _matrix(_stack[0]);
      _stack = [];
      _bbox = null;
      return;
    }

    var m = Matrix();
    var i = _stack.length;

    while (--i >= 0) {
      m.matrix(_stack[i].toArray());
    }

    _matrix(m);
    _stack = [];
    _bbox = null;
  }

  // Convert processed SVG path back to strings
  @override
  String toString() {
    _evaluateStack();

    var elements = [];
    var cmd, skipCmd;

    for (var i = 0; i < segments.length; i++) {
      // remove repeating commands names
      cmd = segments[i][0];
      skipCmd = i > 0 && cmd != 'm' && cmd != 'M' && cmd == segments[i - 1][0];
      elements.addAll(skipCmd ? segments[i].sublist(1) : segments[i]);
    }

    return elements
        .join(' ')
        // Optimizations: remove spaces around commands & before `-`
        //
        // We could also remove leading zeros for `0.5`-like values,
        // but their count is too small to spend time for.
        .replaceAllMapped(
            RegExp(r' ?([achlmqrstvz]) ?', caseSensitive: false),
            (Match m) => '${m[1]}')
        .replaceAll(r' -', '-')
        // workaround for FontForge SVG importing bug
        .replaceAll(r'zm', 'z m');
  }

  // Translate path to (x [, y])
  SvgPath translate(num x, [num y = 0]) {
    _stack.add(Matrix()..translate(x, y));
    return this;
  }

  // Scale path to (sx [, sy])
  // sy = sx if not specified
  SvgPath scale(num sx, [num? sy]) {
    _stack.add(Matrix()..scale(sx, sy == null ? sx : sy));
    return this;
  }

  // Rotate path to (angle, [rx, ry])
  SvgPath rotate(num angle, [num rx = 0, num ry = 0]) {
    _stack.add(Matrix()..rotate(angle, rx, ry));
    return this;
  }

  // Skew path along the X axis by `degrees` angle
  SvgPath skewX(num degrees) {
    _stack.add(Matrix()..skewX(degrees));
    return this;
  }

  // Skew path along the Y axis by `degrees` angle
  SvgPath skewY(num degrees) {
    _stack.add(Matrix()..skewY(degrees));
    return this;
  }

  // Apply matrix transform (array of 6 elements)
  SvgPath matrix(List<num> m) {
    _stack.add(Matrix()..matrix(m));
    return this;
  }

  // Transform path according to "transform" attr of SVG spec
  SvgPath transform(String transformString) {
    if (transformString.trim().isEmpty) {
      return this;
    }

    _stack.add(ParseTransform(transformString));
    return this;
  }

  // Round coords with given decimal precision.
  // 0 by default (to integers)
  SvgPath round([int digits = 0]) {
    _evaluateStack();

    num contourStartDeltaX = 0;
    num contourStartDeltaY = 0;
    num deltaX = 0;
    num deltaY = 0;

    for (var seg in segments) {
      var isRelative = (seg[0].toLowerCase() == seg[0]);

      switch (seg[0]) {
        case 'H':
        case 'h':
          if (isRelative) {
            seg[1] += deltaX;
          }
          deltaX = seg[1] - double.parse(seg[1].toStringAsFixed(digits));
          seg[1] = toFixed(seg[1], digits);
          break;

        case 'V':
        case 'v':
          if (isRelative) {
            seg[1] += deltaY;
          }
          deltaY = seg[1] - double.parse(seg[1].toStringAsFixed(digits));
          seg[1] = toFixed(seg[1], digits);
          break;

        case 'Z':
        case 'z':
          deltaX = contourStartDeltaX;
          deltaY = contourStartDeltaY;
          break;

        case 'M':
        case 'm':
          if (isRelative) {
            seg[1] += deltaX;
            seg[2] += deltaY;
          }

          deltaX = seg[1] - double.parse(seg[1].toStringAsFixed(digits));
          deltaY = seg[2] - double.parse(seg[2].toStringAsFixed(digits));

          contourStartDeltaX = deltaX;
          contourStartDeltaY = deltaY;

          seg[1] = toFixed(seg[1], digits);
          seg[2] = toFixed(seg[2], digits);
          break;

        case 'A':
        case 'a':
          // [cmd, rx, ry, x-axis-rotation, large-arc-flag, sweep-flag, x, y]
          if (isRelative) {
            seg[6] += deltaX;
            seg[7] += deltaY;
          }

          deltaX = seg[6] - double.parse(seg[6].toStringAsFixed(digits));
          deltaY = seg[7] - double.parse(seg[7].toStringAsFixed(digits));

          seg[1] = toFixed(seg[1], digits);
          seg[2] = toFixed(seg[2], digits);
          seg[3] = toFixed(seg[3], digits + 2); // better precision for rotation
          seg[6] = toFixed(seg[6], digits);
          seg[7] = toFixed(seg[7], digits);
          break;

        default:
          // a c l q s t
          var l = seg.length;

          if (isRelative) {
            seg[l - 2] += deltaX;
            seg[l - 1] += deltaY;
          }

          deltaX =
              seg[l - 2] - double.parse(seg[l - 2].toStringAsFixed(digits));
          deltaY =
              seg[l - 1] - double.parse(seg[l - 1].toStringAsFixed(digits));

          for (int i = 1; i < l; i++) {
            seg[i] = toFixed(seg[i], digits);
          }
          break;
      }
    }
    return this;
  }

  // Apply iterator function to all segments. If function returns result,
  // current segment will be replaced to array of returned segments.
  // If empty array is returned, current segment will be deleted.
  SvgPath iterate(Iterator iterator, {bool keepLazyStack: true}) {
    if (!keepLazyStack) {
      _evaluateStack();
    }

    var index = 0;
    var lastX = 0;
    var lastY = 0;
    var countourStartX = 0;
    var countourStartY = 0;

    var replacements = {};
    var needReplace = false;

    for (var seg in segments) {
      var res = iterator(seg, index, lastX, lastY);

      if (res is List) {
        replacements[index] = res;
        needReplace = true;
      }

      var isRelative = (seg[0] == seg[0].toLowerCase());

      // calculate absolute X and Y
      switch (seg[0]) {
        case 'm':
        case 'M':
          lastX = seg[1] + (isRelative ? lastX : 0);
          lastY = seg[2] + (isRelative ? lastY : 0);
          countourStartX = lastX;
          countourStartY = lastY;
          break;

        case 'h':
        case 'H':
          lastX = seg[1] + (isRelative ? lastX : 0);
          break;

        case 'v':
        case 'V':
          lastY = seg[1] + (isRelative ? lastY : 0);
          break;

        case 'z':
        case 'Z':
          // That make sense for multiple contours
          lastX = countourStartX;
          lastY = countourStartY;
          break;

        default:
          lastX = seg[seg.length - 2] + (isRelative ? lastX : 0);
          lastY = seg[seg.length - 1] + (isRelative ? lastY : 0);
          break;
      }
      ++index;
    }

    // Replace segments if iterator return results

    if (!needReplace) {
      return this;
    }

    var newSegments = <List<dynamic>>[];

    for (int i = 0; i < segments.length; i++) {
      if (replacements[i] != null) {
        newSegments.addAll(replacements[i]);
      } else {
        newSegments.add(segments[i]);
      }
    }

    segments = newSegments;

    return this;
  }

  // Converts segments from relative to absolute
  SvgPath abs() {
    iterate((List s, int index, num x, num y) {
      var cmd = s[0];
      var cmdUC = cmd.toUpperCase();

      // Skip absolute commands
      if (cmd == cmdUC) {
        return;
      }

      s[0] = cmdUC;

      switch (cmd) {
        case 'v':
          // v has shifted coords parity
          s[1] += y;
          return;

        case 'a':
          // ARC is: ['A', rx, ry, x-axis-rotation, large-arc-flag, sweep-flag, x, y]
          // touch x, y only
          s[6] += x;
          s[7] += y;
          return;

        default:
          for (int i = 1; i < s.length; i++) {
            s[i] += (i % 2) != 0 ? x : y; // odd values are X, even - Y
          }
      }
    });
    return this;
  }

  // Converts segments from absolute to relative
  SvgPath rel() {
    iterate((List s, int index, num x, num y) {
      var cmd = s[0];
      var cmdLC = cmd.toLowerCase();

      // Skip relative commands
      if (cmd == cmdLC) {
        return;
      }

      // Don't touch the first M to avoid potential confusions.
      if (index == 0 && cmd == 'M') {
        return;
      }

      s[0] = cmdLC;

      switch (cmd) {
        case 'V':
          // V has shifted coords parity
          s[1] -= y;
          return;

        case 'A':
          // ARC is: ['A', rx, ry, x-axis-rotation, large-arc-flag, sweep-flag, x, y]
          // touch x, y only
          s[6] -= x;
          s[7] -= y;
          return;

        default:
          for (int i = 1; i < s.length; i++) {
            s[i] -= (i % 2) != 0 ? x : y; // odd values are X, even - Y
          }
      }
    });
    return this;
  }

  // Converts arcs to cubic bézier curves
  SvgPath unarc() {
    iterate((List s, int index, num x, num y) {
      var cmd = s[0];

      // Skip anything except arcs
      if (cmd != 'A' && cmd != 'a') {
        return null;
      }

      var nextX, nextY;
      if (cmd == 'a') {
        // convert relative arc coordinates to absolute
        nextX = x + s[6];
        nextY = y + s[7];
      } else {
        nextX = s[6];
        nextY = s[7];
      }

      var newSegments = a2c(x, y, nextX, nextY, s[4], s[5], s[1], s[2], s[3]);

      // Degenerated arcs can be ignored by renderer, but should not be dropped
      // to avoid collisions with `S A S` and so on. Replace with empty line.
      if (newSegments.isEmpty) {
        return [
          [s[0] == 'a' ? 'l' : 'L', s[6], s[7]]
        ];
      }

      var result = <List<dynamic>>[];
      for (var newSeg in newSegments) {
        result.add([
          'C',
          newSeg[2],
          newSeg[3],
          newSeg[4],
          newSeg[5],
          newSeg[6],
          newSeg[7]
        ]);
      }

      return result;
    });
    return this;
  }

  // Converts smooth curves (with missed control point) to generic curves
  SvgPath unshort() {
    var prevControlX, prevControlY, prevSegment;
    var curControlX, curControlY;

    // TODO: add lazy evaluation flag when relative commands supported

    iterate((List s, int index, num x, num y) {
      var cmd = s[0];
      var cmdUC = cmd.toUpperCase();

      // First command MUST be M|m, it's safe to skip.
      // Protect from access to [-1] for sure.
      if (index == 0) {
        return;
      }

      if (cmdUC == 'T') {
        // quadratic curve
        var isRelative = (cmd == 't');

        var prevSegment = segments[index - 1];

        if (prevSegment[0] == 'Q') {
          prevControlX = prevSegment[1] - x;
          prevControlY = prevSegment[2] - y;
        } else if (prevSegment[0] == 'q') {
          prevControlX = prevSegment[1] - prevSegment[3];
          prevControlY = prevSegment[2] - prevSegment[4];
        } else {
          prevControlX = 0;
          prevControlY = 0;
        }

        curControlX = -prevControlX;
        curControlY = -prevControlY;

        if (!isRelative) {
          curControlX += x;
          curControlY += y;
        }

        segments[index] = [
          isRelative ? 'q' : 'Q',
          curControlX,
          curControlY,
          s[1],
          s[2]
        ];
      } else if (cmdUC == 'S') {
        // cubic curve
        var isRelative = (cmd == 's');

        prevSegment = segments[index - 1];

        if (prevSegment[0] == 'C') {
          prevControlX = prevSegment[3] - x;
          prevControlY = prevSegment[4] - y;
        } else if (prevSegment[0] == 'c') {
          prevControlX = prevSegment[3] - prevSegment[5];
          prevControlY = prevSegment[4] - prevSegment[6];
        } else {
          prevControlX = 0;
          prevControlY = 0;
        }

        curControlX = -prevControlX;
        curControlY = -prevControlY;

        if (!isRelative) {
          curControlX += x;
          curControlY += y;
        }

        segments[index] = [
          isRelative ? 'c' : 'C',
          curControlX,
          curControlY,
          s[1],
          s[2],
          s[3],
          s[4]
        ];
      }
    });
    return this;
  }

  // Get the bounding box of the path
  BoundingBox get boundingBox {
    _evaluateStack();

    if (_bbox != null) {
      return _bbox!;
    }

    // create a temporary path to avoid manipulate this
    var path = SvgPath._clone(segments);

    // from https://github.com/icons8/svg-path-bounding-box
    var x1 = double.maxFinite;
    var y1 = double.maxFinite;
    var x2 = -double.maxFinite;
    var y2 = -double.maxFinite;

    // from https://github.com/gabelerner/canvg/blob/860e418aca67b9a41e858a223d74d375793ec364/canvg.js#L449
    var addX = (num x) {
      var xd = x.toDouble();
      x1 = min(x1, xd);
      x2 = max(x2, xd);
    };

    var addY = (num y) {
      var yd = y.toDouble();
      y1 = min(y1, yd);
      y2 = max(y2, yd);
    };

    var addPoint = (num x, num y) {
      addX(x);
      addY(y);
    };

    var addBezierCurve = (num p0x, num p0y, num p1x, num p1y, num p2x, num p2y, num p3x, num p3y) {
      // from http://blog.hackers-cafe.net/2009/06/how-to-calculate-bezier-curves-bounding.html
      var p0 = [p0x, p0y];
      var p1 = [p1x, p1y];
      var p2 = [p2x, p2y];
      var p3 = [p3x, p3y];

      addPoint(p0[0], p0[1]);
      addPoint(p3[0], p3[1]);

      for (var i = 0; i <= 1; i++) {
        var f = (t) {
          return pow(1 - t, 3) * p0[i]
              + 3 * pow(1 - t, 2) * t * p1[i]
              + 3 * (1 - t) * pow(t, 2) * p2[i]
              + pow(t, 3) * p3[i];
        };

        var b = 6 * p0[i] - 12 * p1[i] + 6 * p2[i];
        var a = -3 * p0[i] + 9 * p1[i] - 9 * p2[i] + 3 * p3[i];
        var c = 3 * p1[i] - 3 * p0[i];

        if (a == 0) {
          if (b == 0) {
            continue;
          }

          var t = -c / b;
          if (0 < t && t < 1) {
            if (i == 0) {
              addX(f(t));
            }

            if (i == 1) {
              addY(f(t));
            }
          }
          continue;
        }

        var b2ac = pow(b, 2) - 4 * c * a;
        if (b2ac < 0) {
          continue;
        }

        var t1 = (-b + sqrt(b2ac)) / (2 * a);
        if (0 < t1 && t1 < 1) {
          if (i == 0) {
            addX(f(t1));
          }
          if (i == 1) {
            addY(f(t1));
          }
        }

        var t2 = (-b - sqrt(b2ac)) / (2 * a);
        if (0 < t2 && t2 < 1) {
          if (i == 0) {
            addX(f(t2));
          }
          if (i == 1) {
            addY(f(t2));
          }
        }
      }
    };

    var addQuadraticCurve = (num p0x, num p0y, num p1x, num p1y, num p2x, num p2y) {
      var cp1x = p0x + 2 / 3 * (p1x - p0x); // CP1 = QP0 + 2/3 *(QP1-QP0)
      var cp1y = p0y + 2 / 3 * (p1y - p0y); // CP1 = QP0 + 2/3 *(QP1-QP0)
      var cp2x = cp1x + 1 / 3 * (p2x - p0x); // CP2 = CP1 + 1/3 *(QP2-QP0)
      var cp2y = cp1y + 1 / 3 * (p2y - p0y); // CP2 = CP1 + 1/3 *(QP2-QP0)
      addBezierCurve(p0x, p0y, cp1x, cp1y, cp2x, cp2y, p2x, p2y);
    };

    path.abs().unarc().unshort().iterate((List seg, int index, num x, num y) {
      switch (seg[0]) {
        case 'M':
        case 'L':
          addPoint(seg[1], seg[2]);
          break;
        case 'H':
          addX(seg[1]);
          break;
        case 'V':
          addY(seg[1]);
          break;
        case 'Q':
          addQuadraticCurve(x, y, seg[1], seg[2], seg[3], seg[4]);
          break;
        case 'C':
          addBezierCurve(x, y, seg[1], seg[2], seg[3], seg[4], seg[5], seg[6]);
          break;
      }
    });
    _bbox = BoundingBox(x1, y1, x2 - x1, y2 - y1);

    return _bbox!;
  }
}
