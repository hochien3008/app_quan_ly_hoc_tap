import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const TopWaveHeader(),
          const SizedBox(height: 24),
          Text(
            'Welcome !',
            style: GoogleFonts.lato(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Colors.lightBlue,
            ),
          ),
          const SizedBox(height: 32),
          _buildGradientButton(
            text: 'Create Account',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RegisterScreen()),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildOutlinedButton(
            text: 'Login',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
          const SizedBox(height: 32),
          _buildSocialIcons(),
        ],
      ),
    );
  }

  Widget _buildGradientButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6D5DF6), Color(0xFF52B6F4)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOutlinedButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFF6D5DF6), width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          minimumSize: const Size.fromHeight(48),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF6D5DF6),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialIcons() {
    const iconSize = 32.0;
    const spacing = 16.0;
    return Column(
      children: [
        const SizedBox(height: 8),
        const Text(
          "Sign in with another account",
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.alternate_email,
              color: Color(0xFF6D5DF6),
              size: iconSize,
            ),
            SizedBox(width: spacing),
            Icon(Icons.business, color: Color(0xFF6D5DF6), size: iconSize),
            SizedBox(width: spacing),
            Icon(Icons.facebook, color: Color(0xFF6D5DF6), size: iconSize),
            SizedBox(width: spacing),
            Icon(Icons.g_mobiledata, color: Color(0xFF6D5DF6), size: iconSize),
          ],
        ),
      ],
    );
  }
}

class TopWaveHeader extends StatefulWidget {
  const TopWaveHeader({super.key});

  @override
  State<TopWaveHeader> createState() => _TopWaveHeaderState();
}

class _TopWaveHeaderState extends State<TopWaveHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(); // chạy lặp
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 380,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              _buildWaveLayer(
                SmoothWaveClipper(_controller.value),
                340,
                1.0,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/icons/logo.png', height: 128),
                      const SizedBox(height: 6),
                      const Text(
                        'MCG',
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWaveLayer(
    CustomClipper<Path> clipper,
    double height,
    double opacity, {
    Widget? child,
  }) {
    return ClipPath(
      clipper: clipper,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 126, 113, 243).withOpacity(opacity),
              const Color.fromARGB(255, 100, 192, 248).withOpacity(opacity),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: child,
      ),
    );
  }
}

class SmoothWaveClipper extends CustomClipper<Path> {
  final double animationValue;

  SmoothWaveClipper(this.animationValue);

  @override
  Path getClip(Size size) {
    final path = Path();

    // Biên độ dao động từ 10 -> 30 theo animation
    double waveHeight = 6 + sin(animationValue * 2 * pi) * 3;

    double waveLength = 6 * pi; // Nhiều sóng hơn

    path.lineTo(0, size.height - waveHeight);

    for (double i = 0; i <= size.width; i++) {
      double y =
          sin((i / size.width * waveLength) + (animationValue * 2 * pi)) *
              waveHeight +
          (size.height - waveHeight);
      path.lineTo(i, y);
    }

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
