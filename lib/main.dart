import 'package:flutter/material.dart';
import 'presentation/screens/main_navigation_shell.dart';
import 'presentation/state/app_state.dart';
import 'presentation/theme/app_theme.dart';

void main() => runApp(const ResistorApp());

class ResistorApp extends StatefulWidget {
  const ResistorApp({super.key});
  @override
  State<ResistorApp> createState() => _ResistorAppState();
}
class _ResistorAppState extends State<ResistorApp> {
  final state = AppState();
  @override
  void dispose() { state.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => MaterialApp(debugShowCheckedModeBanner: false, title: 'Resistor Studio', theme: AppTheme.dark, home: MainNavigationShell(state: state));
}
