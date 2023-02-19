import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:olxi/CustomWidget/CustomToast.dart';
import 'package:olxi/NavigationPage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  PlatformFile? pickedFile;
  String imageurl = "";
  UploadTask? uploadTask;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  getImage() {
    var doc = _firestore
        .collection('users')
        .doc(_auth.currentUser!.email)
        .snapshots();

    return doc;
  }

  List<Map<String, dynamic>> profileList = [
    {
      "title": "Change Password",
      "icon": Icons.password,
    },
    {
      "title": "Delete Account",
      "icon": Icons.edit_attributes,
    },
    {
      "title": "Logout Account",
      "icon": Icons.logout_outlined,
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10.sp),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 50.h,
                ),
                Stack(
                  children: [
                    StreamBuilder(
                        stream: getImage(),
                        builder: (context,
                            AsyncSnapshot<
                                    DocumentSnapshot<Map<String, dynamic>>>
                                snapshot) {
                          return Center(
                            child: snapshot.hasData &&
                                    snapshot.data!.data()!['imageUrl'] != null
                                ? CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    maxRadius: 150.r,
                                    minRadius: 100.r,
                                    backgroundImage: NetworkImage(
                                        snapshot.data!.data()!['imageUrl']))
                                : CircleAvatar(
                                    maxRadius: 150.r,
                                    minRadius: 100.r,
                                    backgroundColor: Colors.grey,
                                    backgroundImage: const AssetImage(
                                      "assets/images/defaultuserimage.jpg",
                                    ),
                                  ),
                          );
                        }),
                    Positioned(
                      right: 50,
                      top: 0,
                      bottom: -100,
                      child: IconButton(
                        onPressed: () {
                          _showImageEdit(context);
                        },
                        icon: Icon(
                          Icons.edit,
                          color: Colors.black,
                          size: 60.sp,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 30.h,
                ),
                Text(
                  _auth.currentUser!.email.toString(),
                  textScaleFactor: 1.sp,
                  style: GoogleFonts.radley(
                    color: Colors.black,
                    fontSize: 45,
                  ),
                ),
                SizedBox(height: 50.h),
                SizedBox(
                  height: 400.h,
                  width: 1000.w,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: profileList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (index == 0) {
                                _showChangePassword(context);
                              } else if (index == 1) {
                                _auth.currentUser!.delete().then((value) {
                                  Navigator.popUntil(
                                      context, (route) => route.isFirst);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (ctx) {
                                      return const NavigationPage();
                                    }),
                                  );
                                }).catchError((e) {
                                  if (kDebugMode) {
                                    print('user delete error: $e');
                                  }
                                });
                              } else if (index == 2) {
                                _auth.signOut().then((value) {
                                  Navigator.popUntil(
                                      context, (route) => route.isFirst);
                                  Navigator.pushReplacement(
                                    // ab password change krna h phn dekh
                                    context,
                                    MaterialPageRoute(builder: (ctx) {
                                      return const NavigationPage();
                                    }),
                                  );
                                }).catchError((e) {
                                  if (kDebugMode) {
                                    print('user signout error: $e');
                                  }
                                });
                              }
                            },
                            child: Container(
                              height: 100.h,
                              width: 700.w,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(profileList[index]["title"]),
                                  Icon(
                                    profileList[index]["icon"],
                                    color: Colors.black,
                                    size: 100.sp,
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _changePassword(String currentPassword, String newPassword) async {
    final user = FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(
        email: user!.email.toString(), password: currentPassword);

    user.reauthenticateWithCredential(cred).then((value) async {
      await user.updatePassword(newPassword).then((value) {
        Navigator.pop(context);
        toast(context, "Password Changed");
        _newPasswordController.clear();
        _currentPasswordController.clear();
      }).catchError((error) {
        if (kDebugMode) {
          print('error1: $error');
        }
      });
    }).catchError((error) {
      if (kDebugMode) {
        print('error2: $error');
      }
    });
  }

  Future<String?> _showChangePassword(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctxt, setStat) {
          return AlertDialog(
            title: Text(
              'Change Password',
              textScaleFactor: 1.sp,
              style: GoogleFonts.roboto(color: Colors.black, fontSize: 40),
            ),
            content: SizedBox(
              height: 300.h,
              child: Column(
                children: [
                  TextField(
                    controller: _currentPasswordController,
                    style: GoogleFonts.roboto(
                      fontSize: 22.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    cursorColor: Colors.black,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: "Current Password",
                      hintStyle: GoogleFonts.roboto(
                        fontSize: 22.sp,
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
                    controller: _newPasswordController,
                    style: GoogleFonts.roboto(
                      fontSize: 22.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    cursorColor: Colors.black,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: "New Password",
                      hintStyle: GoogleFonts.roboto(
                        fontSize: 22.sp,
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
                  _newPasswordController.clear();
                  _currentPasswordController.clear();
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 47, 63, 71),
                ),
                child: const Text('Confirm Change'),
                onPressed: () async {
                  if (_newPasswordController.text.isEmpty ||
                      _currentPasswordController.text.isEmpty) {
                    toast(context, "Input Data to Upload");
                  } else {
                    await _changePassword(
                      _currentPasswordController.text,
                      _newPasswordController.text,
                    );
                  }
                },
              ),
            ],
          );
        });
      },
    );
  }

  Future<String?> _showImageEdit(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctxt, setStat) {
          return AlertDialog(
            title: Text(
              'Add Profile Image',
              textScaleFactor: 1.sp,
              style: GoogleFonts.roboto(color: Colors.black, fontSize: 40),
            ),
            content: SizedBox(
              height: 200.h,
              child: Column(
                children: [
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
                  if (pickedFile == null) {
                    Navigator.pop(context);
                    toast(context, "Invalid to Upload");
                  } else {
                    await uploadFile();
                    _firestore
                        .collection('users')
                        .doc(_auth.currentUser!.email)
                        .set({
                      'imageUrl': imageurl,
                    }, SetOptions(merge: true)).then((value) {
                      Navigator.pop(context);
                      toast(context, "Profile Image is Updated");
                      pickedFile = null;
                    });
                  } ////dekh phn dekhb  logout kiya ab dekh login krna
                  //lohin hoga but srceen pr homepage nhi ayygea dekh
                },
              ),
            ],
          );
        });
      },
    );
  }

  Future selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      pickedFile = result.files.first;
    }
  }

  Future uploadFile() async {
    final path =
        '${_auth.currentUser!.email}/profile.${pickedFile?.extension ?? 'jpeg'}';
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
}
