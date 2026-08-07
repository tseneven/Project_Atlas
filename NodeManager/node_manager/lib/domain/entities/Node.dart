class Node {
  final String name;
  final String location;
  final String? UUID = null;
  final Setting? setting = null;
  ServerState state = ServerState.unknown;
  Node({required this.name, required this.location, required this.state});
}

class Setting{

}

enum ServerState{
  online,
  offline,
  unknown
}
