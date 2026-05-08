// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_data.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillData _$BillDataFromJson(Map<String, dynamic> json) => BillData(
      pinbankSlipId: json['pinbankSlipId'] as String,
      base64Path: json['base64Path'] as String,
      digitableLine: json['digitableLine'] as String,
      barCode: json['barCode'] as String,
      digitalAccountPinbankId: json['digitalAccountPinbankId'] as String,
    );

Map<String, dynamic> _$BillDataToJson(BillData instance) => <String, dynamic>{
      'pinbankSlipId': instance.pinbankSlipId,
      'base64Path': instance.base64Path,
      'digitableLine': instance.digitableLine,
      'barCode': instance.barCode,
      'digitalAccountPinbankId': instance.digitalAccountPinbankId,
    };
