  let buildArgsList;

// `modulePromise` is a promise to the `WebAssembly.module` object to be
//   instantiated.
// `importObjectPromise` is a promise to an object that contains any additional
//   imports needed by the module that aren't provided by the standard runtime.
//   The fields on this object will be merged into the importObject with which
//   the module will be instantiated.
// This function returns a promise to the instantiated module.
export const instantiate = async (modulePromise, importObjectPromise) => {
    let dartInstance;

      function stringFromDartString(string) {
        const totalLength = dartInstance.exports.$stringLength(string);
        let result = '';
        let index = 0;
        while (index < totalLength) {
          let chunkLength = Math.min(totalLength - index, 0xFFFF);
          const array = new Array(chunkLength);
          for (let i = 0; i < chunkLength; i++) {
              array[i] = dartInstance.exports.$stringRead(string, index++);
          }
          result += String.fromCharCode(...array);
        }
        return result;
    }

    function stringToDartString(string) {
        const length = string.length;
        let range = 0;
        for (let i = 0; i < length; i++) {
            range |= string.codePointAt(i);
        }
        if (range < 256) {
            const dartString = dartInstance.exports.$stringAllocate1(length);
            for (let i = 0; i < length; i++) {
                dartInstance.exports.$stringWrite1(dartString, i, string.codePointAt(i));
            }
            return dartString;
        } else {
            const dartString = dartInstance.exports.$stringAllocate2(length);
            for (let i = 0; i < length; i++) {
                dartInstance.exports.$stringWrite2(dartString, i, string.charCodeAt(i));
            }
            return dartString;
        }
    }

      // Prints to the console
    function printToConsole(value) {
      if (typeof dartPrint == "function") {
        dartPrint(value);
        return;
      }
      if (typeof console == "object" && typeof console.log != "undefined") {
        console.log(value);
        return;
      }
      if (typeof print == "function") {
        print(value);
        return;
      }

      throw "Unable to print message: " + js;
    }

    // Converts a Dart List to a JS array. Any Dart objects will be converted, but
    // this will be cheap for JSValues.
    function arrayFromDartList(constructor, list) {
        const length = dartInstance.exports.$listLength(list);
        const array = new constructor(length);
        for (let i = 0; i < length; i++) {
            array[i] = dartInstance.exports.$listRead(list, i);
        }
        return array;
    }

    buildArgsList = function(list) {
        const dartList = dartInstance.exports.$makeStringList();
        for (let i = 0; i < list.length; i++) {
            dartInstance.exports.$listAdd(dartList, stringToDartString(list[i]));
        }
        return dartList;
    }

    // A special symbol attached to functions that wrap Dart functions.
    const jsWrappedDartFunctionSymbol = Symbol("JSWrappedDartFunction");

    function finalizeWrapper(dartFunction, wrapped) {
        wrapped.dartFunction = dartFunction;
        wrapped[jsWrappedDartFunctionSymbol] = true;
        return wrapped;
    }

    if (WebAssembly.String === undefined) {
        WebAssembly.String = {
            "charCodeAt": (s, i) => s.charCodeAt(i),
            "compare": (s1, s2) => {
                if (s1 < s2) return -1;
                if (s1 > s2) return 1;
                return 0;
            },
            "concat": (s1, s2) => s1 + s2,
            "equals": (s1, s2) => s1 === s2,
            "fromCharCode": (i) => String.fromCharCode(i),
            "length": (s) => s.length,
            "substring": (s, a, b) => s.substring(a, b),
        };
    }

    // Imports
    const dart2wasm = {

  _1589: (x0,x1) => x0.matchMedia(x1),
_1853: () => globalThis.window,
_1874: x0 => x0.matches,
_1878: x0 => x0.platform,
_1883: x0 => x0.navigator,
_1661: s => stringToDartString(JSON.stringify(stringFromDartString(s))),
_1662: s => printToConsole(stringFromDartString(s)),
_1773: o => o === undefined,
_1774: o => typeof o === 'boolean',
_1775: o => typeof o === 'number',
_1777: o => typeof o === 'string',
_1780: o => o instanceof Int8Array,
_1781: o => o instanceof Uint8Array,
_1782: o => o instanceof Uint8ClampedArray,
_1783: o => o instanceof Int16Array,
_1784: o => o instanceof Uint16Array,
_1785: o => o instanceof Int32Array,
_1786: o => o instanceof Uint32Array,
_1787: o => o instanceof Float32Array,
_1788: o => o instanceof Float64Array,
_1789: o => o instanceof ArrayBuffer,
_1790: o => o instanceof DataView,
_1791: o => o instanceof Array,
_1792: o => typeof o === 'function' && o[jsWrappedDartFunctionSymbol] === true,
_1794: o => {
            const proto = Object.getPrototypeOf(o);
            return proto === Object.prototype || proto === null;
          },
_1795: o => o instanceof RegExp,
_1796: (l, r) => l === r,
_1797: o => o,
_1798: o => o,
_1799: o => o,
_1800: b => !!b,
_1801: o => o.length,
_1804: (o, i) => o[i],
_1805: f => f.dartFunction,
_1806: l => arrayFromDartList(Int8Array, l),
_1807: l => arrayFromDartList(Uint8Array, l),
_1808: l => arrayFromDartList(Uint8ClampedArray, l),
_1809: l => arrayFromDartList(Int16Array, l),
_1810: l => arrayFromDartList(Uint16Array, l),
_1811: l => arrayFromDartList(Int32Array, l),
_1812: l => arrayFromDartList(Uint32Array, l),
_1813: l => arrayFromDartList(Float32Array, l),
_1814: l => arrayFromDartList(Float64Array, l),
_1815: (data, length) => {
          const view = new DataView(new ArrayBuffer(length));
          for (let i = 0; i < length; i++) {
              view.setUint8(i, dartInstance.exports.$byteDataGetUint8(data, i));
          }
          return view;
        },
_1816: l => arrayFromDartList(Array, l),
_1817: stringFromDartString,
_1818: stringToDartString,
_1819: () => ({}),
_1820: () => [],
_1822: () => globalThis,
_1823: (constructor, args) => {
      const factoryFunction = constructor.bind.apply(
          constructor, [null, ...args]);
      return new factoryFunction();
    },
_1824: (o, p) => p in o,
_1825: (o, p) => o[p],
_1826: (o, p, v) => o[p] = v,
_1827: (o, m, a) => o[m].apply(o, a),
_1830: (p, s, f) => p.then(s, f),
_1831: s => {
      let jsString = stringFromDartString(s);
      if (/[[\]{}()*+?.\\^$|]/.test(jsString)) {
          jsString = jsString.replace(/[[\]{}()*+?.\\^$|]/g, '\\$&');
      }
      return stringToDartString(jsString);
    },
_1762: (s, m) => {
          try {
            return new RegExp(s, m);
          } catch (e) {
            return String(e);
          }
        },
_1763: (x0,x1) => x0.exec(x1),
_1764: (x0,x1) => x0.test(x1),
_1765: (x0,x1) => x0.exec(x1),
_1766: (x0,x1) => x0.exec(x1),
_1767: x0 => x0.pop(),
_1771: (x0,x1,x2) => x0[x1] = x2,
_1821: l => new Array(l),
_1829: o => String(o),
_1834: x0 => x0.index,
_1836: x0 => x0.length,
_1838: (x0,x1) => x0[x1],
_1842: x0 => x0.flags,
_1843: x0 => x0.multiline,
_1844: x0 => x0.ignoreCase,
_1845: x0 => x0.unicode,
_1846: x0 => x0.dotAll,
_1847: (x0,x1) => x0.lastIndex = x1,
_1722: Object.is,
_1724: WebAssembly.String.concat,
_1730: (t, s) => t.set(s),
_1732: (o) => new DataView(o.buffer, o.byteOffset, o.byteLength),
_1734: o => o.buffer,
_1682: (a, i) => a.push(i),
_1686: a => a.pop(),
_1687: (a, i) => a.splice(i, 1),
_1689: (a, s) => a.join(s),
_1690: (a, s, e) => a.slice(s, e),
_1692: (a, b) => a == b ? 0 : (a > b ? 1 : -1),
_1693: a => a.length,
_1695: (a, i) => a[i],
_1696: (a, i, v) => a[i] = v,
_1698: a => a.join(''),
_1701: (s, t) => s.split(t),
_1702: s => s.toLowerCase(),
_1703: s => s.toUpperCase(),
_1704: s => s.trim(),
_1705: s => s.trimLeft(),
_1706: s => s.trimRight(),
_1708: (s, p, i) => s.indexOf(p, i),
_1709: (s, p, i) => s.lastIndexOf(p, i),
_1710: (o, offsetInBytes, lengthInBytes) => {
      var dst = new ArrayBuffer(lengthInBytes);
      new Uint8Array(dst).set(new Uint8Array(o, offsetInBytes, lengthInBytes));
      return new DataView(dst);
    },
_1711: (o, start, length) => new Uint8Array(o.buffer, o.byteOffset + start, length),
_1712: (o, start, length) => new Int8Array(o.buffer, o.byteOffset + start, length),
_1713: (o, start, length) => new Uint8ClampedArray(o.buffer, o.byteOffset + start, length),
_1714: (o, start, length) => new Uint16Array(o.buffer, o.byteOffset + start, length),
_1715: (o, start, length) => new Int16Array(o.buffer, o.byteOffset + start, length),
_1716: (o, start, length) => new Uint32Array(o.buffer, o.byteOffset + start, length),
_1717: (o, start, length) => new Int32Array(o.buffer, o.byteOffset + start, length),
_1719: (o, start, length) => new BigInt64Array(o.buffer, o.byteOffset + start, length),
_1720: (o, start, length) => new Float32Array(o.buffer, o.byteOffset + start, length),
_1721: (o, start, length) => new Float64Array(o.buffer, o.byteOffset + start, length),
_1723: WebAssembly.String.charCodeAt,
_1725: WebAssembly.String.substring,
_1726: WebAssembly.String.length,
_1727: WebAssembly.String.equals,
_1728: WebAssembly.String.compare,
_1729: WebAssembly.String.fromCharCode,
_1735: o => o.byteOffset,
_1736: Function.prototype.call.bind(Object.getOwnPropertyDescriptor(DataView.prototype, 'byteLength').get),
_1737: (b, o) => new DataView(b, o),
_1738: (b, o, l) => new DataView(b, o, l),
_1739: Function.prototype.call.bind(DataView.prototype.getUint8),
_1740: Function.prototype.call.bind(DataView.prototype.setUint8),
_1741: Function.prototype.call.bind(DataView.prototype.getInt8),
_1742: Function.prototype.call.bind(DataView.prototype.setInt8),
_1743: Function.prototype.call.bind(DataView.prototype.getUint16),
_1744: Function.prototype.call.bind(DataView.prototype.setUint16),
_1745: Function.prototype.call.bind(DataView.prototype.getInt16),
_1746: Function.prototype.call.bind(DataView.prototype.setInt16),
_1747: Function.prototype.call.bind(DataView.prototype.getUint32),
_1748: Function.prototype.call.bind(DataView.prototype.setUint32),
_1749: Function.prototype.call.bind(DataView.prototype.getInt32),
_1750: Function.prototype.call.bind(DataView.prototype.setInt32),
_1753: Function.prototype.call.bind(DataView.prototype.getBigInt64),
_1754: Function.prototype.call.bind(DataView.prototype.setBigInt64),
_1755: Function.prototype.call.bind(DataView.prototype.getFloat32),
_1756: Function.prototype.call.bind(DataView.prototype.setFloat32),
_1757: Function.prototype.call.bind(DataView.prototype.getFloat64),
_1758: Function.prototype.call.bind(DataView.prototype.setFloat64),
_1676: (ms, c) =>
              setTimeout(() => dartInstance.exports.$invokeCallback(c),ms),
_1677: (handle) => clearTimeout(handle),
_1678: (ms, c) =>
          setInterval(() => dartInstance.exports.$invokeCallback(c), ms),
_1679: (handle) => clearInterval(handle),
_1681: () => Date.now(),
_1680: (c) =>
              queueMicrotask(() => dartInstance.exports.$invokeCallback(c)),
_1669: () => globalThis.performance,
_1670: () => globalThis.JSON,
_1671: x0 => x0.measure,
_1672: x0 => x0.mark,
_1673: (x0,x1,x2,x3) => x0.measure(x1,x2,x3),
_1674: (x0,x1,x2) => x0.mark(x1,x2),
_1675: (x0,x1) => x0.parse(x1),
_1600: x0 => new Array(x0),
_1603: (o, c) => o instanceof c,
_1849: (o, p) => o[p],
_1663: (o, t) => o instanceof t,
_1665: f => finalizeWrapper(f,x0 => dartInstance.exports._1665(f,x0)),
_1666: f => finalizeWrapper(f,x0 => dartInstance.exports._1666(f,x0)),
_1667: o => Object.keys(o),
_1759: s => stringToDartString(stringFromDartString(s).toUpperCase()),
_1760: s => stringToDartString(stringFromDartString(s).toLowerCase()),
_1637: v => stringToDartString(v.toString()),
_1638: (d, digits) => stringToDartString(d.toFixed(digits)),
_1641: (d, precision) => stringToDartString(d.toPrecision(precision)),
_1642: o => new WeakRef(o),
_1643: r => r.deref(),
_1648: Date.now,
_1650: s => new Date(s * 1000).getTimezoneOffset() * 60 ,
_1651: s => {
      const jsSource = stringFromDartString(s);
      if (!/^\s*[+-]?(?:Infinity|NaN|(?:\.\d+|\d+(?:\.\d*)?)(?:[eE][+-]?\d+)?)\s*$/.test(jsSource)) {
        return NaN;
      }
      return parseFloat(jsSource);
    },
_1652: () => {
          let stackString = new Error().stack.toString();
          let frames = stackString.split('\n');
          let drop = 2;
          if (frames[0] === 'Error') {
              drop += 1;
          }
          return frames.slice(drop).join('\n');
        },
_1653: () => typeof dartUseDateNowForTicks !== "undefined",
_1654: () => 1000 * performance.now(),
_1655: () => Date.now(),
_1656: () => {
      // On browsers return `globalThis.location.href`
      if (globalThis.location != null) {
        return stringToDartString(globalThis.location.href);
      }
      return null;
    },
_1657: () => {
        return typeof process != undefined &&
               Object.prototype.toString.call(process) == "[object process]" &&
               process.platform == "win32"
      },
_1658: () => new WeakMap(),
_1659: (map, o) => map.get(o),
_1660: (map, o, v) => map.set(o, v),
_166: x0 => x0.focus(),
_167: x0 => x0.select(),
_168: (x0,x1) => x0.append(x1),
_169: x0 => x0.remove(),
_172: x0 => x0.unlock(),
_177: x0 => x0.getReader(),
_187: x0 => new MutationObserver(x0),
_206: (x0,x1,x2) => x0.addEventListener(x1,x2),
_207: (x0,x1,x2) => x0.removeEventListener(x1,x2),
_210: x0 => new ResizeObserver(x0),
_213: (x0,x1) => new Intl.Segmenter(x0,x1),
_214: x0 => x0.next(),
_215: (x0,x1) => new Intl.v8BreakIterator(x0,x1),
_299: f => finalizeWrapper(f,x0 => dartInstance.exports._299(f,x0)),
_300: f => finalizeWrapper(f,x0 => dartInstance.exports._300(f,x0)),
_301: (x0,x1) => ({addView: x0,removeView: x1}),
_302: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._302(f,arguments.length,x0) }),
_303: f => finalizeWrapper(f,() => dartInstance.exports._303(f)),
_304: (x0,x1) => ({initializeEngine: x0,autoStart: x1}),
_305: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._305(f,arguments.length,x0) }),
_306: x0 => ({runApp: x0}),
_307: x0 => new Uint8Array(x0),
_309: x0 => x0.preventDefault(),
_310: x0 => x0.stopPropagation(),
_311: (x0,x1) => x0.addListener(x1),
_312: (x0,x1) => x0.removeListener(x1),
_313: (x0,x1) => x0.append(x1),
_314: x0 => x0.remove(),
_315: x0 => x0.disconnect(),
_316: (x0,x1) => x0.addListener(x1),
_317: (x0,x1) => x0.removeListener(x1),
_318: (x0,x1) => x0.append(x1),
_319: x0 => x0.remove(),
_320: x0 => x0.stopPropagation(),
_324: x0 => x0.preventDefault(),
_325: (x0,x1) => x0.append(x1),
_326: x0 => x0.remove(),
_331: (x0,x1) => x0.appendChild(x1),
_332: (x0,x1,x2) => x0.insertBefore(x1,x2),
_333: (x0,x1) => x0.removeChild(x1),
_334: (x0,x1) => x0.appendChild(x1),
_335: (x0,x1) => x0.transferFromImageBitmap(x1),
_336: (x0,x1) => x0.append(x1),
_337: (x0,x1) => x0.append(x1),
_338: (x0,x1) => x0.append(x1),
_339: x0 => x0.remove(),
_340: x0 => x0.focus(),
_341: x0 => x0.focus(),
_342: x0 => x0.remove(),
_343: x0 => x0.focus(),
_344: x0 => x0.remove(),
_345: (x0,x1) => x0.append(x1),
_346: x0 => x0.focus(),
_347: (x0,x1) => x0.append(x1),
_348: x0 => x0.remove(),
_349: (x0,x1) => x0.append(x1),
_350: (x0,x1) => x0.append(x1),
_351: (x0,x1,x2) => x0.insertBefore(x1,x2),
_352: (x0,x1) => x0.append(x1),
_353: (x0,x1,x2) => x0.insertBefore(x1,x2),
_354: x0 => x0.remove(),
_355: x0 => x0.remove(),
_356: x0 => x0.remove(),
_357: (x0,x1) => x0.append(x1),
_358: x0 => x0.remove(),
_359: x0 => x0.remove(),
_360: x0 => x0.getBoundingClientRect(),
_361: x0 => x0.remove(),
_362: x0 => x0.blur(),
_364: x0 => x0.focus(),
_365: x0 => x0.focus(),
_366: x0 => x0.remove(),
_367: x0 => x0.focus(),
_368: x0 => x0.focus(),
_369: x0 => x0.blur(),
_370: x0 => x0.remove(),
_383: (x0,x1) => x0.append(x1),
_384: x0 => x0.remove(),
_385: (x0,x1) => x0.append(x1),
_386: (x0,x1,x2) => x0.insertBefore(x1,x2),
_387: (x0,x1) => x0.append(x1),
_388: x0 => x0.focus(),
_389: x0 => x0.focus(),
_390: x0 => x0.focus(),
_391: x0 => x0.focus(),
_392: x0 => x0.focus(),
_393: (x0,x1) => x0.append(x1),
_394: x0 => x0.focus(),
_395: x0 => x0.blur(),
_396: x0 => x0.remove(),
_398: x0 => x0.preventDefault(),
_399: x0 => x0.focus(),
_400: x0 => x0.preventDefault(),
_401: x0 => x0.preventDefault(),
_402: x0 => x0.preventDefault(),
_403: x0 => x0.focus(),
_404: x0 => x0.focus(),
_405: (x0,x1) => x0.append(x1),
_406: x0 => x0.focus(),
_407: x0 => x0.focus(),
_408: x0 => x0.focus(),
_409: x0 => x0.focus(),
_410: (x0,x1) => x0.observe(x1),
_411: x0 => x0.disconnect(),
_412: (x0,x1) => x0.appendChild(x1),
_413: (x0,x1) => x0.appendChild(x1),
_414: (x0,x1) => x0.appendChild(x1),
_415: (x0,x1) => x0.append(x1),
_416: (x0,x1) => x0.append(x1),
_417: x0 => x0.remove(),
_418: (x0,x1) => x0.append(x1),
_420: (x0,x1) => x0.appendChild(x1),
_421: (x0,x1) => x0.append(x1),
_422: x0 => x0.remove(),
_423: (x0,x1) => x0.append(x1),
_427: (x0,x1) => x0.appendChild(x1),
_428: x0 => x0.remove(),
_979: () => globalThis.window.flutterConfiguration,
_980: x0 => x0.assetBase,
_984: x0 => x0.debugShowSemanticsNodes,
_985: x0 => x0.hostElement,
_986: x0 => x0.multiViewEnabled,
_987: x0 => x0.nonce,
_989: x0 => x0.useColorEmoji,
_993: x0 => x0.console,
_994: x0 => x0.devicePixelRatio,
_995: x0 => x0.document,
_996: x0 => x0.history,
_997: x0 => x0.innerHeight,
_998: x0 => x0.innerWidth,
_999: x0 => x0.location,
_1000: x0 => x0.navigator,
_1001: x0 => x0.visualViewport,
_1002: x0 => x0.performance,
_1004: (x0,x1) => x0.fetch(x1),
_1007: (x0,x1) => x0.dispatchEvent(x1),
_1008: (x0,x1) => x0.matchMedia(x1),
_1009: (x0,x1) => x0.getComputedStyle(x1),
_1011: x0 => x0.screen,
_1012: (x0,x1) => x0.requestAnimationFrame(x1),
_1013: f => finalizeWrapper(f,x0 => dartInstance.exports._1013(f,x0)),
_1018: (x0,x1) => x0.warn(x1),
_1022: () => globalThis.window,
_1023: () => globalThis.Intl,
_1024: () => globalThis.Symbol,
_1027: x0 => x0.clipboard,
_1028: x0 => x0.maxTouchPoints,
_1029: x0 => x0.vendor,
_1030: x0 => x0.language,
_1031: x0 => x0.platform,
_1032: x0 => x0.userAgent,
_1033: x0 => x0.languages,
_1034: x0 => x0.documentElement,
_1035: (x0,x1) => x0.querySelector(x1),
_1038: (x0,x1) => x0.createElement(x1),
_1040: (x0,x1) => x0.execCommand(x1),
_1044: (x0,x1) => x0.createTextNode(x1),
_1045: (x0,x1) => x0.createEvent(x1),
_1049: x0 => x0.head,
_1050: x0 => x0.body,
_1051: (x0,x1) => x0.title = x1,
_1054: x0 => x0.activeElement,
_1056: x0 => x0.visibilityState,
_1057: () => globalThis.document,
_1058: (x0,x1,x2) => x0.addEventListener(x1,x2),
_1059: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
_1060: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
_1061: (x0,x1,x2) => x0.removeEventListener(x1,x2),
_1064: f => finalizeWrapper(f,x0 => dartInstance.exports._1064(f,x0)),
_1065: x0 => x0.target,
_1067: x0 => x0.timeStamp,
_1068: x0 => x0.type,
_1069: x0 => x0.preventDefault(),
_1073: (x0,x1,x2,x3) => x0.initEvent(x1,x2,x3),
_1078: x0 => x0.firstChild,
_1083: x0 => x0.parentElement,
_1089: (x0,x1) => x0.removeChild(x1),
_1091: (x0,x1) => x0.textContent = x1,
_1093: (x0,x1) => x0.contains(x1),
_1098: x0 => x0.firstElementChild,
_1100: x0 => x0.nextElementSibling,
_1101: x0 => x0.clientHeight,
_1102: x0 => x0.clientWidth,
_1103: x0 => x0.id,
_1104: (x0,x1) => x0.id = x1,
_1107: (x0,x1) => x0.spellcheck = x1,
_1108: x0 => x0.tagName,
_1109: x0 => x0.style,
_1110: (x0,x1) => x0.append(x1),
_1111: (x0,x1) => x0.getAttribute(x1),
_1112: x0 => x0.getBoundingClientRect(),
_1115: (x0,x1) => x0.closest(x1),
_1118: (x0,x1) => x0.querySelectorAll(x1),
_1119: x0 => x0.remove(),
_1120: (x0,x1,x2) => x0.setAttribute(x1,x2),
_1121: (x0,x1) => x0.removeAttribute(x1),
_1122: (x0,x1) => x0.tabIndex = x1,
_1125: x0 => x0.scrollTop,
_1126: (x0,x1) => x0.scrollTop = x1,
_1127: x0 => x0.scrollLeft,
_1128: (x0,x1) => x0.scrollLeft = x1,
_1129: x0 => x0.classList,
_1130: (x0,x1) => x0.className = x1,
_1135: (x0,x1) => x0.getElementsByClassName(x1),
_1137: x0 => x0.click(),
_1138: (x0,x1) => x0.hasAttribute(x1),
_1141: (x0,x1) => x0.attachShadow(x1),
_1144: (x0,x1) => x0.getPropertyValue(x1),
_1146: (x0,x1,x2,x3) => x0.setProperty(x1,x2,x3),
_1148: (x0,x1) => x0.removeProperty(x1),
_1150: x0 => x0.offsetLeft,
_1151: x0 => x0.offsetTop,
_1152: x0 => x0.offsetParent,
_1154: (x0,x1) => x0.name = x1,
_1155: x0 => x0.content,
_1156: (x0,x1) => x0.content = x1,
_1169: (x0,x1) => x0.nonce = x1,
_1174: x0 => x0.now(),
_1176: (x0,x1) => x0.width = x1,
_1178: (x0,x1) => x0.height = x1,
_1182: (x0,x1) => x0.getContext(x1),
_1256: x0 => x0.status,
_1258: x0 => x0.body,
_1259: x0 => x0.arrayBuffer(),
_1264: x0 => x0.read(),
_1265: x0 => x0.value,
_1266: x0 => x0.done,
_1269: x0 => x0.x,
_1270: x0 => x0.y,
_1273: x0 => x0.top,
_1274: x0 => x0.right,
_1275: x0 => x0.bottom,
_1276: x0 => x0.left,
_1286: x0 => x0.height,
_1287: x0 => x0.width,
_1288: (x0,x1) => x0.value = x1,
_1291: (x0,x1) => x0.placeholder = x1,
_1292: (x0,x1) => x0.name = x1,
_1293: x0 => x0.selectionDirection,
_1294: x0 => x0.selectionStart,
_1295: x0 => x0.selectionEnd,
_1298: x0 => x0.value,
_1299: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
_1303: x0 => x0.readText(),
_1304: (x0,x1) => x0.writeText(x1),
_1305: x0 => x0.altKey,
_1306: x0 => x0.code,
_1307: x0 => x0.ctrlKey,
_1308: x0 => x0.key,
_1309: x0 => x0.keyCode,
_1310: x0 => x0.location,
_1311: x0 => x0.metaKey,
_1312: x0 => x0.repeat,
_1313: x0 => x0.shiftKey,
_1314: x0 => x0.isComposing,
_1315: (x0,x1) => x0.getModifierState(x1),
_1316: x0 => x0.state,
_1318: (x0,x1) => x0.go(x1),
_1320: (x0,x1,x2,x3) => x0.pushState(x1,x2,x3),
_1321: (x0,x1,x2,x3) => x0.replaceState(x1,x2,x3),
_1322: x0 => x0.pathname,
_1323: x0 => x0.search,
_1324: x0 => x0.hash,
_1327: x0 => x0.state,
_1331: f => finalizeWrapper(f,(x0,x1) => dartInstance.exports._1331(f,x0,x1)),
_1334: (x0,x1,x2) => x0.observe(x1,x2),
_1337: x0 => x0.attributeName,
_1338: x0 => x0.type,
_1339: x0 => x0.matches,
_1342: x0 => x0.matches,
_1343: x0 => x0.relatedTarget,
_1344: x0 => x0.clientX,
_1345: x0 => x0.clientY,
_1346: x0 => x0.offsetX,
_1347: x0 => x0.offsetY,
_1350: x0 => x0.button,
_1351: x0 => x0.buttons,
_1352: x0 => x0.ctrlKey,
_1353: (x0,x1) => x0.getModifierState(x1),
_1354: x0 => x0.pointerId,
_1355: x0 => x0.pointerType,
_1356: x0 => x0.pressure,
_1357: x0 => x0.tiltX,
_1358: x0 => x0.tiltY,
_1359: x0 => x0.getCoalescedEvents(),
_1360: x0 => x0.deltaX,
_1361: x0 => x0.deltaY,
_1362: x0 => x0.wheelDeltaX,
_1363: x0 => x0.wheelDeltaY,
_1364: x0 => x0.deltaMode,
_1369: x0 => x0.changedTouches,
_1371: x0 => x0.clientX,
_1372: x0 => x0.clientY,
_1373: x0 => x0.data,
_1374: (x0,x1) => x0.type = x1,
_1375: (x0,x1) => x0.max = x1,
_1376: (x0,x1) => x0.min = x1,
_1377: (x0,x1) => x0.value = x1,
_1378: x0 => x0.value,
_1379: x0 => x0.disabled,
_1380: (x0,x1) => x0.disabled = x1,
_1381: (x0,x1) => x0.placeholder = x1,
_1382: (x0,x1) => x0.name = x1,
_1383: (x0,x1) => x0.autocomplete = x1,
_1384: x0 => x0.selectionDirection,
_1385: x0 => x0.selectionStart,
_1386: x0 => x0.selectionEnd,
_1389: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
_1395: (x0,x1) => x0.add(x1),
_1399: (x0,x1) => x0.noValidate = x1,
_1400: (x0,x1) => x0.method = x1,
_1401: (x0,x1) => x0.action = x1,
_1430: x0 => x0.orientation,
_1431: x0 => x0.width,
_1432: x0 => x0.height,
_1433: (x0,x1) => x0.lock(x1),
_1449: f => finalizeWrapper(f,(x0,x1) => dartInstance.exports._1449(f,x0,x1)),
_1458: x0 => x0.length,
_1459: (x0,x1) => x0.item(x1),
_1460: x0 => x0.length,
_1461: (x0,x1) => x0.item(x1),
_1462: x0 => x0.iterator,
_1463: x0 => x0.Segmenter,
_1464: x0 => x0.v8BreakIterator,
_1468: x0 => x0.done,
_1469: x0 => x0.value,
_1470: x0 => x0.index,
_1474: (x0,x1) => x0.adoptText(x1),
_1475: x0 => x0.first(),
_1476: x0 => x0.next(),
_1477: x0 => x0.current(),
_1481: () => globalThis.window.FinalizationRegistry,
_1483: (x0,x1,x2,x3) => x0.register(x1,x2,x3),
_1484: (x0,x1) => x0.unregister(x1),
_1490: x0 => x0.hostElement,
_1491: x0 => x0.viewConstraints,
_1493: x0 => x0.maxHeight,
_1494: x0 => x0.maxWidth,
_1495: x0 => x0.minHeight,
_1496: x0 => x0.minWidth,
_1497: x0 => x0.loader,
_1498: () => globalThis._flutter,
_1499: (x0,x1) => x0.didCreateEngineInitializer(x1),
_1500: (x0,x1,x2) => x0.call(x1,x2),
_1501: () => globalThis.Promise,
_1502: f => finalizeWrapper(f,(x0,x1) => dartInstance.exports._1502(f,x0,x1)),
_1505: x0 => x0.length,
_1: (x0,x1,x2) => x0.set(x1,x2),
_2: (x0,x1,x2) => x0.set(x1,x2),
_6: f => finalizeWrapper(f,x0 => dartInstance.exports._6(f,x0)),
_7: (x0,x1,x2) => x0.slice(x1,x2),
_8: (x0,x1) => x0.decode(x1),
_9: (x0,x1) => x0.segment(x1),
_10: () => new TextDecoder(),
_11: x0 => x0.buffer,
_12: x0 => x0.wasmMemory,
_13: () => globalThis.window._flutter_skwasmInstance,
_14: x0 => x0.rasterStartMilliseconds,
_15: x0 => x0.rasterEndMilliseconds,
_16: x0 => x0.imageBitmaps,
_1634: (decoder, codeUnits) => decoder.decode(codeUnits),
_1635: () => new TextDecoder("utf-8", {fatal: true}),
_1636: () => new TextDecoder("utf-8", {fatal: false})
      };

    const baseImports = {
        dart2wasm: dart2wasm,

  
          Math: Math,
        Date: Date,
        Object: Object,
        Array: Array,
        Reflect: Reflect,
    };
    dartInstance = await WebAssembly.instantiate(await modulePromise, {
        ...baseImports,
        ...(await importObjectPromise),
    });

    return dartInstance;
}

// Call the main function for the instantiated module
// `moduleInstance` is the instantiated dart2wasm module
// `args` are any arguments that should be passed into the main function.
export const invoke = (moduleInstance, ...args) => {
    const dartMain = moduleInstance.exports.$getMain();
    const dartArgs = buildArgsList(args);
    moduleInstance.exports.$invokeMain(dartMain, dartArgs);
}

