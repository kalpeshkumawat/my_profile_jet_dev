import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_profile/core/app_text.dart';
import 'package:my_profile/screens/login/login_screen.dart';
import 'package:my_profile/screens/profile/edit_profile_screen.dart';
import 'package:my_profile/utils/utilities.dart';

import '../../constants/assets.dart';
import '../../constants/strings.dart';
import '../../utils/storage_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image;
  final _picker = ImagePicker();

  final userName = "".obs;
  final userEmail = "".obs;
  final userSkills = "".obs;
  final userWorkExperience = "".obs;

  @override
  Widget build(BuildContext context) {
    _getUserProfileInformation();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _getAppBar(),
      body: _getBody(),
    );
  }

  _getAppBar() {
    return AppBar(
      actions: <Widget>[
        IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.black87,
            ),
            onPressed: () {
              _logoutPressed();
            }),
      ],
      centerTitle: true,
      backgroundColor: Colors.orangeAccent,
      elevation: 4.0,
      title: const AppText(
          text: Strings.strHome, fontWeight: FontWeight.bold, size: 18.0),
    );
  }

  void _logoutPressed() {
    showCupertinoModalPopup(
      context: context,
      barrierColor: Colors.black38,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const AppText(
          text: Strings.strLogout,
          size: 18.0,
          fontWeight: FontWeight.bold,
        ),
        message: const AppText(
          text: Strings.strLogoutMessage,
          size: 15.0,
          fontWeight: FontWeight.w500,
        ),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: const AppText(
              text: Strings.strYes,
              size: 16.0,
              fontWeight: FontWeight.normal,
            ),
            onPressed: () {
              Navigator.pop(context);
              _performLogoutOperation();
            },
          ),
          CupertinoActionSheetAction(
            child: const AppText(
              text: Strings.strNotNow,
              size: 16.0,
              fontWeight: FontWeight.normal,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _performLogoutOperation() {
    Utilities.showToastMsg(context, Strings.strLogoutSuccessMessage);

    // ! Get the "remember me" flag from the storage; we will clear the storage and save it again to the storage.

    bool isRemember =
        StorageService.getData(StorageKeys.isRememberMe.toString(), false);

    StorageService.removeData(StorageKeys.isLogin.toString());

    StorageService.saveData(StorageKeys.isRememberMe.toString(), isRemember);

    Get.offAll(() => const LoginScreen(),
        transition: Transition.zoom, duration: const Duration(milliseconds: 500));
  }

  _getBody() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 40.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _getUserAvatar(),
            putVerticalSpace(40.0),
            _getCommonTitleText(Strings.strName),
            Obx(
              () => _getCommonText(
                userName.value,
                Icons.account_circle,
                () => _profileEditPressed(Strings.strName, userName.value),
              ),
            ),
            putVerticalSpace(20.0),
            _getCommonTitleText(Strings.strEmail),
            Obx(
              () => _getCommonText(
                userEmail.value,
                Icons.email_outlined,
                () => _profileEditPressed(Strings.strEmail, userEmail.value),
              ),
            ),
            putVerticalSpace(20.0),
            _getCommonTitleText(Strings.strSkills),
            Obx(
              () => _getCommonText(
                userSkills.value,
                Icons.list_alt,
                () => _profileEditPressed(Strings.strSkills, userSkills.value),
              ),
            ),
            putVerticalSpace(20.0),
            _getCommonTitleText(Strings.strWorkExperience),
            Obx(
              () => _getCommonText(
                userWorkExperience.value,
                Icons.work_history_outlined,
                () => _profileEditPressed(Strings.strWorkExperience, userWorkExperience.value),
              ),
            )
          ],
        ),
      ),
    );
  }

  _getCommonText(String text, IconData iconData, VoidCallback voidCallback) {
    return Container(
        padding: const EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 0.0),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1.0, color: Colors.black87),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: 20.0,
              color: Colors.black87,
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              flex: 1,
              child: Text(
                text,
                style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87),
              ),
            ),
            IconButton(
              onPressed: voidCallback,
              icon: const Icon(
                Icons.mode_edit_outline,
                size: 20.0,
                color: Colors.black87,
              ),
            ),
          ],
        ));
  }

  _getCommonTitleText(String text) {
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

  _getUserAvatar() {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {
          _selectImageClicked();
        },
        child: CircleAvatar(
          radius: 60.0,
          backgroundImage: _image == null
              ? const AssetImage(Assets.imgPlaceholder)
              : Image.file(_image!).image,
        ),
      ),
    );
  }

  Widget putVerticalSpace(dynamic value) {
    return SizedBox(height: value);
  }

  void _selectImageClicked() {
    showCupertinoModalPopup(
      context: context,
      barrierColor: Colors.black38,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const AppText(
          text: Strings.strAddPhoto,
          size: 20.0,
          fontWeight: FontWeight.bold,
        ),
        message: const AppText(
          text: Strings.strPickPhotoGalleryNGallery,
          size: 15.0,
          fontWeight: FontWeight.normal,
        ),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: const AppText(
              text: Strings.strChooseGallery,
              size: 16.0,
              fontWeight: FontWeight.normal,
            ),
            onPressed: () {
              Navigator.pop(context);
              _openImagePicker(ImageSource.gallery);
            },
          ),
          CupertinoActionSheetAction(
            child: const AppText(
              text: Strings.strPickCamera,
              size: 16.0,
              fontWeight: FontWeight.normal,
            ),
            onPressed: () {
              Navigator.pop(context);
              _openImagePicker(ImageSource.camera);
            },
          ),
          CupertinoActionSheetAction(
            child: const AppText(
              text: Strings.strCancel,
              size: 18.0,
              fontWeight: FontWeight.bold,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _openImagePicker(ImageSource optionSource) async {
    final XFile? pickedImage = await _picker.pickImage(source: optionSource);
    if (pickedImage != null) {
      startImageCropping(File(pickedImage.path));
    }
  }

  void startImageCropping(File file) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Edit Photo',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );

    setState(() {
      _image = File(croppedFile!.path);


    });
  }

  _profileEditPressed(String title, String data) {
    Get.to(() => const EditProfileScreen(), arguments: [
      {Strings.keyScreenTitle: title},
      {Strings.keyScreenData: data},
    ], transition: Transition.rightToLeft, duration: const Duration(milliseconds: 500));
  }

  void _getUserProfileInformation() {
    userEmail.value =
        StorageService.getData(StorageKeys.dbUserEmail.toString(), "");

    userName.value =
        StorageService.getData(StorageKeys.dbUserName.toString(), "");

    userSkills.value =
        StorageService.getData(StorageKeys.userSkills.toString(), "");

    userWorkExperience.value =
        StorageService.getData(StorageKeys.userWorkExperience.toString(), "");
  }
}
