import 'package:atlas/Components/FinLabel.dart';
import 'package:atlas/Components/Logo.dart';
import 'package:atlas/Constants/ColorsApp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../Model/AuthModel.dart';
import '../Service/AuthService.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  String version = 'error';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();

    if (!mounted) return;

    setState(() {
      version = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsApp.backgroundBlack,
      body: Column(
        children: [
          HeaderWidget(version: version),
          MainWidget(),
          FooterWidget(version: version),
        ],
      ),
    );
  }
}

class MainWidget extends StatelessWidget {
  const MainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 50,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 24,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 800;

              if (isMobile) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const LeftCenterWidget(),
                    const SizedBox(height: 40),
                    RightCenterWidget(),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    flex: 7,
                    child: LeftCenterWidget(),
                  ),
                  const SizedBox(width: 40),
                  Expanded(
                    flex: 5,
                    child: RightCenterWidget(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
class RightCenterWidget extends StatefulWidget {
  RightCenterWidget({super.key});

  @override
  State<RightCenterWidget> createState() => _RightCenterWidgetState();
}

class _RightCenterWidgetState extends State<RightCenterWidget> {
  bool saveDevice = false;
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _loginService = AuthService();
  Logger logger = Logger();

  void login() async {
    if (_loginController.text.isEmpty || _passwordController.text.isEmpty)
      return;
    else {
      var result = await _loginService.login(
        AuthModel(_loginController.text, _passwordController.text),
        saveDevice,
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: ColorsApp.mainGrey),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 33),
            Row(
              children: [
                Logo(height: 32, width: 32),
                SizedBox(width: 10),
                FinLabel(),
              ],
            ),
            SizedBox(height: 12),
            Text(
              "Вход в инвестиционный\nтерминал",
              style: GoogleFonts.inter(
                color: ColorsApp.textWhite,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "Введите ваши данные для доступа к портфельной аналитике",
              style: GoogleFonts.inter(
                color: ColorsApp.textWhiteGrey,
                fontSize: 12,
                fontWeight: FontWeight.w200,
                height: 1.4,
              ),
            ),
            SizedBox(height: 24),
            FieldWidget(
              label: "Email / Инвестиционный логин",
              icon: Icons.alternate_email,
              hintText: "investor@example.com",
              textEditingController: _loginController,
            ),
            SizedBox(height: 16),
            FieldWidget(
              label: "Пароль",
              icon: Icons.key,
              hintText: "••••••••••••",
              textEditingController: _passwordController,
              isPassword: true,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: saveDevice,
                  onChanged: (value) {
                    setState(() {
                      saveDevice = value ?? false;
                    });
                  },
                  fillColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return ColorsApp.textWhiteGrey;
                    }
                    return ColorsApp.backgroundBlack;
                  }),
                  checkColor: ColorsApp.backgroundBlack,
                  side: BorderSide(color: ColorsApp.textGrey, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                  visualDensity: VisualDensity.compact,
                ),
                Text(
                  'Запомнить устройство',
                  style: GoogleFonts.inter(
                    color: ColorsApp.textWhiteGrey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ButtonLoginWidget(onTap: login),
            SizedBox(height: 24),
            Divider(
              color: ColorsApp.textGrey.withValues(alpha: 0.5),
              thickness: 1,
              height: 1,
            ),
            SizedBox(height: 16),
            Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Нет аккаунта? ",
                      style: GoogleFonts.inter(
                        color: ColorsApp.textWhite,
                        fontSize: 12,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    TextSpan(
                      text: "Зарегистрироваться",
                      style: GoogleFonts.inter(
                        color: ColorsApp.textBlue,
                        fontSize: 12,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class ButtonLoginWidget extends StatefulWidget {
  const ButtonLoginWidget({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  State<ButtonLoginWidget> createState() => _ButtonLoginWidgetState();
}

class _ButtonLoginWidgetState extends State<ButtonLoginWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
      },
      child: GestureDetector(
        onTap: () {
          widget.onTap?.call();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: _isHovered
                ? ColorsApp.accentBlue.withValues(alpha: 0.8)
                : ColorsApp.accentBlue,
            borderRadius: BorderRadius.circular(2),
          ),
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Войти в систему",
                style: GoogleFonts.inter(
                  color: ColorsApp.textDarkBlue,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              SvgPicture.asset("arrow_left.svg"),
            ],
          ),
        ),
      ),
    );
  }
}

class FieldWidget extends StatefulWidget {
  final String label;
  final IconData icon;
  final String hintText;
  final bool isPassword;

  final TextEditingController textEditingController;

  const FieldWidget({
    super.key,
    required this.label,
    required this.icon,
    required this.hintText,
    required this.textEditingController,
    this.isPassword = false,
  });

  @override
  State<FieldWidget> createState() => _FieldWidgetState();
}

class _FieldWidgetState extends State<FieldWidget> {
  bool _obscureText = true;
  bool _isFocused = false;

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3.0),
          child: Text(
            widget.label,
            style: GoogleFonts.jetBrainsMono(
              color: ColorsApp.textWhiteGrey,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: ColorsApp.backgroundBlack,
            border: Border.all(
              color: _isFocused
                  ? ColorsApp.textBlue
                  : ColorsApp.textGrey.withValues(alpha: 0.5),
            ),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(widget.icon, color: ColorsApp.hintGrey, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  focusNode: _focusNode,
                  controller: widget.textEditingController,
                  style: GoogleFonts.inter(
                    color: ColorsApp.hintGrey,
                    fontSize: 14,
                    fontWeight: FontWeight.w200,
                  ),
                  obscureText: widget.isPassword && _obscureText,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: GoogleFonts.inter(
                      color: ColorsApp.hintGrey,
                      fontSize: 14,
                      fontWeight: FontWeight.w200,
                    ),
                    border: InputBorder.none,
                    isCollapsed: true,
                  ),
                ),
              ),

              if (widget.isPassword)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  child: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: ColorsApp.hintGrey,
                    size: 20,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class LeftCenterWidget extends StatelessWidget {
  const LeftCenterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MainTextWidget(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdvantageCardWidget(
                svgPath: "graf_one.svg",
                labelText: "Глубокая аналитика",
                descText:
                    "Понимайте, из чего формируется доходность портфеля и вклад каждого ыактива.",
              ),
              SizedBox(height: 16),
              AdvantageCardWidget(
                svgPath: "graf_tw.svg",
                labelText: "Динамика портфеля",
                descText:
                    "Следите за изменением стоимости инвестиций во времени и на ключевых бенчмарках.",
              ),
              SizedBox(height: 16),
              AdvantageCardWidget(
                svgPath: "money.svg",
                labelText: "Дивиденды и купоны",
                descText:
                    "Контролируйте фактические и ожидаемые выплаты по календарю отсечек.",
              ),
              SizedBox(height: 16),
              AdvantageCardWidget(
                svgPath: "circ.svg",
                labelText: "Структура и ребалансировка",
                descText:
                    "Сравнивайте распределение активов с целевой стратегией (например, 60 /30 / 10).",
              ),
              SizedBox(height: 17),
            ],
          ),
        ),
      ],
    );
  }
}

