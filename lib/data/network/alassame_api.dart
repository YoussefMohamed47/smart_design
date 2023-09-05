import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import '../../app/constants.dart';
part 'alassame_api.g.dart';

@RestApi(baseUrl: Constants.baseUrl)
abstract class AppCategoriesServiceClient {
  factory AppCategoriesServiceClient(Dio dio, {String baseUrl}) =
      _AppCategoriesServiceClient;

//   @GET(
//       "/categories?is_featured=1&limit=${Constants.PAGE_SIZED_CATEGORY}&page={pageNumber}")
//   Future<CategoriesResponse> getFamousaCategories(@Path() int pageNumber);

//   // @POST("/khotab/playlist?ids={ids}?page={pageNumber}&limit=10000")
//   // Future<PlayerResponse> getPlayer(@Path() String ids,@Path() int pageNumber);

// //ids={ids}?page={pageNumber}&
//   @POST("/khotab/playlist?limit=10000")
//   Future<PlayerResponse> getPlayer(
//     @Field("ids") String ids,
//   );
}
