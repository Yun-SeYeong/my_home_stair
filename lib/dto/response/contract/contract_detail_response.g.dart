// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContractDetailResponse _$ContractDetailResponseFromJson(
        Map<String, dynamic> json) =>
    ContractDetailResponse(
      id: json['id'] as String,
      contractRole: $enumDecode(_$ContractRoleEnumMap, json['contractRole']),
      address: json['address'] as String,
      addressDetail: json['addressDetail'] as String,
      status: $enumDecode(_$ContractStatusEnumMap, json['status']),
      steps: (json['steps'] as List<dynamic>)
          .map((e) => ContractStep.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ContractDetailResponseToJson(
        ContractDetailResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'contractRole': _$ContractRoleEnumMap[instance.contractRole]!,
      'address': instance.address,
      'addressDetail': instance.addressDetail,
      'status': _$ContractStatusEnumMap[instance.status]!,
      'steps': instance.steps,
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
