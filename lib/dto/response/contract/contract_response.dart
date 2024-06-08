
import 'package:json_annotation/json_annotation.dart';
import 'package:my_home_stair/dto/response/contract/contract_status.dart';

import 'contract_role.dart';

part 'contract_response.g.dart';

@JsonSerializable()
class ContractResponse {
  final String id;
  final String address;
  final String addressDetail;
  final ContractRole contractRole;
  final ContractStatus contractStatus;
  final DateTime createdAt;

  ContractResponse({
    required this.id,
    required this.address,
    required this.addressDetail,
    required this.contractRole,
    required this.contractStatus,
    required this.createdAt,
  });

  factory ContractResponse.fromJson(Map<String, dynamic> json) =>
      _$ContractResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ContractResponseToJson(this);

}