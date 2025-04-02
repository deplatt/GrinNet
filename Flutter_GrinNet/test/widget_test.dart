import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Finds hello world text', (WidgetTester tester) async {
    // 1. Build a widget containing "Hello World" text
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Text('Hello World'),
        ),
      ),
    );

    // 2. Verify the text appears exactly once
    expect(find.text('Hello World'), findsOneWidget);
  });
}
