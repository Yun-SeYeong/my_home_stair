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
      $enumDecode(_$ContractTypeEnumMap, json['type']),
      json['isCompleted'] as bool,
      json['fileURL'] as String,
      json['textInput'] as String,
      $enumDecode(_$ContractRoleEnumMap, json['verifyRole']),
      (json['historyTags'] as List<dynamic>).map((e) => e as String).toList(),
      DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ContractHistoryToJson(ContractHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isDefault': instance.isDefault,
      'title': instance.title,
      'description': instance.description,
      'type': _$ContractTypeEnumMap[instance.type]!,
      'isCompleted': instance.isCompleted,
      'fileURL': instance.fileURL,
      'textInput': instance.textInput,
      'verifyRole': _$ContractRoleEnumMap[instance.verifyRole]!,
      'historyTags': instance.historyTags,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$ContractTypeEnumMap = {
  ContractType.roomCheck: 'ROOM_CHECK',
  ContractType.provisionalContract: 'PROVISIONAL_CONTRACT',
  ContractType.contract: 'CONTRACT',
  ContractType.complete: 'COMPLETE',
};

const _$ContractRoleEnumMap = {
  ContractRole.lessee: 'LESSEE',
  ContractRole.landlord: 'LANDLORD',
  ContractRole.intermediary: 'INTERMEDIARY',
};
