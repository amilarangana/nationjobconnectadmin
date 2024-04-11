import 'package:flutter/material.dart';
import 'package:nation_job_connect_admin/widgets/common/accept_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../firebase/firestore_manage_application.dart';
import '../../firebase/firestore_applications.dart';
import '/firebase/firestore_user.dart';
import '../../resources/utils.dart';
import '../../user_profile/models/user.dart';
import '../models/application.dart';
import '../../resources/colors.dart';
import '../../widgets/common/no_data.dart';
import '../../widgets/common/waiting.dart';
import '/base/base_screen.dart';
import '/base/basic_screen.dart';

class ApplicationsScreen extends BaseScreen {
  static const routeName = '/applications';
  final String shiftId;
  ApplicationsScreen(this.shiftId, {super.key});

  @override
  State<ApplicationsScreen> createState() => _MyShiftScreenState();
}

class _MyShiftScreenState extends BaseState<ApplicationsScreen>
    with BasicScreen {
  final _dbConnectApplications = FirestoreApplications();
  final _dbConnectApplication = FirestoreManageApplication();
  final _dbConnectUser = FirestoreUser();

  @override
  void initState() {
    _dbConnectApplications.dbConnect();
    _dbConnectApplication.dbConnect();
    _dbConnectUser.dbConnect();
    super.initState();
  }

  @override
  getExtra() {}

  @override
  Widget screenBody(BuildContext context) {
    //Load the device id....
    return FutureBuilder(
        future: Utils.getDeviceId(),
        builder:
            (BuildContext context, AsyncSnapshot<dynamic> snapshotDeviceId) {
          var deviceId = snapshotDeviceId.data;
          if (deviceId != null) {
            //Load the user id....
            return FutureBuilder(
                future: _dbConnectUser.readUser(deviceId),
                builder: (BuildContext context,
                    AsyncSnapshot<dynamic> snapshotUser) {
                  User? user = snapshotUser.data;
                  if (user != null && user.id != null) {
                    //load all user applied vacancies...
                    return StreamBuilder<List<Application>>(
                        stream: _dbConnectApplications
                            .getApplications(widget.shiftId),
                        builder: (context, snapshotMyShifts) {
                          if (snapshotMyShifts.connectionState ==
                              ConnectionState.active) {
                            var myShiftsList = snapshotMyShifts.data;
                            if (myShiftsList != null &&
                                myShiftsList.isNotEmpty) {
                              //Show list view of the applied shifts...
                              return ListView.builder(
                                  itemCount: myShiftsList.length,
                                  //Load the nation details using nation's id...
                                  itemBuilder: (ctx, i) => GestureDetector(
                                        child: Container(
                                          margin: const EdgeInsets.all(10),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Color(
                                                myShiftsList[i].status == 0
                                                    ? ResColors.colorYellow
                                                    : (myShiftsList[i].status ==
                                                            1
                                                        ? ResColors.colorGreen
                                                        : ResColors.colorRed)),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(15)),
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Name: ",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 140,
                                                    child: Text(
                                                      myShiftsList[i].name,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                myShiftsList[i].deviceId,
                                              ),
                                              Text(
                                                  "Status: ${myShiftsList[i].status == 0 ? "Pending" : (myShiftsList[i].status == 1 ? "Approved" : "Rejected")}"),
                                              InkWell(
                                                  child: const Text(
                                                    "FB Profile:",
                                                    style: TextStyle(
                                                        color: Colors.blue),
                                                  ),
                                                  onTap: () {
                                                    if (myShiftsList[i]
                                                        .fbProfile
                                                        .contains(
                                                            "https://www.")) {
                                                      launchUrl(Uri.parse(
                                                          myShiftsList[i]
                                                              .fbProfile));
                                                    } else {
                                                      launchUrl(Uri.parse(
                                                          "https://www.${myShiftsList[i].fbProfile}"));
                                                    }
                                                  })
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AcceptAlertDialog(
                                                  'Info',
                                                  'What do you want to perform with this application',
                                                  onAccept: () {
                                                    _dbConnectApplications
                                                        .acceptApplication(
                                                            widget.shiftId,
                                                            myShiftsList[i].id!,
                                                            myShiftsList[i]
                                                                .applicantId);
                                                  },
                                                  onReject: () {
                                                    _dbConnectApplications
                                                        .rejectApplication(
                                                            widget.shiftId,
                                                            myShiftsList[i].id!,
                                                            myShiftsList[i]
                                                                .applicantId);
                                                  },
                                                );
                                              });
                                        },
                                      ));
                            } else {
                              return const NoData("No My shifts available");
                            }
                          } else if (snapshotMyShifts.connectionState ==
                              ConnectionState.waiting) {
                            return const Waiting();
                          } else {
                            return const NoData("No My shifts available");
                          }
                        });
                  } else {
                    return const NoData('No My shifts available');
                  }
                });
          } else {
            return const NoData('No My shifts available');
          }
        });
  }

  @override
  String screenName() {
    return "Appliacations";
  }
}
