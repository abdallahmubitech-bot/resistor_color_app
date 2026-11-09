import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class EducationTab extends StatelessWidget {
  const EducationTab({super.key});
  @override
  Widget build(BuildContext context) => SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32), child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 1120), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const PageHeading(eyebrow: 'The fundamentals / 02', title: 'Get to know resistors', subtitle: 'Small components. A big role in every circuit.'), const SizedBox(height: 28),
    const SurfaceCard(color: Color(0xff172b32), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Eyebrow('Start here'), SizedBox(height: 10), Text('What is a resistor?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), SizedBox(height: 10), Text('A resistor is a passive component that opposes the flow of electric current. It can limit current, divide voltage, set operating points, or turn electrical energy into heat. Resistance is measured in ohms (Ω).', style: TextStyle(color: Color(0xffb5c5c9), height: 1.65)), SizedBox(height: 20), Wrap(spacing: 24, runSpacing: 12, children: [_Formula('V = I × R', 'VOLTAGE'), _Formula('I = V ÷ R', 'CURRENT'), _Formula('R = V ÷ I', 'RESISTANCE')])])),
    const SizedBox(height: 32), const Eyebrow('The field guide'), const SizedBox(height: 8), const Text('Resistor types', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)), const SizedBox(height: 7), const Text('Different construction, different jobs. Find the right component for your circuit.', style: TextStyle(color: AppColors.muted, fontSize: 13)), const SizedBox(height: 20),
    LayoutBuilder(builder: (context, constraints) { final columns = constraints.maxWidth >= 850 ? 3 : constraints.maxWidth >= 520 ? 2 : 1; final width = (constraints.maxWidth - (columns - 1) * 16) / columns; return Wrap(spacing: 16, runSpacing: 16, children: [for (final item in _types) SizedBox(width: width, child: _TypeCard(item))]); }),
    const SizedBox(height: 30),
  ]))));
}
class _Formula extends StatelessWidget {
  const _Formula(this.formula, this.label); final String formula, label;
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(formula, style: const TextStyle(color: AppColors.cyan, fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 4), Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 9, letterSpacing: 1.2))]);
}
class _TypeInfo {
  const _TypeInfo(this.title, this.category, this.icon, this.description, this.spec, this.uses);
  final String title, category, description, spec, uses; final IconData icon;
}
const _types = [
  _TypeInfo('Carbon film', 'FIXED RESISTOR', Icons.layers_outlined, 'A thin carbon film deposited on a ceramic core, trimmed to its resistance value.', 'Affordable; moderate stability and noise.', 'General-purpose circuits and prototyping.'),
  _TypeInfo('Metal oxide', 'FIXED RESISTOR', Icons.local_fire_department_outlined, 'A metal-oxide film on a ceramic rod provides a robust resistive element.', 'Good heat and surge tolerance; check the rated power.', 'Power supplies and higher-temperature circuits.'),
  _TypeInfo('Potentiometer', 'VARIABLE RESISTOR', Icons.tune_rounded, 'A three-terminal resistive track with a movable wiper creates an adjustable voltage divider.', 'Adjustable output; rotary or linear formats.', 'Volume controls, calibration and user input.'),
  _TypeInfo('Rheostat', 'VARIABLE RESISTOR', Icons.settings_input_component_outlined, 'A two-terminal variable resistor uses a wiper and resistive element to control current.', 'Power handling depends on construction and setting.', 'Current adjustment and adjustable loads.'),
  _TypeInfo('LDR', 'DEPENDENT RESISTOR', Icons.wb_sunny_outlined, 'A light-dependent semiconductor element changes resistance with illumination.', 'Resistance generally falls as light increases.', 'Light sensors and automatic lighting.'),
  _TypeInfo('Thermistor', 'DEPENDENT RESISTOR', Icons.thermostat_outlined, 'A temperature-sensitive semiconductor resistor, available in NTC and PTC forms.', 'NTC falls with temperature; PTC rises.', 'Temperature sensing and inrush limiting.'),
  _TypeInfo('Surface mount', 'SMD RESISTOR', Icons.memory_outlined, 'A compact resistive film on a ceramic substrate, soldered directly to a circuit board.', 'Small footprints; ratings vary by package size.', 'Dense circuit boards and automated assembly.'),
];
class _TypeCard extends StatelessWidget {
  const _TypeCard(this.item); final _TypeInfo item;
  @override
  Widget build(BuildContext context) => SurfaceCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xff263b42), borderRadius: BorderRadius.circular(10)), child: Icon(item.icon, color: AppColors.cyan, size: 22)), const SizedBox(height: 20), Eyebrow(item.category, color: AppColors.gold), const SizedBox(height: 8), Text(item.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 10), Text(item.description, style: const TextStyle(color: AppColors.muted, fontSize: 12, height: 1.6)), const SizedBox(height: 18), const Divider(), const SizedBox(height: 10), const Eyebrow('Characteristics', color: AppColors.muted), const SizedBox(height: 5), Text(item.spec, style: const TextStyle(fontSize: 12, height: 1.5)), const SizedBox(height: 14), const Eyebrow('Common uses', color: AppColors.muted), const SizedBox(height: 5), Text(item.uses, style: const TextStyle(fontSize: 12, height: 1.5))]));
}
