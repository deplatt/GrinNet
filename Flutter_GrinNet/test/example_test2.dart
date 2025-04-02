import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Example unit test: 2 + 2 = 4', () {
    expect(2 + 2, 4);
  });

  testWidgets('Example widget test', (WidgetTester tester) async {
    // Build a widget with a Text('Hello')
    await tester.pumpWidget(const MaterialApp(home: Text('Hello')));
    // Verify the text exists
    expect(find.text('Hello'), findsOneWidget);
  });
}
