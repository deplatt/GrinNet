import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mocktail/mocktail.dart';
import '../lib/pages/create_post.dart';
import '../lib/main.dart';

/*
This is the file for testing out create_post.dart file. There is a variety of test aimed to test the functionality and 
the display of the Create Post Page. This test file relies on the flutter_test package that includes a great variety of tools
useful for testing. Additionally, it uses the mocktail package that allows us to mock objects for testing, especially when writing
 unit or widget tests. This packages are helpful as well because it help us perform isolated test that do not make real API calls.
*/


/*
* Mock classes for the ImagePicker and XFile classes.
* These are used to simulate the behavior of these classes in tests.
* The MockImagePicker class is used to mock the ImagePicker class, and the MockXFile class is used to mock the XFile class.
*/
class MockImagePicker extends Mock implements ImagePicker {}
/*
* Mock class for the XFile class.
* This class is used to simulate the behavior of the XFile class in tests.
* The MockXFile class is used to mock the XFile class.
* The MockXFile class has a constructor that takes a path parameter, which is used to set the path property of the XFile class.
* The path property is used to get the path of the file.
* The MockXFile class is used to mock the XFile class.
*/
class MockXFile extends Mock implements XFile {
  @override
  final String path;

  MockXFile(this.path);
}

/*
* Mock class for the NavigatorObserver class.
* This class is used to simulate the behavior of the NavigatorObserver class in tests.
* The MockNavigatorObserver class is used to mock the NavigatorObserver class.
*/

class MockNavigatorObserver extends Mock implements NavigatorObserver {}
/*
* This class is used to simulate the behavior of the Route class in tests.
* The FakeRoute class is used to mock the Route class.
* Route is a class that represents a route in the Navigator.
* It is used to manage the navigation stack and the transitions between routes.
*/

class FakeRoute extends Fake implements Route<dynamic> {}

