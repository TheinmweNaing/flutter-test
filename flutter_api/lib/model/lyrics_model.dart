import 'package:json_annotation/json_annotation.dart';

part 'lyrics_model.g.dart';

@JsonSerializable()
class Lyrics {
  String lyrics;

  Lyrics({
    this.lyrics,
  });

  factory Lyrics.fromJson(Map<String, dynamic> json) => _$LyricsFromJson(json);

  Map<String, dynamic> toJson() => _$LyricsToJson(this);
}
