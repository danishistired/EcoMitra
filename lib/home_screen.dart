import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart'; // Ensure you have lucide_icons in pubspec.yaml
import 'scan_screen.dart'; // Import the scan screen

class HomeScreen extends StatelessWidget {
  final String username;

  HomeScreen({required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Green Section
            Container(
              padding: EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  SizedBox(height: 5),
                  Text(
                    username, // Displaying the username
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.green),
                                SizedBox(width: 5),
                                Text("Active Points", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.refresh, size: 18),
                              label: Text("Refresh"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          "16500 Points",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Total Points Earned
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Icon(LucideIcons.arrowDown, color: Colors.red, size: 18), // Down Arrow Icon
                                    SizedBox(width: 4), // Spacing between icon and text
                                    Text(
                                      "Total Points Earned",
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4), // Space between text and points
                                Text(
                                  "56842 Points",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                              ],
                            ),

                            // Total Points Spent
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Icon(LucideIcons.arrowUp, color: Colors.green, size: 18), // Up Arrow Icon
                                    SizedBox(width: 4), // Spacing between icon and text
                                    Text(
                                      "Total Points Spent",
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4), // Space between text and points
                                Text(
                                  "818986 Points",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Scan Image Button (Now Navigates to ScanScreen)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ScanScreen()), // Navigate to ScanScreen
                  );
                },
                icon: Icon(Icons.camera_alt, color: Colors.white), // Camera icon
                label: Text("Scan Image"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ),
            SizedBox(height: 10),

            // XP Progress
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star, color: Colors.yellow),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text("80 XP more to become the savior of the nation!"),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey), // Small arrow icon
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildActionButton("Report a Cleanliness Issue", Icons.report_problem),
                  _buildActionButton("Check Nearby Areas", Icons.location_on),
                  _buildActionButton("View Alert", Icons.notifications),
                ],
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Homepage"),
          BottomNavigationBarItem(icon: Icon(LucideIcons.trash), label: "Trash"), // Using lucide icon
          BottomNavigationBarItem(icon: Icon(LucideIcons.mapPin), label: "Nearby"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  // Custom Button Widget with Icons
  Widget _buildActionButton(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(icon, color: Colors.white),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          minimumSize: Size(double.infinity, 50),
        ),
      ),
    );
  }
}
