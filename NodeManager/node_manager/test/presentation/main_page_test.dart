import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:node_manager/main.dart';
import 'package:node_manager/presentation/admin/server_details/empty_state_view.dart';
import 'package:node_manager/presentation/admin/server_details/server_detail_view.dart';

void main() {
  group('MainPage', () {
    testWidgets('рендерится без ошибок', (tester) async {
      await tester.pumpWidget(const MyApp());

      expect(find.byType(Scaffold), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('отображает серверы по умолчанию', (tester) async {
      await tester.pumpWidget(const MyApp());

      expect(find.text('Server-1'), findsOneWidget);
      expect(find.text('Server-2'), findsOneWidget);
      expect(find.text('Server-3'), findsOneWidget);
      expect(find.text('Server-4'), findsOneWidget);
      expect(find.byType(EmptyStateView), findsOneWidget);
    });

    testWidgets('выбор сервера показывает его детали', (tester) async {
      await tester.pumpWidget(const MyApp());

      await tester.tap(find.text('Server-2'));
      await tester.pumpAndSettle();

      expect(find.byType(ServerDetailView), findsOneWidget);
      expect(find.byType(EmptyStateView), findsNothing);
      expect(find.text('В сети'), findsOneWidget);
      expect(find.text('RUNNING'), findsOneWidget);
      expect(find.text('MySQL'), findsNWidgets(2));
    });

    testWidgets('выбор другого сервера обновляет детали', (tester) async {
      await tester.pumpWidget(const MyApp());

      await tester.tap(find.text('Server-4'));
      await tester.pumpAndSettle();

      expect(find.text('Не в сети'), findsOneWidget);
      expect(find.text('STOPPED'), findsOneWidget);
      expect(find.text('Контейнер остановлен'), findsOneWidget);

      await tester.tap(find.text('Server-1'));
      await tester.pumpAndSettle();

      expect(find.text('Неизвестно'), findsOneWidget);
      expect(find.text('PostgreSQL'), findsNWidgets(2));
    });

    testWidgets('добавляет сервер через диалог', (tester) async {
      await tester.pumpWidget(const MyApp());

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.text('Добавить сервер'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField).at(0), 'Server-9');
      await tester.enterText(find.byType(TextFormField).at(1), 'De');
      await tester.enterText(find.byType(TextFormField).at(2), '10.0.0.9');

      await tester.tap(find.text('Добавить'));
      await tester.pumpAndSettle();

      expect(find.text('Server-9'), findsOneWidget);

      await tester.tap(find.text('Server-9'));
      await tester.pumpAndSettle();

      expect(find.byType(ServerDetailView), findsOneWidget);
      expect(find.text('PostgreSQL'), findsNWidgets(2));
    });
  });
}
