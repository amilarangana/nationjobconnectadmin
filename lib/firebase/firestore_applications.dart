import 'package:cloud_firestore/cloud_firestore.dart';
import '../applications/data_access/idata_access_applications.dart';
import '../applications/models/application.dart';

class FirestoreApplications extends iDataAccessApplications{

  late FirebaseFirestore db;
  
  @override
  void dbConnect() {
    db = FirebaseFirestore.instance;
  }

  @override
  Stream<List<Application>> getApplications(String shiftId) {
    return db.collection("vacant_shifts")
    .doc(shiftId)
    .collection("applications")
    .withConverter<Application>(
      fromFirestore: (snapshot, options){
        return Application.fromJson(snapshot.id, snapshot.data()!);
    }, 
      toFirestore: (value, options){
        return value.toJson();
    })
    .snapshots()
    . map((query) => query.docs.map((snapshot) => snapshot.data()).toList());
  }
  
  @override
  Future<void> acceptApplication(String shiftId, String applicationId, String applicantId) {

    return db.collection('vacant_shifts')
      .doc(shiftId)
      .get()
      .then((element) {
        if (element.data()!=null) {

          db.collection('vacant_shifts')
            .doc(shiftId)
            .collection('applications')
            .doc(applicationId)
            .get()
            .then((elementApplication) {
                var applicationStatus = elementApplication.data()!['status'] as int;
                var noOfVacancies = element.data()!['no_of_vacancies'] as int;

                //Update the no_of_vacancies in vacant_shift.....
                if (applicationStatus == 0 || applicationStatus == 2) {
                  db.collection('vacant_shifts')
                  .doc(shiftId)
                  .set({'no_of_vacancies': noOfVacancies-1}, SetOptions(merge: true)); 
                }
                //Update status of the vacant_shift applications....
                db.collection('vacant_shifts')
                  .doc(shiftId)
                  .collection('applications')
                  .doc(applicationId)
                  .set({'status': 1}, SetOptions(merge: true));

                //Update the status of app-users, applied_shifts....
                db.collection('app-users')
                  .doc(applicantId)
                  .collection('applied_shifts')
                  .where('vacancy_id', isEqualTo: shiftId)
                  .get()
                  .then((element) {
                    for (var item in element.docs) {
                        db.collection('app-users')
                        .doc(applicantId)
                        .collection('applied_shifts')
                        .doc(item.id)
                        .set({'status': 1}, SetOptions(merge: true));
                     }
                  });
            }); 
        }
      });
  }
  
  @override
  Future<void> rejectApplication(String shiftId, String applicationId, String applicantId) {

    return db.collection('vacant_shifts')
      .doc(shiftId)
      .get()
      .then((element) {
        if (element.data()!=null) {

          db.collection('vacant_shifts')
            .doc(shiftId)
            .collection('applications')
            .doc(applicationId)
            .get()
            .then((elementApplication) {
                var applicationStatus = elementApplication.data()!['status'] as int;
                var noOfVacancies = element.data()!['no_of_vacancies'] as int;

                //Update the no_of_vacancies in vacant_shift.....
                if (applicationStatus == 1) {
                  db.collection('vacant_shifts')
                  .doc(shiftId)
                  .set({'no_of_vacancies': noOfVacancies+1}, SetOptions(merge: true)); 
                }
                //Update status of the vacant_shift applications....
               db.collection('vacant_shifts')
                 .doc(shiftId)
                 .collection('applications')
                 .doc(applicationId)
                 .set({'status': 2}, SetOptions(merge: true));

              //Update the status of app-users, applied_shifts....
              db.collection('app-users')
                  .doc(applicantId)
                  .collection('applied_shifts')
                  .where('vacancy_id', isEqualTo: shiftId)
                  .get()
                  .then((element) {
                    for (var item in element.docs) {
                        db.collection('app-users')
                        .doc(applicantId)
                        .collection('applied_shifts')
                        .doc(item.id)
                        .set({'status': 2}, SetOptions(merge: true));
                     }
                  });
            }); 
        }
      });
  }
}