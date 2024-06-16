// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract_step.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContractStep _$ContractStepFromJson(Map<String, dynamic> json) => ContractStep(
      $enumDecode(_$ContractStatusEnumMap, json['status']),
      json['requestEnabled'] as bool,
      ContractHistory.fromJson(
          json['contractHistories'] as Map<String, dynamic>),
      DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ContractStepToJson(ContractStep instance) =>
    <String, dynamic>{
      'status': _$ContractStatusEnumMap[instance.status]!,
      'requestEnabled': instance.requestEnabled,
      'contractHistories': instance.contractHistories,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$ContractStatusEnumMap = {
  ContractStatus.roomCheck: 'ROOM_CHECK',
  ContractStatus.provisionalContract: 'PROVISIONAL_CONTRACT',
  ContractStatus.contract: 'CONTRACT',
  ContractStatus.complete: 'COMPLETE',
};
