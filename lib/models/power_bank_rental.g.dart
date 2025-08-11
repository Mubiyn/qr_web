// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'power_bank_rental.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PowerBankRental _$PowerBankRentalFromJson(Map<String, dynamic> json) =>
    PowerBankRental(
      id: json['id'] as String?,
      stationId: json['stationId'] as String?,
      userId: json['userId'] as String?,
      status: json['status'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$PowerBankRentalToJson(PowerBankRental instance) =>
    <String, dynamic>{
      'id': instance.id,
      'stationId': instance.stationId,
      'userId': instance.userId,
      'status': instance.status,
      'amount': instance.amount,
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
    };
