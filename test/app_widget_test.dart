import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resistor_color_app/main.dart';

void main() {
  testWidgets('mobile navigation opens the learning and guide tabs', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const ResistorApp());
    expect(find.text('Resistor calculator'), findsOneWidget);
    expect(find.text('1 kΩ'), findsOneWidget);
    await tester.tap(find.text('Learn').last);
    await tester.pumpAndSettle();
    expect(find.text('Get to know resistors'), findsOneWidget);
    await tester.tap(find.text('Guide').last);
    await tester.pumpAndSettle();
    expect(find.text('A guide to getting started'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('wide layout uses a navigation rail', (tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const ResistorApp());
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
