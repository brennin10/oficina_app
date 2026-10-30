import 'package:flutter_test/flutter_test.dart';

import 'package:oficina_app/app.dart';

void main() {
  testWidgets('abre a tela de login', (WidgetTester tester) async {
    await tester.pumpWidget(const OficinaApp());

    expect(find.text('Entrar'), findsOneWidget);
  });
}