import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../lib/pages/seetings_page.dart';
import '../lib/Theme_provider.dart';

void main() {
  Widget createWidgetUnderTest() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MaterialApp(
        home: SettingsPage(),
      ),
    );
  }

  testWidgets('SettingsPage displays title and sections', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Dark Mode'), findsOneWidget);
    expect(find.text('Enable Notifications'), findsOneWidget);
    expect(find.text('Change Password'), findsOneWidget);
  });

  testWidgets('Toggles can be switched', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    final darkModeToggle = find.widgetWithText(SwitchListTile, 'Dark Mode');
    final notificationsToggle = find.widgetWithText(SwitchListTile, 'Enable Notifications');

    expect(darkModeToggle, findsOneWidget);
    expect(notificationsToggle, findsOneWidget);

    await tester.tap(darkModeToggle);
    await tester.pump();

    await tester.tap(notificationsToggle);
    await tester.pump();
  });

  testWidgets('Profile image and username field appear', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(CircleAvatar), findsWidgets);
    expect(find.byType(TextField), findsWidgets);
  });
}
