import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:io';

class ScanScreen extends StatefulWidget {
  final Function(int) onPointsEarned;

  const ScanScreen({Key? key, required this.onPointsEarned}) : super(key: key);

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  File? _image;
  bool _isLoading = false;
  bool _isAnalyzing = false;
  LatLng? _currentPosition;
  final MapController _mapController = MapController();
  String _detectionStatus = '';
  bool _showSuccessAnimation = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Waste Scanner",
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
        actions: [
          IconButton(
            icon: const Icon(
              LucideIcons.maximize2,
              color: Colors.white,
            ),
            onPressed: () {
              // Show map in fullscreen dialog
              showDialog(
                context: context,
                builder: (context) => Dialog.fullscreen(
                  child: Scaffold(
                    appBar: AppBar(
                      title: Text(
                        "Map View",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: const Color(0xFF2E7D32),
                      leading: IconButton(
                        icon: const Icon(LucideIcons.x),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    body: _currentPosition != null
                        ? FlutterMap(
                            mapController: _mapController,
                            options: MapOptions(
                              center: _currentPosition!,
                              zoom: 15.0,
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
                                    width: 40,
                                    height: 40,
                                    child: const Icon(
                                      LucideIcons.mapPin,
                                      color: Color(0xFF2E7D32),
                                      size: 40,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                    floatingActionButton: FloatingActionButton(
                      onPressed: () {
                        if (_currentPosition != null) {
                          _mapController.move(_currentPosition!, 15);
                        }
                      },
                      backgroundColor: const Color(0xFF2E7D32),
                      child: const Icon(LucideIcons.locate),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF2E7D32),
              ),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Take a photo of waste to identify and report it",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Image Preview Section
                    Expanded(
                      flex: 3,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF2E7D32),
                            width: 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: _image != null
                              ? Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.file(
                                      _image!,
                                      fit: BoxFit.cover,
                                    ),
                                    if (_showSuccessAnimation)
                                      Container(
                                        color: Colors.green.withOpacity(0.3),
                                        child: Center(
                                          child: Container(
                                            padding: const EdgeInsets.all(16),
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              LucideIcons.check,
                                              color: Color(0xFF2E7D32),
                                              size: 40,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      LucideIcons.image,
                                      size: 60,
                                      color: Colors.green.shade700,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "No image selected",
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.green.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isAnalyzing ? null : () => _pickImage(ImageSource.camera),
                            icon: const Icon(LucideIcons.camera),
                            label: Text(
                              "Take Photo",
                              style: GoogleFonts.poppins(),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2E7D32),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              disabledBackgroundColor: Colors.grey.shade300,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isAnalyzing ? null : () => _pickImage(ImageSource.gallery),
                            icon: const Icon(LucideIcons.image),
                            label: Text(
                              "Gallery",
                              style: GoogleFonts.poppins(),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2E7D32),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              disabledBackgroundColor: Colors.grey.shade300,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Status Section
                    if (_detectionStatus.isNotEmpty)
                      Expanded(
                        flex: 2,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.green.shade200,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    _isAnalyzing ? LucideIcons.loader : LucideIcons.checkCircle,
                                    color: const Color(0xFF2E7D32),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Status",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: const Color(0xFF2E7D32),
                                    ),
                                  ),
                                  if (_isAnalyzing)
                                    Container(
                                      margin: const EdgeInsets.only(left: 8),
                                      width: 16,
                                      height: 16,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Color(0xFF2E7D32),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _detectionStatus,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              
                              if (_showSuccessAnimation) ...[
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 8,
                                  children: [
                                    _buildInfoChip(
                                      icon: LucideIcons.trash2,
                                      label: "Plastic",
                                    ),
                                    _buildInfoChip(
                                      icon: LucideIcons.recycle,
                                      label: "Recyclable",
                                    ),
                                  ],
                                ),
                                const Spacer(),
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
                        ),
                      ),
                    
                    // Spacer to push content up
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: const Color(0xFF2E7D32),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF2E7D32),
            ),
          ),
        ],
      ),
    );
  }
}