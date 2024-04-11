import 'package:flutter/material.dart';
import 'package:nation_job_connect_admin/widgets/common/coming_soon_view.dart';
import '/vacant_shifts/screens/vacant_shifts_screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../resources/colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late List<Widget> _widgetOptions;

  @override
  void initState() {
    _widgetOptions = <Widget>[
      VacantShiftScreen(),
      // VacantShiftScreen(),
      // VacantShiftScreen(),
      ComingSoonView(),
      // VacantShiftScreen(),
    ];
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final mainScreenTitles = ["Shifts", "Profile"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(ResColors.colorPrimaryDark),
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: _selectedIndex,
          onTap: (i) => _onItemTapped(i),
          items: [
            /// Home
            SalomonBottomBarItem(
                icon: const SizedBox(
                    width: 40,
                    child: Icon(Icons.work,
                        color: Color(ResColors.colorFontSplash))),
                title:
                    const Text("Shifts", style: TextStyle(color: Colors.white)),
                selectedColor: Theme.of(context).primaryColor,
                unselectedColor: Theme.of(context).primaryColor),

            // SalomonBottomBarItem(
            //     icon: const SizedBox(
            //         width: 40,
            //         child: Icon(Icons.my_library_add,
            //             color: Color(ResColors.colorFontSplash))),
            //     title: const Text("History",
            //         style: TextStyle(color: Colors.white)),
            //     selectedColor: Theme.of(context).primaryColorDark,
            //     unselectedColor: Theme.of(context).primaryColor),

            // /// Profile
            // SalomonBottomBarItem(
            //     icon: const SizedBox(
            //         width: 40,
            //         child: Icon(Icons.history,
            //             color: Color(ResColors.colorFontSplash))),
            //     title: const Text("History",
            //         style: TextStyle(color: Colors.white)),
            //     selectedColor: Theme.of(context).primaryColorDark,
            //     unselectedColor: Theme.of(context).primaryColor),

            /// Profile
            SalomonBottomBarItem(
                icon: const SizedBox(
                    width: 40,
                    child: Icon(Icons.face,
                        color: Color(ResColors.colorFontSplash))),
                title: const Text("Profile",
                    style: TextStyle(color: Colors.white)),
                selectedColor: Theme.of(context).primaryColorDark,
                unselectedColor: Theme.of(context).primaryColor),
          ],
        ));
  }
}
