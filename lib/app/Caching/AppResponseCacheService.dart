import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class AppResponseCacheData {
  String? key;

  DateTime? createdAt;

  dynamic responseData;

  bool? isNeedSync;

  AppResponseCacheData(
      {this.key, this.createdAt, this.responseData, this.isNeedSync = false});

  static AppResponseCacheData fromJson(Map<String, dynamic> json) {
    return AppResponseCacheData(
      key: json['key'],
      createdAt: DateTime.tryParse(json['DateTime']),
      responseData: json['responseData'],
      isNeedSync: json['isNeedSync'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['DateTime'] = this.createdAt!.toIso8601String();
    data['responseData'] = this.responseData;
    data['isNeedSync'] = this.isNeedSync;
    return data;
  }

  AppResponseCacheData clone(
      {dynamic newResponseData, bool newIsNeedSync = true}) {
    return AppResponseCacheData(
      key: this.key,
      createdAt: this.createdAt,
      responseData: newResponseData ?? this.responseData,
      isNeedSync: this.isNeedSync, //newIsNeedSync ??
    );
  }
}

class AppResponseCacheService {
  static String _dbPath = "AppCacheResponse";
  static String? _prefixStore;

  DatabaseFactory? _dbFactory;
  Database? _database;

  AppResponseCacheService._internal();

  static Map<String, CachedItem> cacheMap = Map();

  static AppResponseCacheService _instance =
      AppResponseCacheService._internal();

  static getInstance(Type type) {
    _prefixStore = type.toString();
    return _instance;
  }

  static initInstance() async {
    await _instance._init();
  }

  _init() async {
    try {
      print("Database INtilizeing");
      _dbFactory = databaseFactoryIo;
      final path = await getApplicationDocumentsDirectory();
      _dbPath = path.path + '/' + "AppCacheResponse";
      _database = await _dbFactory!.openDatabase(_dbPath);
      return true;
    } catch (_) {}
    return false;
  }

  void removeFromCache(String key) {
    try {
      cacheMap.remove(key);
    } catch (e) {
      print("removeFromCache errrrrrrrrr is $e");
    }
  }

  static void clearRunTimeCache() {
    cacheMap.clear();
  }

  Future<bool> deleteRecoredByKey<T>(String? key) async {
    StoreRef store =
        intMapStoreFactory.store(_prefixStore! + "_" + T.toString());
    print("store name?>>>>>>> ${store.name}");
    try {
      removeFromCache(key ?? '');
      var finder = Finder(
        filter: Filter.equals("key", key),
      );
      await store.delete(_database!, finder: finder);
      return true;
    } catch (e) {
      return false;
    }
  }

  getDataFromCache<T>(String key, bool isConnected, int interval) async {
    print("key ........... $key");
    if (cacheMap[key]?.data != null) {
      CachedItem cachedItem = cacheMap[key]!;
      print("cachedItem.cacheTime*** ${cachedItem.cacheTime}");
      if (cachedItem.isValid(
          interval,
          DateTime.fromMillisecondsSinceEpoch(cachedItem.cacheTime),
          !isConnected)) {
        print("Data from run time cache");
        return cachedItem.data;
      }
    } else {
      print("Data from run Local db ");
      print("***********< ${await getRecoredByKey<T>(key)}");
      return await getRecoredByKey<T>(key);
    }
  }

  Future<void> saveDataToRunTimeCache(response, key) async {
    try {
      cacheMap[key] = CachedItem(response);
      print("saved Done ??>>>>");
    } catch (e) {
      print("cache errrrrrrrrr is $e");
    }
  }

  Future<void> saveCacheDataToRunTimeCache(response, cacheKey) async {
    try {
      cacheMap[cacheKey] = response;
    } catch (e) {}
  }

  Future<AppResponseCacheData?>? getRecoredByKey<T>(String key) async {
    print("getRecoredByKey===> $key");
    try {
      final items = await _getByKey<T>(key);
      if (items.isNotEmpty) {
        return items.values.toList()[0];
      }
    } catch (e) {
      print('ERROR IN GET RECORDED BY Key $e');
      return null;
    }
    return null;
  }

  Future<List<AppResponseCacheData>?> getARCs<T>() async {
    final items = await _getAll<T>();
    return items.values.toList();
  }

  Future createARC<T>(AppResponseCacheData resCacheData) async {
    print('CREATE ARC ${resCacheData.key}');
    final findByKey = await _getByKey<T>(resCacheData.key);
    if (findByKey.length > 0) {
      await _updateDataByKey<T>(
          findByKey.keys.toList()[0], resCacheData.toJson());
    } else {
      await _storeInDb<T>(resCacheData.toJson());
    }
  }

  static Future clearAllAppCacheResponse() async {
    clearRunTimeCache();
    await _instance._database!.close();
    await _instance._dbFactory!.deleteDatabase(_dbPath);
    await initInstance();
  }

  // Storage

  _storeInDb<T>(Map<String, dynamic> data) async {
    StoreRef store =
        intMapStoreFactory.store(_prefixStore! + "_" + T.toString());
    print("save data ${store.name}");
    await store.add(_database!, data);
  }

  Future<Map<int, AppResponseCacheData>> _getByKey<T>(String? key) async {
    print("SSSSSSSSSSSSSSSSSSSSSS ${_prefixStore}");
    print("SSSSSSSSSSSSSSSSSSSSSS ${key}");
    print("SSSSSSSSSSSSSSSSSSSSSS ${_database}");
    StoreRef store =
        intMapStoreFactory.store(_prefixStore! + "_" + T.toString());
    var finder = Finder(
      filter: Filter.equals("key", key),
    );
    dynamic result = await store.find(_database!, finder: finder);
    print('WHat is Result $result ');
    return (result.length > 0)
        ? {result[0].key: AppResponseCacheData.fromJson(result[0].value)}
        : {};
  }

  Future<Map<int, AppResponseCacheData>> _getAll<T>() async {
    Map<int, AppResponseCacheData> items = {};
    StoreRef store =
        intMapStoreFactory.store(_prefixStore! + "_" + T.toString());
    dynamic result = await store.find(_database!);
    result.forEach((element) =>
        items[element.key] = AppResponseCacheData.fromJson(element.value));
    return items;
  }

  _updateDataByKey<T>(int key, Map<String, dynamic> data) async {
    StoreRef store =
        intMapStoreFactory.store(_prefixStore! + "_" + T.toString());
    await store.record(key).update(_database!, data);
    return null;
  }
}

// run time cache
class CachedItem {
  dynamic data;
  int cacheTime = DateTime.now().millisecondsSinceEpoch;
  CachedItem(this.data);
}

extension CachedItemExtension on CachedItem {
  bool isValid(int expirationTimeInMillis, DateTime cacheTime, isOffline) {
    print("cacheTime >>>>>>> ${cacheTime.millisecondsSinceEpoch}");
    if (isOffline) return true;
    int currentTimeInMillis = DateTime.now().millisecondsSinceEpoch;
    bool isValid = currentTimeInMillis - cacheTime.millisecondsSinceEpoch <=
        expirationTimeInMillis;
    return isValid;
  }
}
