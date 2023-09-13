import 'package:get_storage/get_storage.dart';

enum StorageKeys {
  isLogin,
  isRememberMe,
  isUserEmailUpdated,
  isUserNameUpdated,
  userAvtar,
  userName,
  userEmail,
  userSkills,
  userWorkExperience,
  dbUserEmail,
  dbUserName

}

class StorageService {
  // Save
  static saveData(String key, dynamic value) {
    final box = GetStorage();

    box.write(key, value);
  }

  // Get
  static dynamic getData(String key, dynamic defaultValue) {
    final box = GetStorage();

    if (box.hasData(key)) {
      return box.read(key);
    } else {
      return defaultValue;
    }
  }

  // Remove
  static void removeData(String key) {
    final box = GetStorage();
    box.remove(key);
  }

  // Clear
  static void clearData() {
    final box = GetStorage();
    box.erase();
  }
}
