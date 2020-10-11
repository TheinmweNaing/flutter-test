import 'package:dio/dio.dart';
import 'package:flutter_api/model/lyrics_model.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: "https://api.lyrics.ovh/v1/")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  static ApiService create() {
    final dio = Dio();
    dio.interceptors.add(PrettyDioLogger());
    return ApiService(dio);
  }

  @GET("{artist}/{title}")
  Future<Lyrics> getLyrics(
      @Path("artist") String artist, @Path("title") String title);
}
