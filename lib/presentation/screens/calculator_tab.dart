import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../domain/resistor_logic.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class CalculatorTab extends StatelessWidget {
  const CalculatorTab({super.key, required this.state});
  final AppState state;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(animation: state, builder: (context, _) => SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32), child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 1120), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const PageHeading(eyebrow: 'Tools / 01', title: 'Resistor calculator', subtitle: 'A little clarity for your next circuit. Calculate with confidence.'),
    const SizedBox(height: 28),
    Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: AppColors.panel, borderRadius: BorderRadius.circular(11), border: Border.all(color: AppColors.border)), child: Wrap(children: [
      _ModeButton(label: 'Color decoder', icon: Icons.palette_outlined, selected: !state.isOhmsLaw, onTap: () => state.setMode(false)),
      _ModeButton(label: "Ohm’s law", icon: Icons.bolt_outlined, selected: state.isOhmsLaw, onTap: () => state.setMode(true)),
    ])),
    const SizedBox(height: 24),
    if (state.isOhmsLaw) _OhmsLaw(state: state) else _Decoder(state: state),
    const SizedBox(height: 28),
    const Row(children: [Icon(Icons.verified_outlined, size: 15, color: AppColors.muted), SizedBox(width: 8), Expanded(child: Text('A thoughtful toolkit for makers, students & engineers.', style: TextStyle(color: AppColors.muted, fontSize: 11)))]),
  ])))));
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({required this.label, required this.icon, required this.selected, required this.onTap});
  final String label; final IconData icon; final bool selected; final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(color: selected ? const Color(0xff293a46) : Colors.transparent, borderRadius: BorderRadius.circular(8), child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(8), child: Padding(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 16, color: selected ? AppColors.cyan : AppColors.muted), const SizedBox(width: 8), Text(label, style: TextStyle(color: selected ? AppColors.white : AppColors.muted, fontSize: 12, fontWeight: FontWeight.w600))]))));
}

class _Decoder extends StatelessWidget {
  const _Decoder({required this.state});
  final AppState state;
  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, constraints) {
    final visual = _ResistorVisual(state: state);
    final configuration = _BandConfiguration(state: state);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (constraints.maxWidth >= 850) IntrinsicHeight(child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [Expanded(flex: 6, child: visual), const SizedBox(width: 18), Expanded(flex: 5, child: configuration)])) else ...[visual, const SizedBox(height: 18), configuration],
      const SizedBox(height: 18),
      _ResultCard(result: state.resistance),
      const SizedBox(height: 18),
      const SurfaceCard(padding: EdgeInsets.all(16), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.lightbulb_outline, color: AppColors.gold, size: 19), SizedBox(width: 12), Expanded(child: Text('GOOD TO KNOW   The tolerance band is usually spaced farther from the others. Read your resistor with this band on the right.', style: TextStyle(color: AppColors.muted, fontSize: 12, height: 1.5)))])),
    ]);
  });
}

class _ResistorVisual extends StatelessWidget {
  const _ResistorVisual({required this.state});
  final AppState state;
  @override
  Widget build(BuildContext context) => SurfaceCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(children: [const Eyebrow('Component preview'), const Spacer(), Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5), decoration: BoxDecoration(color: const Color(0xff263e41), borderRadius: BorderRadius.circular(20)), child: const Row(children: [CircleAvatar(radius: 3, backgroundColor: AppColors.cyan), SizedBox(width: 6), Text('LIVE', style: TextStyle(color: AppColors.cyan, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1))]))]),
    const SizedBox(height: 8), const Text('Your resistor', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
    Semantics(label: 'Resistor bands, left to right: ${state.visibleRoles.map((role) => state.bands[role]!.name).join(', ')}', child: SizedBox(height: 200, width: double.infinity, child: CustomPaint(painter: _ResistorPainter(state.visibleRoles.map((role) => Color(state.bands[role]!.argb)).toList())))),
    const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.arrow_forward_rounded, color: AppColors.gold, size: 14), SizedBox(width: 8), Text('READ LEFT TO RIGHT', style: TextStyle(color: AppColors.muted, fontSize: 10, letterSpacing: 1.2, fontWeight: FontWeight.bold))]),
    const SizedBox(height: 10),
  ]));
}

