import 'package:json_annotation/json_annotation.dart';

import 'history.dart';

part 'history_response.g.dart';

@JsonSerializable()
class HistoryResponse {
  @JsonKey(required: true)
  final String status;

  @JsonKey(required: true)
  final History data;

  HistoryResponse({this.status, this.data});

  // JSON Init
  factory HistoryResponse.fromJson(Map<String, dynamic> json) => _$HistoryResponseFromJson(json);

  // JSON Export
  Map<String, dynamic> toJson() => _$HistoryResponseToJson(this);
}
