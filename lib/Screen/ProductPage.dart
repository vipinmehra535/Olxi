// ignore_for_file: file_names, no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductPage extends StatefulWidget {
  final String id;

  const ProductPage({super.key, required this.id});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int? pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(179, 105, 104, 104),
      ),
      bottomNavigationBar: Container(
        height: 160.h,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color.fromARGB(179, 105, 104, 104),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: 100.h,
              width: 200.h,
              decoration: const BoxDecoration(
                color: Color.fromARGB(179, 105, 104, 104),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Center(
                child: Text(
                  "Chat",
                  textScaleFactor: 1.sp,
                  style: GoogleFonts.roboto(
                    fontSize: 50,
                    color: const Color.fromARGB(255, 47, 63, 71),
                  ),
                ),
              ),
            ),
            Container(
              height: 100.h,
              width: 200.h,
              decoration: const BoxDecoration(
                color: Color.fromARGB(179, 105, 104, 104),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Center(
                child: Text(
                  "Call",
                  textScaleFactor: 1.sp,
                  style: GoogleFonts.roboto(
                    fontSize: 50,
                    color: const Color.fromARGB(255, 47, 63, 71),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: StreamBuilder(
            stream: _firestore.collection('data').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Column(
                  children: [
                    SizedBox(height: 20.h),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 3.w),
                        ),
                        child: Image.network(
                          snapshot.data!.docs
                              .firstWhere((element) {
                                return element.id == widget.id;
                              })
                              .get('imageUrl')
                              .toString(),
                          fit: BoxFit.cover,
                          height: 600.h,
                          width: 500.w,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Text(
                      snapshot.data!.docs
                          .firstWhere((element) {
                            return element.id == widget.id;
                          })
                          .get('name')
                          .toString()
                          .toUpperCase(),
                      textScaleFactor: 1.sp,
                      style: GoogleFonts.roboto(
                        fontSize: 90,
                        color: const Color.fromARGB(255, 47, 63, 71),
                      ),
                    ),
                    Text(
                      "₹ ${snapshot.data!.docs.firstWhere((element) {
                            return element.id == widget.id;
                          }).get('productprice').toString()}",
                      textScaleFactor: 1.sp,
                      style: GoogleFonts.roboto(
                        fontSize: 50,
                        color: const Color.fromARGB(255, 47, 63, 71),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 30.w, right: 30.w, top: 20.h),
                      child: Text(
                        "A product description is the marketing copy that explains what a product is and why it's worth purchasing. The purpose of a product description is to supply customers with important information about the features and benefits of the product so they're compelled to buy.",
                        textScaleFactor: 1.sp,
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.roboto(
                          fontSize: 30,
                          color: const Color.fromARGB(255, 47, 63, 71),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
