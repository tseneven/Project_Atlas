import 'package:atlas/Constants/ColorsApp.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Logo extends StatelessWidget {
  final double? width;
  final double? height;

  const Logo({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 24,
      height: height ?? 24,
      decoration: BoxDecoration(
        color: ColorsApp.textBlue.withValues(alpha: 0.2),
        border: Border.all(color: ColorsApp.textBlue.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: ColorsApp.textBlue.withValues(alpha: 0.2),
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Text(
          "Fi",
          style: GoogleFonts.jetBrainsMono(
            fontSize: 12,
            color: ColorsApp.textBlue,
          ),
        ),
      ),
    );
  }
}
