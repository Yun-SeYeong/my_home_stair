
import 'package:json_annotation/json_annotation.dart';
import 'package:my_home_stair/dto/response/contract/contract_history.dart';
import 'package:my_home_stair/dto/response/contract/contract_status.dart';

part 'contract_step.g.dart';

@JsonSerializable()
class ContractStep {
  final ContractStatus status;
  final bool requestEnabled;
  final List<ContractHistory> contractHistories;
  final DateTime createdAt;

  ContractStep(
      this.status, this.requestEnabled, this.contractHistories, this.createdAt);

  factory ContractStep.fromJson(Map<String, dynamic> json) =>
      _$ContractStepFromJson(json);

  Map<String, dynamic> toJson() => _$ContractStepToJson(this);
}