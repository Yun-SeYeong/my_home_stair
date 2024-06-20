// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_file_upload_history_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateFileUploadHistoryRequest _$CreateFileUploadHistoryRequestFromJson(
        Map<String, dynamic> json) =>
    CreateFileUploadHistoryRequest(
      contractId: json['contractId'] as String,
      fileType: json['fileType'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$CreateFileUploadHistoryRequestToJson(
        CreateFileUploadHistoryRequest instance) =>
    <String, dynamic>{
      'contractId': instance.contractId,
      'fileType': instance.fileType,
      'description': instance.description,
    };
