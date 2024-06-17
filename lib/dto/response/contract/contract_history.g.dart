// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContractHistory _$ContractHistoryFromJson(Map<String, dynamic> json) =>
    ContractHistory(
      json['id'] as String,
      json['isDefault'] as bool,
      json['title'] as String,
      json['description'] as String,
      $enumDecode(_$ContractHistoryTypeEnumMap, json['type']),
      json['isCompleted'] as bool,
      json['fileURL'] as String?,
      json['textInput'] as String?,
      $enumDecode(_$ContractRoleEnumMap, json['verifiedBy']),
      (json['historyTags'] as List<dynamic>).map((e) => e as String).toList(),
      DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ContractHistoryToJson(ContractHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isDefault': instance.isDefault,
      'title': instance.title,
      'description': instance.description,
      'type': _$ContractHistoryTypeEnumMap[instance.type]!,
      'isCompleted': instance.isCompleted,
      'fileURL': instance.fileURL,
      'textInput': instance.textInput,
      'verifiedBy': _$ContractRoleEnumMap[instance.verifiedBy]!,
      'historyTags': instance.historyTags,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$ContractHistoryTypeEnumMap = {
  ContractHistoryType.check: 'CHECK',
  ContractHistoryType.file: 'FILE',
  ContractHistoryType.text: 'TEXT',
};

const _$ContractRoleEnumMap = {
  ContractRole.lessee: 'LESSEE',
  ContractRole.landlord: 'LANDLORD',
  ContractRole.intermediary: 'INTERMEDIARY',
};
