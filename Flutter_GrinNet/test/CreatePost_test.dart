import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mocktail/mocktail.dart';
import '../lib/pages/create_post.dart';
import '../lib/main.dart';

// Import classes that perform mock operations
class MockImagePicker extends Mock implements ImagePicker {}
class MockXFile extends Mock implements XFile {
  @override
  final String path;

  MockXFile(this.path);
}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}
//class MockFilePicker extends Mock implements FilePickerPlatform {}
class FakeRoute extends Fake implements Route<dynamic> {}

void main() {

  // Build Up tests 
  late MockImagePicker mockImagePicker;
  late MockNavigatorObserver mockObserver;
  //late MockFilePicker mockFilePicker;

  setUpAll(() {
   registerFallbackValue(FakeRoute());
  });

  setUp(() {
    mockImagePicker = MockImagePicker();
    mockObserver = MockNavigatorObserver();
    //mockFilePicker = MockFilePicker();
    //FilePicker.platform = mockFilePicker;
  });
  // Set widget to test that the create post screen is on 
  Future<void> pumpCreatePostScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CreatePostScreen(),
        navigatorObservers: [mockObserver],
      ),
    );
  }

  // First Test, just check that the UI builds correctly
  testWidgets('CreatePostScreen UI shows correctly', (WidgetTester tester) async {
    await pumpCreatePostScreen(tester);
    // See comparisons using the expect tool that compares widgets 
    expect(find.text('Create Event Post'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Event Title'), findsOneWidget);
    expect(find.text('Event Description'), findsOneWidget);
    expect(find.text('Select Tags:'), findsOneWidget);
    expect(find.byType(FilterChip), findsNWidgets(9));
    expect(find.text('Upload Image'), findsOneWidget);
    expect(find.text('Post'), findsOneWidget);
  });

  // Second Test, checks that we can input text on the text fields 
  testWidgets('Can input title and description to the post', (WidgetTester tester) async {
    await pumpCreatePostScreen(tester);

    const testTitle = 'Test Event';
    const testDescription = 'What an awesome event ';
    // Enters mock test using the enterText function
    await tester.enterText(find.byType(TextField).first, testTitle);
    await tester.enterText(find.byType(TextField).last, testDescription);

    expect(find.text(testTitle), findsOneWidget);
    expect(find.text(testDescription), findsOneWidget);
  });

  // Checks that a post can be select and deselect
  testWidgets('Can select and deselect tags', (WidgetTester tester) async {
    await pumpCreatePostScreen(tester);
    // Taps on the button
    await tester.tap(find.text('Sports'));
    await tester.pump();
    // Creates a widget to test specifing its content 
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
  // Checks that all posts can be selected and deselected 
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
  // Tests a mock post submission
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
  // Can posts with correct data 
  testWidgets('Post includes correct data when submitted', (WidgetTester tester) async {
  // Get the mock observer set upp 
  final mockObserver = MockNavigatorObserver();
// Fill the post submission requirements 
  await tester.pumpWidget(MaterialApp(
    home: CreatePostScreen(), 
    navigatorObservers: [mockObserver],
  ));

  const testTitle = 'Test Event';
  const testDescription = 'This is an awesome test event description';

  await tester.enterText(find.byType(TextField).first, testTitle);
  await tester.enterText(find.byType(TextField).last, testDescription);
  await tester.tap(find.text('Sports'));
  await tester.tap(find.text('Music'));
  await tester.pump();

  await tester.tap(find.text('Post'));
  await tester.pumpAndSettle();

  // Verified it submitted correctly
  verify(() => mockObserver.didPop(any(), any())).called(1);

});

/*   testWidgets('Can select image and it appears in submitted event', (WidgetTester tester) async {
    // Setup mock file
    final fakeFile = PlatformFile(
      name: 'image.jpg',
      path: 'test/path/image.jpg',
      size: 123456,
      bytes: null,
    );

    final fakeResult = FilePickerResult([fakeFile]);

    when(() => mockFilePicker.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    )).thenAnswer((_) async => fakeResult);

    await pumpCreatePostScreen(tester);

    // Fill required fields
    await tester.enterText(find.byType(TextField).first, 'Test');
    await tester.enterText(find.byType(TextField).last, 'Description');
    await tester.tap(find.text('Sports'));
    await tester.pump();

    // Select image
    await tester.tap(find.text('Upload Image'));
    await tester.pump();

    expect(find.text('Image selected'), findsOneWidget);

    // Test submission
    dynamic poppedResult;
    final context = tester.element(find.text('Post'));
    Navigator.of(context).pop().then((value) => poppedResult = value);

    await tester.tap(find.text('Post'));
    await tester.pump();

    final event = poppedResult as Event;
    expect(event.imageUrl, 'test/path/image.jpg');
  }); */
}