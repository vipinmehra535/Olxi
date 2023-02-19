import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:olxi/Screen/FavPage.dart';
import 'package:olxi/Screen/HomeScreen.dart';
import 'package:olxi/Screen/Profile.dart';
import 'package:olxi/Screen/SearchScreen.dart';

class NavigationBarPage extends StatefulWidget {
  final int initialIndex;
  const NavigationBarPage({super.key, this.initialIndex = 0});

  @override
  State<NavigationBarPage> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  int pageIndex = 0;

  final pages = [
    const HomeSrceen(),
    const SearchScreen(),
    const FavPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    pageIndex = widget.initialIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(179, 105, 104, 104),
      ),
      // drawer: SafeArea(
      //   child: Drawer(
      //     child: ListView(
      //       children: [
      //         DrawerHeader(
      //           decoration: BoxDecoration(
      //             color: Color.fromARGB(179, 105, 104, 104),
      //           ),
      //           child:
      //               Text(FirebaseAuth.instance.currentUser!.email.toString()),
      //         ),
      //         ListTile(
      //           title: Text('SignOut'),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      body: pages[pageIndex],
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
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 0;
                });
              },
              icon: pageIndex == 0
                  ? const Icon(
                      Icons.home_filled,
                      color: Colors.white,
                      size: 35,
                    )
                  : const Icon(
                      Icons.home_outlined,
                      color: Colors.black,
                      size: 35,
                    ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 1;
                });
              },
              icon: pageIndex == 1
                  ? const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 35,
                    )
                  : const Icon(
                      Icons.search,
                      color: Colors.black,
                      size: 35,
                    ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 2;
                });
              },
              icon: pageIndex == 2
                  ? const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 35,
                    )
                  : const Icon(
                      Icons.favorite_border_outlined,
                      color: Colors.black,
                      size: 35,
                    ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 3;
                });
              },
              icon: pageIndex == 3
                  ? const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 35,
                    )
                  : const Icon(
                      Icons.person_outlined,
                      color: Colors.black,
                      size: 35,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
