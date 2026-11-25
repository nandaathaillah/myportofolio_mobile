import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';

void main() {
  testWidgets('Portfolio home screen loads', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('MyPortfolio'), findsOneWidget);
    expect(find.text('Welcome to MyPortfolio Mobile!'), findsOneWidget);
  });
}