import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:nation_job_connect_admin/base/base_screen.dart';
import 'package:nation_job_connect_admin/base/basic_fab_screen.dart';

class ComingSoonView extends BaseScreen {
  @override
  State<ComingSoonView> createState() => _ComingSoonViewState();
}

class _ComingSoonViewState extends BaseState<ComingSoonView>
    with BasicFABScreen {
  @override
  getExtra() {}

  @override
  Widget screenBody(BuildContext context) {
    //load the all vacancies of all the nations as stream
    return Center(
      child: Text(
        "Coming soon",
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  String screenName() {
    return "Profile";
  }
}

typedef OnSwipe = Future<void> Function(String text);
