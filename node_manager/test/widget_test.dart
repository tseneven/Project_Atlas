import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:node_manager/main.dart';

void main() {
  testWidgets('Приложение рендерится и показывает админ-панель',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.text('Server-1'), findsOneWidget);
    expect(find.text('Сервер не выбран'), findsOneWidget);
  });
}
