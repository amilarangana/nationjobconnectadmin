import 'package:flutter/material.dart';
import 'package:nation_job_connect_admin/applications/screens/applications_screen.dart';
import 'package:nation_job_connect_admin/widgets/common/confirm_dialog.dart';
import 'package:nation_job_connect_admin/widgets/common/pick_a_date.dart';
import 'package:nation_job_connect_admin/widgets/common/pick_a_time.dart';
import 'package:nation_job_connect_admin/widgets/common/vacant_shift_details.dart';
import '../../base/basic_fab_screen.dart';
import '../../firebase/firestore_manage_application.dart';
import '../../resources/dimensions.dart';
import '../../resources/utils.dart';
import '/firebase/firestore_nation.dart';
import '/firebase/firestore_shift_type.dart';
import '/firebase/firestore_user.dart';
import '/nations/models/nation.dart';
import '/shift_type/models/shift_type.dart';
import '../../resources/colors.dart';
import '../../widgets/common/no_data.dart';
import '../../widgets/common/waiting.dart';
import '/base/base_screen.dart';
import '/firebase/firestore_connect.dart';

import '../models/vacant_shift.dart';

class VacantShiftScreen extends BaseScreen {
  @override
  State<VacantShiftScreen> createState() => _VacantShiftScreenState();
}

