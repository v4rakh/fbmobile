import 'package:json_annotation/json_annotation.dart';

import 'rest/config.dart';

part 'session.g.dart';

@JsonSerializable()
class Session {
  final String url;
  final String apiKey;
  final Config config;

  Session({this.url, this.apiKey, this.config});

  Session.initial()
      : url = '',
        apiKey = '',
        config = null;

  factory Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);

  Map<String, dynamic> toJson() => _$SessionToJson(this);
}
