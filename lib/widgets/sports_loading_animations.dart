import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:whisperdate/theme_lockerroom.dart';

/// Sports-themed loading animations for LockerRoom Talk
class SportsLoadingAnimations {
  
  /// Basketball bouncing loader
  static Widget basketballLoader({double size = 100}) {
    return Container(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Court background
          Container(
            width: size * 0.8,
            height: size * 0.8,
            decoration: BoxDecoration(
              gradient: LockerRoomColors.courtGradient,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          // Bouncing ball animation
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 800),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, -20 * (1 - value).abs()),
                child: Container(
                  width: size * 0.3,
                  height: size * 0.3,
                  decoration: BoxDecoration(
                    color: LockerRoomColors.basketballOrange,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4 + (20 * value)),
                      ),
                    ],
                  ),
                  child: CustomPaint(
                    painter: BasketballPainter(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Football field loader
  static Widget footballFieldLoader({double width = 200, double height = 100}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LockerRoomColors.fieldGradient,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          // Field lines
          ...List.generate(5, (index) {
            return Positioned(
              left: (width / 5) * index,
              top: 0,
              bottom: 0,
              child: Container(
                width: 2,
                color: Colors.white24,
              ),
            );
          }),
          // Moving football
          AnimatedBuilder(
            animation: AlwaysStoppedAnimation(0),
            builder: (context, child) {
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(seconds: 2),
                curve: Curves.easeInOutCubic,
                onEnd: () {},
                builder: (context, value, child) {
                  return Positioned(
                    left: value * (width - 40),
                    top: height / 2 - 15,
                    child: Container(
                      width: 30,
                      height: 20,
                      decoration: BoxDecoration(
                        color: LockerRoomColors.footballBrown,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  /// Scoreboard counter loading
  static Widget scoreboardLoader({String text = 'LOADING'}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: LockerRoomColors.scoreboardBlack,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: LockerRoomColors.championshipGold, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // LED-style text
          Text(
            text,
            style: const TextStyle(
              color: LockerRoomColors.championshipGold,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: 4,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 8),
          // Score counter animation
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return AnimatedBuilder(
                animation: AlwaysStoppedAnimation(0),
                builder: (context, child) {
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: Duration(milliseconds: 500 + (index * 200)),
                    curve: Curves.easeInOut,
                    onEnd: () {},
                    builder: (context, value, child) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: value > 0.5
                              ? LockerRoomColors.championshipGold
                              : LockerRoomColors.neutral600,
                          shape: BoxShape.circle,
                        ),
                      );
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  /// Trophy shimmer effect
  static Widget trophyShimmer({double size = 150}) {
    return Shimmer.fromColors(
      baseColor: LockerRoomColors.championshipGold.withOpacity(0.3),
      highlightColor: LockerRoomColors.championshipGold,
      period: const Duration(milliseconds: 1500),
      child: Container(
        width: size,
        height: size,
        child: Icon(
          Icons.emoji_events,
          size: size * 0.8,
          color: LockerRoomColors.championshipGold,
        ),
      ),
    );
  }

  /// Stadium wave loader
  static Widget stadiumWaveLoader({double width = 200, double height = 60}) {
    return Container(
      width: width,
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
          return AnimatedBuilder(
            animation: AlwaysStoppedAnimation(0),
            builder: (context, child) {
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: Duration(milliseconds: 200 * (index + 1)),
                curve: Curves.elasticOut,
                onEnd: () {},
                builder: (context, value, child) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 20,
                    height: 20 + (value * 30),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          LockerRoomColors.navyBlue,
                          LockerRoomColors.athleticGreen,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                },
              );
            },
          );
        }),
      ),
    );
  }

  /// Team roster skeleton loader
  static Widget teamRosterSkeleton() {
    return Shimmer.fromColors(
      baseColor: LockerRoomColors.neutral800,
      highlightColor: LockerRoomColors.neutral700,
      child: Column(
        children: List.generate(3, (index) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                // Jersey number
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 12),
                // Player info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 150,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 100,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
                // Stats
                Container(
                  width: 60,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  /// Review card skeleton
  static Widget reviewCardSkeleton() {
    return Shimmer.fromColors(
      baseColor: LockerRoomColors.neutral800,
      highlightColor: LockerRoomColors.neutral700,
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 120,
                        height: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 80,
                        height: 12,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 60,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Content
            Container(
              width: double.infinity,
              height: 60,
              color: Colors.white,
            ),
            const SizedBox(height: 12),
            // Actions
            Row(
              children: [
                Container(width: 80, height: 32, color: Colors.white),
                const SizedBox(width: 8),
                Container(width: 80, height: 32, color: Colors.white),
                const Spacer(),
                Container(width: 40, height: 32, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Success celebration animation
  static Widget victoryCelebration({double size = 200}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Confetti effect
        Container(
          width: size,
          height: size,
          child: CustomPaint(
            painter: ConfettiPainter(),
          ),
        ),
        // Trophy
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 800),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                width: size * 0.5,
                height: size * 0.5,
                decoration: BoxDecoration(
                  gradient: LockerRoomColors.victoryGradient,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.emoji_events,
                  size: size * 0.3,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

/// Custom painter for basketball lines
class BasketballPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black26
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw basketball lines
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );
    
    // Draw curves
    final path = Path();
    path.moveTo(0, size.height * 0.3);
    path.quadraticBezierTo(
      size.width / 2, size.height * 0.2,
      size.width, size.height * 0.3,
    );
    canvas.drawPath(path, paint);
    
    final path2 = Path();
    path2.moveTo(0, size.height * 0.7);
    path2.quadraticBezierTo(
      size.width / 2, size.height * 0.8,
      size.width, size.height * 0.7,
    );
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom painter for confetti
class ConfettiPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final colors = [
      LockerRoomColors.championshipGold,
      LockerRoomColors.athleticGreen,
      LockerRoomColors.navyBlue,
      LockerRoomColors.basketballOrange,
    ];

    for (int i = 0; i < 20; i++) {
      final paint = Paint()
        ..color = colors[i % colors.length].withOpacity(0.7)
        ..style = PaintingStyle.fill;

      final x = (i * 37) % size.width;
      final y = (i * 23) % size.height;
      
      canvas.drawRect(
        Rect.fromLTWH(x, y, 8, 4),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}