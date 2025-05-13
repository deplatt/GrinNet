import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_test2/main.dart';
import 'package:firebase_test2/pages/profile_page.dart';
import 'package:firebase_test2/pages/global.dart';

/// Stub AssetBundle to avoid real asset loads
class TestAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    if (key == 'AssetManifest.json') {
      final manifest = json.encode(<String, dynamic>{});
      return ByteData.view(Uint8List.fromList(utf8.encode(manifest)).buffer);
    }
    if (key.endsWith('.png') || key.endsWith('.jpg') || key.endsWith('.jpeg')) {
      // 1×1 transparent PNG, base64-encoded
      const transparentBase64 =
          'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR4nGMAAQAABQABDQottAAAAABJRU5ErkJggg==';
      final bytes = base64Decode(transparentBase64);
      return ByteData.view(Uint8List.fromList(bytes).buffer);
    }
    return rootBundle.load(key);
  }
}

/// Wrap ProfileScreen in a MaterialApp with the stub bundle
Widget makeTestable({required List<Event> events}) {
  return MaterialApp(
    home: DefaultAssetBundle(
      bundle: TestAssetBundle(),
      child: ProfileScreen(events: events),
    ),
  );
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    Global.username = 'testuser';
    Global.userId = 42;
  });

  // Test 1: loading indicator shows
  testWidgets('Test 1: ProfileScreen displays loading indicator initially',
      (tester) async {
    await tester.pumpWidget(makeTestable(events: []));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  // Test 2: fallback avatar and bio when load fails
  testWidgets('Test 2: ProfileScreen shows default avatar and bio on load failure',
      (tester) async {
    await tester.pumpWidget(makeTestable(events: []));
    await tester.pump();
    await tester.pump();
    final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar).first);
    expect(avatar.backgroundImage, isA<AssetImage>());
    expect(find.text('No bio provided'), findsOneWidget);
  });

  // Test 3: username is shown in header
  testWidgets('Test 3: ProfileScreen displays username in header',
      (tester) async {
    await tester.pumpWidget(makeTestable(events: []));
    await tester.pump();
    await tester.pump();
    expect(find.text('testuser'), findsOneWidget);
  });

  // Test 4: settings icon is present
  testWidgets('Test 4: ProfileScreen shows settings icon', (tester) async {
    await tester.pumpWidget(makeTestable(events: []));
    await tester.pump();
    await tester.pump();
    expect(find.byIcon(Icons.settings), findsOneWidget);
  });

  // Test 5: filters only the user’s events
  testWidgets('Test 5: ProfileScreen filters and displays only user events',
      (tester) async {
    final events = [
      Event(
          username: 'testuser',
          imageUrl: '',
          profileImageUrl: '',
          text: 'User Event',
          tags: [],
          postId: 1,
          userId: 42),
      Event(
          username: 'other',
          imageUrl: '',
          profileImageUrl: '',
          text: 'Other Event',
          tags: [],
          postId: 2,
          userId: 99),
    ];
    await tester.pumpWidget(makeTestable(events: events));
    await tester.pump();
    await tester.pump();
    expect(find.text('User Event'), findsOneWidget);
    expect(find.text('Other Event'), findsNothing);
  });

  // Test 6: event description font size
  testWidgets('Test 6: ProfileScreen displays event text with font size 16',
      (tester) async {
    final events = [
      Event(
          username: 'testuser',
          imageUrl: '',
          profileImageUrl: '',
          text: 'Sample Text',
          tags: [],
          postId: 3,
          userId: 42),
    ];
    await tester.pumpWidget(makeTestable(events: events));
    await tester.pump();
    await tester.pump();
    final textFinder = find.text('Sample Text');
    expect(textFinder, findsOneWidget);
    final textWidget = tester.widget<Text>(textFinder);
    expect(textWidget.style?.fontSize, 16);
  });

  // Test 7: tags are chips
  testWidgets('Test 7: ProfileScreen displays event tags as Chips',
      (tester) async {
    final events = [
      Event(
          username: 'testuser',
          imageUrl: '',
          profileImageUrl: '',
          text: 'With Tags',
          tags: ['A', 'B', 'C'],
          postId: 4,
          userId: 42),
    ];
    await tester.pumpWidget(makeTestable(events: events));
    await tester.pump();
    await tester.pump();
    expect(find.byType(Chip), findsNWidgets(3));
    expect(find.text('A'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
    expect(find.text('C'), findsOneWidget);
  });
}