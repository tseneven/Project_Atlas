import 'package:flutter/material.dart';

class ContainerActions extends StatelessWidget {
  final String nodeName;
  final bool running;

  const ContainerActions({
    super.key,
    required this.nodeName,
    required this.running,
  });

  Future<void> _confirm(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    required Color color,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Отмена"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(confirmLabel),
            ),
          ],
        );
      },
    );

    if (confirmed == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$confirmLabel: контейнер «$nodeName» (мок)"),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttons = [
      _ActionButton(
        icon: running ? Icons.stop_circle_outlined : Icons.play_circle_outline,
        label: running ? "Остановить" : "Запустить",
        color: running ? Colors.orange : Colors.green,
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "${running ? "Остановка" : "Запуск"}: контейнер «$nodeName» (мок)",
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
      _ActionButton(
        icon: Icons.restart_alt,
        label: "Перезапустить",
        color: Colors.blue,
        onPressed: () {
          _confirm(
            context,
            title: "Перезапуск контейнера",
            message: "Перезапустить контейнер «$nodeName»?",
            confirmLabel: "Перезапустить",
            color: Colors.blue,
          );
        },
      ),
      _ActionButton(
        icon: Icons.refresh,
        label: "Пересоздать",
        color: Colors.purple,
        onPressed: () {
          _confirm(
            context,
            title: "Пересоздание контейнера",
            message: "Контейнер «$nodeName» будет удалён и создан заново.\n"
                "Изменения внутри файловой системы контейнера будут потеряны. Продолжить?",
            confirmLabel: "Пересоздать",
            color: Colors.purple,
          );
        },
      ),
      _ActionButton(
        icon: Icons.delete_forever_outlined,
        label: "Удалить",
        color: Colors.red,
        isDestructive: true,
        onPressed: () {
          _confirm(
            context,
            title: "Удаление контейнера",
            message: "Удалить контейнер «$nodeName»?\n"
                "Это действие необратимо. Контейнер будет остановлен и удалён вместе с данными.",
            confirmLabel: "Удалить",
            color: Colors.red,
          );
        },
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 700
            ? 4
            : (constraints.maxWidth > 400 ? 2 : 1);
        const spacing = 12.0;
        final itemWidth =
            (constraints.maxWidth - spacing * (crossAxisCount - 1)) /
            crossAxisCount;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final button in buttons)
              SizedBox(width: itemWidth, child: button),
          ],
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;
  final bool isDestructive;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            color: isDestructive
                ? Colors.red.shade50
                : color.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDestructive
                  ? Colors.red.shade200
                  : color.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: isDestructive ? Colors.red : color),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDestructive ? Colors.red : color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
