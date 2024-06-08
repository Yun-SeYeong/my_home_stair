// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContractResponse _$ContractResponseFromJson(Map<String, dynamic> json) =>
    ContractResponse(
      id: json['id'] as String,
      address: json['address'] as String,
      addressDetail: json['addressDetail'] as String,
      contractRole: $enumDecode(_$ContractRoleEnumMap, json['contractRole']),
      contractStatus:
          $enumDecode(_$ContractStatusEnumMap, json['contractStatus']),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ContractResponseToJson(ContractResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'address': instance.address,
      'addressDetail': instance.addressDetail,
      'contractRole': _$ContractRoleEnumMap[instance.contractRole]!,
      'contractStatus': _$ContractStatusEnumMap[instance.contractStatus]!,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$ContractRoleEnumMap = {
  ContractRole.lessee: 'LESSEE',
  ContractRole.landlord: 'LANDLORD',
  ContractRole.intermediary: 'INTERMEDIARY',
};

const _$ContractStatusEnumMap = {
  ContractStatus.roomCheck: 'ROOM_CHECK',
  ContractStatus.provisionalContract: 'PROVISIONAL_CONTRACT',
  ContractStatus.contract: 'CONTRACT',
  ContractStatus.complete: 'COMPLETE',
};
