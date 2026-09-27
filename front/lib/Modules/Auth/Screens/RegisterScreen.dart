import "package:atlas/Components/FinLabel.dart";
import "package:atlas/Components/Footer.dart";
import "package:atlas/Components/Header.dart";
import "package:atlas/Components/Logo.dart";
import "package:atlas/Constants/ColorsApp.dart";
import "package:atlas/Modules/Auth/Model/AuthModel.dart";
import "package:atlas/Modules/Auth/Service/AuthService.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:google_fonts/google_fonts.dart";

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsApp.backgroundBlack,
      body: Column(children: [HeaderWidget(), MainWidget(), FooterWidget()]),
    );
  }
}

class MainWidget extends StatelessWidget {
  MainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 50,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 800;

              if (isMobile) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    LeftWidget(),
                    const SizedBox(height: 12),
                    RightWidget(),
                  ],
                );
              }

              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: constraints.maxWidth / 12,
                ),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 5,
                        child: LeftWidget(),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 7,
                        child: RightWidget(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class RightWidget extends StatefulWidget {
  RightWidget({super.key});

  @override
  State<RightWidget> createState() => _RightWidgetState();
}

class _RightWidgetState extends State<RightWidget> {
  final TextEditingController _fioController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _repeatPasswordController =
      TextEditingController();

  bool saveDevice = false;
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();

    _passwordController.addListener(() {
      setState(() {
        _passwordController.addListener(_onFormChanged);
        _repeatPasswordController.addListener(_onFormChanged);
        _emailController.addListener(_onFormChanged);
      });
    });
  }

  @override
  void dispose() {
    _fioController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();

    super.dispose();
  }

  void _onFormChanged() {
    setState(() {});
  }

  void register() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty)
      return;
    else {
      var result = await _authService.register(
        AuthModel(_emailController.text, _passwordController.text),
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

  bool get _passwordsMatch {
    return _passwordController.text == _repeatPasswordController.text;
  }

  bool get _passwordValid {
    final password = _passwordController.text;

    return password.length >= 8 &&
        RegExp(r"[A-ZА-ЯЁ]").hasMatch(password) &&
        RegExp(r"[a-zа-яё]").hasMatch(password) &&
        RegExp(r"[0-9]").hasMatch(password);
  }

  bool get _canRegister {
    return _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _repeatPasswordController.text.isNotEmpty &&
        _passwordsMatch &&
        _passwordValid &&
        saveDevice;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorsApp.mainGrey,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Создание аккаунта инвестора",
              style: GoogleFonts.inter(
                color: ColorsApp.textWhite,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "Введите персональные данные для доступа к портфельной аналитике",
              style: GoogleFonts.inter(
                color: ColorsApp.textWhite,
                fontSize: 14,
                fontWeight: FontWeight.w200,
              ),
            ),
            SizedBox(height: 16),
            FieldWidget(
              label: "Имя и фамилия",
              icon: Icons.person,
              hintText: "Иван Иванов",
              textEditingController: _fioController,
            ),
            SizedBox(height: 12),
            FieldWidget(
              label: "Рабочий или личный Email",
              icon: Icons.alternate_email,
              hintText: "investor@fund.ru",
              textEditingController: _emailController,
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FieldWidget(
                    label: "Пароль",
                    icon: Icons.lock,
                    hintText: "••••••••••••",
                    textEditingController: _passwordController,
                    isPassword: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FieldWidget(
                    label: "Повторите пароль",
                    icon: Icons.lock,
                    hintText: "••••••••••••",
                    textEditingController: _repeatPasswordController,
                    isPassword: true,
                  ),
                ),
              ],
            ),
            if (_repeatPasswordController.text.isNotEmpty && !_passwordsMatch)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 3),
                child: Text(
                  "Пароли не совпадают",
                  style: GoogleFonts.inter(
                    color: ColorsApp.textWhiteGrey,
                    fontSize: 10,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            const SizedBox(height: 12),
            PasswordStrengthWidget(text: _passwordController.text),
            const SizedBox(height: 12),
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
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.inter(
                        color: ColorsApp.textWhiteGrey,
                        fontSize: 11,
                        fontWeight: FontWeight.w300,
                      ),
                      children: [
                        const TextSpan(
                          text: "Я даю ",
                        ),
                        TextSpan(
                          text: "согласие на обработку персональных данных",
                          style: GoogleFonts.inter(
                            color: ColorsApp.textBlue,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {

                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ButtonLoginWidget(onTap: _canRegister ? register : null),
            SizedBox(height: 24),
            Divider(
              color: ColorsApp.textGrey.withValues(alpha: 0.5),
              thickness: 1,
              height: 1,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Уже есть аккаунт? ",
                  style: GoogleFonts.inter(
                    color: ColorsApp.textWhite,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.inter(
                      color: ColorsApp.textWhiteGrey,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        text: "Войти в систему",
                        style: GoogleFonts.inter(
                          color: ColorsApp.textBlue,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacementNamed(context, "auth");
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class LeftWidget extends StatelessWidget {
  const LeftWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorsApp.mainGrey,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              children: [
                Logo(width: 40, height: 40),
                SizedBox(width: 12),
                FinLabel(),
              ],
            ),
            SizedBox(height: 24),
            MainTextWidget(),
          ],
        ),
      ),
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
          "Ваши инвестиции. Под полным контролем.",
          style: GoogleFonts.inter(
            color: ColorsApp.textWhite,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 5),
        Text(
          "Анализируйте портфель, отслеживайте доходность и будущие выплаты в едином интерфейсе.",
          style: GoogleFonts.inter(
            color: ColorsApp.textWhite,
            fontSize: 14,
            fontWeight: FontWeight.w200,
          ),
        ),
        SizedBox(height: 28),
        AdvantageCardWidget(
          svgPath: "graf_one.svg",
          labelText: "Глубокая аналитика",
          descText:
              " - Понимайте, из чего формируется доходность портфеля и вклад каждого актива.",
        ),
        SizedBox(height: 16),
        AdvantageCardWidget(
          svgPath: "graf_tw.svg",
          labelText: "Динамика портфеля",
          descText:
              " - Следите за изменением стоимости инвестиций во времени и на ключевых бенчмарках.",
        ),
        SizedBox(height: 16),
        AdvantageCardWidget(
          svgPath: "money.svg",
          labelText: "Дивиденды и купоны",
          descText:
              " - Контролируйте фактические и ожидаемые выплаты по календарю отсечек.",
        ),
        SizedBox(height: 16),
        AdvantageCardWidget(
          svgPath: "circ.svg",
          labelText: "Структура и ребалансировка",
          descText:
              " -  Сравнивайте распределение активов с целевой стратегией",
        ),
        SizedBox(height: 24),
        Divider(
          color: ColorsApp.textGrey.withValues(alpha: 0.5),
          thickness: 1,
          height: 1,
        ),
        SizedBox(height: 12),
        AdvantageCardWidget(
          svgPath: "save_blue.svg",
          labelText: "",
          descText:
              "Доступ к брокерским счетам осуществляется исключительно в режиме read-only.",
          iconHeight: 18,
          iconWidth: 13,
        ),
      ],
    );
  }
}

class AdvantageCardWidget extends StatefulWidget {
  final String svgPath;
  final String labelText;
  final String descText;
  final double iconWidth;
  final double iconHeight;

  AdvantageCardWidget({
    super.key,
    required this.svgPath,
    required this.labelText,
    required this.descText,
    this.iconHeight = 32,
    this.iconWidth = 32,
  });

  @override
  State<AdvantageCardWidget> createState() => _AdvantageCardWidgetState();
}

class _AdvantageCardWidgetState extends State<AdvantageCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          widget.svgPath,
          width: widget.iconWidth,
          height: widget.iconHeight,
        ),
        const SizedBox(width: 12),

        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: widget.labelText,
                  style: GoogleFonts.inter(
                    color: ColorsApp.textWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: widget.descText,
                  style: GoogleFonts.inter(
                    color: ColorsApp.textWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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

class PasswordStrengthWidget extends StatelessWidget {
  const PasswordStrengthWidget({super.key, required this.text});

  final String text;

  int get _strength {
    int result = 0;

    if (text.length >= 8) result++;
    if (RegExp(r"[A-ZА-ЯЁ]").hasMatch(text)) result++;
    if (RegExp(r"[a-zа-яё]").hasMatch(text)) result++;
    if (RegExp(r"[0-9]").hasMatch(text)) result++;

    return result;
  }

  String get _strengthText {
    switch (_strength) {
      case 0:
        return "Введите пароль";
      case 1:
        return "Слабый пароль";
      case 2:
        return "Средний пароль";
      case 3:
        return "Хороший пароль";
      case 4:
        return "Надёжный пароль";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Надёжность пароля",
              style: GoogleFonts.jetBrainsMono(
                color: ColorsApp.textWhiteGrey,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              _strengthText,
              style: GoogleFonts.inter(
                color: ColorsApp.textWhiteGrey,
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),

        const SizedBox(height: 6),

        Row(
          children: List.generate(
            4,
            (index) => Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(right: index == 3 ? 0 : 4),
                decoration: BoxDecoration(
                  color: index < _strength
                      ? ColorsApp.textBlue
                      : ColorsApp.backgroundBlack,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 8),

        Wrap(
          spacing: 12,
          runSpacing: 4,
          children: [
            _Requirement(text: "8+ символов", valid: text.length >= 8),
            _Requirement(
              text: "Заглавная буква",
              valid: RegExp(r"[A-ZА-ЯЁ]").hasMatch(text),
            ),
            _Requirement(
              text: "Строчная буква",
              valid: RegExp(r"[a-zа-яё]").hasMatch(text),
            ),
            _Requirement(text: "Цифра", valid: RegExp(r"[0-9]").hasMatch(text)),
          ],
        ),
      ],
    );
  }
}

class _Requirement extends StatelessWidget {
  const _Requirement({required this.text, required this.valid});

  final String text;
  final bool valid;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          valid ? Icons.check : Icons.circle_outlined,
          size: 12,
          color: valid ? ColorsApp.textBlue : ColorsApp.hintGrey,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: GoogleFonts.inter(
            color: valid ? ColorsApp.textWhite : ColorsApp.hintGrey,
            fontSize: 10,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
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

  bool get isEnabled => widget.onTap != null;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: isEnabled
          ? (_) {
              setState(() {
                _isHovered = true;
              });
            }
          : null,
      onExit: isEnabled
          ? (_) {
              setState(() {
                _isHovered = false;
              });
            }
          : null,
      child: GestureDetector(
        onTap: isEnabled ? widget.onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: !isEnabled
                ? ColorsApp.textGrey
                : _isHovered
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
                  color: isEnabled
                      ? ColorsApp.textDarkBlue
                      : ColorsApp.hintGrey,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              SvgPicture.asset(
                "arrow_left.svg",
                colorFilter: isEnabled
                    ? null
                    : ColorFilter.mode(ColorsApp.hintGrey, BlendMode.srcIn),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
