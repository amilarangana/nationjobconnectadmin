import '/user_profile/models/user.dart';

abstract class iDataAccessUser{
  void dbConnect();
  Future<User?> readUser(String deviceId);
  Future<String> saveUser(User user);
  
}