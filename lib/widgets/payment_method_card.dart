import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../providers/payment_provider.dart';

class PaymentMethodCard extends StatelessWidget {
  final PaymentType paymentType;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodCard({
    super.key,
    required this.paymentType,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(AppColors.cardBackground),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(AppColors.primaryBlue) : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getIconBackgroundColor().withValues(alpha: .1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_getIcon(), color: _getIconColor(), size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getTitle(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(AppColors.textPrimary),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getSubtitle(),
                    style: const TextStyle(fontSize: 14, color: Color(AppColors.textSecondary)),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(AppColors.primaryBlue) : Colors.grey.shade400,
                  width: 2,
                ),
                color: isSelected ? const Color(AppColors.primaryBlue) : Colors.transparent,
              ),
              child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (paymentType) {
      case PaymentType.applePay:
        return Icons.apple;
      case PaymentType.card:
        return Icons.credit_card;
    }
  }

  Color _getIconColor() {
    switch (paymentType) {
      case PaymentType.applePay:
        return Colors.black;
      case PaymentType.card:
        return const Color(AppColors.primaryBlue);
    }
  }

  Color _getIconBackgroundColor() {
    switch (paymentType) {
      case PaymentType.applePay:
        return Colors.black;
      case PaymentType.card:
        return const Color(AppColors.primaryBlue);
    }
  }

  String _getTitle() {
    switch (paymentType) {
      case PaymentType.applePay:
        return AppConstants.applePayButton;
      case PaymentType.card:
        return AppConstants.cardPayButton;
    }
  }

  String _getSubtitle() {
    switch (paymentType) {
      case PaymentType.applePay:
        return 'Быстрая и безопасная оплата';
      case PaymentType.card:
        return 'Оплата банковской картой';
    }
  }
}
