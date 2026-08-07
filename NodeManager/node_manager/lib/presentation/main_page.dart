import 'package:flutter/material.dart';

import '../domain/entities/Node.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  ClientState state = ClientState.admin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 204, 204, 204),
      body: Column(children: [ControlMenu(), AdminPanel()]),
    );
  }
}

class ControlMenu extends StatefulWidget {
  const ControlMenu({super.key});

  @override
  State<ControlMenu> createState() => _ControlMenuState();
}

class _ControlMenuState extends State<ControlMenu> {
  int selectedIndex = 0;

  final buttons = [Icons.admin_panel_settings, Icons.person, Icons.settings];

  final titles = ["Админ-панель", "Клиент", "Настройки"];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery
          .of(context)
          .size
          .width / 3,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final buttonWidth = constraints.maxWidth / buttons.length;
          final indicatorWidth = buttonWidth * 0.65;

          return SizedBox(
            height: 45,
            child: Stack(
              children: [
                Row(
                  children: List.generate(buttons.length, (index) {
                    return SizedBox(
                      width: buttonWidth,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              buttons[index],
                              size: 20,
                              color: selectedIndex == index
                                  ? Colors.blue
                                  : Colors.grey,
                            ),

                            Text(
                              titles[index],
                              style: TextStyle(
                                fontSize: 12,
                                color: selectedIndex == index
                                    ? Colors.blue
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),

                AnimatedPositioned(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.fastOutSlowIn,

                  bottom: 0,

                  left:
                  selectedIndex * buttonWidth +
                      (buttonWidth - indicatorWidth) / 2,

                  child: Container(
                    width: indicatorWidth,
                    height: 3,

                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withValues(alpha: 0.35),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class AdminPanel extends StatelessWidget {
  final List<Node> nodeList = [
    Node(name: "Server-1", location: "Ru", state: ServerState.unknown),
    Node(name: "Server-2", location: "Ru", state: ServerState.online),
    Node(name: "Server-3", location: "Ru", state: ServerState.online),
    Node(name: "Server-4", location: "Ru", state: ServerState.offline),
  ];

  AdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: nodeList.length,
                      itemBuilder: (context, index) {
                        final node = nodeList[index];

                        Color? colorStatus = null;

                        switch (node.state) {
                          case ServerState.online:
                            colorStatus = Colors.green;
                            break;
                          case ServerState.offline:
                            colorStatus = Colors.red;
                            break;
                          case ServerState.unknown:
                            colorStatus = Colors.grey;
                            break;
                          default:
                            colorStatus = Colors.grey;
                            break;
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),

                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.dns,
                                      color: Colors.blue,
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          node.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),

                                        const SizedBox(height: 4),

                                        Text(
                                          node.location,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: colorStatus,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum ClientState { admin, client, setting }
