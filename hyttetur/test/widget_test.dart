import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyttetur/main.dart'; // Import your app's main Dart file

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build your app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Your test logic here...
  });
}