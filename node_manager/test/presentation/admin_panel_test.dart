import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:node_manager/domain/entities/Node.dart';
import 'package:node_manager/presentation/admin/admin_panel.dart';
import 'package:node_manager/presentation/admin/server_details/empty_state_view.dart';
import 'package:node_manager/presentation/admin/server_details/server_detail_view.dart';
import 'package:node_manager/presentation/admin/server_list_tile.dart';

Node _node(
  String name,
  ServerState state, [
  DatabaseType db = DatabaseType.postgres,
]) {
  return Node(name: name, location: 'Ru', state: state, database: db);
}

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  group('AdminPanel', () {
    testWidgets('показывает пустое состояние, когда сервер не выбран', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          AdminPanel(
            nodeList: [],
            currentServer: null,
            onServerSelected: (_) {},
          ),
        ),
      );

      expect(find.byType(EmptyStateView), findsOneWidget);
      expect(find.text('Сервер не выбран'), findsOneWidget);
      expect(find.byType(ServerListTile), findsNothing);
    });

    testWidgets('отображает список серверов', (tester) async {
      final nodes = [
        _node('Server-1', ServerState.online),
        _node('Server-2', ServerState.offline),
      ];

      await tester.pumpWidget(
        _wrap(
          AdminPanel(
            nodeList: nodes,
            currentServer: null,
            onServerSelected: (_) {},
          ),
        ),
      );

      expect(find.byType(ServerListTile), findsNWidgets(2));
      expect(find.text('Server-1'), findsOneWidget);
      expect(find.text('Server-2'), findsOneWidget);
      expect(find.text('Ru'), findsNWidgets(2));
    });

    testWidgets('показывает список серверов и пустое состояние до выбора', (
      tester,
    ) async {
      final nodes = [_node('Server-1', ServerState.online)];

      await tester.pumpWidget(
        _wrap(
          AdminPanel(
            nodeList: nodes,
            currentServer: null,
            onServerSelected: (_) {},
          ),
        ),
      );

      expect(find.byType(ServerListTile), findsOneWidget);
      expect(find.byType(EmptyStateView), findsOneWidget);
    });

    testWidgets('вызывает onServerSelected при нажатии на сервер', (
      tester,
    ) async {
      final nodes = [
        _node('Server-1', ServerState.online),
        _node('Server-2', ServerState.offline),
      ];
      Node? selected;

      await tester.pumpWidget(
        _wrap(
          AdminPanel(
            nodeList: nodes,
            currentServer: null,
            onServerSelected: (node) => selected = node,
          ),
        ),
      );

      await tester.tap(find.text('Server-2'));
      expect(selected, nodes[1]);
    });

    testWidgets('показывает детали выбранного сервера', (tester) async {
      final nodes = [_node('Server-1', ServerState.online)];

      await tester.pumpWidget(
        _wrap(
          AdminPanel(
            nodeList: nodes,
            currentServer: nodes.first,
            onServerSelected: (_) {},
          ),
        ),
      );

      expect(find.byType(ServerDetailView), findsOneWidget);
      expect(find.byType(EmptyStateView), findsNothing);
      expect(find.text('Server-1'), findsNWidgets(2));
    });

    testWidgets('не показывает детали, когда currentServer null', (
      tester,
    ) async {
      final nodes = [_node('Server-1', ServerState.online)];

      await tester.pumpWidget(
        _wrap(
          AdminPanel(
            nodeList: nodes,
            currentServer: null,
            onServerSelected: (_) {},
          ),
        ),
      );

      expect(find.byType(ServerDetailView), findsNothing);
      expect(find.byType(EmptyStateView), findsOneWidget);
    });
  });
}
