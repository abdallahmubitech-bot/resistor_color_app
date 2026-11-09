import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'calculator_tab.dart';
import 'education_tab.dart';
import 'guide_tab.dart';

class MainNavigationShell extends StatelessWidget {
  const MainNavigationShell({super.key, required this.state});
  final AppState state;
  static const labels = ['Calculator', 'Learn', 'Guide'];
  static const icons = [Icons.tune_rounded, Icons.menu_book_rounded, Icons.auto_stories_outlined];
  @override
  Widget build(BuildContext context) => AnimatedBuilder(animation: state.navigation, builder: (context, _) => LayoutBuilder(builder: (context, constraints) {
    final wide = constraints.maxWidth >= 800;
    final pages = [CalculatorTab(state: state), const EducationTab(), const GuideTab()];
    return Scaffold(
      body: Row(children: [
        if (wide) Container(width: 228, decoration: const BoxDecoration(color: Color(0xff101821), border: Border(right: BorderSide(color: AppColors.border))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Padding(padding: EdgeInsets.fromLTRB(24, 32, 20, 42), child: _Brand()),
          const Padding(padding: EdgeInsets.only(left: 24, bottom: 12), child: Text('WORKSPACE', style: TextStyle(color: AppColors.muted, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.bold))),
          Expanded(child: NavigationRail(extended: true, minExtendedWidth: 228, backgroundColor: Colors.transparent, selectedIndex: state.navigationIndex, onDestinationSelected: state.setNavigation, indicatorColor: const Color(0xff253d46), selectedIconTheme: const IconThemeData(color: AppColors.cyan), selectedLabelTextStyle: const TextStyle(color: AppColors.white, fontWeight: FontWeight.w600), unselectedLabelTextStyle: const TextStyle(color: AppColors.muted), destinations: [for (var i = 0; i < labels.length; i++) NavigationRailDestination(icon: Icon(icons[i]), label: Text(labels[i]))])),
          const Padding(padding: EdgeInsets.all(24), child: Text('BUILT FOR CURIOSITY\nDesigned for the details.', style: TextStyle(color: AppColors.muted, fontSize: 10, letterSpacing: .7, height: 1.8))),
        ])),
        Expanded(child: SafeArea(child: Column(children: [
          Container(height: 64, padding: EdgeInsets.symmetric(horizontal: wide ? 40 : 20), decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.border))), child: Row(children: [if (!wide) const Expanded(child: _Brand()) else ...[Text('WORKSPACE', style: TextStyle(color: AppColors.muted.withOpacity(.8), fontSize: 10, letterSpacing: 1.4)), const Text('   /   ', style: TextStyle(color: AppColors.muted)), Text(labels[state.navigationIndex], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)), const Spacer()], const Icon(Icons.bolt_rounded, color: AppColors.gold, size: 17), const SizedBox(width: 5), const Text('THE RESISTOR UTILITY', style: TextStyle(color: AppColors.muted, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1))])),
          Expanded(child: IndexedStack(index: state.navigationIndex, children: pages)),
        ]))),
      ]),
      bottomNavigationBar: wide ? null : NavigationBar(selectedIndex: state.navigationIndex, onDestinationSelected: state.setNavigation, backgroundColor: AppColors.panel, indicatorColor: const Color(0xff253d46), destinations: [for (var i = 0; i < labels.length; i++) NavigationDestination(icon: Icon(icons[i]), label: labels[i])]),
    );
  }));
}

class _Brand extends StatelessWidget {
  const _Brand();
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [Container(width: 34, height: 34, decoration: BoxDecoration(color: AppColors.cyan, borderRadius: BorderRadius.circular(9)), child: const Icon(Icons.electrical_services_rounded, color: AppColors.background, size: 21)), const SizedBox(width: 10), const Flexible(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [Text('RESISTOR', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1.1)), Text('STUDIO', style: TextStyle(color: AppColors.cyan, fontSize: 9, letterSpacing: 2.4, fontWeight: FontWeight.bold))]))]);
}
