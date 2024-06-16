import 'package:json_annotation/json_annotation.dart';
import 'package:my_home_stair/dto/response/contract/contract_role.dart';

part 'contract_request.g.dart';

@JsonSerializable()
class ContractRequest {
  final String address;
  final String addressDetail;
  final ContractRole contractRole;

  ContractRequest({
    required this.address,
    required this.addressDetail,
    required this.contractRole,
  });

  factory ContractRequest.fromJson(Map<String, dynamic> json) =>
      _$ContractRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ContractRequestToJson(this);
}
