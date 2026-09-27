import 'package:atlas/Constants/ColorsApp.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FinLabel extends StatelessWidget {
  const FinLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "Fin",
            style: GoogleFonts.inter(
              color: ColorsApp.textWhite,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: "Intelligence",
            style: GoogleFonts.inter(
              color: ColorsApp.textBlue,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}