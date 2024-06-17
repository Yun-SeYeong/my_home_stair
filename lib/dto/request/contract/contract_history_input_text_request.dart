import 'package:json_annotation/json_annotation.dart';

part 'contract_history_input_text_request.g.dart';

@JsonSerializable()
class ContractHistoryInputTextRequest {
  String textInput;

  ContractHistoryInputTextRequest(this.textInput);

  Map<String, dynamic> toJson() => {
    'textInput': textInput,
  };

  ContractHistoryInputTextRequest.fromJson(Map<String, dynamic> json)
      : textInput = json['textInput'];
}