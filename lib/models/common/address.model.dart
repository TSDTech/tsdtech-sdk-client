import 'package:json_annotation/json_annotation.dart';
import 'package:voucherize/core/utils/unix_datetime.decorator.dart';

part 'address.model.g.dart';

@JsonSerializable()
class AddressModel {
  final String id;

  @UnixDateTimeConverter()
  final DateTime createdAtUtc;

  final String countryCode;
  final String street;
  final String number;
  final String complement;
  final String district;
  final String city;
  final String state;
  final String zipCode;

  AddressModel({
    required this.id,
    required this.createdAtUtc,
    this.countryCode = 'BR',
    required this.street,
    required this.number,
    required this.complement,
    required this.district,
    required this.city,
    required this.state,
    required this.zipCode,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddressModelToJson(this);
}
