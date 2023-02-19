import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

toast(BuildContext context, String text) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      width: double.infinity,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.r),
      ),
      backgroundColor: const Color.fromARGB(255, 47, 63, 71),
      content: SizedBox(
        height: 75.h,
        child: Center(
          child: Text(
            text,
            textScaleFactor: 1.sp,
            style: GoogleFonts.raleway(
              fontSize: 25,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            overflow: TextOverflow.visible,
          ),
        ),
      ),
    ),
  );
}
