import 'package:flutter/material.dart';
import '/resources/colors.dart';
import './base_screen.dart';
// import 'package:match_maker/widgets/app_bar/app_bar_drawer_button.dart';
// import 'package:provider/provider.dart';

mixin BasicFABScreen<Screen extends BaseScreen> on BaseState<Screen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  Widget screenBody(BuildContext context);

  Widget fab() => Container();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            key: _key,
            // appBar: HomeAppBar(screenName(), _key),
            appBar: AppBar(
              backgroundColor: const Color(ResColors.colorPrimaryDark),
              leading: const Text(""),
              title: Text(screenName(), style: const TextStyle(color: Colors.white),),
             
            ),
            resizeToAvoidBottomInset: false,
            floatingActionButton: fab(),
            
            body: Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.symmetric(vertical: 5),
              color: const Color(ResColors.colorPrimary),
              child: screenBody(context),
            ),
          );
        }
  }

