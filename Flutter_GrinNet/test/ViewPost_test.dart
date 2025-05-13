import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_test2/pages/view_post.dart';
import 'package:firebase_test2/main.dart'; 

// Sample Event object used for testing
final testEvent = Event(
  username: 'testuser',
  imageUrl: '', 
  profileImageUrl: '',
  text: 'This is a test event description.',
  tags: ['Tag1', 'Tag2'],
  postId: 1,   // added since event model has been updated
  userId: 1,   // added since event model has been updated
);

// Dummy home widget for testing back navigation
class DummyHome extends StatelessWidget {
  const DummyHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text('Go to ViewPost'),
          onPressed: () {
            Navigator.pushNamed(context, '/view');
          },
        ),
      ),
    );
  }
}

void main() {
  // Test 1: Verify AppBar title (username) and the presence of a back button
  testWidgets('ViewPostScreen displays AppBar with username and back button', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ViewPostScreen(event: testEvent),
    ));
    expect(find.text('testuser'), findsOneWidget); 
    expect(find.byIcon(Icons.arrow_back), findsOneWidget); 
  });

  // Test 2: Verify that no image is displayed when imageUrl is empty.
  testWidgets('ViewPostScreen image displayed when imageUrl is empty', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ViewPostScreen(event: testEvent),
    ));
    expect(find.byType(Image), findsNothing); // No Image widget should be found
  });

  // Test 3: Verify that event tags are displayed as Chips.
  testWidgets('ViewPostScreen displays all event tags as Chips', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ViewPostScreen(event: testEvent),
    ));
    expect(find.text('Tag1'), findsOneWidget);
    expect(find.text('Tag2'), findsOneWidget);
    expect(find.byType(Chip), findsNWidgets(testEvent.tags.length));
  });

  // Test 4: Verify that the event description text appears with font size 18.0.
  testWidgets('ViewPostScreen displays description text with proper font size', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ViewPostScreen(event: testEvent),
    ));
    final textFinder = find.text(testEvent.text);
    expect(textFinder, findsOneWidget);

    final Text descriptionText = tester.widget<Text>(textFinder);
    expect(descriptionText.style?.fontSize, 18.0);
  });

  // Test 5: Verify that tapping the back button navigates back to the previous screen.
  testWidgets('Back button correctly navigates back to previous route', (WidgetTester tester) async {
    // Define routes: DummyHome as the initial route and ViewPostScreen at '/view'.
    await tester.pumpWidget(MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const DummyHome(),
        '/view': (context) => ViewPostScreen(event: testEvent),
      },
    ));

    // Navigate to the ViewPostScreen.
    expect(find.text('Go to ViewPost'), findsOneWidget);
    await tester.tap(find.text('Go to ViewPost'));
    await tester.pumpAndSettle();
    expect(find.text(testEvent.text), findsOneWidget);

    // Tap the back button (arrow icon) on the AppBar.
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.text('Go to ViewPost'), findsOneWidget); // Verify we are back at DummyHome.
  });

  // NEW TESTS FOR REPORT FEATURE

  // Test 6: Verify that the report button is displayed with correct text and style
  testWidgets('ViewPostScreen displays report button with correct text and style', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ViewPostScreen(event: testEvent),
    ));

    // Locate the Report User button
    final reportButtonFinder = find.widgetWithText(ElevatedButton, 'Report User');
    expect(reportButtonFinder, findsOneWidget);

    // Verify the button's background color is redAccent
    final ElevatedButton reportButton = tester.widget<ElevatedButton>(reportButtonFinder);
    final ButtonStyle? style = reportButton.style;
    expect(style, isNotNull);
    final MaterialStateProperty<Color?>? bgColorProp = style?.backgroundColor;
    expect(bgColorProp?.resolve(<MaterialState>{}), equals(Colors.redAccent));
  });

  // Test 7: Verify that the report button is centered on the screen
  testWidgets('Report button is centered in ViewPostScreen', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ViewPostScreen(event: testEvent),
    ));

    // Check that the ElevatedButton is a descendant of a Center widget
    final centeredFinder = find.descendant(
      of: find.byType(Center),
      matching: find.widgetWithText(ElevatedButton, 'Report User'),
    );
    expect(centeredFinder, findsOneWidget);
  });
}
