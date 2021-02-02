import 'package:json_annotation/json_annotation.dart';

import 'history_item.dart';
import 'history_multipaste_item.dart';

part 'history.g.dart';

@JsonSerializable()
class History {
  @JsonKey(name: "items")
  final Map<String, HistoryItem> items;

  @JsonKey(name: "multipaste_items")
  final Map<String, HistoryMultipasteItem> multipasteItems;

  @JsonKey(name: "total_size")
  final String totalSize;

  History({this.items, this.multipasteItems, this.totalSize});

  // JSON Init
  factory History.fromJson(Map<String, dynamic> json) => _$HistoryFromJson(json);

  // JSON Export
  Map<String, dynamic> toJson() => _$HistoryToJson(this);
}
