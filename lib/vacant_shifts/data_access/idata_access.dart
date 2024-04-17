import '/vacant_shifts/models/vacant_shift.dart';

abstract class iDataAccess{
  void dbConnect();
  Future<void> publishVacancy(VacantShift vacantShift);
  Stream<List<VacantShift>> getVacancies(String nationId);
  Future<void> deleteVacancy(String vacantShiftId);
}