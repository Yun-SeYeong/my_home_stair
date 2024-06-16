// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reissue_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReissueRequest _$ReissueRequestFromJson(Map<String, dynamic> json) =>
    ReissueRequest(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );

Map<String, dynamic> _$ReissueRequestToJson(ReissueRequest instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
    };