class AdvantageCardWidget extends StatelessWidget {
  final String svgPath;
  final String labelText;
  final String descText;

  const AdvantageCardWidget({
    super.key,
    required this.svgPath,
    required this.labelText,
    required this.descText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(svgPath, width: 32, height: 32),
        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                labelText,
                style: GoogleFonts.inter(
                  color: ColorsApp.textWhite,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                descText,
                softWrap: true,
                style: GoogleFonts.inter(
                  color: ColorsApp.textWhiteGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w200,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MainTextWidget extends StatelessWidget {
  const MainTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "FININTELLIGENCE TERMINAL",
          style: GoogleFonts.jetBrainsMono(
            color: ColorsApp.textBlue,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 5),
        Text(
          "Ваши инвестиции. \nПод полным контролем.",
          style: GoogleFonts.inter(
            color: ColorsApp.textWhite,
            fontSize: 36,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 5),
        Text(
          "Анализируйте портфель, отслеживайте доходность и будущие\nвыплаты в едином интерфейсе.",
          style: GoogleFonts.inter(
            color: ColorsApp.textWhite,
            fontSize: 16,
            fontWeight: FontWeight.w200,
          ),
        ),
      ],
    );
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key, required this.version});

  final String version;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: ColorsApp.borderGrey)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            children: [
              Logo(),
              SizedBox(width: 20),
              FinLabel(),
              SizedBox(width: 20),
              Text(
                "/",
                style: GoogleFonts.inter(
                  color: ColorsApp.textGrey,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(width: 10),
              Text(
                "SECURE GATEWAY CORE V${version}",
                style: GoogleFonts.jetBrainsMono(
                  color: ColorsApp.textWhiteGrey,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FooterWidget extends StatelessWidget {
  const FooterWidget({
    super.key,
    required this.version,
  });

  final String version;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: ColorsApp.borderGrey,
            ),
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 800;

            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 24,
                vertical: isMobile ? 0 : 0,
              ),
              child: isMobile
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "FinIntelligence Terminal v$version • Secure Gateway Core",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: ColorsApp.textWhiteGrey,
                      fontSize: 11,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildLinks(),
                ],
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      "FinIntelligence Terminal v$version • Secure Gateway Core",
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: ColorsApp.textWhiteGrey,
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  _buildLinks(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLinks() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Безопасность",
          style: GoogleFonts.inter(
            color: ColorsApp.textWhiteGrey,
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(width: 15),
        Text(
          "Конфиденциальность",
          style: GoogleFonts.inter(
            color: ColorsApp.textWhiteGrey,
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}