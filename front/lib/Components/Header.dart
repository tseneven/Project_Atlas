import 'package:atlas/Components/FinLabel.dart';
import 'package:atlas/Components/Logo.dart';
import 'package:atlas/Constants/ColorsApp.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({super.key});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
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