class _ResistorPainter extends CustomPainter {
  _ResistorPainter(this.colors);
  final List<Color> colors;
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width; final cy = size.height / 2; final bodyW = math.min(w * .68, 280.0); final left = (w - bodyW) / 2; final right = left + bodyW;
    final wire = Paint()..shader = const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xff6e7779), Color(0xffd1d1c9), Color(0xff535d61)]).createShader(Rect.fromLTWH(0, cy - 4, w, 8));
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTRB(5, cy - 3, w - 5, cy + 3), const Radius.circular(3)), wire);
    final path = Path()..moveTo(left, cy - 34)..quadraticBezierTo(left, cy - 44, left + 14, cy - 44)..lineTo(left + 40, cy - 44)..quadraticBezierTo(left + 50, cy - 44, left + 58, cy - 35)..lineTo(right - 58, cy - 35)..quadraticBezierTo(right - 50, cy - 44, right - 40, cy - 44)..lineTo(right - 14, cy - 44)..quadraticBezierTo(right, cy - 44, right, cy - 34)..lineTo(right, cy + 34)..quadraticBezierTo(right, cy + 44, right - 14, cy + 44)..lineTo(right - 40, cy + 44)..quadraticBezierTo(right - 50, cy + 44, right - 58, cy + 35)..lineTo(left + 58, cy + 35)..quadraticBezierTo(left + 50, cy + 44, left + 40, cy + 44)..lineTo(left + 14, cy + 44)..quadraticBezierTo(left, cy + 44, left, cy + 34)..close();
    canvas.drawShadow(path, Colors.black, 12, false);
    canvas.drawPath(path, Paint()..shader = const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xffe3c496), Color(0xffc5a377), Color(0xffa77f53), Color(0xffd5b58a), Color(0xff806341)], stops: [0, .18, .55, .8, 1]).createShader(Rect.fromLTRB(left, cy - 44, right, cy + 44)));
    canvas.save(); canvas.clipPath(path);
    for (var i = 0; i < colors.length; i++) {
      final x = i == colors.length - 1 ? right - bodyW * .18 : left + bodyW * (.19 + i * (colors.length == 5 ? .135 : .17));
      canvas.drawRect(Rect.fromLTWH(x, cy - 48, bodyW * .055, 96), Paint()..color = colors[i]);
    }
    canvas.drawRect(Rect.fromLTRB(left, cy - 44, right, cy + 44), Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.white.withOpacity(.22), Colors.transparent, Colors.black.withOpacity(.3)]).createShader(Rect.fromLTRB(left, cy - 44, right, cy + 44)));
    canvas.restore();
  }
  @override
  bool shouldRepaint(covariant _ResistorPainter oldDelegate) => true;
}

class _BandConfiguration extends StatelessWidget {
  const _BandConfiguration({required this.state});
  final AppState state;
  @override
  Widget build(BuildContext context) => SurfaceCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Eyebrow('Customize'), const SizedBox(height: 8), const Text('Band configuration', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)), const SizedBox(height: 5), const Text('Select the colors on your resistor.', style: TextStyle(color: AppColors.muted, fontSize: 12)), const SizedBox(height: 18),
    Row(children: [const Text('NUMBER OF BANDS', style: TextStyle(color: AppColors.muted, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1)), const Spacer(), _BandToggle(label: '4 bands', selected: !state.fiveBands, onTap: () => state.setFiveBands(false)), const SizedBox(width: 6), _BandToggle(label: '5 bands', selected: state.fiveBands, onTap: () => state.setFiveBands(true))]),
    const SizedBox(height: 18),
    for (final role in state.visibleRoles) _BandSelector(role: role, state: state),
  ]));
}
class _BandToggle extends StatelessWidget {
  const _BandToggle({required this.label, required this.selected, required this.onTap});
  final String label; final bool selected; final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(7), child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), decoration: BoxDecoration(color: selected ? AppColors.cyan : AppColors.background, borderRadius: BorderRadius.circular(7), border: Border.all(color: selected ? AppColors.cyan : AppColors.border)), child: Text(label, style: TextStyle(color: selected ? AppColors.background : AppColors.muted, fontSize: 11, fontWeight: FontWeight.bold))));
}
class _BandSelector extends StatelessWidget {
  const _BandSelector({required this.role, required this.state});
  final BandRole role; final AppState state;
  String get label => switch (role) {BandRole.first => 'Band 1', BandRole.second => 'Band 2', BandRole.third => 'Band 3', BandRole.multiplier => 'Multiplier', BandRole.tolerance => 'Tolerance'};
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(children: [SizedBox(width: 90, child: Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 12))), Expanded(child: Container(height: 39, padding: const EdgeInsets.symmetric(horizontal: 12), decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.border)), child: DropdownButtonHideUnderline(child: DropdownButton<BandColor>(hint: Text(label), isExpanded: true, value: state.bands[role], dropdownColor: AppColors.panelLight, icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.muted, size: 18), items: [for (final color in colorsFor(role)) DropdownMenuItem(value: color, child: Row(children: [Container(width: 15, height: 15, decoration: BoxDecoration(color: Color(color.argb), shape: BoxShape.circle, border: Border.all(color: Colors.white24))), const SizedBox(width: 10), Text(color.name, style: const TextStyle(fontSize: 12))]))], onChanged: (value) { if (value != null) state.setBand(role, value); }))))]));
}
class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.result});
  final ResistanceResult result;
  @override
  Widget build(BuildContext context) => SurfaceCard(color: const Color(0xff172b32), child: LayoutBuilder(builder: (context, constraints) {
    final main = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Eyebrow('Calculated resistance'), const SizedBox(height: 9), Wrap(crossAxisAlignment: WrapCrossAlignment.center, spacing: 12, children: [Text(formatResistance(result.ohms), style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700, letterSpacing: -1)), Text('± ${formatNumber(result.tolerancePercent)}%', style: const TextStyle(color: AppColors.gold, fontSize: 15, fontWeight: FontWeight.w600))])]);
    final range = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Eyebrow('Tolerance range', color: AppColors.muted), const SizedBox(height: 10), Text('${formatResistance(result.minimum)}  —  ${formatResistance(result.maximum)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)), const SizedBox(height: 3), const Text('Minimum                       Maximum', style: TextStyle(color: AppColors.muted, fontSize: 10))]);
    return constraints.maxWidth > 550 ? Row(children: [Expanded(child: main), range]) : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [main, const SizedBox(height: 20), range]);
  }));
}

