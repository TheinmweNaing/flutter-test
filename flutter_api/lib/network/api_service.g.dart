// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _ApiService implements ApiService {
  _ApiService(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    baseUrl ??= 'https://api.lyrics.ovh/v1/';
  }

  final Dio _dio;

  String baseUrl;

  @override
  Future<Lyrics> getLyrics(artist, title) async {
    ArgumentError.checkNotNull(artist, 'artist');
    ArgumentError.checkNotNull(title, 'title');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('$artist/$title',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = Lyrics.fromJson(_result.data);
    return value;
  }
}
