// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'join_contract_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JoinContractRequest _$JoinContractRequestFromJson(Map<String, dynamic> json) =>
    JoinContractRequest(
      contractId: json['contractId'] as String,
      contractRole: $enumDecode(_$ContractRoleEnumMap, json['contractRole']),
    );

Map<String, dynamic> _$JoinContractRequestToJson(
        JoinContractRequest instance) =>
    <String, dynamic>{
      'contractId': instance.contractId,
      'contractRole': _$ContractRoleEnumMap[instance.contractRole]!,
    };

const _$ContractRoleEnumMap = {
  ContractRole.lessee: 'LESSEE',
  ContractRole.landlord: 'LANDLORD',
  ContractRole.intermediary: 'INTERMEDIARY',
};
