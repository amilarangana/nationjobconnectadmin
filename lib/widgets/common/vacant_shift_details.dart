import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nation_job_connect_admin/firebase/firestore_connect.dart';
import 'package:nation_job_connect_admin/nations/models/nation.dart';
import 'package:nation_job_connect_admin/resources/utils.dart';
import 'package:nation_job_connect_admin/shift_type/models/shift_type.dart';
import 'package:nation_job_connect_admin/vacant_shifts/models/vacant_shift.dart';
import 'package:nation_job_connect_admin/widgets/common/confirm_dialog.dart';

class VacantShiftDetails extends StatelessWidget {
  void Function()? onTap;
  Nation nation;
  VacantShift vacantShift;
  ShiftType? shiftType;
  final FirebaseConnect dbConnect;

  VacantShiftDetails({
    super.key,
    required this.nation,
    required this.onTap,
    required this.vacantShift,
    required this.shiftType,
    required this.dbConnect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Dismissible(
        key: Key(vacantShift.id),
        background: Container(),
        secondaryBackground: Container(
          color: Colors.red,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.centerRight,
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        confirmDismiss: (direction) async {
          bool dismiss = false;
          if (direction == DismissDirection.endToStart) {
            await showDialog(
                context: context,
                builder: (context) {
                  return ConfirmDialog(
                      "Confirm", "Are you sure you want to delete the item",
                      onConfirm: () {
                    dismiss = true;
                    dbConnect.deleteVacancy(vacantShift.id);
                  });
                });
          } else {
            dismiss = false;
          }
          return dismiss;
        },
        child: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shiftType?.type ?? "",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text("Date: ${Utils.getDate(vacantShift.time)}"),
                  Text(
                      "Hours: ${Utils.getTimeFromDate(vacantShift.time)} - ${Utils.getTimeFromDate(vacantShift.endTime)}"),
                  Text(
                    "${vacantShift.noOfVacancies} Shifts available",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${vacantShift.wage} Kr/Hour",
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(
                CupertinoIcons.chevron_right,
                size: 25,
              )
            ],
          ),
        ),
      ),
    );
  }
}
