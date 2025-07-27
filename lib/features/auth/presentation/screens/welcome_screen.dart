import 'package:flutter/material.dart';
import '../../../../routes/route_names.dart';

class WelcomeScreen extends StatelessWidget {
  static const List<Color> mainGradient = [
    Color(0xFF232526), // dark gray
    Color(0xFF414345), // blue-gray
  ];
  static const Color mainColor = Color(0xFF4FC3F7); // modern blue

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: mainGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo with glow effect
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Vòng sáng phía sau
                      Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              mainColor.withOpacity(0.25),
                              Colors.transparent,
                            ],
                            radius: 0.8,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: mainColor.withOpacity(0.5),
                              blurRadius: 32,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      // Logo lớn hơn vòng sáng
                      Image.asset(
                        'assets/icons/logo.png',
                        width: 250, // logo lớn hơn vòng sáng
                        height: 250, // logo lớn hơn vòng sáng
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // App name
                  const SizedBox(height: 12),
                  // Welcome text
                  Text(
                    "Welcome!",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black12,
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),
                  // Create Account Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 36),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [mainColor, Color(0xFF185a9d)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: mainColor.withOpacity(0.25),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, RouteNames.register);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          minimumSize: const Size.fromHeight(54),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text(
                          "Create Account",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  // Login Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 36),
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RouteNames.login);
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        side: const BorderSide(color: mainColor, width: 2),
                        foregroundColor: mainColor,
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        backgroundColor: Colors.white,
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(color: mainColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Social login text
                  Text(
                    "Or sign in with",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.92),
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 18),
                  // Social icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialIcon(context, Icons.email, mainColor),
                      const SizedBox(width: 22),
                      _buildSocialIcon(context, Icons.business, mainColor),
                      const SizedBox(width: 22),
                      _buildSocialIcon(
                        context,
                        Icons.facebook,
                        Color(0xFF4267B2),
                      ),
                      const SizedBox(width: 22),
                      _buildSocialIcon(
                        context,
                        Icons.g_mobiledata,
                        Color(0xFFEA4335),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildSocialIcon(
    BuildContext context,
    IconData icon,
    Color color,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () {
        // TODO: Implement social login
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Social login coming soon!'),
            backgroundColor: color,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.85),
          border: Border.all(color: color.withOpacity(0.18), width: 1.5),
        ),
        padding: const EdgeInsets.all(14),
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }
}
