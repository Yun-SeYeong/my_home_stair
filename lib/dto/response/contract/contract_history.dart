import 'package:json_annotation/json_annotation.dart';
import 'package:my_home_stair/dto/response/contract/contract_role.dart';
import 'package:my_home_stair/dto/response/contract/contract_type.dart';

part 'contract_history.g.dart';

@JsonSerializable()
class ContractHistory {
  final String id;
  final bool isDefault;
  final String title;
  final String description;
  final ContractType type;
  final bool isCompleted;
  final String fileURL;
  final String textInput;
  final ContractRole verifyRole;
  final List<String> historyTags;
  final DateTime createdAt;

  ContractHistory(
    this.id,
    this.isDefault,
    this.title,
    this.description,
    this.type,
    this.isCompleted,
    this.fileURL,
    this.textInput,
    this.verifyRole,
    this.historyTags,
    this.createdAt,
  );

  factory ContractHistory.fromJson(Map<String, dynamic> json) =>
      _$ContractHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$ContractHistoryToJson(this);
}
