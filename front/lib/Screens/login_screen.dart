import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Constants/ColorsApp.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(child: Container()),
          RightPart(),
        ],
      ),
    );
  }
}

class RightPart extends StatelessWidget {
  const RightPart({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: ColorsApp.BlueAccent,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "FinIntelliGence",
              style: GoogleFonts.ubuntu(fontSize: 66, color: Colors.white),
            ),
            Text(
              "Современный аналитик  ваших финансов",
              style: GoogleFonts.ubuntu(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.w100,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 100.0),
            AboutProjectButton(),
          ],
        ),
      ),
    );
  }
}

class AboutProjectButton extends StatefulWidget {
  const AboutProjectButton({super.key});

  @override
  State<AboutProjectButton> createState() => _AboutProjectButtonState();
}

class _AboutProjectButtonState extends State<AboutProjectButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: () {
          // действие
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 15,
          ),
          decoration: BoxDecoration(
            color: isHovered
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.transparent,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            'Узнать больше',
            style: GoogleFonts.ubuntu(
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}