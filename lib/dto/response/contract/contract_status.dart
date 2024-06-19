
import 'package:json_annotation/json_annotation.dart';

enum ContractStatus {
  @JsonValue('ROOM_CHECK')
  roomCheck("방확인"),
  @JsonValue('PROVISIONAL_CONTRACT')
  provisionalContract("가계약"),
  @JsonValue('CONTRACT')
  contract("실계약"),
  @JsonValue('COMPLETED')
  complete("완료"),
  @JsonValue('EXPIRED')
  expired("만료");

  final String name;

  const ContractStatus(this.name);
}