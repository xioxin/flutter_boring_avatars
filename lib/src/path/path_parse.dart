// Copyright (c) 2016, SlickTech. All rights reserved. Use of this source code
// is governed by a MIT license that can be found in the LICENSE file.

const _paramCounts = {
  'a': 7,
  'c': 6,
  'h': 1,
  'l': 2,
  'm': 2,
  'r': 4,
  'q': 4,
  's': 4,
  't': 2,
  'v': 1,
  'z': 0
};

const _SPACES = [
  0x1680,

  // Line terminators
  0x0A,
  0x0D,
  0x2028,
  0x2029,

  // White spaces
  0x20,
  0x09,
  0x0B,
  0x0C,
  0xA0,

  // Special spaces
  0x1680,
  0x180E,
  0x2000,
  0x2001,
  0x2002,
  0x2003,
  0x2004,
  0x2005,
  0x2006,
  0x2007,
  0x2008,
  0x2009,
  0x200A,
  0x202F,
  0x205F,
  0x3000,
  0xFEFF
];

bool _isSpace(int ch) {
  return _SPACES.contains(ch) || ch.compareTo(_SPACES.first) > 0;
}

bool _isCommand(int ch) {
  switch (ch | 0x20) {
    case 0x6D /* m */ :
      return true;
    case 0x7A /* z */ :
      return true;
    case 0x6C /* l */ :
      return true;
    case 0x68 /* h */ :
      return true;
    case 0x76 /* v */ :
      return true;
    case 0x63 /* c */ :
      return true;
    case 0x73 /* s */ :
      return true;
    case 0x71 /* q */ :
      return true;
    case 0x74 /* t */ :
      return true;
    case 0x61 /* a */ :
      return true;
    case 0x72 /* r */ :
      return true;
  }
  return false;
}

bool _isDigit(int ch) {
  return ch >= 48 && ch <= 57;
}

bool _isDigitStart(int ch) {
  return _isDigit(ch) ||
      ch == 0x2B /* + */ ||
      ch == 0x2D /* - */ ||
      ch == 0x2E /* . */;
}

class _State {
  final String path;

  int index = 0;
  int max;
  final List<List> result = [];
  num param = 0;
  String err = '';
  int segmentStart = 0;
  List data = [];

  _State(this.path) : max = path.length;
}

void _skipSpaces(_State state) {
  while (
      state.index < state.max && _isSpace(state.path.codeUnitAt(state.index))) {
    ++state.index;
  }
}

void _scanParam(_State state) {
  var start = state.index;
  var index = start;
  if (index >= state.max) {
    state.err = 'SvgPath: missed param (at pos $index)';
    return;
  }

  int? ch = state.path.codeUnitAt(index);

  if (ch == 0x2B /* + */ || ch == 0x2D /* - */) {
    ++index;
    ch = (index < state.max) ? state.path.codeUnitAt(index) : 0;
  }

  // This logic is shamelessly borrowed from Esprima
  // https://github.com/ariya/esprimas
  //
  if (!_isDigit(ch) && ch != 0x2E /* . */) {
    state.err = 'SvgPath: param should start with 0..9 or `.` (at pos $index)';
    return;
  }

  var hasCeiling = false;
  var hasDot = false;
  var hasDecimal = false;

  if (ch != 0x2E /* . */) {
    var zeroFirst = (ch == 0x30 /* 0 */);
    index++;

    ch = (index < state.max) ? state.path.codeUnitAt(index) : null;

    if (zeroFirst && index < state.max) {
      // decimal number starts with '0' such as '09' is illegal.
      if (ch != null && _isDigit(ch)) {
        state.err =
            'SvgPath: numbers started with `0` such as `09` are ilegal (at pos $start)';
        return;
      }
    }

    while (index < state.max && _isDigit(state.path.codeUnitAt(index))) {
      index++;
      hasCeiling = true;
    }
    ch = (index < state.max) ? state.path.codeUnitAt(index) : null;
  }

  if (ch == 0x2E /* . */) {
    hasDot = true;
    index++;
    while (index < state.max && _isDigit(state.path.codeUnitAt(index))) {
      index++;
      hasDecimal = true;
    }
    ch = (index < state.max) ? state.path.codeUnitAt(index) : null;
  }

  if (ch == 0x65 /* e */ || ch == 0x45 /* E */) {
    if (hasDot && !hasCeiling && !hasDecimal) {
      state.err = 'SvgPath: invalid float exponent (at pos $index)';
      return;
    }

    ++index;

    ch = (index < state.max) ? state.path.codeUnitAt(index) : null;
    if (ch == 0x2B /* + */ || ch == 0x2D /* - */) {
      index++;
    }
    if (index < state.max && _isDigit(state.path.codeUnitAt(index))) {
      while (index < state.max && _isDigit(state.path.codeUnitAt(index))) {
        ++index;
      }
    } else {
      state.err = 'SvgPath: invalid float exponent (at pos $index)';
      return;
    }
  }
  state.index = index;
  state.param = double.parse(state.path.substring(start, index));

  // Fix integer value
  var integer = state.param.toInt();
  if (integer == state.param) {
    // this is a integer value
    state.param = integer;
  }
}

