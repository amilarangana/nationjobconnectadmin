import '/user_profile/models/user.dart';

abstract class iDataAccessSignin{
  void dbConnect();
  Future<User?> signinUser(String username, String password);
  
}