import 'package:json_annotation/json_annotation.dart';

enum ContractRole {
  @JsonValue("LESSEE")
  lessee("임대인"),
  @JsonValue("LANDLORD")
  landlord("중계인"),
  @JsonValue("INTERMEDIARY")
  intermediary("임차인");

  final String name;

  const ContractRole(this.name);
}
