// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive_file_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArchiveFileResponse _$ArchiveFileResponseFromJson(Map<String, dynamic> json) =>
    ArchiveFileResponse(
      json['contractId'] as String,
      json['historyId'] as String,
      json['address'] as String,
      json['addressDetail'] as String,
      json['fileKey'] as String,
      (json['historyTags'] as List<dynamic>).map((e) => e as String).toList(),
      DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ArchiveFileResponseToJson(
        ArchiveFileResponse instance) =>
    <String, dynamic>{
      'contractId': instance.contractId,
      'historyId': instance.historyId,
      'address': instance.address,
      'addressDetail': instance.addressDetail,
      'fileKey': instance.fileKey,
      'historyTags': instance.historyTags,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
