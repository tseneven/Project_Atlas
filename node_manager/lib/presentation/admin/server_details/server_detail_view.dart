import 'package:flutter/material.dart';
import 'package:node_manager/domain/entities/Node.dart';
import 'package:node_manager/presentation/admin/server_details/container_actions.dart';
import 'package:node_manager/presentation/admin/server_details/container_info_card.dart';
import 'package:node_manager/presentation/admin/server_details/info_cards.dart';
import 'package:node_manager/presentation/admin/server_details/section_title.dart';
import 'package:node_manager/presentation/admin/server_details/telemetry.dart';
import 'package:node_manager/presentation/widgets/database_icons.dart';

class ServerDetailView extends StatelessWidget {
  final Node server;

  const ServerDetailView({super.key, required this.server});

  Color _getStatusColor() {
    switch (server.state) {
      case ServerState.online:
        return Colors.green;
      case ServerState.offline:
        return Colors.red;
      case ServerState.unknown:
        return Colors.grey;
    }
  }

  String _getStatusText() {
    switch (server.state) {
      case ServerState.online:
        return "В сети";
      case ServerState.offline:
        return "Не в сети";
      case ServerState.unknown:
        return "Неизвестно";
    }
  }

  @override
  Widget build(BuildContext context) {
    final running = server.state != ServerState.offline;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ServerDetailHeader(
            server: server,
            statusColor: _getStatusColor(),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionTitle(title: "Общая информация"),
                  const SizedBox(height: 16),
                  InfoGrid(
                    children: [
                      InfoCard(
                        icon: Icons.fingerprint,
                        label: "UUID",
                        value: server.UUID ?? "Не назначен",
                        iconColor: Colors.purple,
                      ),
                      InfoCard(
                        icon: Icons.memory,
                        label: "Статус",
                        value: _getStatusText(),
                        iconColor: _getStatusColor(),
                      ),
                      InfoCard(
                        icon: Icons.location_city,
                        label: "Локация",
                        value: server.location,
                        iconColor: Colors.orange,
                      ),
                      InfoCard(
                        icon: databaseIcon(server.database),
                        label: "База данных",
                        value: server.database.label,
                        iconColor: databaseColor(server.database),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  const SectionTitle(title: "Информация о контейнере"),
                  const SizedBox(height: 16),
                  ContainerInfoCard(
                    containerId: "a1b2c3d4e5f6",
                    image: "atlas/${server.name.toLowerCase()}:latest",
                    ports: "8080 -> 80",
                    uptime: "3 дн 4 ч 12 мин",
                    database: server.database,
                    running: running,
                  ),
                  const SizedBox(height: 28),
                  const SectionTitle(title: "Телеметрия контейнера"),
                  const SizedBox(height: 16),
                  TelemetrySection(running: running),
                  const SizedBox(height: 28),
                  const SectionTitle(title: "Действия"),
                  const SizedBox(height: 16),
                  ContainerActions(nodeName: server.name, running: running),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServerDetailHeader extends StatelessWidget {
  final Node server;
  final Color statusColor;

  const _ServerDetailHeader({
    required this.server,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade600,
            Colors.blue.shade800,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.dns, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  server.name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: statusColor, width: 1.5),
                      ),
                      child: Text(
                        server.state.name.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            server.location,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
