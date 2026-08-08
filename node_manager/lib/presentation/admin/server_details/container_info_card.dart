import 'package:flutter/material.dart';
import 'package:node_manager/domain/entities/Node.dart';
import 'package:node_manager/presentation/widgets/database_icons.dart';

class ContainerInfoCard extends StatelessWidget {
  final String containerId;
  final String image;
  final String ports;
  final String uptime;
  final DatabaseType database;
  final bool running;

  const ContainerInfoCard({
    super.key,
    required this.containerId,
    required this.image,
    required this.ports,
    required this.uptime,
    required this.database,
    required this.running,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.indigo.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.inventory_2,
                  color: Colors.indigo,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Контейнер ${containerId.substring(0, 8)}",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      running ? "Работает" : "Остановлен",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: running ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: (running ? Colors.green : Colors.red).withValues(
                    alpha: 0.12,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: running ? Colors.green : Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      running ? "RUNNING" : "STOPPED",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: running ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _ContainerInfoRow(
            icon: databaseIcon(database),
            label: "База данных",
            value: database.label,
          ),
          const SizedBox(height: 10),
          _ContainerInfoRow(icon: Icons.image, label: "Образ", value: image),
          const SizedBox(height: 10),
          _ContainerInfoRow(
            icon: Icons.alt_route,
            label: "Порты",
            value: ports,
          ),
          const SizedBox(height: 10),
          _ContainerInfoRow(
            icon: Icons.timer,
            label: "Время работы",
            value: uptime,
          ),
          const SizedBox(height: 10),
          _ContainerInfoRow(
            icon: Icons.tag,
            label: "ID контейнера",
            value: containerId,
            mono: true,
          ),
        ],
      ),
    );
  }
}

class _ContainerInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool mono;

  const _ContainerInfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.mono = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade500),
        const SizedBox(width: 10),
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
              fontFamily: mono ? 'monospace' : null,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
