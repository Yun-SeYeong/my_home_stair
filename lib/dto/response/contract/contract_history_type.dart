
import 'package:json_annotation/json_annotation.dart';

enum ContractHistoryType {
  @JsonValue("CHECK")
  check,
  @JsonValue("FILE")
  file,
  @JsonValue("TEXT")
  text
}