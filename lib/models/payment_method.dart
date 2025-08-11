import 'package:json_annotation/json_annotation.dart';

part 'payment_method.g.dart';

@JsonSerializable()
class PaymentMethod {
  final String? id;
  final String? type; // 'card', 'apple_pay'
  final String? token;
  final String? last4;
  final String? brand;
  final String? expirationDate;
  final bool isDefault;

  const PaymentMethod({
    this.id,
    this.type,
    this.token,
    this.last4,
    this.brand,
    this.expirationDate,
    this.isDefault = false,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => _$PaymentMethodFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentMethodToJson(this);

  PaymentMethod copyWith({
    String? id,
    String? type,
    String? token,
    String? last4,
    String? brand,
    String? expirationDate,
    bool? isDefault,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      type: type ?? this.type,
      token: token ?? this.token,
      last4: last4 ?? this.last4,
      brand: brand ?? this.brand,
      expirationDate: expirationDate ?? this.expirationDate,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  bool get isCard => type == 'card';
  bool get isApplePay => type == 'apple_pay';
}
