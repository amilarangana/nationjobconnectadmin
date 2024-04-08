import '../models/application.dart';

abstract class iDataAccessApplications{
  void dbConnect();
  Stream<List<Application>> getApplications(String shiftId);
  Future<void> acceptApplication(String shiftId, String applicationId, String applicantId);
  Future<void> rejectApplication(String shiftId, String applicationId, String applicantId);
}