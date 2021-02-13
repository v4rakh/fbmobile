import 'package:json_annotation/json_annotation.dart';

part 'create_apikey_response.g.dart';

@JsonSerializable()
class CreateApiKeyResponse {
  @JsonKey(required: true)
  final String status;

  @JsonKey(required: true)
  final Map<String, String> data;

  CreateApiKeyResponse({this.status, this.data});

  // JSON Init
  factory CreateApiKeyResponse.fromJson(Map<String, dynamic> json) => _$CreateApiKeyResponseFromJson(json);

  // JSON Export
  Map<String, dynamic> toJson() => _$CreateApiKeyResponseToJson(this);
}
