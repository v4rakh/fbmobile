import 'package:json_annotation/json_annotation.dart';

part 'session.g.dart';

@JsonSerializable()
class Session {
  final String url;
  final String apiKey;

  Session({this.url, this.apiKey});

  Session.initial()
      : url = '',
        apiKey = '';

  factory Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);

  Map<String, dynamic> toJson() => _$SessionToJson(this);
}
