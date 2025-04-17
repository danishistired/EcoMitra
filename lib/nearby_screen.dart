import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';

class NearbyScreen extends StatefulWidget {
  @override
  _NearbyScreenState createState() => _NearbyScreenState();
}

class _NearbyScreenState extends State<NearbyScreen> {
  LatLng? _currentLocation;
  bool _loading = true;
  bool _mapView = true;
  final List<Map<String, dynamic>> _nearbyLocations = [
    {
      'name': 'City Recycling Center',
      'distance': '1.2 km',
      'rating': 4.5,
      'type': 'Recycling',
      'address': '123 Green Street, Eco City',
      'location': LatLng(28.6139, 77.2090), // Example coordinates
    },
    {
      'name': 'Community Compost Hub',
      'distance': '2.4 km',
      'rating': 4.2,
      'type': 'Compost',
      'address': '456 Earth Avenue, Eco City',
      'location': LatLng(28.6219, 77.2100), // Example coordinates
    },
    {
      'name': 'Green Waste Management',
      'distance': '3.1 km',
      'rating': 4.7,
      'type': 'E-Waste',
      'address': '789 Sustainable Road, Eco City',
      'location': LatLng(28.6180, 77.2150), // Example coordinates
    },
    {
      'name': 'EcoMitra Collection Point',
      'distance': '0.8 km',
      'rating': 4.8,
      'type': 'All Types',
      'address': '101 Clean Street, Eco City',
      'location': LatLng(28.6150, 77.2070), // Example coordinates
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          _showPermissionDeniedMessage();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showPermissionDeniedMessage();
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      
      if (mounted) {
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error getting location: ${e.toString()}"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(10),
          ),
        );
      }
    }
  }

  void _showPermissionDeniedMessage() {
    if (mounted) {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Location permission denied. Some features may be limited."),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(10),
          action: SnackBarAction(
            label: "Settings",
            textColor: Colors.white,
            onPressed: () async {
              await Geolocator.openAppSettings();
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F6),
      body: Column(
        children: [
          _buildHeader(),
          _buildToggleView(),
          Expanded(
            child: _loading
                ? _buildLoadingView()
                : _currentLocation == null
                    ? _buildErrorView()
                    : _mapView
                        ? _buildMapView()
                        : _buildListView(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
      decoration: const BoxDecoration(
        color: Color(0xFF2E7D32),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Nearby",
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "Find recycling centers and waste collection points near you",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: const Duration(milliseconds: 500));
  }

  Widget _buildToggleView() {
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(5),
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
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _mapView = true;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _mapView ? const Color(0xFF2E7D32) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.map,
                      size: 18,
                      color: _mapView ? Colors.white : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Map View",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: _mapView ? Colors.white : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _mapView = false;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !_mapView ? const Color(0xFF2E7D32) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.list,
                      size: 18,
                      color: !_mapView ? Colors.white : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "List View",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: !_mapView ? Colors.white : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(
          duration: const Duration(milliseconds: 500),
          delay: const Duration(milliseconds: 100),
        );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
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
            child: const CircularProgressIndicator(
              color: Color(0xFF2E7D32),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Getting your location...",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Please wait while we find nearby centers",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(
          duration: const Duration(milliseconds: 500),
          delay: const Duration(milliseconds: 200),
        );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.alertTriangle,
                size: 50,
                color: Colors.red.shade400,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Location Access Required",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "We need access to your location to show nearby recycling centers and waste collection points.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _loading = true;
                });
                _fetchLocation();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 0,
              ),
              child: Text(
                "Try Again",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(
          duration: const Duration(milliseconds: 500),
          delay: const Duration(milliseconds: 200),
        );
  }

  Widget _buildMapView() {
    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            center: _currentLocation!,
            zoom: 14.0,
            interactiveFlags: InteractiveFlag.all,
          ),
          children: [
            TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: const ['a', 'b', 'c'],
            ),
            MarkerLayer(
              markers: [
                // Current location marker
                Marker(
                  point: _currentLocation!,
                  width: 60,
                  height: 60,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Icon(
                      LucideIcons.mapPin,
                      size: 40,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ),
                // Nearby locations markers
                ..._nearbyLocations.map((location) => Marker(
                      point: location['location'],
                      width: 50,
                      height: 50,
                      child: GestureDetector(
                        onTap: () {
                          _showLocationDetails(location);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Icon(
                            _getIconForType(location['type']),
                            size: 30,
                            color: _getColorForType(location['type']),
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ],
        ),
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Nearby Locations",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Tap on a marker to view details",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildLegendItem(
                      "Recycling",
                      LucideIcons.recycle,
                      const Color(0xFF81C784),
                    ),
                    _buildLegendItem(
                      "Compost",
                      LucideIcons.leaf,
                      const Color(0xFFFFB74D),
                    ),
                    _buildLegendItem(
                      "E-Waste",
                      LucideIcons.cpu,
                      const Color(0xFF64B5F6),
                    ),
                    _buildLegendItem(
                      "All Types",
                      LucideIcons.trash2,
                      const Color(0xFF9575CD),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ).animate().slideY(
              begin: 1,
              end: 0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
              delay: const Duration(milliseconds: 300),
            ),
        Positioned(
          top: 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                _loading = true;
              });
              _fetchLocation();
            },
            backgroundColor: Colors.white,
            elevation: 3,
            child: const Icon(
              LucideIcons.locate,
              color: Color(0xFF2E7D32),
            ),
          ),
        ).animate().fadeIn(
              duration: const Duration(milliseconds: 500),
              delay: const Duration(milliseconds: 400),
            ),
      ],
    );
  }

  Widget _buildListView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: _nearbyLocations.length,
        itemBuilder: (context, index) {
          final location = _nearbyLocations[index];
          return GestureDetector(
            onTap: () {
              _showLocationDetails(location);
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 15),
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
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _getColorForType(location['type']).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getIconForType(location['type']),
                        size: 24,
                        color: _getColorForType(location['type']),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            location['name'],
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            location['address'],
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getColorForType(location['type']).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  location['type'],
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: _getColorForType(location['type']),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Icon(
                                LucideIcons.mapPin,
                                size: 12,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                location['distance'],
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Icon(
                                LucideIcons.star,
                                size: 12,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                location['rating'].toString(),
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      LucideIcons.chevronRight,
                      size: 20,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ),
              ),
            ),
          ).animate().fadeIn(
                duration: const Duration(milliseconds: 500),
                delay: Duration(milliseconds: 100 + (index * 100)),
              );
        },
      ),
    );
  }

  Widget _buildLegendItem(String label, IconData icon, Color color) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: color,
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 10,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  void _showLocationDetails(Map<String, dynamic> location) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _getColorForType(location['type']).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getIconForType(location['type']),
                        size: 20,
                        color: _getColorForType(location['type']),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      location['type'],
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: _getColorForType(location['type']),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(LucideIcons.x, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              location['name'],
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Icon(
                  LucideIcons.mapPin,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 5),
                Text(
                  location['address'],
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Row(
                  children: [
                    Icon(
                      LucideIcons.mapPin,
                      size: 16,
                      color: const Color(0xFF2E7D32),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      location['distance'],
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF2E7D32),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Row(
                  children: [
                    Icon(
                      LucideIcons.star,
                      size: 16,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "${location['rating']} / 5.0",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 15),
            Text(
              "Services",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            _buildServicesList(location['type']),
            const SizedBox(height: 20),
            Text(
              "Operating Hours",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            _buildOperatingHours(),
            const SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to directions
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(LucideIcons.navigation, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          "Directions",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Call the center
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF2E7D32),
                      side: const BorderSide(color: Color(0xFF2E7D32)),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(LucideIcons.phone, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          "Call",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesList(String type) {
    final List<Map<String, dynamic>> services = [];
    
    if (type == 'Recycling' || type == 'All Types') {
      services.addAll([
        {'name': 'Paper Recycling', 'icon': LucideIcons.fileText},
        {'name': 'Plastic Recycling', 'icon': LucideIcons.glassWater},
        {'name': 'Glass Recycling', 'icon': LucideIcons.wine},
      ]);
    }
    
    if (type == 'Compost' || type == 'All Types') {
      services.addAll([
        {'name': 'Food Waste Composting', 'icon': LucideIcons.apple},
        {'name': 'Garden Waste Composting', 'icon': LucideIcons.leaf},
      ]);
    }
    
    if (type == 'E-Waste' || type == 'All Types') {
      services.addAll([
        {'name': 'Electronics Recycling', 'icon': LucideIcons.smartphone},
        {'name': 'Battery Disposal', 'icon': LucideIcons.battery},
      ]);
    }
    
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: services.map((service) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                service['icon'],
                size: 16,
                color: const Color(0xFF2E7D32),
              ),
              const SizedBox(width: 8),
              Text(
                service['name'],
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOperatingHours() {
    final List<Map<String, dynamic>> hours = [
      {'day': 'Monday - Friday', 'time': '8:00 AM - 6:00 PM'},
      {'day': 'Saturday', 'time': '9:00 AM - 5:00 PM'},
      {'day': 'Sunday', 'time': 'Closed'},
    ];
    
    return Column(
      children: hours.map((hour) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                hour['day'],
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                hour['time'],
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'Recycling':
        return LucideIcons.recycle;
      case 'Compost':
        return LucideIcons.leaf;
      case 'E-Waste':
        return LucideIcons.cpu;
      case 'All Types':
        return LucideIcons.trash2;
      default:
        return LucideIcons.mapPin;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'Recycling':
        return const Color(0xFF81C784);
      case 'Compost':
        return const Color(0xFFFFB74D);
      case 'E-Waste':
        return const Color(0xFF64B5F6);
      case 'All Types':
        return const Color(0xFF9575CD);
      default:
        return const Color(0xFF2E7D32);
    }
  }
}
