import 'package:flutter/material.dart';
import 'package:node_manager/domain/entities/Node.dart';

IconData databaseIcon(DatabaseType type) {
  switch (type) {
    case DatabaseType.postgres:
      return Icons.storage;
    case DatabaseType.mysql:
      return Icons.data_object;
    case DatabaseType.mongodb:
      return Icons.bolt;
    case DatabaseType.sqlite:
      return Icons.folder_shared;
  }
}

Color databaseColor(DatabaseType type) {
  switch (type) {
    case DatabaseType.postgres:
      return Colors.indigo;
    case DatabaseType.mysql:
      return Colors.orange;
    case DatabaseType.mongodb:
      return Colors.green;
    case DatabaseType.sqlite:
      return Colors.blueGrey;
  }
}
