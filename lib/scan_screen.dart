import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:io';
import 'dart:ui';

class ScanScreen extends StatefulWidget {
  final Function(int) onPointsEarned;

  const ScanScreen({Key? key, required this.onPointsEarned}) : super(key: key);

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with SingleTickerProviderStateMixin {
  File? _image;
  bool _isLoading = false;
  bool _isAnalyzing = false;
  LatLng? _currentPosition;
  final MapController _mapController = MapController();
  late AnimationController _animationController;
  String _detectionStatus = '';
  bool _showSuccessAnimation = false;
  bool _showMapExpanded = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _showCustomSnackBar('Location permission denied', isError: true);
        setState(() {
          _isLoading = false;
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });
    } catch (e) {
      _showCustomSnackBar('Failed to get location: $e', isError: true);
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showCustomSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : const Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: source,
        imageQuality: 80,
      );
      
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _detectionStatus = '';
          _showSuccessAnimation = false;
        });
        
        if (_currentPosition != null) {
          _analyzeImage();
        } else {
          _showCustomSnackBar('Location not available. Retrying...', isError: true);
          await _getCurrentLocation();
          if (_currentPosition != null) {
            _analyzeImage();
          } else {
            _showCustomSnackBar('Could not get your location. Please try again.', isError: true);
          }
        }
      }
    } catch (e) {
      _showCustomSnackBar('Error picking image: $e', isError: true);
    }
  }

  Future<void> _analyzeImage() async {
    if (_image == null) return;
    
    setState(() {
      _isAnalyzing = true;
      _detectionStatus = 'Analyzing image...';
    });
    
    // Simulate analysis process with steps
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _detectionStatus = 'Detecting waste type...';
    });
    
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _detectionStatus = 'Classifying materials...';
    });
    
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _detectionStatus = 'Verifying location data...';
    });
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Now send to server
    _sendImageToServer(_image!, _currentPosition!);
  }

  Future<void> _sendImageToServer(File image, LatLng position) async {
    setState(() {
      _detectionStatus = 'Uploading data...';
    });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://tryingtohost.onrender.com/upload'),
      );
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
      request.fields['latitude'] = position.latitude.toString();
      request.fields['longitude'] = position.longitude.toString();

      var response = await request.send();
      if (response.statusCode == 200) {
        setState(() {
          _isAnalyzing = false;
          _showSuccessAnimation = true;
          _detectionStatus = 'Waste detected: Plastic bottles & packaging';
        });
        
        // Start success animation
        _animationController.reset();
        _animationController.forward();
        
        // Award points
        widget.onPointsEarned(200);
        
        _showCustomSnackBar('Great job! You earned 200 points');
      } else {
        setState(() {
          _isAnalyzing = false;
          _detectionStatus = 'Upload failed. Please try again.';
        });
        _showCustomSnackBar('Failed to send image. Try again!', isError: true);
      }
    } catch (e) {
      setState(() {
        _isAnalyzing = false;
        _detectionStatus = 'Error: $e';
      });
      _showCustomSnackBar('Network error: $e', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F6),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Waste Scanner",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _showMapExpanded ? LucideIcons.minimize2 : LucideIcons.maximize2,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _showMapExpanded = !_showMapExpanded;
              });
            },
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
      body: Column(
        children: [
          // Map Section
          Expanded(
            flex: _showMapExpanded ? 2 : 1,
            child: _buildMapSection(),
          ),

          // Bottom Sheet
          Expanded(
            flex: _showMapExpanded ? 1 : 2,
            child: _buildBottomSheet(),
          ),
        ],
      ),
      floatingActionButton: _showMapExpanded && _currentPosition != null
          ? FloatingActionButton(
              onPressed: () {
                _mapController.move(_currentPosition!, 15);
              },
              backgroundColor: const Color(0xFF2E7D32),
              child: const Icon(LucideIcons.locate),
            )
          : null,
    );
  }

  Widget _buildMapSection() {
    return _currentPosition != null
        ? FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: _currentPosition!,
              zoom: 15.0,
              interactiveFlags: InteractiveFlag.all,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _currentPosition!,
                    width: 60,
                    height: 60,
                    child: _buildAnimatedMarker(),
                  ),
                ],
              ),
              // Nearby waste spots (simulated)
              MarkerLayer(
                markers: _getNearbyWasteSpots(),
              ),
            ],
          ).animate().fadeIn(duration: const Duration(milliseconds: 500))
        : Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  color: Color(0xFF2E7D32),
                ),
                const SizedBox(height: 20),
                Text(
                  "Loading map...",
                  style: GoogleFonts.poppins(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
  }

  Widget _buildAnimatedMarker() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer pulse
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32).withOpacity(0.2),
            shape: BoxShape.circle,
          ),
        ).animate(onPlay: (controller) => controller.repeat())
          .scale(
            begin: const Offset(0.8, 0.8),
            end: const Offset(1.2, 1.2),
            duration: const Duration(seconds: 1),
          )
          .fadeOut(
            begin: 0.7,
            duration: const Duration(seconds: 1),
          ),
        
        // Inner pulse
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32).withOpacity(0.3),
            shape: BoxShape.circle,
          ),
        ),
        
        // Pin
        const Icon(
          LucideIcons.mapPin,
          size: 30,
          color: Color(0xFF2E7D32),
        ),
      ],
    );
  }

  List<Marker> _getNearbyWasteSpots() {
    if (_currentPosition == null) return [];
    
    // Simulated nearby waste spots
    final spots = [
      LatLng(
        _currentPosition!.latitude + 0.002,
        _currentPosition!.longitude + 0.003,
      ),
      LatLng(
        _currentPosition!.latitude - 0.001,
        _currentPosition!.longitude + 0.002,
      ),
      LatLng(
        _currentPosition!.latitude + 0.003,
        _currentPosition!.longitude - 0.002,
      ),
    ];
    
    return spots.map((spot) => Marker(
      point: spot,
      width: 30,
      height: 30,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.8),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: const Icon(
          LucideIcons.trash2,
          color: Colors.white,
          size: 16,
        ),
      ),
    )).toList();
  }

  Widget _buildBottomSheet() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
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
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Scan Waste",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Take a photo of waste to identify and report it",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 25),
                  
                  // Image Preview Section
                  _buildImagePreviewSection(),
                  
                  const SizedBox(height: 25),
                  
                  // Camera and Gallery Buttons
                  _buildActionButtons(),
                  
                  const SizedBox(height: 20),
                  
                  // Detection Status
                  if (_detectionStatus.isNotEmpty)
                    _buildDetectionStatus(),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate().slideY(
      begin: 1,
      end: 0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutQuint,
    );
  }

  Widget _buildImagePreviewSection() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _image != null ? const Color(0xFF2E7D32) : Colors.transparent,
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: _image != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(
                    _image!,
                    fit: BoxFit.cover,
                  ),
                  if (_showSuccessAnimation)
                    _buildSuccessOverlay(),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.image,
                    size: 60,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "No image selected",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSuccessOverlay() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Stack(
          children: [
            // Green overlay
            Container(
              color: const Color(0xFF2E7D32).withOpacity(0.3),
            ),
            
            // Checkmark
            Center(
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LucideIcons.checkCircle,
                  color: const Color(0xFF2E7D32),
                  size: 40 * _animationController.value,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: LucideIcons.camera,
            label: "Take Photo",
            onTap: _isAnalyzing ? null : () => _pickImage(ImageSource.camera),
            color: const Color(0xFF2E7D32),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildActionButton(
            icon: LucideIcons.image,
            label: "Gallery",
            onTap: _isAnalyzing ? null : () => _pickImage(ImageSource.gallery),
            color: const Color(0xFF388E3C),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: onTap == null ? Colors.grey.shade300 : color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: onTap == null
              ? []
              : [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    ).animate()
      .fadeIn(duration: const Duration(milliseconds: 500))
      .slideY(
        begin: 0.2,
        end: 0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutQuint,
      );
  }

  Widget _buildDetectionStatus() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: _showSuccessAnimation
            ? const Color(0xFFE8F5E9)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: _showSuccessAnimation
              ? const Color(0xFF2E7D32)
              : Colors.transparent,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _isAnalyzing
                    ? LucideIcons.loader
                    : _showSuccessAnimation
                        ? LucideIcons.checkCircle
                        : LucideIcons.info,
                color: _isAnalyzing
                    ? Colors.blue
                    : _showSuccessAnimation
                        ? const Color(0xFF2E7D32)
                        : Colors.grey.shade700,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                _isAnalyzing ? "Processing" : "Status",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: _isAnalyzing
                      ? Colors.blue
                      : _showSuccessAnimation
                          ? const Color(0xFF2E7D32)
                          : Colors.grey.shade700,
                ),
              ),
              if (_isAnalyzing)
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  width: 15,
                  height: 15,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.blue,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _detectionStatus,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
          
          // Show additional info if successful
          if (_showSuccessAnimation) ...[
            const SizedBox(height: 15),
            Row(
              children: [
                _buildInfoChip(
                  icon: LucideIcons.trash2,
                  label: "Plastic",
                  color: Colors.blue,
                ),
                const SizedBox(width: 10),
                _buildInfoChip(
                  icon: LucideIcons.alertTriangle,
                  label: "Recyclable",
                  color: Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Thank you for reporting! Your contribution helps keep our environment clean.",
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(
      duration: const Duration(milliseconds: 500),
      delay: const Duration(milliseconds: 200),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}