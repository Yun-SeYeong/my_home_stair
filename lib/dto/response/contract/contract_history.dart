import 'package:json_annotation/json_annotation.dart';
import 'package:my_home_stair/dto/response/contract/contract_history_type.dart';
import 'package:my_home_stair/dto/response/contract/contract_role.dart';

part 'contract_history.g.dart';

@JsonSerializable()
class ContractHistory {
  final String id;
  final bool isDefault;
  final String title;
  final String description;
  final ContractHistoryType type;
  final bool isCompleted;
  final String? fileURL;
  final String? textInput;
  final ContractRole verifiedBy;
  final List<String> historyTags;
  final DateTime updatedAt;

  ContractHistory(
    this.id,
    this.isDefault,
    this.title,
    this.description,
    this.type,
    this.isCompleted,
    this.fileURL,
    this.textInput,
    this.verifiedBy,
    this.historyTags,
    this.updatedAt,
  );

  factory ContractHistory.fromJson(Map<String, dynamic> json) =>
      _$ContractHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$ContractHistoryToJson(this);
}
