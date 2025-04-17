import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'dart:ui';
import 'scan_screen.dart';
import 'history_screen.dart';
import 'nearby_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  int _activePoints = 16500;
  late AnimationController _animationController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
    _animationController.dispose();
    super.dispose();
  }

  void _addPoints(int points) {
    setState(() {
      _activePoints += points;
    });
    // Show a snackbar when points are added
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You earned $points points!'),
        backgroundColor: const Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      _buildMainHome(context),
      HistoryScreen(),
      NearbyScreen(),
      ProfileScreen(username: widget.username, activePoints: _activePoints),
    ];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF5F9F6),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              LucideIcons.leaf,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              "EcoMitra",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.bell, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(LucideIcons.settings, color: Colors.white),
            onPressed: () {},
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2E7D32), Color(0xFF388E3C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() => _currentIndex = index);
              _animationController.reset();
              _animationController.forward();
            },
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFF2E7D32),
            unselectedItemColor: Colors.grey.shade400,
            selectedLabelStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            unselectedLabelStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon: Icon(LucideIcons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(LucideIcons.trash2),
                label: "History",
              ),
              BottomNavigationBarItem(
                icon: Icon(LucideIcons.mapPin),
                label: "Nearby",
              ),
              BottomNavigationBarItem(
                icon: Icon(LucideIcons.user),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScanScreen(onPointsEarned: _addPoints),
                  ),
                );
              },
              backgroundColor: const Color(0xFF2E7D32),
              child: const Icon(LucideIcons.camera),
            )
              .animate()
              .scale(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              )
              .fadeIn()
          : null,
    );
  }

  Widget _buildMainHome(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderSection(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildPointsCard(),
                const SizedBox(height: 25),
                Text(
                  "Quick Actions",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 15),
                _buildActionGrid(),
                const SizedBox(height: 25),
                _buildEcoTipsSection(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      height: 200,
      width: double.infinity,
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
      child: Stack(
        children: [
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
            bottom: -60,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome Back,",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.username,
                  style: GoogleFonts.poppins(
                    fontSize: 28,
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

  Widget _buildPointsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFFF7F9F8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Your Green Points",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      LucideIcons.trendingUp,
                      size: 14,
                      color: Color(0xFF2E7D32),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "+210 this week",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF2E7D32),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$_activePoints",
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2E7D32),
                    ),
                  ),
                  Text(
                    "Total Points",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.refreshCw, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      "Refresh",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _activePoints / 20000, // Example max value
              backgroundColor: Colors.grey.shade200,
              color: const Color(0xFF2E7D32),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Level 3",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                "${20000 - _activePoints} points to Level 4",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: const Duration(milliseconds: 500)).slideY(
          begin: 0.2,
          end: 0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
          delay: const Duration(milliseconds: 100),
        );
  }

  Widget _buildActionGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 1.1,
      padding: EdgeInsets.zero,
      children: [
        _buildActionCard(
          "Scan Waste",
          LucideIcons.camera,
          const Color(0xFF81C784),
          const Color(0xFFE8F5E9),
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ScanScreen(onPointsEarned: _addPoints),
              ),
            );
          },
        ),
        _buildActionCard(
          "Report Issue",
          LucideIcons.alertTriangle,
          const Color(0xFFE57373),
          const Color(0xFFFFEBEE),
          () {},
        ),
        _buildActionCard(
          "Nearby Areas",
          LucideIcons.mapPin,
          const Color(0xFFFFB74D),
          const Color(0xFFFFF8E1),
          () {Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NearbyScreen(),
              ),
            );},
        ),
        _buildActionCard(
          "View Alerts",
          LucideIcons.bell,
          const Color(0xFF9575CD),
          const Color(0xFFEDE7F6),
          () {},
        ),
      ],
    );
  }

  Widget _buildActionCard(
    String title,
    IconData icon,
    Color iconColor,
    Color bgColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 28, color: iconColor),
            ),
            const SizedBox(height: 15),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(
          duration: const Duration(milliseconds: 500),
          delay: Duration(milliseconds: 200 + (title.length * 20)),
        );
  }

  Widget _buildEcoTipsSection() {
    final List<Map<String, dynamic>> tips = [
      {
        'title': 'Separate Your Waste',
        'description': 'Separate recyclables from general waste to increase recycling efficiency.',
        'icon': LucideIcons.trash2,
        'color': const Color(0xFF81C784),
      },
      {
        'title': 'Reduce Plastic Usage',
        'description': 'Use reusable bags and bottles to minimize plastic waste in the environment.',
        'icon': LucideIcons.shoppingBag,
        'color': const Color(0xFF64B5F6),
      },
      {
        'title': 'Compost Food Waste',
        'description': 'Turn food scraps into nutrient-rich soil for your plants.',
        'icon': LucideIcons.leaf,
        'color': const Color(0xFFFFB74D),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Eco Tips",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 15),
        ...tips.map((tip) => _buildTipCard(tip)).toList(),
      ],
    );
  }

  Widget _buildTipCard(Map<String, dynamic> tip) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: tip['color'].withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              tip['icon'],
              size: 24,
              color: tip['color'],
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tip['title'],
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  tip['description'],
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(
          duration: const Duration(milliseconds: 500),
          delay: Duration(milliseconds: 300 + (tip['title'] as String).length * 20),
        );
  }
}
