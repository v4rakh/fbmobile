import 'package:json_annotation/json_annotation.dart';

part 'rest_error.g.dart';

@JsonSerializable()
class RestError {
  final String status;
  final String message;
  @JsonKey(name: "error_id")
  final String errorId;

  RestError({
    this.status,
    this.message,
    this.errorId,
  }); // JSON Init

  factory RestError.fromJson(Map<String, dynamic> json) => _$RestErrorFromJson(json);

  // JSON Export
  Map<String, dynamic> toJson() => _$RestErrorToJson(this);
}
