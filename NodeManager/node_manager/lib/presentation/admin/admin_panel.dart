import 'package:flutter/material.dart';
import 'package:node_manager/domain/entities/Node.dart';
import 'package:node_manager/presentation/admin/server_details/empty_state_view.dart';
import 'package:node_manager/presentation/admin/server_details/server_detail_view.dart';
import 'package:node_manager/presentation/admin/server_list_tile.dart';

class AdminPanel extends StatelessWidget {
  final List<Node> nodeList;
  final Node? currentServer;
  final ValueChanged<Node> onServerSelected;

  const AdminPanel({
    super.key,
    required this.currentServer,
    required this.onServerSelected,
    required this.nodeList,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: nodeList.length,
                  itemBuilder: (context, index) {
                    final node = nodeList[index];
                    return ServerListTile(
                      node: node,
                      isSelected: currentServer == node,
                      onTap: () => onServerSelected(node),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 6,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: currentServer != null
                ? ServerDetailView(server: currentServer!)
                : const EmptyStateView(),
          ),
        ),
      ],
    );
  }
}
