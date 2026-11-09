import 'package:flutter/material.dart';

class Facility {
  final String name;
  final String type;
  final String address;
  final String distance;
  final IconData icon;
  final double latitude;
  final double longitude;
  final String phone;
  final List<String> services;

  const Facility({
    required this.name,
    required this.type,
    required this.address,
    required this.distance,
    required this.icon,
    required this.latitude,
    required this.longitude,
    this.phone = 'Belum tersedia',
    this.services = const [],
  });
}
