import 'package:json_annotation/json_annotation.dart';

part 'apikey.g.dart';

@JsonSerializable()
class ApiKey {
  @JsonKey(required: true)
  final String key;

  @JsonKey(required: true)
  final String created;

  @JsonKey(required: true, name: 'access_level')
  final String accessLevel;

  final String comment;

  ApiKey({this.key, this.created, this.accessLevel, this.comment});

  // JSON Init
  factory ApiKey.fromJson(Map<String, dynamic> json) => _$ApiKeyFromJson(json);

  // JSON Export
  Map<String, dynamic> toJson() => _$ApiKeyToJson(this);
}
