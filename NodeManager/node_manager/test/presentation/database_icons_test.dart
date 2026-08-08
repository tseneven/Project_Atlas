import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:node_manager/domain/entities/Node.dart';
import 'package:node_manager/presentation/widgets/database_icons.dart';

void main() {
  group('databaseIcon', () {
    test('возвращает иконку для каждого типа БД', () {
      expect(databaseIcon(DatabaseType.postgres), Icons.storage);
      expect(databaseIcon(DatabaseType.mysql), Icons.data_object);
      expect(databaseIcon(DatabaseType.mongodb), Icons.bolt);
      expect(databaseIcon(DatabaseType.sqlite), Icons.folder_shared);
    });
  });

  group('databaseColor', () {
    test('возвращает цвет для каждого типа БД', () {
      expect(databaseColor(DatabaseType.postgres), Colors.indigo);
      expect(databaseColor(DatabaseType.mysql), Colors.orange);
      expect(databaseColor(DatabaseType.mongodb), Colors.green);
      expect(databaseColor(DatabaseType.sqlite), Colors.blueGrey);
    });

    test('цвета различаются между типами', () {
      final colors = DatabaseType.values.map(databaseColor).toSet();
      expect(colors.length, DatabaseType.values.length);
    });
  });
}
