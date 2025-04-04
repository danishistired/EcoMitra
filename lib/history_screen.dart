import 'dart:io';
import 'package:flutter/material.dart';

class UploadHistoryItem {
  final File image;
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  UploadHistoryItem({
    required this.image,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });
}

class HistoryScreen extends StatelessWidget {
  // Dummy data for now – in a real app, replace with actual uploaded history
  final List<UploadHistoryItem> historyItems = [
    UploadHistoryItem(
      image: File('assets/sample1.jpg'), // Replace with real image paths
      latitude: 37.7749,
      longitude: -122.4194,
      timestamp: DateTime.now().subtract(Duration(minutes: 30)),
    ),
    UploadHistoryItem(
      image: File('assets/sample2.jpg'),
      latitude: 40.7128,
      longitude: -74.0060,
      timestamp: DateTime.now().subtract(Duration(hours: 2)),
    ),
    // Add more if needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload History')),
      body: historyItems.isEmpty
          ? Center(child: Text("No uploads yet."))
          : ListView.builder(
              itemCount: historyItems.length,
              itemBuilder: (context, index) {
                final item = historyItems[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        item.image,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      'Lat: ${item.latitude.toStringAsFixed(4)}, Long: ${item.longitude.toStringAsFixed(4)}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Uploaded at: ${item.timestamp}',
                      style: TextStyle(fontSize: 12),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                );
              },
            ),
    );
  }
}