class _VacantShiftScreenState extends BaseState<VacantShiftScreen>
    with BasicFABScreen {
  final _dbConnect = FirebaseConnect();
  final _dbConnectNation = FirestoreNation();
  final _dbConnectApplication = FirestoreManageApplication();
  final _dbConnectUser = FirestoreUser();
  final _dbConnectShiftType = FirestoreShiftType();

  final _controllerNoOfVacanciesText = TextEditingController();
  final _controllerWageText = TextEditingController();

  late DateTime date;
  late TimeOfDay time;
  late DateTime endDate;
  late TimeOfDay endTime;
  ShiftType? selectedShiftType;

  @override
  void initState() {
    _dbConnect.dbConnect();
    _dbConnectNation.dbConnect();
    _dbConnectApplication.dbConnect();
    _dbConnectUser.dbConnect();
    _dbConnectShiftType.dbConnect();
    super.initState();
  }

  @override
  getExtra() {}

  @override
  Widget fab() {
    return FloatingActionButton(
        backgroundColor: const Color(ResColors.colorPrimaryDark),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return Container(
                height: 400,
                padding: const EdgeInsets.all(10),
                color: const Color(ResColors.colorPrimary),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text('Publish a Shift'),
                    FutureBuilder(
                      future: _dbConnectShiftType.readShiftTypeList(),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: Utils.getTextViewDecoration(),
                            child: DropdownButtonFormField<ShiftType>(
                              value: selectedShiftType,
                              style: const TextStyle(
                                  color: Color(ResColors.colorFontSplash),
                                  fontSize: ResDimensions.fontSizeDataEntry),
                              dropdownColor:
                                  const Color(ResColors.colorPrimary),
                              iconEnabledColor:
                                  const Color(ResColors.colorFontSplash),
                              items: getItemsList(snapshot.data),
                              onChanged: (value) {
                                // setState(() {
                                selectedShiftType = value;
                                // });
                              },
                              hint: const Text(
                                "Select Shift",
                                style: TextStyle(
                                    color: Color(ResColors.colorFontSplash),
                                    fontSize: ResDimensions.fontSizeDataEntry),
                              ),
                            ),
                          );
                        } else {
                          return const Text("No Data");
                        }
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2 - 10,
                          child: TextFormField(
                            controller: _controllerNoOfVacanciesText,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Shift type can not be empty";
                              }
                              return null;
                            },
                            style: const TextStyle(
                                color: Color(ResColors.colorFontSplash),
                                fontSize: ResDimensions.fontSizeDataEntry),
                            decoration: Utils.getInputDecoration(
                                "No of Vacancies", null),
                            cursorColor: const Color(ResColors.colorFontSplash),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2 - 10,
                          child: TextFormField(
                            controller: _controllerWageText,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Wage can not be empty";
                              }
                              return null;
                            },
                            style: const TextStyle(
                                color: Color(ResColors.colorFontSplash),
                                fontSize: ResDimensions.fontSizeDataEntry),
                            decoration: Utils.getInputDecoration("Wage", null),
                            cursorColor: const Color(ResColors.colorFontSplash),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width / 2 - 10,
                            child: PickADate("Start Date",
                                initialDate: DateTime.now(),
                                onDatePicked: (selectedDate) {
                              date = selectedDate;
                            })),
                        SizedBox(
                            width: MediaQuery.of(context).size.width / 2 - 10,
                            child: PickATime("Start Time",
                                initialTime: TimeOfDay.now(),
                                onTimePicked: (selectedTime) {
                              time = selectedTime;
                            })),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width / 2 - 10,
                            child: PickADate("End Date",
                                initialDate: DateTime.now(),
                                onDatePicked: (selectedDate) {
                              endDate = selectedDate;
                            })),
                        SizedBox(
                            width: MediaQuery.of(context).size.width / 2 - 10,
                            child: PickATime("End Time",
                                initialTime: TimeOfDay.now(),
                                onTimePicked: (selectedTime) {
                              endTime = selectedTime;
                            })),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          child: const Text('Cancel'),
                          onPressed: () => Navigator.pop(context),
                        ),
                        ElevatedButton(
                          child: const Text('Publish'),
                          onPressed: () {
                            var dateTime = DateTime(date.year, date.month,
                                date.day, time.hour, time.minute);
                            var endDateTime = DateTime(
                                endDate.year,
                                endDate.month,
                                endDate.day,
                                endTime.hour,
                                endTime.minute);
                            _dbConnect.publishVacancy(VacantShift(
                              "",
                              nation: "uplands",
                              noOfVacancies: int.parse(
                                  _controllerNoOfVacanciesText.text.trim()),
                              shiftType: selectedShiftType!.id,
                              time: dateTime,
                              endTime: endDateTime,
                              wage:
                                  double.parse(_controllerWageText.text.trim()),
                              status: 1,
                            ));
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  List<DropdownMenuItem<ShiftType>> getItemsList(List<ShiftType> shiftList) {
    List<DropdownMenuItem<ShiftType>> dropDownMenuItemList = [];
    for (var value in shiftList) {
      dropDownMenuItemList.add(DropdownMenuItem(
          key: UniqueKey(),
          value: value,
          child: Container(
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width / 4 * 3,
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: Utils.getContainerDecoration(),
              child: Text(value.type))));
    }

    return dropDownMenuItemList;
  }

  @override
  Widget screenBody(BuildContext context) {
    //load the all vacancies of all the nations as stream
    return StreamBuilder<List<VacantShift>>(
        stream: _dbConnect.getVacancies(),
        builder: (context, snapshotVacantShifts) {
          if (snapshotVacantShifts.connectionState == ConnectionState.active) {
            var vacantShiftsList = snapshotVacantShifts.data;
            if (vacantShiftsList != null && vacantShiftsList.isNotEmpty) {
              //Show list view of the vacant shifts...
              return ListView.builder(
                  itemCount: vacantShiftsList.length,
                  //Load the nation details using nation's id...
                  itemBuilder: (ctx, i) => FutureBuilder(
                        future: _dbConnectNation
                            .readNationsList(vacantShiftsList[i].nation),
                        builder: (BuildContext context,
                            AsyncSnapshot<Nation> snapshot) {
                          var nation = snapshot.data;
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            //Load the shift types list.......
                            return FutureBuilder(
                              future: _dbConnectShiftType
                                  .readShiftType(vacantShiftsList[i].shiftType),
                              builder: (BuildContext context,
                                  AsyncSnapshot<ShiftType> snapshotShiftType) {
                                if (snapshotShiftType.connectionState ==
                                    ConnectionState.done) {
                                  var shiftType = snapshotShiftType.data;

                                  return VacantShiftDetails(
                                      nation: nation!,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ApplicationsScreen(
                                                      vacantShiftsList[i].id)),
                                        );
                                      },
                                      vacantShift: vacantShiftsList[i],
                                      shiftType: shiftType,
                                      dbConnect: _dbConnect);

                                  // GestureDetector(
                                  //   child: Dismissible(
                                  //     key: Key(vacantShiftsList[i].id),
                                  //     background: Container(),
                                  //     secondaryBackground: Container(
                                  //       color: Colors.red,
                                  //       padding: const EdgeInsets.symmetric(
                                  //           horizontal: 20),
                                  //       alignment: Alignment.centerRight,
                                  //       child: const Icon(
                                  //         Icons.delete,
                                  //         color: Colors.white,
                                  //       ),
                                  //     ),
                                  //     confirmDismiss: (direction) async {
                                  //       bool dismiss = false;
                                  //       if (direction ==
                                  //           DismissDirection.endToStart) {
                                  //         await showDialog(
                                  //             context: context,
                                  //             builder: (context) {
                                  //               return ConfirmDialog("Confirm",
                                  //                   "Are you sure you want to delete the item",
                                  //                   onConfirm: () {
                                  //                 dismiss = true;
                                  //                 _dbConnect.deleteVacancy(
                                  //                     vacantShiftsList[i].id);
                                  //               });
                                  //             });
                                  //       } else {
                                  //         dismiss = false;
                                  //       }
                                  //       return dismiss;
                                  //     },
                                  //     child: Container(
                                  //       width: double.infinity,
                                  //       margin: const EdgeInsets.all(10),
                                  //       padding: const EdgeInsets.all(5),
                                  //       decoration: const BoxDecoration(
                                  //         color:
                                  //             Color(ResColors.colorFontSplash),
                                  //         borderRadius: BorderRadius.all(
                                  //             Radius.circular(5)),
                                  //       ),
                                  //       child: Column(
                                  //         children: [
                                  //           // Text(nation!.name),
                                  //           Text(
                                  //               "No of Vacancies: ${vacantShiftsList[i].noOfVacancies}"),
                                  //           Text(
                                  //               "Shift Type: ${shiftType!.type}"),
                                  //           Text(
                                  //               "Time: ${vacantShiftsList[i].time}"),
                                  //           Text(
                                  //               "End time: ${vacantShiftsList[i].endTime}"),
                                  //           Text(
                                  //               "Wage: ${vacantShiftsList[i].wage}"),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ),
                                  //   onTap: () {
                                  //     Navigator.push(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //           builder: (context) =>
                                  //               ApplicationsScreen(
                                  //                   vacantShiftsList[i].id)),
                                  //     );
                                  //   },
                                  // );
                                } else {
                                  return const NoData(
                                      "No vacant shifts available");
                                }
                              },
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Waiting();
                          } else {
                            return const NoData("No vacant shifts available");
                          }
                        },
                      ));
            } else {
              return const NoData("No vacant shifts available");
            }
          } else if (snapshotVacantShifts.connectionState ==
              ConnectionState.waiting) {
            return const Waiting();
          } else {
            return const NoData("No vacant shifts available");
          }
        });
  }

  @override
  String screenName() {
    return "All Shifts";
  }
}

typedef OnSwipe = Future<void> Function(String text);
