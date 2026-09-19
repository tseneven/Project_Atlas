import 'package:atlas/Modules/Auth/Model/AuthModel.dart';
import 'package:atlas/Modules/Auth/Service/AuthService.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import '../../../Constants/ColorsApp.dart';

class AuthScreen extends StatelessWidget {
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
  final AuthService _loginService = AuthService();
  Logger logger = Logger();
  LoginState _loginState = LoginState.Login;

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void login() async {
    if (_loginController.text.isEmpty || _passwordController.text.isEmpty)
      return;
    else {
      var result = await _loginService.login(
        AuthModel(_loginController.text, _passwordController.text),
      );
      if (result.Success) {
        Navigator.pushReplacementNamed(context, "main");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.Error ?? "Ошибка. Напиши в поддержку")),
        );
      }
    }
  }

  void register() async {
    if (_loginController.text.isEmpty || _passwordController.text.isEmpty)
      return;
    else {
      var result = await _loginService.register(
        AuthModel(_loginController.text, _passwordController.text),
      );
      if (result.Success) {
        Navigator.pushReplacementNamed(context, "main");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.Error ?? "Ошибка. Напиши в поддержку")),
        );
      }
    }
  }

  void changeState() {
    setState(() {
      if (_loginState == LoginState.Login)
        _loginState = LoginState.Register;
      else
        _loginState = LoginState.Login;
    });
  }

  bool stateIsLogin() => _loginState == LoginState.Login;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              stateIsLogin() ? "Войти" : "Регистрация",
              style: GoogleFonts.ubuntu(
                fontSize: 66,
                color: ColorsApp.TextBlack,
              ),
            ),
            CustomField("Почта", _loginController),
            CustomField("Пароль", _passwordController),
            LoginScreenButton(
              stateIsLogin() ? "Войти" : "Зарегистрироваться",
              ColorsApp.BlueAccent,
              false,
              145.0,
              20.0,
              stateIsLogin() ? login : register,
            ),
            SizedBox(height: 30),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: !stateIsLogin()
                        ? "Уже есть аккаунт? "
                        : "Ещё нет аккаунта? ",
                    style: GoogleFonts.ubuntu(fontSize: 16),
                  ),
                  TextSpan(
                    text: !stateIsLogin()
                        ? "Авторизируйся!"
                        : "Зарегистрируйся!",
                    style: GoogleFonts.ubuntu(color: Colors.blue, fontSize: 16),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        changeState();
                      },
                  ),
                ],
              ),
            ),
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
            controller: widget.controller,
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
              "Современный аналитик\nваших финансов",
              style: GoogleFonts.ubuntu(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.w100,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 100.0),
            LoginScreenButton(
              "Узнать больше",
              Colors.transparent,
              true,
              40.0,
              15.0,
              null,
            ),
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
    this.hasBorder,
    this.horizonalPadding,
    this.verticalPadding,
    this.onTap, {
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
          padding: EdgeInsets.symmetric(
            horizontal: widget.horizonalPadding,
            vertical: widget.verticalPadding,
          ),
          decoration: BoxDecoration(
            color: isHovered
                ? widget.buttonColor.withValues(alpha: 0.7)
                : widget.buttonColor,
            border: widget.hasBorder ? Border.all(color: Colors.white) : null,
            borderRadius: BorderRadius.circular(10),
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

enum LoginState { Login, Register }
