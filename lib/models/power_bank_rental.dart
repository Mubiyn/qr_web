import 'package:json_annotation/json_annotation.dart';

part 'power_bank_rental.g.dart';

@JsonSerializable()
class PowerBankRental {
  final String? id;
  final String? stationId;
  final String? userId;
  final String? status; // 'pending', 'active', 'completed', 'failed'
  final double? amount;
  final DateTime? startTime;
  final DateTime? endTime;
  final DateTime? createdAt;

  const PowerBankRental({
    this.id,
    this.stationId,
    this.userId,
    this.status,
    this.amount,
    this.startTime,
    this.endTime,
    this.createdAt,
  });

  factory PowerBankRental.fromJson(Map<String, dynamic> json) => _$PowerBankRentalFromJson(json);
  Map<String, dynamic> toJson() => _$PowerBankRentalToJson(this);

  PowerBankRental copyWith({
    String? id,
    String? stationId,
    String? userId,
    String? status,
    double? amount,
    DateTime? startTime,
    DateTime? endTime,
    DateTime? createdAt,
  }) {
    return PowerBankRental(
      id: id ?? this.id,
      stationId: stationId ?? this.stationId,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  bool get isPending => status == 'pending';
  bool get isActive => status == 'active';
  bool get isCompleted => status == 'completed';
  bool get isFailed => status == 'failed';
}