void main() {

  // Mock classes for the ImagePicker and XFile classes
  // These are used to simulate the behavior of these classes in tests
  // The MockImagePicker class is used to mock the ImagePicker class, and the MockXFile class is used to mock the XFile class 
  late MockImagePicker mockImagePicker;
  late MockNavigatorObserver mockObserver;
  
 // Set up the mock classes for the ImagePicker and XFile classes
  setUpAll(() {
   registerFallbackValue(FakeRoute());
  });

  setUp(() {
    mockImagePicker = MockImagePicker();
    mockObserver = MockNavigatorObserver();
    //mockFilePicker = MockFilePicker();
    //FilePicker.platform = mockFilePicker;
  });
  // Helper function to reduce duplication
  // This function is used to pump the CreatePostScreen widget into the widget tree
  // The pumpCreatePostScreen function takes a WidgetTester as a parameter and pumps the CreatePostScreen widget into the widget tree
  Future<void> pumpCreatePostScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CreatePostScreen(),
        navigatorObservers: [mockObserver],
      ),
    );
  }

  // First Test, checks that all the elements in the UI are present
  // This test checks that the CreatePostScreen widget has all the UI elements
  testWidgets('CreatePostScreen UI shows correctly', (WidgetTester tester) async {
    await pumpCreatePostScreen(tester);
    // Uses the find widget to check if the widgets are present 
    expect(find.text('Create Event Post'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Event Title'), findsOneWidget);
    expect(find.text('Event Description'), findsOneWidget);
    expect(find.text('Select Tags:'), findsOneWidget);
    expect(find.byType(FilterChip), findsNWidgets(9));
    expect(find.text('Upload Image'), findsOneWidget);
    expect(find.text('Post'), findsOneWidget);
  });

  // Test 2: Checks that the image picker is called when the button is pressed
  testWidgets('Can input title and description to the post', (WidgetTester tester) async {
    await pumpCreatePostScreen(tester);

    const testTitle = 'Test Event';
    const testDescription = 'What an awesome event ';
    // Uses enterText to simulate the user inputting text into the text fields
    await tester.enterText(find.byType(TextField).first, testTitle);
    await tester.enterText(find.byType(TextField).last, testDescription);
    // Uses the find widget to check if the widgets are present
    expect(find.text(testTitle), findsOneWidget);
    expect(find.text(testDescription), findsOneWidget);
  });

  // Test 3: Checks that the image picker is called when the button is pressed
  testWidgets('Can select and deselect tags', (WidgetTester tester) async {
    await pumpCreatePostScreen(tester);
    // taps the button to select the tag 
    await tester.tap(find.text('Sports'));
    // Pumps the widget to update the UI
    await tester.pump();
    // Creates a filter chip to check if the tag is selected
    final sportsTag = tester.widget<FilterChip>(
    find.byWidgetPredicate(
      (widget) =>
          widget is FilterChip &&
          (widget.label is Text) &&
          (widget.label as Text).data == 'Sports',
    ),
  );
    // Compares widgets 
    expect(sportsTag.selected, isTrue);
    // Does the same but in reverse 
    await tester.tap(find.text('Sports'));
    await tester.pump();

      final sportsUntag = tester.widget<FilterChip>(
    find.byWidgetPredicate(
      (widget) =>
          widget is FilterChip &&
          (widget.label is Text) &&
          (widget.label as Text).data == 'Sports',
    ),
  );

    
    expect(sportsUntag.selected, isFalse);
  });
 
  // Test 4: Checks that the image picker is called when the button is pressed
    testWidgets('Can select and deselect all tags', (WidgetTester tester) async {
    await pumpCreatePostScreen(tester);

    await tester.tap(find.text('Sports'));
    await tester.pump();
     final sportsTag = tester.widget<FilterChip>(
    find.byWidgetPredicate(
      (widget) =>
          widget is FilterChip &&
          (widget.label is Text) &&
          (widget.label as Text).data == 'Sports',
    ),
  );
    expect(sportsTag.selected, isTrue);

    await tester.tap(find.text('Culture'));
    await tester.pump();
     final cultureTag = tester.widget<FilterChip>(
    find.byWidgetPredicate(
      (widget) =>
          widget is FilterChip &&
          (widget.label is Text) &&
          (widget.label as Text).data == 'Culture',
    ),
  );
    expect(cultureTag.selected, isTrue);

    await tester.tap(find.text('Games'));
    await tester.pump();
     final gamesTag = tester.widget<FilterChip>(
    find.byWidgetPredicate(
      (widget) =>
          widget is FilterChip &&
          (widget.label is Text) &&
          (widget.label as Text).data == 'Games',
    ),
  );
    expect(gamesTag.selected, isTrue);

    await tester.tap(find.text('SEPCs'));
    await tester.pump();
    final SEPCsTags = tester.widget<FilterChip>(
    find.byWidgetPredicate(
      (widget) =>
          widget is FilterChip &&
          (widget.label is Text) &&
          (widget.label as Text).data == 'SEPCs',
    ),
  );
    expect(SEPCsTags.selected, isTrue);

    await tester.tap(find.text('Dance'));
    await tester.pump();
    final danceTags = tester.widget<FilterChip>(
    find.byWidgetPredicate(
      (widget) =>
          widget is FilterChip &&
          (widget.label is Text) &&
          (widget.label as Text).data == 'Dance',
    ),
  );
    expect(danceTags.selected, isTrue);

    await tester.tap(find.text('Music'));
    await tester.pump();
    final musicTags = tester.widget<FilterChip>(
    find.byWidgetPredicate(
      (widget) =>
          widget is FilterChip &&
          (widget.label is Text) &&
          (widget.label as Text).data == 'Music',
    ),
  );
    expect(musicTags.selected, isTrue);

    await tester.tap(find.text('Food'));
    await tester.pump();
    final foodTags = tester.widget<FilterChip>(
    find.byWidgetPredicate(
      (widget) =>
          widget is FilterChip &&
          (widget.label is Text) &&
          (widget.label as Text).data == 'Food',
    ),
  );
    expect(foodTags.selected, isTrue);

    await tester.tap(find.text('Social'));
    await tester.pump();
    final socialTags = tester.widget<FilterChip>(
    find.byWidgetPredicate(
      (widget) =>
          widget is FilterChip &&
          (widget.label is Text) &&
          (widget.label as Text).data == 'Social',
    ),
  );
    expect(socialTags.selected, isTrue);

    await tester.tap(find.text('Misc'));
    await tester.pump();
    final miscTags = tester.widget<FilterChip>(
    find.byWidgetPredicate(
      (widget) =>
          widget is FilterChip &&
          (widget.label is Text) &&
          (widget.label as Text).data == 'Misc',
    ),
  );
    expect(miscTags.selected, isTrue);


    await tester.tap(find.text('Sports'));
    await tester.pump();
    final SportsUntag = tester.widget<FilterChip>(
    find.byWidgetPredicate(
      (widget) =>
          widget is FilterChip &&
          (widget.label is Text) &&
          (widget.label as Text).data == 'Sports',
    ),
  );
    expect(SportsUntag.selected, isFalse);

    await tester.tap(find.text('Culture'));
    await tester.pump();
    final CulturesUntag = tester.widget<FilterChip>(
    find.byWidgetPredicate(
      (widget) =>
          widget is FilterChip &&
          (widget.label is Text) &&
          (widget.label as Text).data == 'Culture',
    ),
  );
    expect(CulturesUntag.selected, isFalse);

    await tester.tap(find.text('Games'));
    await tester.pump();
    final GamesUntag = tester.widget<FilterChip>(
    find.byWidgetPredicate(
      (widget) =>
          widget is FilterChip &&
          (widget.label is Text) &&
          (widget.label as Text).data == 'Games',
    ),
  );
    expect(GamesUntag.selected, isFalse);

    await tester.tap(find.text('SEPCs'));
    await tester.pump();
   final SEPCsunTags = tester.widget<FilterChip>(
    find.byWidgetPredicate(
      (widget) =>
          widget is FilterChip &&
          (widget.label is Text) &&
          (widget.label as Text).data == 'SEPCs',
    ),
  );
    expect(SEPCsunTags.selected, isFalse);

    await tester.tap(find.text('Dance'));
    await tester.pump();
   final DanceUntags = tester.widget<FilterChip>(
    find.byWidgetPredicate(
      (widget) =>
          widget is FilterChip &&
          (widget.label is Text) &&
          (widget.label as Text).data == 'Dance',
    ),
  );
    expect(DanceUntags.selected, isFalse);

    await tester.tap(find.text('Music'));
    await tester.pump();
    final MusicUntags = tester.widget<FilterChip>(
    find.byWidgetPredicate(
      (widget) =>
          widget is FilterChip &&
          (widget.label is Text) &&
          (widget.label as Text).data == 'Music',
    ),
  );
    expect(MusicUntags.selected, isFalse);

    await tester.tap(find.text('Food'));
    await tester.pump();
    final FoodUntags = tester.widget<FilterChip>(
    find.byWidgetPredicate(
      (widget) =>
          widget is FilterChip &&
          (widget.label is Text) &&
          (widget.label as Text).data == 'Food',
    ),
  );
    expect(FoodUntags.selected, isFalse);
    

    await tester.tap(find.text('Social'));
    await tester.pump();
     final SocialUntags = tester.widget<FilterChip>(
    find.byWidgetPredicate(
      (widget) =>
          widget is FilterChip &&
          (widget.label is Text) &&
          (widget.label as Text).data == 'Social',
    ),
  );
    expect(SocialUntags.selected, isFalse);

    await tester.tap(find.text('Misc'));
    await tester.pump();
    final MiscUntags = tester.widget<FilterChip>(
    find.byWidgetPredicate(
      (widget) =>
          widget is FilterChip &&
          (widget.label is Text) &&
          (widget.label as Text).data == 'Sports',
    ),
  );
    expect(MiscUntags.selected, isFalse);
  });
    // Checks that if there is no info given the post button doesnt do anythinf
  testWidgets('Post does nothing when required fields are empty', (WidgetTester tester) async {
    await pumpCreatePostScreen(tester);

    await tester.tap(find.text('Post'));
    await tester.pump();

    verifyNever(() => mockObserver.didPop(any(), any()));
  });
  // Test 6: Mocks Post Creation
  testWidgets('Can mock post with all required fields', (WidgetTester tester) async {
    await pumpCreatePostScreen(tester);

    const testTitle = 'Test Event';
    const testDescription = 'This is an incredible test event description';
    await tester.enterText(find.byType(TextField).first, testTitle);
    await tester.enterText(find.byType(TextField).last, testDescription);
    await tester.tap(find.text('Culture'));
    await tester.tap(find.text('Music'));
    await tester.pump();

    await tester.tap(find.text('Post'));
    await tester.pump();
    // Verifies all steps were done correctly 
    final captured = verify(() => mockObserver.didPop(captureAny(), any())).captured;
    expect(captured, hasLength(1));
    final route = captured.first as Route;
    expect(route is ModalRoute, isTrue);
    expect((route as ModalRoute).settings.name, '/');
  });

}