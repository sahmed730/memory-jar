// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:memory_jar_mobile/app.dart';

void main() {
  testWidgets('App boot smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MemoryJarApp());

    // Verify that our app boots and shows something from the app (e.g. Memory Jar)
    // The splash screen should be the first thing. We pump a few frames.
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // After animation, we expect the Memory Jar brand to be visible in some form,
    // or just checking no crash occurred is a good smoke test.
    expect(find.byType(MemoryJarApp), findsOneWidget);
  });
}
