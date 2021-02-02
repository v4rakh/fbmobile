import 'package:json_annotation/json_annotation.dart';

part 'uploaded.g.dart';

@JsonSerializable()
class Uploaded {
  @JsonKey(required: true)
  final List<String> ids;

  @JsonKey(required: true)
  final List<String> urls;

  Uploaded({this.ids, this.urls});

  // JSON Init
  factory Uploaded.fromJson(Map<String, dynamic> json) => _$UploadedFromJson(json);

  // JSON Export
  Map<String, dynamic> toJson() => _$UploadedToJson(this);
}
