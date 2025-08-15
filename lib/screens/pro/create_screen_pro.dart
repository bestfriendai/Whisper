import 'package:flutter/material.dart';
import 'package:whisperdate/theme_modern_2025.dart';

class CreateScreenPro extends StatelessWidget {
  const CreateScreenPro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ModernColors.background,
      appBar: AppBar(
        title: const Text('Create Review'),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rate_review,
              size: 64,
              color: ModernColors.neutral300,
            ),
            const SizedBox(height: 16),
            Text(
              'Share Your Experience',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: ModernColors.neutral900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Help others by sharing your dating experiences',
              style: TextStyle(
                fontSize: 14,
                color: ModernColors.neutral600,
              ),
            ),
            const SizedBox(height: 32),
            ProButton(
              text: 'Write a Review',
              onPressed: () {},
              icon: Icons.edit,
            ),
          ],
        ),
      ),
    );
  }
}