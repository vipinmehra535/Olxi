import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:olxi/CustomWidget/CustomToast.dart';
import 'package:olxi/Screen/NavigationBarPage.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  TextEditingController emailController = TextEditingController();

  bool isLoading = false;
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFFFFFFF),
      body: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 30.h,
            ),
            TextField(
              controller: emailController,
              style: GoogleFonts.roboto(
                fontSize: 30.sp,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: "Enter Email",
                hintStyle: GoogleFonts.roboto(
                  fontSize: 30.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2.sp,
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 4.sp,
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 4.sp,
                    color: Colors.blueGrey.shade400,
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            isLoading
                ? AlertDialog(
                    content: Row(
                      children: [
                        const CircularProgressIndicator(),
                        Container(
                          margin: EdgeInsets.only(left: 20.w),
                          child: const Text("Loading..."),
                        ),
                      ],
                    ),
                  )
                : GestureDetector(
                    onTap: () async {
                      await signup();
                    },
                    child: Container(
                      height: 100.h,
                      width: 700.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[400],
                        border: Border.all(
                          width: 0,
                          color: Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4.r,
                            offset: Offset(2.w, 7.h),
                          )
                        ],
                      ),
                      child: Text(
                        "Reset Password",
                        style: GoogleFonts.roboto(
                          fontSize: 30.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Future signup() async {
    if (emailController.text.isEmpty) {
      toast(context, 'All fields required');
    } else {
      isLoading = true;
      setState(() {});
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim())
          .then((value) {
        isLoading = false;
        setState(() {});
        Navigator.of(context).pop();
        toast(context, "Link sended to your Mail");
      }).catchError((e) {
        isLoading = false;
        setState(() {});
        if (kDebugMode) {
          print(e);
        }
        toast(context, e.toString());
      });

      isLoading = false;
      setState(() {});
    }
  }
}
