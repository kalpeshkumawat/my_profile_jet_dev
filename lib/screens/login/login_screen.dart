import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_profile/constants/strings.dart';
import 'package:my_profile/core/app_text.dart';
import 'package:my_profile/screens/home/home_screen.dart';
import 'package:my_profile/utils/email_validator.dart';
import 'package:my_profile/utils/utilities.dart';

import '../../core/app_text_form_field.dart';
import '../../utils/storage_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();

  final _obscurePassword = true.obs;
  final textFieldFocusNode = FocusNode();

  final _isRememberedMe = false.obs;

  final _userNameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _prefillUserNamePassword();

    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: _getBody(),
        ));
  }

  _getBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const AppText(
              text: Strings.strLogin, size: 40.0, fontWeight: FontWeight.bold),
          putVerticalSpace(30.0),
          AppTextFormField(
            controller: _userNameController,
            textInputType: TextInputType.emailAddress,
            labletext: Strings.hintUserName,
            color: Colors.white,
            focusNode: _userNameFocusNode,
            nextFocusNode: _passwordFocusNode,
            textInputAction: TextInputAction.next,
            suifxicon: const Icon(
              Icons.email_outlined,
              color: Colors.black87,
            ),
          ),
          putVerticalSpace(20.0),
          Obx(
            () => AppTextFormField(
              controller: _passwordController,
              textInputType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              labletext: Strings.hintPassword,
              focusNode: _passwordFocusNode,
              color: Colors.white,
              obscuretext: _obscurePassword.value,
              suifxicon: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 4.0, 0.0),
                child: GestureDetector(
                  onTap: _toggleObscured,
                  child: Icon(
                    _obscurePassword.value
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                    size: 24.0,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
          putVerticalSpace(20.0),
          Row(
            children: [
              Obx(
                () => Checkbox(
                  value: _isRememberedMe.value,
                  onChanged: (bool? value) {
                    _isRememberedMe.value = value!;
                  },
                ),
              ),
              const AppText(
                  text: Strings.strRememberMe,
                  size: 16.0,
                  fontWeight: FontWeight.w500)
            ],
          ),
          putVerticalSpace(20.0),
          OutlinedButton(
            onPressed: () {
              _loginPressed();
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0))),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(Strings.strLogin,
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87)),
            ),
          ),
        ],
      ),
    );
  }

  Widget putVerticalSpace(dynamic value) {
    return SizedBox(height: value);
  }

  void _toggleObscured() {
    _obscurePassword.value = !_obscurePassword.value;
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _loginPressed() async {
    Utilities.hideKeyboard();

    final validUserName =
        StorageService.getData(StorageKeys.dbUserEmail.toString(), "");
    final validPassword =
        StorageService.getData(StorageKeys.dbUserName.toString(), "");




    final userNameStr = Utilities.getString(_userNameController);
    final passwordStr = Utilities.getString(_passwordController);



    if (userNameStr.isEmpty) {
      _showMessage(Strings.errorEmptyUserName);
    } else if (!EmailValidator.validate(userNameStr)) {
      _showMessage(Strings.errorValidUserName);
    } else if (passwordStr.isEmpty) {
      _showMessage(Strings.errorEmptyPassword);
    } else if (userNameStr != validUserName) {
      _showMessage(Strings.errorInvalidUserName);
    } else if (passwordStr != validPassword) {
      _showMessage(Strings.errorInvalidPassword);
    } else {
      _showMessage(Strings.msgLoginSuccess);

      StorageService.saveData(StorageKeys.isLogin.toString(), true);

      StorageService.saveData(StorageKeys.userEmail.toString(), userNameStr);
      StorageService.saveData(StorageKeys.userName.toString(), passwordStr);

      StorageService.saveData(
          StorageKeys.isRememberMe.toString(), _isRememberedMe.value);

      Get.offAll(() => const HomeScreen(),
          transition: Transition.zoom, duration: const Duration(milliseconds: 500));
    }
  }

  void _showMessage(String msg) {
    Utilities.showToastMsg(context, msg);
  }

  void _prefillUserNamePassword() async {
    // ! Check if remember me is true then set username & password to Input fields

    final isRememberFlag =
        StorageService.getData(StorageKeys.isRememberMe.toString(), false);

    _isRememberedMe.value = isRememberFlag;

    if (isRememberFlag) {
      final validUserName =
          StorageService.getData(StorageKeys.userEmail.toString(), "");
      final validPassword =
          StorageService.getData(StorageKeys.userName.toString(), "");


      _userNameController.text = validUserName;
      _passwordController.text = validPassword;
    }
  }
}
