import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_constants.dart';
import '../providers/rental_provider.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  Future<void> _launchAppStore() async {
    const url = AppConstants.iosAppStoreUrl; // iOS App Store
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            // Get station ID before resetting
            final rentalProvider = context.read<RentalProvider>();
            final stationId = rentalProvider.stationId;

            // Reset rental state for a fresh start
            rentalProvider.resetRental();

            // Navigate back to payment screen with the same station
            if (stationId != null) {
              context.go('/payment/$stationId');
            } else {
              // Fallback: go to root
              context.go('/');
            }
          },
        ),
      ),
      body: Consumer<RentalProvider>(
        builder: (context, rentalProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recharge.city branding
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8BC34A), // Green color
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'recharge.city',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF8BC34A),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Main Title
                const Text(
                  'Charger Ejected!',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),

                const SizedBox(height: 16),

                // Order ID Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.receipt_outlined, color: Colors.grey.shade700, size: 14),
                      const SizedBox(width: 12),
                      Text(
                        'Order ID: ${rentalProvider.currentRental?.id ?? '#95730630547'}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Rental Information Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.grey.shade700, size: 14),
                          const SizedBox(width: 12),
                          const Text(
                            'Rental information',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        'Power bank ID:',
                        _generatePowerBankId(rentalProvider.currentRental?.id),
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        'Started at:',
                        _formatDateTime(rentalProvider.currentRental?.startTime),
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        'Rental location:',
                        _getRentalLocation(rentalProvider.stationId),
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow('Venue name:', _getVenueName(rentalProvider.stationId)),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // How to end rental section
                const Text(
                  'How to end my rental?',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
                ),

                const SizedBox(height: 16),

                // Step 1
                _buildStep(
                  icon: Icons.location_on_outlined,
                  title: 'Find any Recharge station',
                  subtitle: 'You can use the app to find one near you.',
                ),

                const SizedBox(height: 13),

                // Step 2
                _buildStep(
                  icon: Icons.power_outlined,
                  title: 'Return the charger by inserting it into any empty slot.',
                  subtitle: null,
                ),

                const SizedBox(height: 13),

                // Step 3
                _buildStep(
                  icon: Icons.check_circle_outline,
                  title: 'Rental ends automatically!',
                  subtitle: null,
                ),

                const SizedBox(height: 16),

                // Download App Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: CupertinoButton(
                    onPressed: _launchAppStore,
                    color: const Color(0xFF8BC34A), // Green color
                    child: const Text(
                      'Download App',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Contact support
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // Add contact support functionality
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Nothing happened? ',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const Text(
                          'Contact support',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildStep({required IconData icon, required String title, String? subtitle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
          child: Icon(icon, size: 15, color: Colors.grey.shade700),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _generatePowerBankId(String? rentalId) {
    if (rentalId != null && rentalId.isNotEmpty) {
      // Generate a realistic power bank ID based on rental ID
      return 'RECHRL${rentalId.substring(0, rentalId.length.clamp(0, 10)).padRight(10, '0')}';
    }
    return 'RECHRL3H31100248'; // Fallback
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime != null) {
      return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
    }
    return '${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year} ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}:${DateTime.now().second.toString().padLeft(2, '0')}';
  }

  String _getRentalLocation(String? stationId) {
    if (stationId != null && stationId.isNotEmpty) {
      // Extract location info from station ID or use API data
      if (stationId.contains('RECH')) {
        return 'Recharge Station Location';
      }
    }
    return 'Test location'; // Fallback
  }

  String _getVenueName(String? stationId) {
    if (stationId != null && stationId.isNotEmpty) {
      // You could map station IDs to venue names from API or config
      return 'PowerBank Station ${stationId.substring(stationId.length - 4)}';
    }
    return 'Test location'; // Fallback
  }
}
