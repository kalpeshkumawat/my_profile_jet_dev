import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_profile/utils/storage_service.dart';

import '../../constants/strings.dart';
import '../../core/app_text.dart';
import '../../core/app_text_form_field.dart';
import '../../utils/email_validator.dart';
import '../../utils/utilities.dart';
import '../home/home_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var screenTitle = "";
  var screenData = "";

  var _iconData;

  final _textInputController = TextEditingController();

  @override
  void dispose() {
    _textInputController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    screenTitle = Get.arguments[0][Strings.keyScreenTitle];
    screenData = Get.arguments[1][Strings.keyScreenData];

    _textInputController.text = screenData;

    if (screenTitle == Strings.strName) {
      _iconData = Icons.account_circle;
    } else if (screenTitle == Strings.strEmail) {
      _iconData = Icons.email_outlined;
    } else if (screenTitle == Strings.strSkills) {
      _iconData = Icons.list_alt;
    } else if (screenTitle == Strings.strWorkExperience) {
      _iconData = Icons.work_history_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _getAppBar(),
        body: _getBody(),
      ),
    );
  }

  _getAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => _onWillPop(),
      ),
      centerTitle: true,
      backgroundColor: Colors.orangeAccent,
      elevation: 4.0,
      title: const AppText(
          text: Strings.strUpdateProfile,
          fontWeight: FontWeight.bold,
          size: 18.0),
    );
  }

  Future<bool> _onWillPop() async {
    var isValueUpdated = false;

    if (screenData == Utilities.getString(_textInputController)) {
      // Old and new If the values are the same, the value is not changed.

      isValueUpdated = true;
    } else {
      // Value is updated

      isValueUpdated = false;
    }

    if (isValueUpdated) {
      Navigator.pop(context);
      return Future.value(false);
    } else {
      return (await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              title: const Text(Strings.strConfirmTheAction),
              content: const Text(Strings.strLeaveScreenMessage),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text(Strings.strNotNow),
                ),
                TextButton(
                  onPressed: () =>
                      {Navigator.of(context).pop(true), Navigator.pop(context)},
                  child: const Text(Strings.strYes),
                ),
              ],
            ),
          )) ??
          false;
    }
  }

  _getBody() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 30.0),
      child: Column(
        children: [
          _getTitleText(screenTitle),
          const SizedBox(
            height: 30.0,
          ),
          AppTextFormField(
            controller: _textInputController,
            textInputType: TextInputType.text,
            labletext: screenTitle,
            color: Colors.white,
            textInputAction: TextInputAction.done,
            suifxicon: Icon(
              _iconData,
              color: Colors.black87,
            ),
          ),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            onPressed: () {
              _updateButtonPressed();
            },
            child: const SizedBox(
                width: double.infinity,
                child: Center(
                    child: AppText(
                  text: Strings.strSave,
                  size: 18.0,
                  fontWeight: FontWeight.w500,
                ))),
          ),
        ],
      ),
    );
  }

  _getTitleText(String text) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }

  void _updateButtonPressed() {
    Utilities.hideKeyboard();

    final dataStr = Utilities.getString(_textInputController);

    if (dataStr.isEmpty) {
      _showMessage(Strings.strPleaseEnter + screenTitle);
    } else {
      if (screenTitle == Strings.strName) {
        // Name Updating

       // _saveDataToStorage(StorageKeys.userName.toString());
        _saveDataToStorage(StorageKeys.dbUserName.toString());
        StorageService.saveData(StorageKeys.isUserNameUpdated.toString(), true);

        _navigateToHomePage();
      } else if (screenTitle == Strings.strEmail) {
        // Email Updating

        if (!EmailValidator.validate(dataStr)) {
          _showMessage(Strings.errorValidEmailAddress);
        } else {

        //  _saveDataToStorage(StorageKeys.userEmail.toString());
          _saveDataToStorage(StorageKeys.dbUserEmail.toString());

          StorageService.saveData(
              StorageKeys.isUserEmailUpdated.toString(), true);

          _navigateToHomePage();
        }
      } else if (screenTitle == Strings.strSkills) {
        // Skills Updating

        _saveDataToStorage(StorageKeys.userSkills.toString());

        _navigateToHomePage();
      } else if (screenTitle == Strings.strWorkExperience) {
        // Work Experience Updating

        _saveDataToStorage(StorageKeys.userWorkExperience.toString());

        _navigateToHomePage();
      }
    }
  }

  void _showMessage(String msg) {
    Utilities.showToastMsg(context, msg);
  }

  void _navigateToHomePage() {
    _showMessage(Strings.strProfileUpdateSuccessMessage);

    Get.offAll(() => const HomeScreen(),
        transition: Transition.zoom,
        duration: const Duration(milliseconds: 500));
  }

  void _saveDataToStorage(String keyName) {
    StorageService.saveData(keyName, Utilities.getString(_textInputController));
  }
}
