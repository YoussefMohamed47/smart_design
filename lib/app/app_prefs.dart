import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../presentation/resources/langauge_manager.dart';

const String PREFS_KEY_LANG = "PREFS_KEY_LANG";
const String PREFS_KEY_ONBOARDING_SCREEN_VIEWED =
    "PREFS_KEY_ONBOARDING_SCREEN_VIEWED";
const String PREFS_KEY_IS_USER_LOGGED_IN = "PREFS_KEY_IS_USER_LOGGED_IN";
const String CURRENT_MEDIA_INDEX = "CURRENT_MEDIA_INDEX";
const String CURRENT_MEDIA_INDEX_TELWAT = "CURRENT_MEDIA_INDEX_TELWAT";
const String CURRENT_MEDIA_INDEX_LIBRARY = "CURRENT_MEDIA_INDEX_LIBRARY";
const String USER_SELECTED_OPTION = "USER_SELECTED_OPTION";
const String LIST_FAVOURIT = "LIST_FAVOURIT";
const String LIST_PLAYER = "LIST_PLAYER";
const String LIST_PLAYER_LIBRARY = "LIST_PLAYER_LIBRARY";
const String HAS_TOKEN = "HAS_TOKEN";
const String ACCESSTOKEN = "ACCESSTOKEN";
const String REMEMBERTOKEN = "REMEMBERTOKEN";
const String NAME = "NAME";
const String EMAIL = "EMAIL";

class AppPreferences {
  final SharedPreferences _sharedPreferences;

  AppPreferences(this._sharedPreferences);

  Future<String> getAppLanguage() async {
    String? language = _sharedPreferences.getString(PREFS_KEY_LANG);
    if (language != null && language.isNotEmpty) {
      return language;
    } else {
      // return default lang
      return LanguageType.ENGLISH.getValue();
    }
  }

  Future<void> changeAppLanguage() async {
    String currentLang = await getAppLanguage();

    if (currentLang == LanguageType.ARABIC.getValue()) {
      // set english
      _sharedPreferences.setString(
          PREFS_KEY_LANG, LanguageType.ENGLISH.getValue());
    } else {
      // set arabic
      _sharedPreferences.setString(
          PREFS_KEY_LANG, LanguageType.ARABIC.getValue());
    }
  }

  Future<Locale> getLocal() async {
    String currentLang = await getAppLanguage();

    if (currentLang == LanguageType.ARABIC.getValue()) {
      return ARABIC_LOCAL;
    } else {
      return ENGLISH_LOCAL;
    }
  }

  // on boarding

  Future<void> setOnBoardingScreenViewed() async {
    _sharedPreferences.setBool(PREFS_KEY_ONBOARDING_SCREEN_VIEWED, true);
  }

  Future<bool> isOnBoardingScreenViewed() async {
    return _sharedPreferences.getBool(PREFS_KEY_ONBOARDING_SCREEN_VIEWED) ??
        false;
  }

  //login

  Future<void> setUserLoggedIn() async {
    _sharedPreferences.setBool(PREFS_KEY_IS_USER_LOGGED_IN, true);
  }

  Future<bool> isUserLoggedIn() async {
    return _sharedPreferences.getBool(PREFS_KEY_IS_USER_LOGGED_IN) ?? false;
  }

  Future<void> logout() async {
    _sharedPreferences.remove(PREFS_KEY_IS_USER_LOGGED_IN);
  }

  Future<void> setCurrentMediaPlay(int index) async {
    _sharedPreferences.setInt(CURRENT_MEDIA_INDEX, index);
  }

  Future<void> setCurrentMediaPlayTelwat(int index) async {
    _sharedPreferences.setInt(CURRENT_MEDIA_INDEX_TELWAT, index);
  }

  Future<void> setCurrentMediaPlayLibrary(int index) async {
    _sharedPreferences.setInt(CURRENT_MEDIA_INDEX_LIBRARY, index);
  }

  Future<int> getCurrentMediaPlayLibrary() async {
    int? currentMediaPlay =
        _sharedPreferences.getInt(CURRENT_MEDIA_INDEX_LIBRARY);

    if (currentMediaPlay == null) {
      return 0;
    } else {
      return currentMediaPlay;
    }
  }

  Future<int> getCurrentMediaPlay() async {
    int? currentMediaPlay = _sharedPreferences.getInt(CURRENT_MEDIA_INDEX);

    if (currentMediaPlay == null) {
      return 0;
    } else {
      return currentMediaPlay;
    }
  }

