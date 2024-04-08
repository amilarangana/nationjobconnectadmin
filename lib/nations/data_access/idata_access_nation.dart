import '/nations/models/nation.dart';

abstract class iDataAccessNation{
  void dbConnect();
  Future<Nation> readNationsList(String nationId);

}