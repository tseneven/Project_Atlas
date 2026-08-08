class Node {
  final String name;
  final String location;
  final String? UUID = null;
  final Setting? setting = null;
  final DatabaseType database;
  ServerState state = ServerState.unknown;
  Node({
    required this.name,
    required this.location,
    required this.state,
    required this.database,
  });
}

class Setting {
}

enum ServerState {
  online,
  offline,
  unknown,
}

enum DatabaseType {
  postgres('PostgreSQL'),
  mysql('MySQL'),
  mongodb('MongoDB'),
  sqlite('SQLite');

  final String label;

  const DatabaseType(this.label);
}
