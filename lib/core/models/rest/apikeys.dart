import 'package:json_annotation/json_annotation.dart';

import 'apikey.dart';

part 'apikeys.g.dart';

@JsonSerializable()
class ApiKeys {
  @JsonKey(name: "items")
  final Map<String, ApiKey> apikeys;

  ApiKeys({this.apikeys});

  // JSON Init
  factory ApiKeys.fromJson(Map<String, dynamic> json) => _$ApiKeysFromJson(json);

  // JSON Export
  Map<String, dynamic> toJson() => _$ApiKeysToJson(this);
}
