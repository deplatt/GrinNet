import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/mockito.dart';
import 'package:intl/intl.dart';

import 'package:firebase_test2/pages/create_post.dart';
import 'package:firebase_test2/api_service.dart';
import 'package:firebase_test2/pages/global.dart';

// Mock classes
class MockImagePicker extends Mock implements ImagePicker {}
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late MockImagePicker mockImagePicker;
  late MockNavigatorObserver mockObserver;

  setUp(() {
    mockImagePicker = MockImagePicker();
    mockObserver = MockNavigatorObserver();
    Global.userId = 1; // Initialize global state
  });

  tearDown(() {
    reset(mockImagePicker);
    reset(mockObserver);
  });

  Widget createTestWidget() {
    return MaterialApp(
      home: CreatePostScreen(),
      navigatorObservers: [mockObserver],
    );
  }

  group('UI Rendering Tests', () {
    testWidgets('renders all initial UI elements', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Create Event Post'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('Event Title'), findsOneWidget);
      expect(find.text('Event Description'), findsOneWidget);
      expect(find.text('Select Tags:'), findsOneWidget);
      expect(find.byType(FilterChip), findsNWidgets(9));
      expect(find.text('Upload Image'), findsOneWidget);
      expect(find.text('Select Event Date'), findsOneWidget);
      expect(find.text('Post'), findsOneWidget);
    });

    testWidgets('allows entering title and description', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextField).first, 'Test Title');
      await tester.enterText(find.byType(TextField).last, 'Test Description');

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
    });

   testWidgets('allows selecting and deselecting tags', (tester) async {
      await tester.pumpWidget(createTestWidget());
      final sportsChipFinder = find.widgetWithText(FilterChip, 'Sports').first;
       // Tap to select the chip
      await tester.tap(sportsChipFinder);
      await tester.pump();
      final selectedChip = tester.widget<FilterChip>(sportsChipFinder);
      expect(selectedChip.selected, isTrue);
    // Tap again to deselect
     await tester.tap(sportsChipFinder);
     await tester.pump();
    final deselectedChip = tester.widget<FilterChip>(sportsChipFinder);
    expect(deselectedChip.selected, isFalse);
  });
});


  group('Date Picker Tests', () {
    testWidgets('opens date picker on tap', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.tap(find.text('Select Event Date'));
      await tester.pump();

      expect(find.byType(DatePickerDialog), findsOneWidget);
    });
  });
}
