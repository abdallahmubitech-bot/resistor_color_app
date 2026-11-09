import 'package:flutter_test/flutter_test.dart';
import 'package:resistor_color_app/domain/resistor_logic.dart';
import 'package:resistor_color_app/presentation/state/app_state.dart';

void main() {
  test('decodes four bands and tolerance', () {
    final result = decodeResistance([colorNamed('Brown'), colorNamed('Black')], colorNamed('Red'), colorNamed('Gold'));
    expect(result.ohms, 1000);
    expect(result.minimum, 950);
    expect(result.maximum, 1050);
    expect(formatResistance(result.ohms), '1 kΩ');
  });
  test('decodes five bands and fractional multipliers', () {
    final result = decodeResistance([colorNamed('Brown'), colorNamed('Black'), colorNamed('Black')], colorNamed('Silver'), colorNamed('Brown'));
    expect(result.ohms, 1);
    expect(result.tolerancePercent, 1);
    expect(colorsFor(BandRole.first).contains(colorNamed('Black')), isFalse);
  });
  test('band roles reject invalid colors', () {
    expect(colorsFor(BandRole.tolerance).contains(colorNamed('Yellow')), isFalse);
    expect(colorsFor(BandRole.second).contains(colorNamed('Gold')), isFalse);
    expect(() => decodeResistance([colorNamed('Black'), colorNamed('Brown')], colorNamed('Red'), colorNamed('Gold')), throwsArgumentError);
    expect(() => decodeResistance([colorNamed('Brown'), colorNamed('Black')], colorNamed('Red'), colorNamed('Yellow')), throwsArgumentError);
  });
  test('solves all Ohm law quantities and rejects zero divisors', () {
    expect(solveOhmsLaw(ElectricalVariable.voltage, 2, 10), 20);
    expect(solveOhmsLaw(ElectricalVariable.current, 20, 10), 2);
    expect(solveOhmsLaw(ElectricalVariable.resistance, 20, 2), 10);
    expect(solveOhmsLaw(ElectricalVariable.current, 20, 0), isNull);
    expect(solveOhmsLaw(ElectricalVariable.voltage, -1, 2), isNull);
  });
  test('state validates inputs and calculates live', () {
    final state = AppState();
    state.setTarget(ElectricalVariable.current);
    state.setInput(ElectricalVariable.voltage, '5');
    state.setInput(ElectricalVariable.resistance, '0');
    expect(state.inputError(ElectricalVariable.resistance), isNotNull);
    expect(state.ohmsResult, isNull);
    state.setInput(ElectricalVariable.resistance, '1000');
    expect(state.ohmsResult, .005);
    state.dispose();
  });
  test('formats integer and scaled values', () {
    expect(formatNumber(100), '100');
    expect(formatResistance(2200000), '2.2 MΩ');
    expect(formatResistance(.1), '0.1 Ω');
    expect(formatNumber(1e-12), '1.000e-12');
    expect(formatNumber(1e20), '1.000e+20');
  });
}
