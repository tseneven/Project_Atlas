import 'package:flutter_test/flutter_test.dart';
import 'package:node_manager/domain/entities/Node.dart';

void main() {
  group('Node', () {
    test('создаётся со всеми полями', () {
      final node = Node(
        name: 'Server-1',
        location: 'Ru',
        state: ServerState.online,
        database: DatabaseType.postgres,
      );

      expect(node.name, 'Server-1');
      expect(node.location, 'Ru');
      expect(node.state, ServerState.online);
      expect(node.database, DatabaseType.postgres);
    });

    test('UUID и setting по умолчанию null', () {
      final node = Node(
        name: 'Server-1',
        location: 'Ru',
        state: ServerState.unknown,
        database: DatabaseType.mysql,
      );

      expect(node.UUID, isNull);
      expect(node.setting, isNull);
    });

    test('state по умолчанию unknown', () {
      final node = Node(
        name: 'Server-1',
        location: 'Ru',
        database: DatabaseType.mysql,
        state: ServerState.unknown,
      );

      expect(node.state, ServerState.unknown);
    });
  });

  group('ServerState', () {
    test('содержит все состояния', () {
      expect(ServerState.values, [ServerState.online, ServerState.offline, ServerState.unknown]);
    });
  });

  group('DatabaseType', () {
    test('содержит все типы', () {
      expect(
        DatabaseType.values,
        [DatabaseType.postgres, DatabaseType.mysql, DatabaseType.mongodb, DatabaseType.sqlite],
      );
    });

    test('имеет корректные подписи', () {
      expect(DatabaseType.postgres.label, 'PostgreSQL');
      expect(DatabaseType.mysql.label, 'MySQL');
      expect(DatabaseType.mongodb.label, 'MongoDB');
      expect(DatabaseType.sqlite.label, 'SQLite');
    });
  });
}