class _OhmsLaw extends StatelessWidget {
  const _OhmsLaw({required this.state});
  final AppState state;
  static const names = {ElectricalVariable.voltage: 'Voltage', ElectricalVariable.current: 'Current', ElectricalVariable.resistance: 'Resistance'};
  static const symbols = {ElectricalVariable.voltage: 'V', ElectricalVariable.current: 'I', ElectricalVariable.resistance: 'R'};
  static const units = {ElectricalVariable.voltage: 'V', ElectricalVariable.current: 'A', ElectricalVariable.resistance: 'Ω'};
  @override
  Widget build(BuildContext context) => SurfaceCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Eyebrow('Circuit essentials'), const SizedBox(height: 8), const Text("Ohm’s law calculator", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)), const SizedBox(height: 6), const Text('Choose a quantity to solve for, then enter the other two values.', style: TextStyle(color: AppColors.muted, height: 1.5)), const SizedBox(height: 24), const Eyebrow('Solve for', color: AppColors.muted), const SizedBox(height: 10),
    Wrap(spacing: 8, runSpacing: 8, children: [for (final variable in ElectricalVariable.values) ChoiceChip(label: Text('${names[variable]} (${symbols[variable]})'), selected: state.target == variable, onSelected: (_) => state.setTarget(variable), selectedColor: const Color(0xff29484e))]),
    const SizedBox(height: 24),
    LayoutBuilder(builder: (context, constraints) => Wrap(spacing: 14, runSpacing: 16, children: [for (final variable in ElectricalVariable.values) SizedBox(width: constraints.maxWidth >= 650 ? (constraints.maxWidth - 28) / 3 : constraints.maxWidth, child: _InputField(key: ValueKey(variable), state: state, variable: variable, label: names[variable]!, unit: units[variable]!))])),
    const SizedBox(height: 24),
    Container(width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: const Color(0xff172b32), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xff31505a))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Eyebrow('${names[state.target]} result'), const SizedBox(height: 10), Text(state.ohmsResult == null ? '—' : '${formatNumber(state.ohmsResult!)} ${units[state.target]}', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)), const SizedBox(height: 5), Text(switch (state.target) {ElectricalVariable.voltage => 'V = I × R', ElectricalVariable.current => 'I = V ÷ R', ElectricalVariable.resistance => 'R = V ÷ I'}, style: const TextStyle(color: AppColors.muted))])),
  ]));
}
class _InputField extends StatefulWidget {
  const _InputField({super.key, required this.state, required this.variable, required this.label, required this.unit});
  final AppState state; final ElectricalVariable variable; final String label, unit;
  @override
  State<_InputField> createState() => _InputFieldState();
}
class _InputFieldState extends State<_InputField> {
  late final TextEditingController controller;
  @override
  void initState() { super.initState(); controller = TextEditingController(text: widget.state.inputs[widget.variable]); }
  @override
  void dispose() { controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    final solving = widget.state.target == widget.variable;
    final result = widget.state.ohmsResult;
    final display = solving ? (result == null ? '' : formatNumber(result)) : widget.state.inputs[widget.variable]!;
    if (controller.text != display) {
      controller.value = TextEditingValue(text: display, selection: TextSelection.collapsed(offset: display.length));
    }
    return TextField(controller: controller, enabled: !solving, keyboardType: const TextInputType.numberWithOptions(decimal: true), onChanged: (value) => widget.state.setInput(widget.variable, value), decoration: InputDecoration(labelText: widget.label, suffixText: widget.unit, hintText: solving ? 'Calculated below' : 'Enter value', errorText: widget.state.inputError(widget.variable)));
  }
}
