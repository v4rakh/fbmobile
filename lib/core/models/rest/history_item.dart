import 'package:json_annotation/json_annotation.dart';

part 'history_item.g.dart';

@JsonSerializable()
class HistoryItem {
  @JsonKey(required: true)
  final String id;
  final String date;
  final String filename;
  final String filesize;
  final String hash;
  final String mimetype;
  final String thumbnail;

  HistoryItem({this.date, this.filename, this.filesize, this.hash, this.id, this.mimetype, this.thumbnail});

  // JSON Init
  factory HistoryItem.fromJson(Map<String, dynamic> json) => _$HistoryItemFromJson(json);

  // JSON Export
  Map<String, dynamic> toJson() => _$HistoryItemToJson(this);
}
