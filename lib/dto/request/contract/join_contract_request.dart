

import 'package:json_annotation/json_annotation.dart';
import 'package:my_home_stair/dto/response/contract/contract_role.dart';

part 'join_contract_request.g.dart';

@JsonSerializable()
class JoinContractRequest {
  final String contractId;
  final ContractRole contractRole;

  JoinContractRequest({
    required this.contractId,
    required this.contractRole,
  });

  factory JoinContractRequest.fromJson(Map<String, dynamic> json) =>
      _$JoinContractRequestFromJson(json);

  Map<String, dynamic> toJson() => _$JoinContractRequestToJson(this);
}