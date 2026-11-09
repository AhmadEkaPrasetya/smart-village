import 'package:flutter/material.dart';

class LocationCard extends StatelessWidget {
  final String location;
  final VoidCallback? onTap;

  const LocationCard({
    super.key,
    this.location = 'Lokasi belum terdeteksi',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFE0F2EC),
          child: Icon(Icons.location_on, color: Color(0xFF16856B)),
        ),
        title: const Text(
          'Lokasi Anda',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(location),
        trailing: IconButton(
          onPressed: onTap,
          icon: const Icon(Icons.my_location),
          color: const Color(0xFF16856B),
        ),
      ),
    );
  }
}
