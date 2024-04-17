import 'package:flutter/material.dart';
import 'package:nation_job_connect_admin/firebase/firestore_signin.dart';
import 'package:nation_job_connect_admin/shift_type/screens/manage_shift_types_screen.dart';
import '../../authentication/screens/signin_screen.dart';
import '../../authentication/store_credentials/auth_shared_prefs.dart';
import '../../resources/strings.dart';
import '/base/base_screen.dart';
import '/base/basic_screen.dart';

class ProfileScreen extends BaseScreen {
  static const routeName = '/signin_screen';
  
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _MyShiftScreenState();
}

class _MyShiftScreenState extends BaseState<ProfileScreen> with BasicScreen {


  final _dbConnectSignin = FirestoreSignin();
  final _authShredPrefs = AuthSharedPrefs();

  @override
  void initState() {
    _dbConnectSignin.dbConnect();
    super.initState();
  }
  
  @override
  getExtra() {
   
  }
  
  @override
  Widget screenBody(BuildContext context) {
    var savedUser = _authShredPrefs.retrieveSavedUserCredentials();
  
    return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                savedUser != null ? Image.network(savedUser.logo, width: 80): const Text(''),
                const SizedBox(height: 50),
                savedUser != null ? Text(savedUser.name, style: const TextStyle(fontSize: 20),): const Text(""),
                const SizedBox(height: 50),
                ElevatedButton(
                  child: const Text("Manage Shift Types"),
                  onPressed: () async {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => ManageShiftTypesScreen(
                              key: const Key(Strings.stringSettingsScreen),
                            )));
                  },
                ),
                ElevatedButton(
                  child: const Text("Logout"),
                  onPressed: () async {
                      _authShredPrefs.removeSavedUserCredentials();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) => SigninScreen(
                              key: const Key("signin_screen"),
                            )));
                  },
                ),
              ],
            ),
        );
  }
  
  @override
  String screenName() {
    return "Profile";
  }
}
