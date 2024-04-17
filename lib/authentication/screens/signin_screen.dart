// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:nation_job_connect_admin/base/main_screen.dart';
import '../store_credentials/auth_shared_prefs.dart';
import '/widgets/common/alert_dialog.dart';
import '../../firebase/firestore_signin.dart';
import '../../resources/colors.dart';
import '../../resources/dimensions.dart';
import '../../resources/utils.dart';
import '../../widgets/common/subtitle_text.dart';
import '/base/base_screen.dart';
import '/base/basic_screen.dart';

class SigninScreen extends BaseScreen {
  static const routeName = '/signin';
  SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends BaseState<SigninScreen>
    with BasicScreen {
  final _loginFormKey = GlobalKey<FormState>();
  final _dbConnectSignin = FirestoreSignin();
  final _authShredPrefs = AuthSharedPrefs();

  final _usernameTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  @override
  void initState() {
    _dbConnectSignin.dbConnect();
    super.initState();
  }

  @override
  getExtra() {}

  @override
  Widget screenBody(BuildContext context) {
    //load all user applied vacancies...
    return Container(
                padding: const EdgeInsets.all(10),
                height: MediaQuery.of(context).size.height / 2,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
                child: Form(
                    key: _loginFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SubTitleText("Signin"),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          controller: _usernameTextController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Username can not be empty";
                            }
                            return null;
                          },
                          obscureText: false,
                          style: const TextStyle(
                              color: Color(ResColors.colorFontSplash),
                              fontSize: ResDimensions.fontSizeDataEntry),
                          decoration:
                              Utils.getInputDecoration("Username", null),
                          cursorColor: const Color(ResColors.colorFontSplash),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _passwordTextController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password can not be empty";
                            }
                            return null;
                          },
                          obscureText: true,
                          style: const TextStyle(
                              color: Color(ResColors.colorFontSplash),
                              fontSize: ResDimensions.fontSizeDataEntry),
                          decoration:
                              Utils.getInputDecoration("Password", null),
                          cursorColor: const Color(ResColors.colorFontSplash),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          child: const Text('  Signin  '),
                          onPressed: () async {
                            if (_loginFormKey.currentState!.validate()) {
                              var user = await _dbConnectSignin.signinUser(_usernameTextController.text.trim(),
                               Utils.generateMd5(_passwordTextController.text.trim()));
                               if (user != null) {
                                await _authShredPrefs.storeUserCredentials(user);
                                 Navigator.of(context).pushReplacement(MaterialPageRoute(
                                  builder: (BuildContext context) => const MainScreen(
                                        key: Key("main_screen"),
                                      )
                                    )
                                  );
                               }else{
                                showDialog(context: context, 
                                builder: (context){
                                  return const CustomAlertDialog("Info", "Username or Password is incorrect");
                                });
                               }
                            }
                          },
                        ),
                        
                      ],
                    )));
  }

  @override
  String screenName() {
    return "Signin";
  }
}
