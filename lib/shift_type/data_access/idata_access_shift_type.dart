import '/shift_type/models/shift_type.dart';

abstract class IDataAccessShiftType{
  void dbConnect();
  Future<ShiftType> readShiftType(String shiftId);
  Future<List<ShiftType>> readShiftTypeList();
  Future<bool> addShiftType(ShiftType shiftType);
}