import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:node_manager/domain/entities/Node.dart';
import 'package:node_manager/presentation/widgets/add_node_dialog.dart';

void main() {
  Future<void> pumpDialog(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: TextButton(
                onPressed: () {
                  showDialog<Node>(
                    context: context,
                    builder: (context) => const AddNodeDialog(),
                  );
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  Future<void> fillForm(WidgetTester tester,
      {String name = 'Server-9', String location = 'De', String ip = '10.0.0.9'}) async {
    await tester.enterText(find.byType(TextFormField).at(0), name);
    await tester.enterText(find.byType(TextFormField).at(1), location);
    await tester.enterText(find.byType(TextFormField).at(2), ip);
  }

  group('AddNodeDialog', () {
    testWidgets('отображает все элементы диалога', (tester) async {
      await pumpDialog(tester);

      expect(find.text('Добавить сервер'), findsOneWidget);
      expect(find.text('Заполните информацию о новом сервере'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(3));
      expect(find.text('База данных'), findsOneWidget);
      expect(find.text('Отмена'), findsOneWidget);
      expect(find.text('Добавить'), findsOneWidget);
    });

    testWidgets('по умолчанию выбрана PostgreSQL', (tester) async {
      await pumpDialog(tester);

      expect(find.text('PostgreSQL'), findsOneWidget);
    });

    testWidgets('валидация отклоняет пустую форму', (tester) async {
      await pumpDialog(tester);

      await tester.tap(find.text('Добавить'));
      await tester.pump();

      expect(find.text('Введите название'), findsOneWidget);
      expect(find.text('Введите расположение'), findsOneWidget);
      expect(find.text('Введите IP-адрес'), findsOneWidget);
      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('не показывает ошибки при заполнении', (tester) async {
      await pumpDialog(tester);

      await fillForm(tester);
      await tester.tap(find.text('Добавить'));
      await tester.pumpAndSettle();

      expect(find.text('Введите название'), findsNothing);
      expect(find.text('Введите расположение'), findsNothing);
      expect(find.text('Введите IP-адрес'), findsNothing);
    });

    testWidgets('возвращает Node с введёнными данными', (tester) async {
      Node? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => Center(
                child: TextButton(
                  onPressed: () async {
                    result = await showDialog<Node>(
                      context: context,
                      builder: (context) => const AddNodeDialog(),
                    );
                  },
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await fillForm(tester);
      await tester.tap(find.text('Добавить'));
      await tester.pumpAndSettle();

      expect(result, isNotNull);
      expect(result!.name, 'Server-9');
      expect(result!.location, 'De');
      expect(result!.state, ServerState.unknown);
      expect(result!.database, DatabaseType.postgres);
    });

    testWidgets('возвращает выбранную БД', (tester) async {
      Node? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => Center(
                child: TextButton(
                  onPressed: () async {
                    result = await showDialog<Node>(
                      context: context,
                      builder: (context) => const AddNodeDialog(),
                    );
                  },
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await fillForm(tester);

      await tester.tap(find.text('PostgreSQL'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('MongoDB').last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Добавить'));
      await tester.pumpAndSettle();

      expect(result, isNotNull);
      expect(result!.database, DatabaseType.mongodb);
    });

    testWidgets('список БД содержит все типы', (tester) async {
      await pumpDialog(tester);

      await tester.tap(find.text('PostgreSQL'));
      await tester.pumpAndSettle();

      expect(find.text('PostgreSQL'), findsNWidgets(2));
      expect(find.text('MySQL'), findsOneWidget);
      expect(find.text('MongoDB'), findsOneWidget);
      expect(find.text('SQLite'), findsOneWidget);
    });

    testWidgets('кнопка Отмена закрывает диалог без результата', (tester) async {
      Node? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => Center(
                child: TextButton(
                  onPressed: () async {
                    result = await showDialog<Node>(
                      context: context,
                      builder: (context) => const AddNodeDialog(),
                    );
                  },
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Отмена'));
      await tester.pumpAndSettle();

      expect(result, isNull);
      expect(find.byType(AlertDialog), findsNothing);
    });
  });
}
