import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:smart_hire_app/main.dart';

void main() {
  testWidgets('App loads test', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartHireApp());

    expect(find.text('Smart Hire'), findsOneWidget);
  });
}
