// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:olxi/CustomWidget/CustomToast.dart';
import 'package:olxi/Screen/NavigationBarPage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController nameController = TextEditingController();

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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 200.h, left: 40.w, right: 40.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: nameController,
                style: GoogleFonts.roboto(
                  fontSize: 30.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintText: "Enter Name",
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
                      content: Row(
                        children: [
                          CircularProgressIndicator(),
                          Container(
                            margin: EdgeInsets.only(left: 20.w),
                            child: Text("Loading..."),
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
                        width: 400.h,
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
                          "SignUp",
                          style: GoogleFonts.roboto(
                            fontSize: 40.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future signup() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        nameController.text.isEmpty) {
      toast(context, 'All fields required');
    } else {
      isLoading = true;
      setState(() {});
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
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
          'lastLogin': DateTime
              .now(), //DateFormat('yyyy/MM/dd, hh:mm:ss').format(DateTime.now())
        });
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return NavigationBarPage();
          },
        ));
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
