import 'package:cloud_firestore/cloud_firestore.dart';
import '/shift_type/data_access/idata_access_shift_type.dart';
import '/shift_type/models/shift_type.dart';

class FirestoreShiftType extends iDataAccessShiftType{

  late FirebaseFirestore db;

  @override
  void dbConnect() {
    db = FirebaseFirestore.instance;
  }

  @override
  Future<ShiftType> readShiftType(String shiftId) async {
    var documentSnapshot = await db.collection("shift_types").doc(shiftId).get();
    return ShiftType.fromJson(documentSnapshot.id, documentSnapshot.data()!=null? documentSnapshot.data()!:{});
  }
  
  @override
  Future<List<ShiftType>> readShiftTypeList() async {
     var snapshot = await db.collection("shift_types").get();

     List<ShiftType> list = [];
     for (var element in snapshot.docs) { 
      list.add(ShiftType.fromJson(element.id, element.data()));
     }
     return list;
  }
}