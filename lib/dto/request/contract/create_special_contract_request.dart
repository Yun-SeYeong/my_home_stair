
import 'package:json_annotation/json_annotation.dart';

part 'create_special_contract_request.g.dart';

@JsonSerializable()
class CreateSpecialContractRequest {
  final contractId;
  final description;

  CreateSpecialContractRequest({
    required this.contractId,
    required this.description,
  });

  factory CreateSpecialContractRequest.fromJson(Map<String, dynamic> json) => _$CreateSpecialContractRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateSpecialContractRequestToJson(this);
}