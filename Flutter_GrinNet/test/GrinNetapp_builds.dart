void main() {
  testWidgets('GrinNetApp builds correctly and configures MaterialApp correctly', 
  (WidgetTester tester) async {
    // 1. Build the widget with test parameters
     await tester.pumpWidget(const GrinNetApp());

    // 2. Verify the widget exists witht the correct properties
    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.debugShowCheckedModeBanner, false);
    expect(materialApp.title, 'GrinNet');
    expect(materialApp.theme, ThemeData(primarySwatch: Colors.blue));
    expect(materialApp.home, isA<LoginScreen>());

    // 3. Verify there are no build errors
    expect(tester.takeException(), isNull);
  });
}
