// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:nation_job_connect_admin/firebase/firestore_shift_type.dart';
import 'package:nation_job_connect_admin/resources/strings.dart';
import 'package:nation_job_connect_admin/shift_type/models/shift_type.dart';
import '../../authentication/store_credentials/auth_shared_prefs.dart';
import '../../firebase/firestore_signin.dart';
import '../../resources/colors.dart';
import '../../resources/dimensions.dart';
import '../../resources/utils.dart';
import '../../widgets/common/subtitle_text.dart';
import '/base/base_screen.dart';
import '/base/basic_screen.dart';

class ManageShiftTypesScreen extends BaseScreen {
  static const routeName = '/settings_screen';
  ManageShiftTypesScreen({super.key});

  @override
  State<ManageShiftTypesScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends BaseState<ManageShiftTypesScreen>
    with BasicScreen {
  final _addShiftTypeFormKey = GlobalKey<FormState>();
  final _dbConnectShiftType = FirestoreShiftType();
  final _authShredPrefs = AuthSharedPrefs();

  final _shiftNameTextController = TextEditingController();
  final _descriptionTextController = TextEditingController();

  @override
  void initState() {
    _dbConnectShiftType.dbConnect();
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
                    key: _addShiftTypeFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SubTitleText("Add new shift type"),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _shiftNameTextController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Shift name can not be empty";
                            }
                            return null;
                          },
                          obscureText: false,
                          style: const TextStyle(
                              color: Color(ResColors.colorFontSplash),
                              fontSize: ResDimensions.fontSizeDataEntry),
                          decoration:
                              Utils.getInputDecoration("Shift Type", null),
                          cursorColor: const Color(ResColors.colorFontSplash),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _descriptionTextController,
                          validator: (value) {
                            // if (value == null || value.isEmpty) {
                            //   return "Description can not be empty";
                            // }
                            return null;
                          },
                          obscureText: false,
                          style: const TextStyle(
                              color: Color(ResColors.colorFontSplash),
                              fontSize: ResDimensions.fontSizeDataEntry),
                          decoration:
                              Utils.getInputDecoration(Strings.stringDescription, null),
                          cursorColor: const Color(ResColors.colorFontSplash),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          child: const Text('  Add '),
                          onPressed: () async {
                            if (_addShiftTypeFormKey.currentState!.validate()) {
                              var newShiftType = ShiftType(
                                id: null, 
                                type: _shiftNameTextController.text.trim(), 
                                description: _descriptionTextController.text.trim(),
                                nationId: _authShredPrefs.retrieveSavedUserCredentials()!.id);
                              _dbConnectShiftType.addShiftType(newShiftType).then((value) {
                                _shiftNameTextController.text = Strings.stringEmpty;
                                _descriptionTextController.text = Strings.stringEmpty;
                                showSnackbar(Strings.stringShiftTypeAdded);
                              });
                            }
                          },
                        ),
                        
                      ],
                    )));
  }

  @override
  String screenName() {
    return Strings.stringManageShiftTypes;
  }
}
