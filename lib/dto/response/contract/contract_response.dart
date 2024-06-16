
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
  final ContractStatus status;
  final DateTime createdAt;

  ContractResponse({
    required this.id,
    required this.address,
    required this.addressDetail,
    required this.contractRole,
    required this.status,
    required this.createdAt,
  });

  factory ContractResponse.fromJson(Map<String, dynamic> json) =>
      _$ContractResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ContractResponseToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContractResponse &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}