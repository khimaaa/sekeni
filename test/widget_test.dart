import 'package:flutter_test/flutter_test.dart';

import 'package:my_app/main.dart';

void main() {
  testWidgets('App starts with splash', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Sekeni'), findsWidgets);
  });
}
