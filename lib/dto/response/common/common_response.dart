
import 'package:json_annotation/json_annotation.dart';

part 'common_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class CommonResponse<T> {
  final T content;

  CommonResponse({required this.content});

  factory CommonResponse.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$CommonResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$CommonResponseToJson(this, toJsonT);
}