import 'package:json_annotation/json_annotation.dart';

import 'uploaded.dart';

part 'uploaded_response.g.dart';

@JsonSerializable()
class UploadedResponse {
  @JsonKey(required: true)
  final String status;

  @JsonKey(required: true)
  final Uploaded data;

  UploadedResponse({this.status, this.data});

  // JSON Init
  factory UploadedResponse.fromJson(Map<String, dynamic> json) => _$UploadedResponseFromJson(json);

  // JSON Export
  Map<String, dynamic> toJson() => _$UploadedResponseToJson(this);
}