  Future<int> getCurrentMediaPlayTelwat() async {
    int? currentMediaPlay =
        _sharedPreferences.getInt(CURRENT_MEDIA_INDEX_TELWAT);

    if (currentMediaPlay == null) {
      return 0;
    } else {
      return currentMediaPlay;
    }
  }

  Future<void> setUserSelectedOption(int option) async {
    _sharedPreferences.setInt(USER_SELECTED_OPTION, option);
  }

  Future<int?> getUserSelectedOption() async {
    int? currentMediaPlay = _sharedPreferences.getInt(USER_SELECTED_OPTION);
    return currentMediaPlay;
  }

  Future<void> addORRemoveFavourite(int seriseId) async {
    List<String> allFavourite = await getFavourite() ?? [];
    bool isFound = allFavourite
            .where((element) => element == seriseId.toString())
            .isNotEmpty
        ? true
        : false;
    if (isFound) {
      allFavourite.remove(seriseId.toString());
    } else {
      allFavourite.add(seriseId.toString());
    }
    _sharedPreferences.setStringList(LIST_FAVOURIT, allFavourite);
  }

  Future<List<String>?> getFavourite() async {
    return _sharedPreferences.getStringList(LIST_FAVOURIT);
  }

  Future<bool> setToken(bool val) async {
    return _sharedPreferences.setBool(HAS_TOKEN, val);
  }

  Future<bool> hasToken() async {
    return _sharedPreferences.getBool(HAS_TOKEN) ?? false;
  }

  setAccessToken(String token) async {
    await _sharedPreferences.setString(ACCESSTOKEN, token);
  }

  getAccessToken() async {
    return _sharedPreferences.getString(ACCESSTOKEN);
  }

  setRemeberToken(String token) async {
    await _sharedPreferences.setString(REMEMBERTOKEN, token);
  }

  getRemeberToken() async {
    return _sharedPreferences.getString(REMEMBERTOKEN);
  }

  setName(String name) async {
    await _sharedPreferences.setString(NAME, name);
  }

  getName() {
    return _sharedPreferences.getString(NAME);
  }

  setEmail(String email) async {
    print("app pref emal >>> $email");
    await _sharedPreferences.setString(EMAIL, email);
  }

  getEmail() {
    return _sharedPreferences.getString(EMAIL);
  }

  Future<List<String>?> getPlayerList() async {
    return _sharedPreferences.getStringList(LIST_PLAYER);
  }

  Future<List<String>?> getPlayerListLibrary() async {
    return _sharedPreferences.getStringList(LIST_PLAYER_LIBRARY);
  }

  Future<void> addORRemovePlayerLibrary(String subjectId) async {
    List<String> allPlayerId = await getPlayerListLibrary() ?? [];
    bool isFound = allPlayerId
            .where((element) => element == subjectId.toString())
            .isNotEmpty
        ? true
        : false;
    if (isFound) {
      allPlayerId.remove(subjectId.toString());
    } else {
      allPlayerId.add(subjectId.toString());
    }
    _sharedPreferences.setStringList(LIST_PLAYER_LIBRARY, allPlayerId);
  }

  setPlayerList(List<String> ids) async {
    return _sharedPreferences.setStringList(LIST_PLAYER, ids);
  }

  setPlayerListLibrary(List<String> ids) async {
    return _sharedPreferences.setStringList(LIST_PLAYER_LIBRARY, ids);
  }

  Future<void> addORRemovePlayer(int subjectId) async {
    List<String> allPlayerId = await getPlayerList() ?? [];
    bool isFound = allPlayerId
            .where((element) => element == subjectId.toString())
            .isNotEmpty
        ? true
        : false;
    if (isFound) {
      allPlayerId.remove(subjectId.toString());
    } else {
      allPlayerId.add(subjectId.toString());
    }
    _sharedPreferences.setStringList(LIST_PLAYER, allPlayerId);
  }

  Future<void> addTOPlayer(int subjectId) async {
    List<String> allPlayerId = await getPlayerList() ?? [];
    bool isFound = allPlayerId
            .where((element) => element == subjectId.toString())
            .isNotEmpty
        ? true
        : false;
    if (isFound) {
    } else {
      allPlayerId.add(subjectId.toString());
    }
    _sharedPreferences.setStringList(LIST_PLAYER, allPlayerId);
  }

  Future<void> removeFromPlayer(int subjectId) async {
    List<String> allPlayerId = await getPlayerList() ?? [];
    bool isFound = allPlayerId
            .where((element) => element == subjectId.toString())
            .isNotEmpty
        ? true
        : false;
    if (isFound) {
      allPlayerId.remove(subjectId.toString());
    }
    _sharedPreferences.setStringList(LIST_PLAYER, allPlayerId);
  }
}
