// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class FavPage extends StatefulWidget {
  const FavPage({super.key});

  @override
  State<FavPage> createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String email = FirebaseAuth.instance.currentUser!.email.toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12.sp),
          child: StreamBuilder(
            stream: _firestore
                .collection('favorite')
                .doc(email)
                .collection('Favproduct')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Padding(
                  padding: EdgeInsets.only(top: 500.h),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (snapshot.data!.docs.isEmpty) {
                return Padding(
                  padding: EdgeInsets.only(top: 500.h),
                  child: Center(
                    child: Text(
                      "No data Found",
                      textScaleFactor: 1.sp,
                      style: GoogleFonts.robotoFlex(
                        fontWeight: FontWeight.w500,
                        fontSize: 45,
                      ),
                    ),
                  ),
                );
              } else {
                QuerySnapshot qSnap = snapshot.data!;

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: .8,
                    crossAxisCount: 2,
                  ),
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: qSnap.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot dSnap = qSnap.docs[index];
                    return GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 5.w,
                          right: 5.w,
                          bottom: 20.h,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.black45, width: 2.w),
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                Image.asset("assets/images/logo.jpg"),
                                Text(dSnap.get('name').toString()),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
