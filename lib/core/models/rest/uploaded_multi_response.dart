import 'package:json_annotation/json_annotation.dart';

import 'uploaded_multi.dart';

part 'uploaded_multi_response.g.dart';

@JsonSerializable()
class UploadedMultiResponse {
  @JsonKey(required: true)
  final String status;

  @JsonKey(required: true)
  final UploadedMulti data;

  UploadedMultiResponse({this.status, this.data});

  // JSON Init
  factory UploadedMultiResponse.fromJson(Map<String, dynamic> json) => _$UploadedMultiResponseFromJson(json);

  // JSON Export
  Map<String, dynamic> toJson() => _$UploadedMultiResponseToJson(this);
}
