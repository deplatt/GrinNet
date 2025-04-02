import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Test framework works', (tester) async {
    expect(true, isTrue); // Just verifies tests can run
  });
}
