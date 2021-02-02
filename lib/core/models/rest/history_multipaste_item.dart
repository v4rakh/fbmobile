import 'package:json_annotation/json_annotation.dart';

import 'history_item.dart';

part 'history_multipaste_item.g.dart';

@JsonSerializable()
class HistoryMultipasteItem {
  final String date;
  final Map<String, HistoryItem> items;

  @JsonKey(name: "url_id")
  final String urlId;

  HistoryMultipasteItem({this.date, this.items, this.urlId});

  // JSON Init
  factory HistoryMultipasteItem.fromJson(Map<String, dynamic> json) => _$HistoryMultipasteItemFromJson(json);

  // JSON Export
  Map<String, dynamic> toJson() => _$HistoryMultipasteItemToJson(this);
}
