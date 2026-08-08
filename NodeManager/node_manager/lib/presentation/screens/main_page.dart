import 'package:flutter/material.dart';
import 'package:node_manager/domain/entities/Node.dart';
import 'package:node_manager/presentation/admin/admin_panel.dart';
import 'package:node_manager/presentation/widgets/add_node_dialog.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  ClientState state = ClientState.admin;
  Node? currentServer;
  final List<Node> nodeList = [
    Node(
      name: "Server-1",
      location: "Ru",
      state: ServerState.unknown,
      database: DatabaseType.postgres,
    ),
    Node(
      name: "Server-2",
      location: "Ru",
      state: ServerState.online,
      database: DatabaseType.mysql,
    ),
    Node(
      name: "Server-3",
      location: "Ru",
      state: ServerState.online,
      database: DatabaseType.mongodb,
    ),
    Node(
      name: "Server-4",
      location: "Ru",
      state: ServerState.offline,
      database: DatabaseType.sqlite,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 204, 204, 204),
      body: AdminPanel(
        nodeList: nodeList,
        currentServer: currentServer,
        onServerSelected: (node) {
          setState(() {
            currentServer = node;
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final Node? node = await showDialog<Node>(
            context: context,
            builder: (context) {
              return const AddNodeDialog();
            },
          );
          if (node != null) {
            setState(() {
              nodeList.add(node);
            });
          }
        },
      ),
    );
  }
}

enum ClientState { admin, client, setting }
