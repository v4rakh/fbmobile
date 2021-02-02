import 'package:json_annotation/json_annotation.dart';

part 'config.g.dart';

@JsonSerializable()
class Config {
  @JsonKey(name: "upload_max_size", required: true)
  final num uploadMaxSize;

  @JsonKey(name: "max_files_per_request", required: true)
  final num maxFilesPerRequest;

  @JsonKey(name: "max_input_vars", required: true)
  final num maxInputVars;

  @JsonKey(name: "request_max_size", required: true)
  final num requestMaxSize;

  Config({this.uploadMaxSize, this.maxFilesPerRequest, this.maxInputVars, this.requestMaxSize});

  // JSON Init
  factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);

  // JSON Export
  Map<String, dynamic> toJson() => _$ConfigToJson(this);
}
