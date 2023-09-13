import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_profile/screens/home/home_screen.dart';
import 'package:my_profile/screens/login/login_screen.dart';
import 'package:my_profile/utils/app_config.dart';

import 'utils/storage_service.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  initClasses();

}

void initClasses() async {
  // ! Set the Device's Orientations - Here we are using "Portrait" mode only

  await setPreferredOrientations();

  // ! initialize the storage to store and fetch the data

  await GetStorage.init();

  var isUserEmailUpdated =
      StorageService.getData(StorageKeys.isUserEmailUpdated.toString(), false);
  var isUserNameUpdated =
      StorageService.getData(StorageKeys.isUserNameUpdated.toString(), false);

  if (!isUserEmailUpdated) {
    // First Time

    final fetchUserEmail = await AppConfig.getUserEmail();
    StorageService.saveData(StorageKeys.dbUserEmail.toString(), fetchUserEmail);
  }

  if (!isUserNameUpdated) {
    // First Time

    final fetchUserName = await AppConfig.getUserName();
    StorageService.saveData(StorageKeys.dbUserName.toString(), fetchUserName);
  }

  await Future.delayed(const Duration(milliseconds: 150));


  runApp(const InitialApp());
}

Future<void> setPreferredOrientations() {
  return SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}

class InitialApp extends StatefulWidget {
  const InitialApp({super.key});

  @override
  State<InitialApp> createState() => _InitialAppState();
}

class _InitialAppState extends State<InitialApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Profile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: _getWidget(),
    );
  }

  _getWidget() {
    var isLogin = StorageService.getData(StorageKeys.isLogin.toString(), false);

    debugPrint("User Login Status: $isLogin");

    if (isLogin) {
      // User logged in

      return const HomeScreen();
    } else {
      // User not logged in

      return const LoginScreen();
    }
  }
}
