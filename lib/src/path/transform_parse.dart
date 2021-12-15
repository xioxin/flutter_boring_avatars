// Copyright (c) 2016, SlickTech. All rights reserved. Use of this source code
// is governed by a MIT license that can be found in the LICENSE file.

import 'matrix.dart';

const OPERATIONS = const [
  'matrix',
  'scale',
  'rotate',
  'translate',
  'skewX',
  'skewY'
];

var CMD_SPLIT_REGEX = r'(\s*)[\(\)](\s*)';
var PARAMS_SPLIT_RE = r'([\s,]+)';

Matrix ParseTransform(String transform) {
  var matrix = new Matrix();

  var cmd, params;

  // Split value into ['', 'translate', '10 50', '', 'scale', '2', '', 'rotate',  '-45', '']
  for (var item in transform.split(new RegExp(CMD_SPLIT_REGEX))) {

    // Skip empty elements
    if (item.isEmpty) {
      continue;
    }

    // remember operation
    if (OPERATIONS.contains(item)) {
      cmd = item;
      continue;
    }

    // extract params & att operation to matrix
    params = item.split(new RegExp(PARAMS_SPLIT_RE)).map((i) {
      num val = double.parse(i);
      var integer = val.toInt();
      if (integer == val) {
        val = integer;
      }
      return val;
    }).toList();

    // If params count is not correct - ignore command
    switch (cmd) {
      case 'matrix':
        if (params.length == 6) {
          matrix.matrix(params);
        }
        continue;

      case 'scale':
        if (params.length == 1) {
          matrix.scale(params[0], params[0]);
        } else if (params.length == 2) {
          matrix.scale(params[0], params[1]);
        }
        continue;

      case 'rotate':
        if (params.length == 1) {
          matrix.rotate(params[0], 0, 0);
        } else if (params.length == 3) {
          matrix.rotate(params[0], params[1], params[2]);
        }
        continue;

      case 'translate':
        if (params.length == 1) {
          matrix.translate(params[0], 0);
        } else if (params.length == 2) {
          matrix.translate(params[0], params[1]);
        }
        continue;

      case 'skewX':
        if (params.length == 1) {
          matrix.skewX(params[0]);
        }
        continue;

      case 'skewY':
        if (params.length == 1) {
          matrix.skewY(params[0]);
        }
        continue;
    }
  }

  return matrix;
}
