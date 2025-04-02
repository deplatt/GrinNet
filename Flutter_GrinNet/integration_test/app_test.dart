import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:Flutter_GrinNet/main.dart'; // Replace with your app

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App launches on mobile', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
