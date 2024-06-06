
import 'package:json_annotation/json_annotation.dart';

part 'member_response.g.dart';

@JsonSerializable()
class MemberResponse {
  final String id;
  final String email;

  MemberResponse({required this.id, required this.email});

factory MemberResponse.fromJson(Map<String, dynamic> json) =>
      _$MemberResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MemberResponseToJson(this);
}