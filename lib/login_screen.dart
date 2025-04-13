import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:lottie/lottie.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _navigateToHome() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate loading for a better UX
      await Future.delayed(const Duration(milliseconds: 1500));

      if (!mounted) return;
      
      setState(() {
        _isLoading = false;
      });

      String username = _usernameController.text;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(username: username),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F6),
      body: Stack(
        children: [
          // Background design elements
          _buildBackgroundElements(),
          
          // Main content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    _buildHeader(),
                    const SizedBox(height: 40),
                    _buildLoginForm(),
                    const SizedBox(height: 40),
                    _buildEcoFactsSection(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundElements() {
    return Stack(
      children: [
        // Top gradient
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 260, // Increased height to accommodate the full text
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2E7D32), Color(0xFF388E3C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
        ),
        
        // Decorative circles
        Positioned(
          right: -50,
          top: -50,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          left: -30,
          top: 100,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
          ),
        ),
        
        // Bottom decorative elements
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withOpacity(0.05),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                LucideIcons.leaf,
                color: Color(0xFF2E7D32),
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              "EcoMitra",
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ).animate().fadeIn(duration: const Duration(milliseconds: 600)).slideY(
              begin: 0.3,
              end: 0,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutQuint,
            ),
        
        const SizedBox(height: 24),
        
        Text(
          "Welcome",
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ).animate().fadeIn(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 300),
            ).slideY(
              begin: 0.3,
              end: 0,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutQuint,
              delay: const Duration(milliseconds: 300),
            ),
        
        const SizedBox(height: 8),
        
        Text(
          "Join our community of eco-warriors and help make the world cleaner!",
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.white.withOpacity(0.9),
          ),
        ).animate().fadeIn(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 400),
            ).slideY(
              begin: 0.3,
              end: 0,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutQuint,
              delay: const Duration(milliseconds: 400),
            ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Let's get started",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Enter your name to continue",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            
            // Username field
            TextFormField(
              controller: _usernameController,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black87,
              ),
              decoration: InputDecoration(
                labelText: "Your Name",
                labelStyle: GoogleFonts.poppins(
                  color: Colors.grey.shade600,
                ),
                prefixIcon: const Icon(
                  LucideIcons.user,
                  color: Color(0xFF2E7D32),
                  size: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Please enter your name";
                }
                if (value.trim().length < 2) {
                  return "Name must be at least 2 characters";
                }
                return null;
              },
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _navigateToHome(),
            ),
            
            const SizedBox(height: 32),
            
            // Login button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _navigateToHome,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Continue",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            LucideIcons.arrowRight,
                            size: 20,
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(
          duration: const Duration(milliseconds: 800),
          delay: const Duration(milliseconds: 600),
        ).slideY(
          begin: 0.3,
          end: 0,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutQuint,
          delay: const Duration(milliseconds: 600),
        );
  }

  Widget _buildEcoFactsSection() {
    final List<Map<String, dynamic>> facts = [
      {
        'title': 'Did you know?',
        'description': 'Recycling one aluminum can saves enough energy to run a TV for 3 hours.',
        'icon': LucideIcons.recycle,
        'color': const Color(0xFF81C784),
      },
      {
        'title': 'Make a difference',
        'description': 'By reporting waste, you help create cleaner communities and protect wildlife.',
        'icon': LucideIcons.heart,
        'color': const Color(0xFFE57373),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Eco Facts",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ).animate().fadeIn(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 900),
            ),
        const SizedBox(height: 16),
        ...facts.asMap().entries.map((entry) {
          final int index = entry.key;
          final Map<String, dynamic> fact = entry.value;
          
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: fact['color'].withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    fact['icon'],
                    size: 24,
                    color: fact['color'],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fact['title'],
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        fact['description'],
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(
                duration: const Duration(milliseconds: 600),
                delay: Duration(milliseconds: 1000 + (index * 200)),
              ).slideY(
                begin: 0.3,
                end: 0,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutQuint,
                delay: Duration(milliseconds: 1000 + (index * 200)),
              );
        }).toList(),
        const SizedBox(height: 40),
      ],
    );
  }
}