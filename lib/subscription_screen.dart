import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SubscriptionScreen extends StatefulWidget {
  final String username;

  const SubscriptionScreen({super.key, required this.username});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int _selectedPlan = 0; // 0: Basic, 1: Premium, 2: Enterprise

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F6),
      appBar: AppBar(
        title: Text(
          "Subscription Plans",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Choose Your Plan",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Select the plan that best fits your needs",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 25),
                  _buildPlanSelector(),
                  const SizedBox(height: 30),
                  _buildPlanDetails(),
                  const SizedBox(height: 30),
                  _buildSubscribeButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF2E7D32),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -50,
            top: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: -30,
            bottom: -60,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Subscription Plans",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Unlock Premium Features",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: const Duration(milliseconds: 500)).slideY(
          begin: 0.2,
          end: 0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
  }

  Widget _buildPlanSelector() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildPlanTab("Basic", 0),
          _buildPlanTab("Premium", 1),
          _buildPlanTab("Enterprise", 2),
        ],
      ),
    ).animate().fadeIn(
          duration: const Duration(milliseconds: 500),
          delay: const Duration(milliseconds: 200),
        );
  }

  Widget _buildPlanTab(String title, int index) {
    final isSelected = _selectedPlan == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPlan = index;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2E7D32) : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlanDetails() {
    // Plan details based on selected plan
    final List<Map<String, dynamic>> plans = [
      {
        'title': 'Basic Plan',
        'price': 'Free',
        'features': [
          'Upload "before" and "after" photos',
          'Earn EcoTokens for validated cleanups',
          'View cleanup history + map of cleaned locations',
          'Participate in leaderboards (local rewards)',
          'Wallet integration (receive tokens to a basic wallet)',
        ],
        'icon': LucideIcons.leaf,
      },
      {
        'title': 'Premium Plan',
        'price': '₹199/month',
        'features': [
          'Team Management: Create teams & track multiple contributors',
          'Advanced analytics dashboard (number of cleanups, tokens earned, carbon footprint impact)',
          'Special badges & certifications (for volunteers)',
          'Identity-linked reputation system (via blockchain)',
          'All features from Basic plan',
        ],
        'icon': LucideIcons.crown,
      },
      {
        'title': 'Enterprise Plan',
        'price': '₹499/month',
        'features': [
          'Bulk cleanup management (city-wide operations)',
          'Integration with CCTV / IoT sensors for automatic detection of garbage (AI/ML-powered)',
          'ESG & carbon credit reporting (for CSR)',
          'SLA-backed support + quarterly training workshops',
          'All features from Premium plan',
        ],
        'icon': LucideIcons.building2,
      },
    ];

    final selectedPlanData = plans[_selectedPlan];

    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  selectedPlanData['icon'],
                  size: 28,
                  color: const Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedPlanData['title'],
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    selectedPlanData['price'],
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF2E7D32),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 25),
          const Divider(),
          const SizedBox(height: 20),
          ...selectedPlanData['features'].map<Widget>((feature) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    LucideIcons.check,
                    size: 18,
                    color: Color(0xFF2E7D32),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      feature,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    ).animate().fadeIn(
          duration: const Duration(milliseconds: 500),
          delay: const Duration(milliseconds: 300),
        );
  }

  Widget _buildSubscribeButton() {
    final List<String> buttonTexts = [
      "Continue with Free Plan",
      "Subscribe to Premium",
      "Subscribe to Enterprise"
    ];

    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () {
          // Show confirmation dialog
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                "Confirm Subscription",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                _selectedPlan == 0
                    ? "You will continue with the Basic plan."
                    : "This is a prototype. In a real app, this would process payment for the ${_selectedPlan == 1 ? 'Premium' : 'Enterprise'} plan.",
                style: GoogleFonts.poppins(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          _selectedPlan == 0
                              ? "Continuing with Basic plan"
                              : "${_selectedPlan == 1 ? 'Premium' : 'Enterprise'} plan selected successfully!",
                        ),
                        backgroundColor: const Color(0xFF2E7D32),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.all(10),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                    // Return to profile page
                    Future.delayed(const Duration(seconds: 2), () {
                      Navigator.pop(context);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                  ),
                  child: Text(
                    "Confirm",
                    style: GoogleFonts.poppins(),
                  ),
                ),
              ],
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E7D32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 0,
        ),
        child: Text(
          buttonTexts[_selectedPlan],
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ).animate().fadeIn(
          duration: const Duration(milliseconds: 500),
          delay: const Duration(milliseconds: 400),
        );
  }
}
