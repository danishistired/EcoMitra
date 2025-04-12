import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:io';

class ScanScreen extends StatefulWidget {
  final Function(int) onPointsEarned;

  ScanScreen({required this.onPointsEarned});

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  File? _image;
  bool _isLoading = false;
  LatLng? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permission denied')),
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get location: $e')),
      );
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      if (_currentPosition != null) {
        _sendImageToServer(_image!, _currentPosition!);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location not available')),
        );
      }
    }
  }

  Future<void> _sendImageToServer(File image, LatLng position) async {
    setState(() {
      _isLoading = true;
    });

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://tryingtohost.onrender.com/upload'),
    );
    request.files.add(await http.MultipartFile.fromPath('image', image.path));
    request.fields['latitude'] = position.latitude.toString();
    request.fields['longitude'] = position.longitude.toString();

    var response = await request.send();
    if (response.statusCode == 200) {
      widget.onPointsEarned(200);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image sent successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send image. Try again!')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scan Image & Map')),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: _currentPosition != null
                ? FlutterMap(
                    options: MapOptions(
                      center: _currentPosition!,
                      zoom: 15.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c'],
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _currentPosition!,
                            width: 80,
                            height: 80,
                            child: Icon(
                              Icons.location_pin,
                              size: 40,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Center(child: CircularProgressIndicator()),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _image != null
                            ? Image.file(_image!, height: 150)
                            : Icon(Icons.camera_alt,
                                size: 100, color: Colors.grey),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () => _pickImage(ImageSource.camera),
                              child: Text('Capture Image'),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () => _pickImage(ImageSource.gallery),
                              child: Text('Pick from Gallery'),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