void _finalizeSegment(_State state) {
  // Process duplicated commands (without command name)

  // This logic is shamelessly borrowed from Raphael
  // https://github.com/DmitryBaranovskiy/raphael/
  //
  var cmd = state.path[state.segmentStart];
  var cmdLC = cmd.toLowerCase();

  var params = state.data;

  if (cmdLC == 'm' && params.length > 2) {
    state.result.add([cmd, params[0], params[1]]);
    params = params.sublist(2);
    cmdLC = 'l';
    cmd = (cmd == 'm') ? 'l' : 'L';
  }

  if (cmdLC == 'r') {
    var seg = <dynamic>[cmd];
    seg.addAll(params);
    state.result.add(seg);
  } else {
    while (params.length >= _paramCounts[cmdLC]!) {
      var seg = <dynamic>[cmd];
      seg.addAll(params.sublist(0, _paramCounts[cmdLC]));
      params.removeRange(0, _paramCounts[cmdLC]!);
      state.result.add(seg);
      if (_paramCounts[cmdLC] == 0) {
        break;
      }
    }
  }
}

void _scanSegment(_State state) {
  state.segmentStart = state.index;
  var cmdCode = state.path.codeUnitAt(state.index);

  if (!_isCommand(cmdCode)) {
    state.err =
        'SvgPath: bad command ${state.path[state.index]} (at pos ${state.index})';
    return;
  }

  var need_params = _paramCounts[state.path[state.index].toLowerCase()];

  state.index++;
  _skipSpaces(state);

  state.data = [];

  if (need_params == 0) {
    // Z
    _finalizeSegment(state);
    return;
  }

  var comma_found = false;

  for (;;) {
    for (int i = need_params!; i > 0; i--) {
      _scanParam(state);
      if (state.err.isNotEmpty) {
        return;
      }
      state.data.add(state.param);

      _skipSpaces(state);
      comma_found = false;

      if (state.index < state.max &&
          state.path.codeUnitAt(state.index) == 0x2C /* , */) {
        state.index++;
        _skipSpaces(state);
        comma_found = true;
      }
    }

    // after ',' param is mandatory
    if (comma_found) {
      continue;
    }

    if (state.index >= state.max) {
      break;
    }

    // Stop on next segment
    if (!_isDigitStart(state.path.codeUnitAt(state.index))) {
      break;
    }
  }

  _finalizeSegment(state);
}

class ParseResult {
  final String err;
  final List<List<dynamic>> segments;

  ParseResult(this.err, this.segments);
}

ParseResult parsePath(String path) {
  var state = _State(path);
  _skipSpaces(state);

  while (state.index < state.max && state.err.isEmpty) {
    _scanSegment(state);
  }

  if (state.err.isNotEmpty) {
    state.result.clear();
  } else if (state.result.isNotEmpty) {
    if ('mM'.indexOf(state.result[0][0]) < 0) {
      state.err = 'SvgPath: string should start with "M" or "m"';
      state.result.clear();
    } else {
      state.result[0][0] = 'M';
    }
  }

  return ParseResult(state.err, state.result);
}
