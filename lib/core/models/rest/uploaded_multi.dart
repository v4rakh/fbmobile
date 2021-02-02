import 'package:json_annotation/json_annotation.dart';

part 'uploaded_multi.g.dart';

@JsonSerializable()
class UploadedMulti {
  @JsonKey(required: true)
  final String url;

  @JsonKey(required: true, name: "url_id")
  final String urlId;

  UploadedMulti({this.url, this.urlId});

  // JSON Init
  factory UploadedMulti.fromJson(Map<String, dynamic> json) => _$UploadedMultiFromJson(json);

  // JSON Export
  Map<String, dynamic> toJson() => _$UploadedMultiToJson(this);
}
