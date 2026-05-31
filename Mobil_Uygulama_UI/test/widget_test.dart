import 'package:flutter_test/flutter_test.dart';

import 'package:kargo_sistemi/app/app.dart';

void main() {
  testWidgets('Uygulama açılır ve splash görünür', (WidgetTester tester) async {
    await tester.pumpWidget(const KargoApp());
    expect(find.text('Kargo Sistemi'), findsOneWidget);
  });
}
