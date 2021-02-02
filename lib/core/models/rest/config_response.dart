import 'package:json_annotation/json_annotation.dart';

import 'config.dart';

part 'config_response.g.dart';

@JsonSerializable()
class ConfigResponse {
  @JsonKey(required: true)
  final String status;

  @JsonKey(required: true)
  final Config data;

  ConfigResponse({this.status, this.data});

  // JSON Init
  factory ConfigResponse.fromJson(Map<String, dynamic> json) => _$ConfigResponseFromJson(json);

  // JSON Export
  Map<String, dynamic> toJson() => _$ConfigResponseToJson(this);
}
