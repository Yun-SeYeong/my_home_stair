import 'package:json_annotation/json_annotation.dart';

enum ContractRole {
  @JsonValue("LESSEE")
  lessee,
  @JsonValue("LANDLORD")
  landlord,
  @JsonValue("INTERMEDIARY")
  intermediary
}
