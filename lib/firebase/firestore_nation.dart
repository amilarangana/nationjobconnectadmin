import 'package:cloud_firestore/cloud_firestore.dart';
import '/nations/data_access/idata_access_nation.dart';
import '/nations/models/nation.dart';

class FirestoreNation extends iDataAccessNation{

  late FirebaseFirestore db;

  @override
  void dbConnect() {
    db = FirebaseFirestore.instance;
  }

  @override
  Future<Nation> readNationsList(String nationId) async{
    var documentSnapshot = await db.collection("nations").doc(nationId).get();
    return Nation.fromJson(documentSnapshot.id, documentSnapshot.data()!=null? documentSnapshot.data()!:{});
  }
}