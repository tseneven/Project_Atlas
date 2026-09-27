import 'package:atlas/Constants/ColorsApp.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';

class FooterWidget extends StatefulWidget {
  const FooterWidget({super.key});



  @override
  State<FooterWidget> createState() => _FooterWidgetState();
}

class _FooterWidgetState extends State<FooterWidget> {
  String version = "error";

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
    return Expanded(
      flex: 4,
      child: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: ColorsApp.borderGrey)),
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
                    "FinIntelligence Terminal v${version} • 2026 • Secure Gateway Core",
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
                      "FinIntelligence Terminal v${version} • 2026 • Secure Gateway Core",
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
