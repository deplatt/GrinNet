import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_test2/pages/login_register_page.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test2/auth.dart';

class MockAuth extends Mock implements Auth {}
class MockUserCredential extends Mock implements UserCredential {}

void main() {
  late MockAuth mockAuth;
  late MockUserCredential mockUserCredential;

  setUpAll(() {
    registerFallbackValue(''); // For email strings
    registerFallbackValue(''); // For password strings
  });

  setUp(() {
    mockAuth = MockAuth();
    mockUserCredential = MockUserCredential();

    // Correct mock setup with named parameters
    when(() => mockAuth.signInWithEmailAndPassword(
      email: any(named: 'email'),
      password: any(named: 'password'),
    )).thenAnswer((_) async => mockUserCredential);
  });

  // Helper function to reduce duplication
  Future<void> pumpLoginPage(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoginPage(auth: mockAuth),
      ),
    );
    await tester.pump(); // Allow initial build to complete
  }

 // First Test checking all the elements in the UI are present
  testWidgets('LoginScreen has all UI elements', (WidgetTester tester) async {
    await pumpLoginPage(tester);

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('GrinNet'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.widgetWithText(TextField, 'Email'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Password'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
    expect(find.widgetWithText(TextButton, 'I want to create an account'), findsOneWidget);
  });

    // Check 2: Text Fields can be filled 
  testWidgets('Can enter email and password', (WidgetTester tester) async {
    await pumpLoginPage(tester);

    final emailField = find.widgetWithText(TextField, 'Email');
    final passwordField = find.widgetWithText(TextField, 'Password');

    await tester.enterText(emailField, 'student1@grinnell.edu');
    expect(find.text('student1@grinnell.edu'), findsOneWidget);

    await tester.enterText(passwordField, 'Password 123');
    expect(find.text('Password 123'), findsOneWidget);
  });
  // Switches the button depending on register or login
  testWidgets('Switches between login and register modes', (WidgetTester tester) async {
    await pumpLoginPage(tester);

    expect(find.text('Login'), findsOneWidget);
    expect(find.text('I want to create an account'), findsOneWidget);

    await tester.tap(find.text('I want to create an account'));
    await tester.pumpAndSettle();

    expect(find.text('Register'), findsOneWidget);
    expect(find.text('I already have an account'), findsOneWidget);
  });

    // Mocks the entire log in process 
  testWidgets('Successful login flow with mock verification', (WidgetTester tester) async {
    await pumpLoginPage(tester);

    final emailField = find.widgetWithText(TextField, 'Email');
    final passwordField = find.widgetWithText(TextField, 'Password');
    final loginButton = find.widgetWithText(ElevatedButton, 'Login');

    await tester.enterText(emailField, 'student@grinnell.com');
    await tester.enterText(passwordField, 'Password123');
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
    // Verifies the mock authentication worked 
    verify(() => mockAuth.signInWithEmailAndPassword(
      email: 'student@grinnell.com',
      password: 'Password123',
    )).called(1);
  });
  
    // Future test for when an error message shows up
  /* testWidgets('Failed login shows error message', (WidgetTester tester) async {
    // Override the default mock behavior for this test
    when(() => mockAuth.signInWithEmailAndPassword(
      email: any(named: 'email'),
      password: any(named: 'password'),
    )).thenThrow(FirebaseAuthException(code: 'wrong-password'));

    await pumpLoginPage(tester);

    await tester.enterText(find.widgetWithText(TextField, 'Email'), 'wrong@email.com');
    await tester.enterText(find.widgetWithText(TextField, 'Password'), 'wrongpass');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.text(''), findsOneWidget);
  }); */
}
