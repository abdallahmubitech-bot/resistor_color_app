import 'package:flutter/foundation.dart';
import '../../domain/resistor_logic.dart';

class AppState extends ChangeNotifier {
  final ValueNotifier<int> navigation = ValueNotifier<int>(0);
  int get navigationIndex => navigation.value;
  bool isOhmsLaw = false;
  bool fiveBands = false;
  ElectricalVariable target = ElectricalVariable.voltage;
  final Map<BandRole, BandColor> bands = {
    BandRole.first: colorNamed('Brown'),
    BandRole.second: colorNamed('Black'),
    BandRole.third: colorNamed('Black'),
    BandRole.multiplier: colorNamed('Red'),
    BandRole.tolerance: colorNamed('Gold'),
  };
  final Map<ElectricalVariable, String> inputs = {
    for (final variable in ElectricalVariable.values) variable: '',
  };

  List<BandRole> get visibleRoles => [BandRole.first, BandRole.second, if (fiveBands) BandRole.third, BandRole.multiplier, BandRole.tolerance];
  ResistanceResult get resistance => decodeResistance([
    bands[BandRole.first]!, bands[BandRole.second]!, if (fiveBands) bands[BandRole.third]!,
  ], bands[BandRole.multiplier]!, bands[BandRole.tolerance]!);
  void setNavigation(int value) { navigation.value = value; }
  void setMode(bool value) { isOhmsLaw = value; notifyListeners(); }
  void setFiveBands(bool value) { fiveBands = value; notifyListeners(); }
  void setBand(BandRole role, BandColor value) { bands[role] = value; notifyListeners(); }
  void setTarget(ElectricalVariable value) { target = value; notifyListeners(); }
  void setInput(ElectricalVariable variable, String value) { inputs[variable] = value; notifyListeners(); }
  String? inputError(ElectricalVariable variable) {
    if (variable == target) return null;
    final raw = inputs[variable]!.trim();
    if (raw.isEmpty) return null;
    final value = double.tryParse(raw);
    if (value == null || !value.isFinite) return 'Enter a valid number';
    if (value < 0) return 'Enter a non-negative value';
    if (value == 0 && ((target == ElectricalVariable.current && variable == ElectricalVariable.resistance) ||
        (target == ElectricalVariable.resistance && variable == ElectricalVariable.current))) return 'Cannot divide by zero';
    return null;
  }
  @override
  void dispose() { navigation.dispose(); super.dispose(); }

  double? get ohmsResult {
    final variables = switch (target) {
      ElectricalVariable.voltage => [ElectricalVariable.current, ElectricalVariable.resistance],
      ElectricalVariable.current => [ElectricalVariable.voltage, ElectricalVariable.resistance],
      ElectricalVariable.resistance => [ElectricalVariable.voltage, ElectricalVariable.current],
    };
    if (variables.any((v) => inputError(v) != null)) return null;
    final first = double.tryParse(inputs[variables[0]]!.trim());
    final second = double.tryParse(inputs[variables[1]]!.trim());
    if (first == null || second == null) return null;
    return solveOhmsLaw(target, first, second);
  }
}
