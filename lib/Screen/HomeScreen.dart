import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:olxi/CustomWidget/CustomToast.dart';
import 'package:olxi/Screen/NavigationBarPage.dart';
import 'package:olxi/Screen/ProductPage.dart';

class HomeSrceen extends StatefulWidget {
  const HomeSrceen({super.key});

  @override
  State<HomeSrceen> createState() => _HomeSrceenState();
}

class _HomeSrceenState extends State<HomeSrceen> {
  final _productNameController = TextEditingController();
  final _productPriceController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String email = FirebaseAuth.instance.currentUser!.email.toString();
  String imageurl = "";

  double? latitude;
  double? longitude;
  PlatformFile? pickedFile;

  UploadTask? uploadTask;
  List<Map<String, dynamic>> browsCategories = [
    {
      "name": "OLXI ATUOS(CARS)",
      "icon": Icons.car_rental,
    },
    {
      "name": "PROPERTIES",
      "icon": Icons.house_rounded,
    },
    {
      "name": "MOBILES",
      "icon": Icons.phone_iphone_rounded,
    },
    {
      "name": "JOBS",
      "icon": Icons.work,
    },
    {
      "name": "BIKES",
      "icon": Icons.bike_scooter_rounded,
    },
    {
      "name": "ELECTONICS &\n APPLIANCES",
      "icon": Icons.tv_rounded,
    },
    {
      "name": "     COMMERICAL\nVEHICLES & SPARES",
      "icon": Icons.spa,
    },
    {
      "name": "FURNITURE",
      "icon": Icons.chair_rounded,
    },
    {
      "name": "FASHION",
      "icon": Icons.car_crash,
    },
    {
      "name": "BOOKS,SPORTS &\n      HOBBIES",
      "icon": Icons.book_rounded,
    },
    {
      "name": "PETS",
      "icon": Icons.pets,
    },
    {
      "name": "SERVICES",
      "icon": Icons.design_services_rounded,
    },
  ];
  String? id;
  String name = 'OLXI';
  bool isError = false;

  @override
  void initState() {
    _getMaxId();
    _loadData();
    super.initState();
  }

