// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentMethod _$PaymentMethodFromJson(Map<String, dynamic> json) =>
    PaymentMethod(
      id: json['id'] as String?,
      type: json['type'] as String?,
      token: json['token'] as String?,
      last4: json['last4'] as String?,
      brand: json['brand'] as String?,
      expirationDate: json['expirationDate'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
    );

Map<String, dynamic> _$PaymentMethodToJson(PaymentMethod instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'token': instance.token,
      'last4': instance.last4,
      'brand': instance.brand,
      'expirationDate': instance.expirationDate,
      'isDefault': instance.isDefault,
    };
