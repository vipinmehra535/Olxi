// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:olxi/CustomWidget/CustomToast.dart';
import 'package:olxi/Screen/ResetPasswordPage.dart';
import 'package:olxi/Screen/SignUpScreen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                style: GoogleFonts.roboto(
                  fontSize: 30.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                cursorColor: Colors.black,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: "Email",
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
              TextField(
                controller: passwordController,
                style: GoogleFonts.roboto(
                  fontSize: 30.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                cursorColor: Colors.black,
                obscureText: obscureText,
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Icon(
                        obscureText
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 40.sp,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                  hintText: "Password",
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
                      backgroundColor: Colors.blueGrey[400],
                      content: Row(
                        children: [
                          CircularProgressIndicator(
                            color: Colors.white,
                          ),
                          Container(
                            color: Colors.blueGrey[400],
                            margin: EdgeInsets.only(left: 20.w),
                            child: Text(
                              "Loading...",
                              style: GoogleFonts.roboto(
                                fontSize: 40.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : GestureDetector(
                      onTap: () async {
                        await login();
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
                          "Login",
                          style: GoogleFonts.roboto(
                            fontSize: 40.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => ResetPasswordPage()),
                  );
                },
                child: Text(
                  "Reset Password!",
                  style: GoogleFonts.roboto(
                    fontSize: 30.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have account?",
                    style: GoogleFonts.roboto(
                      fontSize: 30.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => SignUpPage()),
                      );
                    },
                    child: Text(
                      "SignUp",
                      style: GoogleFonts.roboto(
                        fontSize: 30.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      toast(context, 'All fields required');
    } else {
      isLoading = true;
      setState(() {});
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      )
          .then((value) {
        isLoading = false;
        setState(() {});
        FirebaseFirestore.instance
            .collection("users")
            .doc(emailController.text.trim())
            .set({
          'lastLogin': DateTime.now(),
          //DateFormat('yyyy/MM/dd, hh:mm:ss').format(DateTime.now())
        });
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
