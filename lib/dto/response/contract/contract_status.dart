
import 'package:json_annotation/json_annotation.dart';

enum ContractStatus {
  @JsonValue('ROOM_CHECK')
  roomCheck,
  @JsonValue('PROVISIONAL_CONTRACT')
  provisionalContract,
  @JsonValue('CONTRACT')
  contract,
  @JsonValue('COMPLETE')
  complete,
}