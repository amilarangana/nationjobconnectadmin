import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nation_job_connect_admin/authentication/data_access/idata_access_signin.dart';
import '/user_profile/models/user.dart';

class FirestoreSignin extends iDataAccessSignin{

  late FirebaseFirestore db;

  @override
  void dbConnect() {
    db = FirebaseFirestore.instance;
  }

  @override
  Future<User?> signinUser(String username, String password) async {
    var querySnapshot = 
      await db.collection("nations")
              .where('username', isEqualTo: username)
              .where('password', isEqualTo: password)
              .get();
      if (querySnapshot.size > 0) {
        return User.fromJson(querySnapshot.docs[0].id, querySnapshot.docs[0].data());
      }else{
        return null;
      }
  }
}