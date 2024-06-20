// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_special_contract_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateSpecialContractRequest _$CreateSpecialContractRequestFromJson(
        Map<String, dynamic> json) =>
    CreateSpecialContractRequest(
      contractId: json['contractId'],
      description: json['description'],
    );

Map<String, dynamic> _$CreateSpecialContractRequestToJson(
        CreateSpecialContractRequest instance) =>
    <String, dynamic>{
      'contractId': instance.contractId,
      'description': instance.description,
    };
