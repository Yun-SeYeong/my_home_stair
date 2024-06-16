
import 'package:json_annotation/json_annotation.dart';
import 'package:my_home_stair/dto/response/contract/contract_role.dart';
import 'package:my_home_stair/dto/response/contract/contract_status.dart';

import 'contract_step.dart';

part 'contract_detail_response.g.dart';

@JsonSerializable()
class ContractDetailResponse {
  final String id;
  final ContractRole contractRole;
  final String address;
  final String addressDetail;
  final ContractStatus status;
  final List<ContractStep> steps;

ContractDetailResponse({
    required this.id,
    required this.contractRole,
    required this.address,
    required this.addressDetail,
    required this.status,
    required this.steps,
  });

  factory ContractDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$ContractDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ContractDetailResponseToJson(this);
}