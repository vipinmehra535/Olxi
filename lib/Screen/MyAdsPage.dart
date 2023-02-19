// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:olxi/Screen/ProductPage.dart';

class MyAdsPage extends StatefulWidget {
  const MyAdsPage({super.key});

  @override
  State<MyAdsPage> createState() => _MyAdsPageState();
}

class _MyAdsPageState extends State<MyAdsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 10.w, top: 20.h),
            child: Text(
              "My Ads",
              textScaleFactor: 1.sp,
              style: GoogleFonts.robotoFlex(
                fontSize: 40,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        SizedBox(height: 20.h),
        StreamBuilder(
          stream: _firestore.collection('data').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: .7,
                  crossAxisCount: 2,
                ),
                itemCount: snapshot.data?.docs.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: 5.w,
                      right: 5.w,
                      bottom: 20.h,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => ProductPage(
                              id: snapshot.data!.docs[index].get('id'),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black45, width: 2.w),
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        child: Center(
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  SizedBox(height: 20.h),
                                  Image.network(
                                      snapshot.data!.docs[index]
                                          .get('imageUrl')
                                          .toString(),
                                      fit: BoxFit.cover,
                                      height: 300.h),
                                  Text(
                                    snapshot.data!.docs[index]
                                        .get('name')
                                        .toString()
                                        .toUpperCase(),
                                    overflow: TextOverflow.ellipsis,
                                    textScaleFactor: 1.sp,
                                    style: GoogleFonts.robotoFlex(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 45,
                                    ),
                                  ),
                                  Text(
                                    "₹ ${snapshot.data!.docs[index].get('productprice').toString()}",
                                    textScaleFactor: 1.sp,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.robotoFlex(
                                      fontSize: 35,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
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
      ]),
    );
  }
}
