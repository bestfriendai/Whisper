import 'package:flutter/material.dart';
import 'package:whisperdate/theme_modern_2025.dart';

class MessagesScreenPro extends StatelessWidget {
  const MessagesScreenPro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ModernColors.background,
      appBar: AppBar(
        title: const Text('Messages'),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) => _buildMessageItem(index),
      ),
    );
  }
  
  Widget _buildMessageItem(int index) {
    final names = ['Alex', 'Jordan', 'Casey', 'Morgan', 'Taylor'];
    final messages = [
      'Hey! How was your weekend?',
      'That coffee place was amazing!',
      'Looking forward to our next date',
      'Thanks for the great evening',
      'Did you check out that restaurant?',
    ];
    final times = ['2m', '15m', '1h', '3h', 'Yesterday'];
    final unread = [true, true, false, false, false];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: unread[index] ? ModernColors.primary.withOpacity(0.3) : ModernColors.neutral200,
          width: unread[index] ? 1 : 0.5,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: ModernColors.neutral200,
            child: Text(
              names[index][0],
              style: TextStyle(
                color: ModernColors.neutral700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      names[index],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: unread[index] ? FontWeight.w600 : FontWeight.w500,
                        color: ModernColors.neutral900,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      times[index],
                      style: TextStyle(
                        fontSize: 12,
                        color: unread[index] ? ModernColors.primary : ModernColors.neutral500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  messages[index],
                  style: TextStyle(
                    fontSize: 13,
                    color: unread[index] ? ModernColors.neutral700 : ModernColors.neutral600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (unread[index])
            Container(
              margin: const EdgeInsets.only(left: 8),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: ModernColors.primary,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
        ],
      ),
    );
  }
}