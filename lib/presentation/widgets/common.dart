import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SurfaceCard extends StatelessWidget {
  const SurfaceCard({super.key, required this.child, this.padding = const EdgeInsets.all(24), this.color = AppColors.panel});
  final Widget child;
  final EdgeInsets padding;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(padding: padding, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)), child: child);
}

class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key, this.color = AppColors.cyan});
  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) => Text(text.toUpperCase(), style: TextStyle(color: color, fontWeight: FontWeight.w700, letterSpacing: 1.5, fontSize: 10));
}

class PageHeading extends StatelessWidget {
  const PageHeading({super.key, required this.eyebrow, required this.title, required this.subtitle});
  final String eyebrow, title, subtitle;
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Eyebrow(eyebrow), const SizedBox(height: 10), Text(title, style: const TextStyle(fontSize: 32, height: 1.15, fontWeight: FontWeight.w700, letterSpacing: -.8)), const SizedBox(height: 9), Text(subtitle, style: const TextStyle(color: AppColors.muted, fontSize: 14, height: 1.5))]);
}
