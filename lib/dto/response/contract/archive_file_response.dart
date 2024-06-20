
import 'package:json_annotation/json_annotation.dart';

part 'archive_file_response.g.dart';

@JsonSerializable()
class ArchiveFileResponse {
  final String contractId;
  final String historyId;
  final String address;
  final String addressDetail;
  final String fileKey;
  final List<String> historyTags;
  final DateTime updatedAt;

  ArchiveFileResponse(
    this.contractId,
    this.historyId,
    this.address,
    this.addressDetail,
    this.fileKey,
    this.historyTags,
    this.updatedAt,
  );

  factory ArchiveFileResponse.fromJson(Map<String, dynamic> json) =>
      _$ArchiveFileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ArchiveFileResponseToJson(this);
}