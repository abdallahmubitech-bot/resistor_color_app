import 'dart:math' as math;

/// EIA 60062 color information. Null values indicate an invalid position.
class BandColor {
  const BandColor(this.name, this.argb, {this.digit, this.multiplier, this.tolerance});
  final String name;
  final int argb;
  final int? digit;
  final double? multiplier;
  final double? tolerance;
}

const bandColors = <BandColor>[
  BandColor('Black', 0xff24272b, digit: 0, multiplier: 1),
  BandColor('Brown', 0xff87513c, digit: 1, multiplier: 10, tolerance: 1),
  BandColor('Red', 0xffd94c4c, digit: 2, multiplier: 100, tolerance: 2),
  BandColor('Orange', 0xffed914b, digit: 3, multiplier: 1000),
  BandColor('Yellow', 0xffe8c851, digit: 4, multiplier: 10000),
  BandColor('Green', 0xff5caa78, digit: 5, multiplier: 100000, tolerance: .5),
  BandColor('Blue', 0xff4c86c6, digit: 6, multiplier: 1000000, tolerance: .25),
  BandColor('Violet', 0xff9270bb, digit: 7, multiplier: 10000000, tolerance: .1),
  BandColor('Grey', 0xff939ba4, digit: 8, multiplier: 100000000, tolerance: .05),
  BandColor('White', 0xffe9edf0, digit: 9, multiplier: 1000000000),
  BandColor('Gold', 0xffc6a35c, multiplier: .1, tolerance: 5),
  BandColor('Silver', 0xffabb4bd, multiplier: .01, tolerance: 10),
];

BandColor colorNamed(String name) => bandColors.firstWhere((color) => color.name == name);

enum BandRole { first, second, third, multiplier, tolerance }

List<BandColor> colorsFor(BandRole role) => bandColors.where((c) {
  switch (role) {
    case BandRole.first: return c.digit != null && c.digit != 0;
    case BandRole.second:
    case BandRole.third: return c.digit != null;
    case BandRole.multiplier: return c.multiplier != null;
    case BandRole.tolerance: return c.tolerance != null;
  }
}).toList(growable: false);

class ResistanceResult {
  const ResistanceResult(this.ohms, this.tolerancePercent);
  final double ohms;
  final double tolerancePercent;
  double get minimum => ohms * (1 - tolerancePercent / 100);
  double get maximum => ohms * (1 + tolerancePercent / 100);
}

ResistanceResult decodeResistance(List<BandColor> digits, BandColor multiplier, BandColor tolerance) {
  if (digits.length < 2 || digits.length > 3 || digits.first.digit == 0 ||
      digits.any((c) => c.digit == null) || multiplier.multiplier == null || tolerance.tolerance == null) {
    throw ArgumentError('Invalid resistor bands');
  }
  final value = digits.fold<int>(0, (value, color) => value * 10 + color.digit!);
  return ResistanceResult(value * multiplier.multiplier!, tolerance.tolerance!);
}

String formatNumber(double value, {int precision = 4}) {
  if (value == 0) return '0';
  // Fixed decimal formatting would round very small non-zero values to zero.
  if (value.abs() < 1e-6 || value.abs() >= 1e15) {
    return value.toStringAsExponential(precision - 1);
  }
  final decimals = math.max(0, precision - 1 - (math.log(value.abs()) / math.ln10).floor()).clamp(0, 10).toInt();
  final text = value.toStringAsFixed(decimals);
  return text.contains('.') ? text.replaceFirst(RegExp(r'\.?0+$'), '') : text;
}

String formatResistance(double ohms) {
  if (ohms >= 1000000) return '${formatNumber(ohms / 1000000)} MΩ';
  if (ohms >= 1000) return '${formatNumber(ohms / 1000)} kΩ';
  return '${formatNumber(ohms)} Ω';
}

enum ElectricalVariable { voltage, current, resistance }

/// Returns null for undefined or non-finite results.
double? solveOhmsLaw(ElectricalVariable target, double first, double second) {
  if (!first.isFinite || !second.isFinite || first < 0 || second < 0) return null;
  final double result;
  switch (target) {
    case ElectricalVariable.voltage: result = first * second;
    case ElectricalVariable.current:
    case ElectricalVariable.resistance:
      if (second == 0) return null;
      result = first / second;
  }
  return result.isFinite ? result : null;
}
