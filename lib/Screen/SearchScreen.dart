import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:olxi/Screen/ProductPage.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  QuerySnapshot? originalQSnap;
  List<QueryDocumentSnapshot<Object?>>? qSnap = [];
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.sp),
                child: TextField(
                  onChanged: (v) {
                    filterResult(v);
                  },
                  decoration: InputDecoration(
                    hintText: "Search here",
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
                        width: 2.sp,
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
              ),
              FutureBuilder(
                future: _firestore.collection('data').get(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    originalQSnap = snapshot.data!;

                    if (counter == 0) {
                      qSnap = originalQSnap!.docs;
                    }
                    counter = counter + 1;
                    if (kDebugMode) {
                      print('counter: $counter');
                    }

                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: .7,
                        crossAxisCount: 2,
                      ),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: qSnap?.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        // DocumentSnapshot? dSnap = qSnap?[index];

                        return GestureDetector(
                          onTap: () {
                            /* 
                                      {
                                        'name': ' new name',
                                        'email': 'jhggjh@jhggh.com',
                                        'phone': '8956235689',
                                        'gender': 'male',
                                      }
                                      */
                            // _firestore.collection('data').doc(dSnap.id).set({
                            //   'name': 'updatedName'
                            // }); // replace existing document with new map

                            // _firestore.collection('data').doc(dSnap?.id).set(
                            //   {
                            //     // 'gender': 'male',
                            //     'name': ' new name',
                            //   },
                            //   SetOptions(merge: true),
                            // ); // it will not replace existing document but only the field which is inside this map
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 5.w,
                              right: 5.w,
                              bottom: 20.h,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ProductPage(
                                    id: snapshot.data!.docs[index].get('id'),
                                  ),
                                ));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black45, width: 2.w),
                                  borderRadius: BorderRadius.circular(5.r),
                                ),
                                child: Center(
                                  child: Column(
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
                                      ),
                                      // Text(dSnap?['name'] ?? ""),
                                    ],
                                  ),
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
            ],
          ),
        ),
      ),
    );
  }

  filterResult(String searchText) {
    if (searchText.isNotEmpty) {
      qSnap = originalQSnap!.docs;
    } else {
      qSnap = [];
    }
    qSnap?.removeWhere((element) => !element['name']
        .toString()
        .toLowerCase()
        .contains(searchText.toLowerCase()));

    // print('qSnap.lenght1: ' + qSnap!.length.toString());
    // qSnap!.clear();

    // print('qSnap.lenght2: ' + qSnap!.length.toString());
    // for (int i = 0; i < originalQSnap!.docs.length; i++) {
    //   if (originalQSnap!.docs[i]['name']
    //       .toString()
    //       .toLowerCase()
    //       .contains(searchText.toLowerCase())) {
    //     qSnap!.add(originalQSnap!.docs[i]);
    //   }
    // }
    // print('qSnap.lenght3: ' + qSnap!.length.toString());

    setState(() {});
  }
}
