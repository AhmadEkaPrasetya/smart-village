import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import '../models/facility.dart';

class MapScreen extends StatelessWidget {
  final Position position;
  final List<Facility> facilities;

  const MapScreen({
    super.key,
    required this.position,
    required this.facilities,
  });

  void _showFacilityDetail(BuildContext context, Facility facility) {
    final distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      facility.latitude,
      facility.longitude,
    );

    final distanceText = distance >= 1000
        ? '${(distance / 1000).toStringAsFixed(2)} km'
        : '${distance.toStringAsFixed(0)} meter';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 45,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  Row(
                    children: [
                      CircleAvatar(
                        radius: 27,
                        backgroundColor: const Color(0xFFE0F2EC),
                        child: Icon(
                          facility.icon,
                          color: const Color(0xFF16856B),
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          facility.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  _detailRow(Icons.category, 'Jenis fasilitas', facility.type),

                  const SizedBox(height: 14),

                  _detailRow(Icons.location_on, 'Alamat', facility.address),

                  const SizedBox(height: 14),

                  _detailRow(Icons.phone, 'Nomor telepon', facility.phone),

                  const SizedBox(height: 14),

                  _detailRow(
                    Icons.directions,
                    'Jarak dari lokasi Anda',
                    distanceText,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Jenis Pelayanan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  if (facility.services.isEmpty)
                    const Text(
                      'Informasi pelayanan belum tersedia.',
                      style: TextStyle(color: Colors.grey),
                    )
                  else
                    ...facility.services.map(
                      (service) => Padding(
                        padding: const EdgeInsets.only(bottom: 9),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Color(0xFF16856B),
                              size: 18,
                            ),
                            const SizedBox(width: 9),
                            Expanded(child: Text(service)),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => Navigator.pop(context),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF16856B),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Tutup'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _detailRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF16856B), size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final userLocation = LatLng(position.latitude, position.longitude);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Peta Smart Village',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF16856B),
        foregroundColor: Colors.white,
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: userLocation,
          initialZoom: 12,
          minZoom: 5,
          maxZoom: 18,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.smart_village',
          ),

          MarkerLayer(
            markers: [
              Marker(
                point: userLocation,
                width: 60,
                height: 60,
                child: const Icon(
                  Icons.my_location,
                  color: Colors.blue,
                  size: 38,
                ),
              ),

              ...facilities.map((facility) {
                return Marker(
                  point: LatLng(facility.latitude, facility.longitude),
                  width: 150,
                  height: 85,
                  child: GestureDetector(
                    onTap: () {
                      _showFacilityDetail(context, facility);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          facility.type == 'Rumah Sakit'
                              ? Icons.local_hospital
                              : facility.type == 'Puskesmas'
                              ? Icons.health_and_safety
                              : Icons.medical_services,
                          color: const Color(0xFFE53935),
                          size: 38,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: const [
                              BoxShadow(color: Colors.black26, blurRadius: 4),
                            ],
                          ),
                          child: Text(
                            facility.name,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),

          RichAttributionWidget(
            attributions: [
              TextSourceAttribution('© OpenStreetMap contributors'),
            ],
          ),
        ],
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.my_location, color: Colors.blue),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Lokasi Anda',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    '${facilities.length} fasilitas',
                    style: const TextStyle(
                      color: Color(0xFF16856B),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '${position.latitude.toStringAsFixed(6)}, '
                '${position.longitude.toStringAsFixed(6)}',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Icon(Icons.location_on, color: Colors.red),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Tekan marker untuk melihat detail dan pelayanan',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
