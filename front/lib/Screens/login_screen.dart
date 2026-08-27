import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Constants/ColorsApp.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Row(children: [LeftPart(), RightPart()]));
  }
}

class LeftPart extends StatefulWidget {
  LeftPart({super.key});

  @override
  State<LeftPart> createState() => _LeftPartState();
}

class _LeftPartState extends State<LeftPart> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void login(){

  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Войти",
              style: GoogleFonts.ubuntu(
                fontSize: 66,
                color: ColorsApp.TextBlack,
              ),
            ),
            CustomField("Почта", _loginController),
            CustomField("Пароль", _passwordController),
            LoginScreenButton("Войти", ColorsApp.BlueAccent, false, 145.0, 20.0, login),
          ],
        ),
      ),
    );
  }
}

class CustomField extends StatefulWidget {
  final String label;
  final TextEditingController controller;

  const CustomField(this.label, this.controller, {super.key});

  @override
  State<CustomField> createState() => _CustomFieldState();
}

class _CustomFieldState extends State<CustomField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 120.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: ColorsApp.TextBlack),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextFormField(
            decoration: InputDecoration(
              hint: Text(widget.label),
              hintStyle: GoogleFonts.ubuntu(color: ColorsApp.TextBlack),
              border: InputBorder.none,
            ),
          ),
        ),
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
            LoginScreenButton("Узнать больше", Colors.transparent, true, 40.0, 15.0, null),
          ],
        ),
      ),
    );
  }
}

class LoginScreenButton extends StatefulWidget {
  final String text;
  final Color buttonColor;
  final bool hasBorder;
  final double horizonalPadding;
  final double verticalPadding;
  final VoidCallback? onTap;

  const LoginScreenButton(
    this.text,
    this.buttonColor,
    this.hasBorder, this.horizonalPadding, this.verticalPadding, this.onTap, {
    super.key,
  });

  @override
  State<LoginScreenButton> createState() => _LoginScreenButtonState();
}

class _LoginScreenButtonState extends State<LoginScreenButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: () {
          widget.onTap?.call();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.symmetric(horizontal: widget.horizonalPadding, vertical: widget.verticalPadding),
          decoration: BoxDecoration(
            color: isHovered
                ? widget.buttonColor.withValues(alpha: 0.7)
                : widget.buttonColor,
            border: widget.hasBorder ? Border.all(color: Colors.white) : null,
            borderRadius: BorderRadius.circular(10)
          ),
          child: Text(
            widget.text,
            style: GoogleFonts.ubuntu(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
