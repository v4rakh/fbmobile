import 'package:json_annotation/json_annotation.dart';

import 'apikeys.dart';

part 'apikeys_response.g.dart';

@JsonSerializable()
class ApiKeysResponse {
  @JsonKey(required: true)
  final String status;

  @JsonKey(required: true)
  final ApiKeys data;

  ApiKeysResponse({this.status, this.data});

  // JSON Init
  factory ApiKeysResponse.fromJson(Map<String, dynamic> json) => _$ApiKeysResponseFromJson(json);

  // JSON Export
  Map<String, dynamic> toJson() => _$ApiKeysResponseToJson(this);
}
