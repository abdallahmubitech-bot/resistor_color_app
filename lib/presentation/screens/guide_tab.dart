import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class GuideTab extends StatelessWidget {
  const GuideTab({super.key});
  @override
  Widget build(BuildContext context) => SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32), child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 900), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const PageHeading(eyebrow: 'Documentation / 03', title: 'A guide to getting started', subtitle: 'Everything you need to go from color bands to confident calculations.'), const SizedBox(height: 28),
    const SurfaceCard(color: Color(0xff172b32), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.tips_and_updates_outlined, color: AppColors.cyan), SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Eyebrow('The quick version'), SizedBox(height: 8), Text('Read. Select. Calculate.', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), SizedBox(height: 8), Text('Orient your resistor, match its colors, and let the calculator do the rest. Explore the sections below for a closer look.', style: TextStyle(color: AppColors.muted, height: 1.6))]))])),
    const SizedBox(height: 30), const Eyebrow('Step by step'), const SizedBox(height: 10), const Text('The essentials', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)), const SizedBox(height: 16),
    const _GuideTile(number: '01', title: 'How to read physical resistor bands', subtitle: 'Find the direction and identify each band.', content: 'Place the resistor so the tolerance band, often gold or silver and spaced farther from the others, is on the right. Read from left to right. On a 4-band resistor, the first two bands are digits, the third is the multiplier and the fourth is tolerance. On a 5-band resistor, the first three are digits, followed by multiplier and tolerance. If the orientation is unclear, consult the component datasheet.'),
    const _GuideTile(number: '02', title: 'Use the live color decoder', subtitle: 'Turn those colors into a resistance value.', content: 'Open Calculator and choose Color decoder. Select 4 bands or 5 bands to match your component. Tap each color selector and choose the matching color. The illustration and resistance update immediately. The result includes the nominal value and the minimum and maximum values permitted by the selected tolerance.'),
    const _GuideTile(number: '03', title: 'Calculate with Ohm’s law', subtitle: 'Solve for voltage, current or resistance.', content: 'Switch to Ohm’s law and select the quantity you want to solve for. Enter the other two values in volts, amperes and ohms. The answer updates as you type. Division by zero is not defined, so the divisor must be greater than zero. For example, 5 V across 1,000 Ω gives 0.005 A.'),
    const _GuideTile(number: '04', title: 'Common engineering traps', subtitle: 'Make a safe, practical component choice.', content: 'Resistance is only part of the story. Calculate dissipated power using P = V × I or P = I² × R, then choose a resistor with a suitable power rating and design margin for its operating temperature. Check voltage and pulse ratings, tolerance, and temperature coefficient against the datasheet. Never measure resistance in an energized circuit; disconnect power and discharge capacitors first.'),
    const SizedBox(height: 24),
  ]))));
}
class _GuideTile extends StatelessWidget {
  const _GuideTile({required this.number, required this.title, required this.subtitle, required this.content});
  final String number, title, subtitle, content;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Container(decoration: BoxDecoration(color: AppColors.panel, border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(14)), child: ClipRRect(borderRadius: BorderRadius.circular(14), child: ExpansionTile(tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8), childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 22), leading: Text(number, style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, letterSpacing: 1)), title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)), subtitle: Padding(padding: const EdgeInsets.only(top: 5), child: Text(subtitle, style: const TextStyle(color: AppColors.muted, fontSize: 12))), children: [Text(content, style: const TextStyle(color: AppColors.muted, height: 1.7, fontSize: 13))]))));
}