  @override
  void dispose() {
    _productNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWitdh = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: isError
          ? const Text("somethhing went wrong")
          : id == null
              ? const CircularProgressIndicator()
              : FloatingActionButton(
                  onPressed: () {
                    _showTextInputDialog(context);
                  },
                  backgroundColor: const Color.fromARGB(255, 47, 63, 71),
                  child: const Icon(Icons.add),
                ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: const Color.fromARGB(179, 105, 104, 104),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, left: 10),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_rounded),
                        SizedBox(
                          width: 10.w,
                        ),
                        const Text(
                          "Sehatpur, Faridabad",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Icon(
                          Icons.arrow_drop_down,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                                    builder: (ctx) => const NavigationBarPage(
                                          initialIndex: 1,
                                        )));
                          },
                          behavior: HitTestBehavior.translucent,
                          child: Container(
                              height: 60.h,
                              width: screenWitdh - 80,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.search),
                                    SizedBox(width: 10.w),
                                    Center(
                                      child: Text(
                                        "Find Cars, Mobile Phones and mo...",
                                        textScaleFactor: 1.sp,
                                        style: const TextStyle(fontSize: 25),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        SizedBox(width: 20.w),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.notifications_sharp),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Browse categories",
                    textScaleFactor: 1.sp,
                    style: const TextStyle(
                        fontSize: 40, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "See all",
                    textScaleFactor: 1.sp,
                    style: const TextStyle(
                      shadows: [
                        Shadow(color: Colors.black, offset: Offset(0, -2))
                      ],
                      color: Colors.transparent,
                      fontWeight: FontWeight.w500,
                      fontSize: 40,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.black,
                      decorationThickness: 3,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            SizedBox(
              height: 220.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: browsCategories.length,
                itemBuilder: (cxt, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 30),
                    child: SizedBox(
                      child: Column(
                        children: [
                          Icon(
                            browsCategories[index]["icon"],
                            size: 100.sp,
                            color: const Color.fromARGB(255, 47, 63, 71),
                          ),
                          SizedBox(height: 15.h),
                          Text(
                            browsCategories[index]["name"],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Divider(
              color: Colors.black45,
              thickness: 8.sp,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 10.w, top: 20.h),
                child: Text(
                  "Fresh Recommendations",
                  textScaleFactor: 1.sp,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            FutureBuilder(
              future: _firestore.collection('data').get(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (!snapshot.hasData) {
                  return Padding(
                    padding: EdgeInsets.only(top: 150.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('Loading data..  '),
                        CircularProgressIndicator(),
                      ],
                    ),
                  );
                } else if (snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      "No data Found",
                      textScaleFactor: 1.sp,
                      style: GoogleFonts.robotoFlex(
                        fontWeight: FontWeight.w500,
                        fontSize: 45,
                      ),
                    ),
                  );
                } else {
                  return FutureBuilder(
                      future: _firestore.collection('data').get(),
                      // sortByLocation(snapshot.data!.docs),
                      builder: (context, AsyncSnapshot ss) {
                        if (!ss.hasData) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('Loading data..  '),
                              CircularProgressIndicator(),
                            ],
                          );
                        }
                        //  else if (!ss.hasData &&
                        //     ss.connectionState == ConnectionState.done) {
                        //   return const Text('Data could not be sorted');
                        // }
                        else {
                          var sortedList = ss.data!;
                          return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: .7,
                              crossAxisCount: 2,
                            ),
                            itemCount: snapshot.data!.docs.length,
                            // sortedList.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (ctx, index) {
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
                                          id: snapshot.data!.docs[index]
                                              .data()['id'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black45, width: 2.w),
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
                                              SizedBox(height: 10.h),
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
                                              SizedBox(height: 10.h),
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

                                          // StreamBuilder(
                                          //     stream: _firestore
                                          //         .collection('favorite')
                                          //         .doc(email)
                                          //         .collection('Favproduct')
                                          //         .snapshots(),
                                          //     builder: (context,
                                          //         AsyncSnapshot<QuerySnapshot> ss) {
                                          //       return IconButton(
                                          //         onPressed: () {
                                          //           if (snapshot
                                          //               .data!.docs[index].exists) {
                                          //             _firestore
                                          //                 .collection('favorite')
                                          //                 .doc(email)
                                          //                 .collection('Favproduct')
                                          //                 .doc(snapshot
                                          //                     .data!.docs[index].id)
                                          //                 .delete();
                                          //           } else {
                                          //             _firestore
                                          //                 .collection('favorite')
                                          //                 .doc(email)
                                          //                 .collection('Favproduct')
                                          //                 .doc(snapshot
                                          //                     .data!.docs[index].id)
                                          //                 .set({
                                          //               'name': snapshot
                                          //                   .data!.docs[index]
                                          //                   .get('name'),
                                          //               'id': snapshot
                                          //                   .data!.docs[index]
                                          //                   .get('id'),
                                          //             });
                                          //           }
                                          //           setState(() {});
                                          //         },
                                          //         icon: ss.hasData &&
                                          //                 ss.data!.docs[index].exists
                                          //             ? Icon(Icons.favorite)
                                          //             : Icon(Icons.favorite_border),
                                          //       );
                                          //     },),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  _loadData() {}

  Future selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      pickedFile = result.files.first;
    }
  }

  Future uploadFile() async {
    final path = 'files/${pickedFile?.name ?? ''}';
    final file = File(pickedFile?.path ?? '');
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask?.whenComplete(() => {});
    final urlDownload = await snapshot?.ref.getDownloadURL();
    imageurl = urlDownload ?? '';
    if (kDebugMode) {
      print("downloaded URL: $urlDownload");
    }

    uploadTask = null;
  }

  Future<String?> _showTextInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (ctx) {
        // bool isUploading = false;
        return StatefulBuilder(builder: (ctxt, setStat) {
          return SingleChildScrollView(
            child: AlertDialog(
              title: Text(
                'Add Product For Sale',
                textScaleFactor: 1.sp,
                style: GoogleFonts.roboto(color: Colors.black, fontSize: 40),
              ),
              content: SizedBox(
                height: 500.h,
                child: Column(
                  children: [
                    TextField(
                      controller: _productNameController,
                      style: GoogleFonts.roboto(
                        fontSize: 30.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                      cursorColor: Colors.black,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: "Product Name",
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
                    SizedBox(height: 20.h),
                    TextField(
                      controller: _productPriceController,
                      style: GoogleFonts.roboto(
                        fontSize: 30.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                      cursorColor: Colors.black,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: "Product Price",
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
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        if (pickedFile != null)
                          SizedBox(
                            width: 200.w,
                            child: Text(
                              pickedFile!.name,
                              textScaleFactor: 1.sp,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.roboto(
                                color: Colors.black,
                                fontSize: 25,
                              ),
                            ),
                          )
                        else
                          Text(
                            "No image selected ",
                            textScaleFactor: 1.sp,
                            style: GoogleFonts.roboto(
                                color: Colors.black, fontSize: 25),
                          ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 47, 63, 71),
                          ),
                          onPressed: () async {
                            await selectFile();
                            setStat(() {});
                          },
                          child: const Text("Select Image"),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    // isUploading ? uploadProgress() : Center()
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 47, 63, 71),
                  ),
                  child: const Text("Cancel"),
                  onPressed: () {
                    _productNameController.clear();
                    _productPriceController.clear();
                    pickedFile = null;
                    Navigator.pop(context);
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 47, 63, 71),
                  ),
                  child: const Text('OK'),
                  onPressed: () async {
                    if (_productNameController.text.isEmpty ||
                        _productPriceController.text.isEmpty ||
                        pickedFile == null) {
                      Navigator.pop(context);
                      toast(context, "Input Data to Upload");
                    } else {
                      await _determinePosition().then(
                        (position) {
                          if (kDebugMode) {
                            latitude = position.latitude;
                            longitude = position.longitude;

                            print("Geo Latitude: $latitude");
                            print("Geo Latitude: $longitude");
                          }
                        },
                      );
                      await uploadFile();

                      _firestore.collection('data').doc(id).set({
                        'name': _productNameController.text,
                        'productprice': _productPriceController.text,
                        'id': id,
                        'imageUrl': imageurl,
                        'latitude': latitude,
                        'longitude': longitude,
                      }).then((value) {
                        id = (int.parse(id!) + 1).toString();
                        _productNameController.clear();
                        _productPriceController.clear();
                        pickedFile = null;
                        Navigator.pop(context);
                      });
                    }
                  },
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Future<List<DocumentSnapshot<Map<String, dynamic>>>> sortByLocation(
      var list) async {
    var tempList = list;
    double? lat, lon;

    await _determinePosition().then(
      (value) {
        if (kDebugMode) {
          lat = value.latitude;
          lon = value.longitude;

          print("Geo Latitude: $lat");
          print("Geo Latitude: $lon");
        }
      },
    );

    if (tempList.length > 1) {
      for (var doc in tempList) {
        int index = tempList.indexOf(doc);

        double distanceFromIndex = calculateDistance(
            lat!, lon!, doc.data()['latitude'], doc.data()['longitude']);

        double distanceFromNextIndex = calculateDistance(
          lat!,
          lon!,
          tempList[index + 1].data()['latitude'],
          tempList[index + 1].data()['longitude'],
        );

        if (distanceFromIndex > distanceFromNextIndex) {
          tempList.insert(index + 1, list.removeAt(index));
        }
      }
    }
    return tempList;
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  _getMaxId() async {
    int max = 0;

    await _firestore.collection('data').get().then((snapshot) {
      snapshot.docs;

      for (int i = 0; i < snapshot.docs.length - 1; i++) {
        if (int.parse(snapshot.docs[i].get('id')) <
            int.parse(snapshot.docs[i + 1].get('id'))) {
          max = int.parse(snapshot.docs[i + 1].get('id'));
        }
      }
    }).catchError((e) {
      isError = true;
      setState(() {});
    });

    if (kDebugMode) {
      print('max id in firestore: $max');
    }
    id = '${max + 1}';
    setState(() {});
  }
}
