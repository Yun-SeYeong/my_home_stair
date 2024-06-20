
import 'package:json_annotation/json_annotation.dart';

part 'create_file_upload_history_request.g.dart';

@JsonSerializable()
class CreateFileUploadHistoryRequest {
  final String contractId;
  final String fileType;
  final String description;

  CreateFileUploadHistoryRequest({
    required this.contractId,
    required this.fileType,
    required this.description,
  });

  factory CreateFileUploadHistoryRequest.fromJson(Map<String, dynamic> json) => _$CreateFileUploadHistoryRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateFileUploadHistoryRequestToJson(this);
}