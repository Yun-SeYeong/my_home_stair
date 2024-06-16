// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContractRequest _$ContractRequestFromJson(Map<String, dynamic> json) =>
    ContractRequest(
      address: json['address'] as String,
      addressDetail: json['addressDetail'] as String,
      contractRole: $enumDecode(_$ContractRoleEnumMap, json['contractRole']),
    );

Map<String, dynamic> _$ContractRequestToJson(ContractRequest instance) =>
    <String, dynamic>{
      'address': instance.address,
      'addressDetail': instance.addressDetail,
      'contractRole': _$ContractRoleEnumMap[instance.contractRole]!,
    };

const _$ContractRoleEnumMap = {
  ContractRole.lessee: 'LESSEE',
  ContractRole.landlord: 'LANDLORD',
  ContractRole.intermediary: 'INTERMEDIARY',
};
