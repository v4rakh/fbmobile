import 'package:json_annotation/json_annotation.dart';

part 'uploaded_paste.g.dart';

@JsonSerializable()
class UploadedPaste {
  final DateTime date;
  final String filename;
  final num filesize;
  final String hash;
  final String id;
  final String mimetype;
  final String thumbnail;
  final bool isMulti;
  final List<String> items;

  UploadedPaste(
      {this.date,
      this.filename,
      this.filesize,
      this.hash,
      this.id,
      this.mimetype,
      this.thumbnail,
      this.isMulti,
      this.items});

  // JSON Init
  factory UploadedPaste.fromJson(Map<String, dynamic> json) => _$UploadedPasteFromJson(json);

  // JSON Export
  Map<String, dynamic> toJson() => _$UploadedPasteToJson(this);
}
