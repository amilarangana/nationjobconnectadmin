import 'package:cloud_firestore/cloud_firestore.dart';
import '/vacant_shifts/data_access/idata_access.dart';
import '/vacant_shifts/models/vacant_shift.dart';

class FirebaseConnect implements iDataAccess{

  late FirebaseFirestore db;

  @override
  void dbConnect() {
    db = FirebaseFirestore.instance;
  }

  @override
  Stream<List<VacantShift>> getVacancies(String nationId) {
    return db.collection("vacant_shifts")
    .where("nation", isEqualTo: nationId)
    .withConverter<VacantShift>(
      fromFirestore: (snapshot, options){
        return VacantShift.fromJson(snapshot.id, snapshot.data()!);
    }, 
      toFirestore: (value, options){
        return value.toJson();
    })
    .snapshots()
    .map((query) => query.docs.map((snapshot) => snapshot.data()).toList());
  
  }
  
  @override
  Future<void> publishVacancy(VacantShift vacantShift) {
    return db
        .collection('vacant_shifts')
        .doc()
        .set(vacantShift.toJson()); 
  }
  
  @override
  Future<void> deleteVacancy(String vacantShiftId) {
    db.collection('vacant_shifts')
        .doc(vacantShiftId)
        .delete();

    return db
        .collection('app-users').get().then((usersSnapshot) {
          for (var element in usersSnapshot.docs) {
            element.reference
            .collection('applied_shifts')
            .where('vacancy_id', isEqualTo: vacantShiftId)
            .get().then((snapshot) {
              for (var element2 in snapshot.docs) {
                element2.reference.delete();
              }
            });
          }
        });
  }
}