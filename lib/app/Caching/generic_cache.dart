import 'dart:convert';

import '../../data/network/error_handler.dart';
import '../../data/network/failure.dart';
import '../constants.dart';
import 'AppResponseCacheService.dart';

AppResponseCacheService cacheService =
    AppResponseCacheService.getInstance(GenericCache);

abstract class CacheDataSource {
  _getDataFromCache<T>(
      String cacheKey, int interval, Function fromJson, bool isConnected);
}

class GenericCache implements CacheDataSource {
  GenericCache();
  GenericCache._() {}
  static final GenericCache instance = GenericCache._();

  Future<bool> deleteRecoredByKey<T>(String? key) async {
    try {
      String keyForCacheKey = "general-$key";
      AppResponseCacheData? akCache = AppResponseCacheData();
      List<String>? additionalKeys = [];
      akCache = await cacheService.getDataFromCache<List<String>>(
          keyForCacheKey, false, 1000000);
      print("key >>>>> $key");
      print("keyForCacheKey >>>>> $keyForCacheKey");
      if (akCache != null) {
        for (int i = 0;
            i < json.decode(json.encode(akCache.responseData)).length;
            i++) {
          print("delete akCache====> ${akCache.responseData[i].toString()}");
          additionalKeys.add(akCache.responseData[i].toString());
        }
        for (var element in additionalKeys) {
          print("element1 $element");
          print("element2 $keyForCacheKey $element");
          print("element3 $key - $element");
          await cacheService.deleteRecoredByKey<T>(element);
        }
        await cacheService.deleteRecoredByKey<List<String>>(keyForCacheKey);
      }
      return await cacheService.deleteRecoredByKey<T>(key);
    } catch (e) {
      print("cacheService errror >>> $e");
    }
    return false;
  }

  Future<T?> getCacheResultCore<T>(
      Function remote, String cacheKey, Function fromJson, bool isConnected,
      {int? cacheTimeInterval, String? additionalFilter}) async {
    String fullCacheKey = "$cacheKey - ${additionalFilter ?? ''}";
    try {
      // get response from cache
      final response = await _getDataFromCache<T>(
          fullCacheKey,
          cacheTimeInterval ?? Constants.CACHE_TIME_INTERVAL,
          fromJson,
          isConnected);
      print("getDataFromCache..... $fullCacheKey");
      return response;
    } catch (cacheError) {
      try {
        final response = await remote.call();
        var data;
        print('Response OF CACHE ${response}');
        if (response != null) {
          if (response is List) {
            response.map((e) {
              data = e.toJson();
              data = e.toJson();
              // use decode / encode to convert data to json to can save data in local data base
              data = json.decode(json.encode(e));
              print("fullDATA >>>>>>> $data");
            });
          } else {
            data = response.toJson();
            data = response.toJson();
            // use decode / encode to convert data to json to can save data in local data base
            data = json.decode(json.encode(response));
            print("fullDATA >>>>>>> $data");
          }

          //saveDataToCache
          try {
            print("fullCacheKey >>>>>>> $fullCacheKey");
            await cacheService.saveDataToRunTimeCache(response, fullCacheKey);
            await cacheService.createARC<T>(AppResponseCacheData(
              key: fullCacheKey,
              createdAt: DateTime.now(),
              responseData: data,
            ));

            //
            String keyForCacheKey = "general-$cacheKey";
            List<String> additionalKeys = [];
            AppResponseCacheData? akCache = AppResponseCacheData();
            akCache = await cacheService.getDataFromCache<List<String>>(
                keyForCacheKey, isConnected, cacheTimeInterval ?? 0);

            if (akCache == null) {
              print('JSONENCODE ${json.encode(additionalKeys)}');
              print('ADDITIONALKEY ${additionalKeys}');
              print('keyForCacheKey $keyForCacheKey');
              print("no akCache >>>> $keyForCacheKey $additionalFilter");
              additionalKeys.add(fullCacheKey);
              await cacheService.createARC<List<String>>(AppResponseCacheData(
                key: keyForCacheKey,
                createdAt: DateTime.now(),
                responseData: additionalKeys,
              ));
            } else {
              for (int i = 0; i < akCache.responseData.length; i++) {
                additionalKeys.add(akCache.responseData[i].toString());
              }
              bool isNewAdditionalKey = additionalKeys
                      .where((element) => element == keyForCacheKey)
                      .toList()
                      .isEmpty
                  ? true
                  : false;
              if (isNewAdditionalKey) {
                print("fullCacheKey $fullCacheKey ${fullCacheKey.length}");
                print('JSONENCODE ${json.encode(additionalKeys)}');
                additionalKeys.add(fullCacheKey);

                await cacheService.createARC<List<String>>(AppResponseCacheData(
                  key: keyForCacheKey,
                  createdAt: DateTime.now(),
                  responseData: json.decode(json.encode(additionalKeys)),
                ));
              }
            }
          } catch (e) {
            print("error in save to cache  $e");
          }
          print("getDataFromRemote..... ");
          return response;
        } else {
          throw Failure(ApiInternalStatus.FAILURE,
              response.error?.message ?? ResponseMessage.DEFAULT);
        }
      } catch (error) {
        print("Error IN GENERIC CACHE ${error.toString()}");
        throw ErrorHandler.handle(error).failure;
      }
    }
  }

  @override
  _getDataFromCache<T>(
      String cacheKey, int interval, fromJson2, bool isConnected) async {
    //print("interval*************** ${interval}");
    dynamic res =
        await cacheService.getDataFromCache<T>(cacheKey, isConnected, interval);
    // print("res >>>>>>> ${res.runtimeType}");
    // print("(res == null) ${(res == null)}");
    // print("(res ) ${(res)}");
    if (res == null) throw ErrorHandler.handle(DataSource.CACHE_ERROR);
    if (res.runtimeType != AppResponseCacheData) {
      print("return from cache not server");
      return res;
    }

    final cacheDataResponse = res;
    try {
      var newItem2 = fromJson2(cacheDataResponse.responseData);
      cacheDataResponse.responseData = newItem2;
      CachedItem cachedItem = CachedItem(cacheDataResponse.responseData);

      //AppShared.cacheMap[cacheKey]=  cacheDataResponse;
      cacheService.saveCacheDataToRunTimeCache(
          cacheDataResponse.responseData, cacheKey);
      if (cachedItem.isValid(interval,
          cacheDataResponse.createdAt ?? DateTime.now(), !isConnected)) {
        // return the response from cache
        return cachedItem.data;
      }
    } catch (e) {
      print("ErrorgetDataFromCache........ $e");
    }
    // return an error that cache is not there or its not valid
    throw ErrorHandler.handle(DataSource.CACHE_ERROR);
  }
}
