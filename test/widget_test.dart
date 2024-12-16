import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:animus_senai/main.dart'; // Verifique se este arquivo está correto

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Construa o aplicativo e gere um frame
    await tester.pumpWidget(const MyApp()); // MyApp precisa ser uma classe existente

    // Verifique se o contador começa em 0
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Toque no ícone '+' e gere um novo frame
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verifique se o contador foi incrementado
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
