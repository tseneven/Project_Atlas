import 'package:atlas/Constants/ColorsApp.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderWidget(),
          Expanded(
            child: Row(
              children: [
                MenuWidget(),
                Expanded(child: Container(color: Colors.redAccent), flex: 3),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MenuWidget extends StatelessWidget {
  const MenuWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                scrollbars: false,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    MenuButtonWidget(
                      "assets/house_icon.png",
                      "Главная",
                    ),
                    MenuButtonWidget(
                      "assets/portfel_icon.png",
                      "Портфель",
                    ),
                    MenuButtonWidget(
                      "assets/svin_icon.png",
                      "Ваша кубышка",
                    ),
                    MenuButtonWidget(
                      "assets/credit_icon.png",
                      "Кредиты",
                    ),
                    MenuButtonWidget(
                      "assets/money_icon.png",
                      "Расходы",
                    ),
                    MenuButtonWidget(
                      "assets/moscow_icon.png",
                      "Мосбиржа",
                    ),
                    MenuButtonWidget(
                      "assets/nalogi_icon.png",
                      "Ваши налоги",
                    ),
                    MenuButtonWidget(
                      "assets/settings_icon.png",
                      "Настройки",
                    ),
                  ],
                ),
              ),
            ),
          ),
          decoration: BoxDecoration(
            color: ColorsApp.milkWhite,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: ColorsApp.BlueAccent,
                blurRadius: 4,
                offset: Offset(0, 4),
              ),
            ],
          ),
        ),
      ),
      flex: 1,
    );
  }
}

class MenuButtonWidget extends StatelessWidget {
  final String iconPath;
  final String text;

  MenuButtonWidget(this.iconPath, this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        child: Row(
          children: [
            SizedBox(width: 27),
            Image.asset(iconPath),
            SizedBox(width: 5),
            Text(
              text,
              style: GoogleFonts.ubuntu(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(color: ColorsApp.BlueAccent),
      child: Row(
        children: [LabelWidget(), const SizedBox(width: 20), UserWidget()],
      ),
    );
  }
}

class LabelWidget extends StatelessWidget {
  const LabelWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FittedBox(
        alignment: Alignment.centerLeft,
        fit: BoxFit.scaleDown,
        child: Text(
          "FinIntelligence",
          style: GoogleFonts.ubuntu(
            fontSize: 50,
            color: Colors.white,
            decoration: TextDecoration.underline,
            decorationColor: Colors.white,
            decorationThickness: 1,
          ),
        ),
      ),
    );
  }
}

class UserWidget extends StatelessWidget {
  const UserWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 200),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "Александр",
              style: GoogleFonts.ubuntu(
                fontSize: 38,
                color: Colors.white,
                fontWeight: FontWeight.w100,
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        const CircleAvatar(radius: 25),
        const SizedBox(width: 20),
      ],
    );
  }
}
