import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:node_manager/domain/entities/Node.dart';
import 'package:node_manager/presentation/admin/server_details/server_detail_view.dart';

Node _node(
  String name,
  ServerState state, [
  DatabaseType db = DatabaseType.postgres,
]) {
  return Node(name: name, location: 'Ru', state: state, database: db);
}

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

Future<void> _scrollTo(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
}

void main() {
  group('ServerDetailView', () {
    testWidgets('отображает базовую информацию о сервере', (tester) async {
      final node = _node('Server-1', ServerState.online);

      await tester.pumpWidget(_wrap(ServerDetailView(server: node)));

      expect(find.text('Server-1'), findsOneWidget);
      expect(find.text('Ru'), findsNWidgets(2));
      expect(find.text('ONLINE'), findsOneWidget);
      expect(find.text('В сети'), findsOneWidget);
    });

    testWidgets('отображает тип БД в информации и в контейнере', (
      tester,
    ) async {
      final node = _node('Server-1', ServerState.online, DatabaseType.mysql);

      await tester.pumpWidget(_wrap(ServerDetailView(server: node)));

      expect(find.text('MySQL'), findsNWidgets(2));
      expect(find.text('База данных'), findsNWidgets(2));
    });

    testWidgets('отображает UUID, статус, локацию', (tester) async {
      final node = _node('Server-1', ServerState.offline);

      await tester.pumpWidget(_wrap(ServerDetailView(server: node)));

      expect(find.text('Не назначен'), findsOneWidget);
      expect(find.text('Не в сети'), findsOneWidget);
      expect(find.text('Ru'), findsNWidgets(2));
    });

    testWidgets('показывает RUNNING и телеметрию для онлайн сервера', (
      tester,
    ) async {
      final node = _node('Server-1', ServerState.online);

      await tester.pumpWidget(_wrap(ServerDetailView(server: node)));

      expect(find.text('RUNNING'), findsOneWidget);
      expect(find.text('Работает'), findsOneWidget);
      expect(find.text('CPU'), findsOneWidget);
      expect(find.text('RAM'), findsOneWidget);
      expect(find.text('Диск'), findsOneWidget);
      expect(find.text('Сеть'), findsOneWidget);
      expect(find.text('Контейнер остановлен'), findsNothing);
    });

    testWidgets('показывает STOPPED и заглушку телеметрии для офлайн сервера', (
      tester,
    ) async {
      final node = _node('Server-1', ServerState.offline);

      await tester.pumpWidget(_wrap(ServerDetailView(server: node)));

      expect(find.text('STOPPED'), findsOneWidget);
      expect(find.text('Остановлен'), findsOneWidget);
      expect(find.text('Контейнер остановлен'), findsOneWidget);
      expect(find.text('CPU'), findsNothing);
    });

    testWidgets('отображает информацию о контейнере', (tester) async {
      final node = _node('Server-1', ServerState.online);

      await tester.pumpWidget(_wrap(ServerDetailView(server: node)));

      expect(find.text('atlas/server-1:latest'), findsOneWidget);
      expect(find.text('8080 -> 80'), findsOneWidget);
      expect(find.text('3 дн 4 ч 12 мин'), findsOneWidget);
      expect(find.text('a1b2c3d4e5f6'), findsOneWidget);
      expect(find.text('Контейнер a1b2c3d4'), findsOneWidget);
    });

    testWidgets('отображает кнопки действий', (tester) async {
      final node = _node('Server-1', ServerState.online);

      await tester.pumpWidget(_wrap(ServerDetailView(server: node)));

      expect(find.text('Остановить'), findsOneWidget);
      expect(find.text('Перезапустить'), findsOneWidget);
      expect(find.text('Пересоздать'), findsOneWidget);
      expect(find.text('Удалить'), findsOneWidget);
    });

    testWidgets('для офлайн сервера показывает кнопку Запустить', (
      tester,
    ) async {
      final node = _node('Server-1', ServerState.offline);

      await tester.pumpWidget(_wrap(ServerDetailView(server: node)));

      expect(find.text('Запустить'), findsOneWidget);
      expect(find.text('Остановить'), findsNothing);
    });

    testWidgets('запуск показывает SnackBar без диалога', (tester) async {
      final node = _node('Server-1', ServerState.offline);

      await tester.pumpWidget(_wrap(ServerDetailView(server: node)));

      await _scrollTo(tester, find.text('Запустить'));
      await tester.tap(find.text('Запустить'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(AlertDialog), findsNothing);
      expect(find.text('Запуск: контейнер «Server-1» (мок)'), findsOneWidget);
    });

    testWidgets('остановка показывает SnackBar без диалога', (tester) async {
      final node = _node('Server-1', ServerState.online);

      await tester.pumpWidget(_wrap(ServerDetailView(server: node)));

      await _scrollTo(tester, find.text('Остановить'));
      await tester.tap(find.text('Остановить'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(AlertDialog), findsNothing);
      expect(
        find.text('Остановка: контейнер «Server-1» (мок)'),
        findsOneWidget,
      );
    });

    testWidgets('перезапуск требует подтверждения', (tester) async {
      final node = _node('Server-1', ServerState.online);

      await tester.pumpWidget(_wrap(ServerDetailView(server: node)));

      await _scrollTo(tester, find.text('Перезапустить'));
      await tester.tap(find.text('Перезапустить'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Перезапуск контейнера'), findsOneWidget);
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('подтверждение пересоздания показывает SnackBar', (
      tester,
    ) async {
      final node = _node('Server-1', ServerState.online);

      await tester.pumpWidget(_wrap(ServerDetailView(server: node)));

      await _scrollTo(tester, find.text('Пересоздать'));
      await tester.tap(find.text('Пересоздать'));
      await tester.pumpAndSettle();

      expect(find.text('Пересоздание контейнера'), findsOneWidget);
      expect(find.textContaining('будут потеряны'), findsOneWidget);

      await tester.tap(find.widgetWithText(ElevatedButton, 'Пересоздать'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      expect(
        find.text('Пересоздать: контейнер «Server-1» (мок)'),
        findsOneWidget,
      );
    });

    testWidgets('подтверждение удаления показывает SnackBar', (tester) async {
      final node = _node('Server-1', ServerState.online);

      await tester.pumpWidget(_wrap(ServerDetailView(server: node)));

      await _scrollTo(tester, find.text('Удалить'));
      await tester.tap(find.text('Удалить'));
      await tester.pumpAndSettle();

      expect(find.text('Удаление контейнера'), findsOneWidget);
      expect(find.textContaining('необратимо'), findsOneWidget);

      await tester.tap(find.widgetWithText(ElevatedButton, 'Удалить'));
      await tester.pumpAndSettle();

      expect(find.text('Удалить: контейнер «Server-1» (мок)'), findsOneWidget);
    });

    testWidgets('отмена в диалоге не показывает SnackBar', (tester) async {
      final node = _node('Server-1', ServerState.online);

      await tester.pumpWidget(_wrap(ServerDetailView(server: node)));

      await _scrollTo(tester, find.text('Удалить'));
      await tester.tap(find.text('Удалить'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Отмена'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      expect(find.byType(SnackBar), findsNothing);
    });
  });
}
