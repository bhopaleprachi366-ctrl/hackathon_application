// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hackathon_application/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
<<<<<<< HEAD
<<<<<<< HEAD
    await tester.pumpWidget(const MyApp());
=======
    await tester.pumpWidget(const SubServeApp());
>>>>>>> 2e50f87933f4881bf8088e621692378779d08a8c
=======

    await tester.pumpWidget(const SubServeApp());

    await tester.pumpWidget(const MyApp());
>>>>>>> 175f09dc933504074c414746529e7bc24ff5e311

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
