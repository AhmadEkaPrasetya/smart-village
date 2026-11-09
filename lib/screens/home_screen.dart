import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../models/facility.dart';
import '../services/location_service.dart';
import '../widgets/category_filter.dart';
import '../widgets/facility_card.dart';
import '../widgets/location_card.dart';
import '../widgets/search_field.dart';
import '../widgets/welcome_card.dart';
import 'map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  final LocationService _locationService = LocationService();

  StreamSubscription<Position>? _positionSubscription;

  static const double _geofenceRadius = 500;

  String _selectedCategory = 'Semua';
  String _currentLocation = 'Lokasi belum terdeteksi';
  bool _isLoadingLocation = false;

  Position? _currentPosition;

  final Set<String> _insideGeofences = {};

  final List<Facility> _facilities = [
    // RUMAH SAKIT
    const Facility(
      name: 'RSUD Cengkareng',
      type: 'Rumah Sakit',
      address: 'Jl. Bumi Cengkareng Indah No. 1, Cengkareng Timur',
      distance: 'Belum diketahui',
      icon: Icons.local_hospital,
      latitude: -6.142792,
      longitude: 106.734871,
      phone: '(021) 54372874',
      services: [
        'Instalasi Gawat Darurat',
        'Rawat jalan',
        'Rawat inap',
        'Pemeriksaan penunjang',
      ],
    ),
    const Facility(
      name: 'RS Pondok Indah - Puri Indah',
      type: 'Rumah Sakit',
      address: 'Jl. Puri Indah Raya Blok S-2, Kembangan Selatan',
      distance: 'Belum diketahui',
      icon: Icons.local_hospital,
      latitude: -6.186236848,
      longitude: 106.7354641,
      phone: '(021) 25695200',
      services: [
        'Ortopedi',
        'Kebidanan dan kandungan',
        'Pencernaan, hati, dan pankreas',
        'Kulit dan estetika',
        'Pemeriksaan kesehatan',
        'Spesialis gigi',
      ],
    ),
    const Facility(
      name: 'RS Sumber Waras',
      type: 'Rumah Sakit',
      address: 'Jl. Kyai Tapa No. 1, Tomang',
      distance: 'Belum diketahui',
      icon: Icons.local_hospital,
      latitude: -6.168473257,
      longitude: 106.7975597,
      phone: '(021) 5682011',
      services: [
        'Instalasi Gawat Darurat 24 jam',
        'Poliklinik',
        'Rawat jalan',
        'Rawat inap',
      ],
    ),
    const Facility(
      name: 'RS Jantung dan Pembuluh Darah Harapan Kita',
      type: 'Rumah Sakit',
      address: 'Jl. Letjen S. Parman Kav. 87, Slipi',
      distance: 'Belum diketahui',
      icon: Icons.local_hospital,
      latitude: -6.185318,
      longitude: 106.797530,
      phone: '1500034',
      services: [
        'Pemeriksaan jantung',
        'Pelayanan kardiovaskular',
        'Konsultasi spesialis jantung',
      ],
    ),
    const Facility(
      name: 'RS Ukrida',
      type: 'Rumah Sakit',
      address: 'Jl. Arjuna Utara No. 6, Duri Kepa',
      distance: 'Belum diketahui',
      icon: Icons.local_hospital,
      latitude: -6.185612333,
      longitude: 106.78102,
      phone: '1500007',
      services: [
        'Rawat jalan',
        'Rawat inap',
        'Instalasi Gawat Darurat',
        'Pelayanan kesehatan umum',
      ],
    ),

    // PUSKESMAS
    const Facility(
      name: 'Puskesmas Kecamatan Cengkareng',
      type: 'Puskesmas',
      address: 'Jl. Kamal Raya No. 2, Cengkareng Barat',
      distance: 'Belum diketahui',
      icon: Icons.health_and_safety,
      latitude: -6.1294,
      longitude: 106.7433,
      phone: '(021) 29038167',
      services: [
        'Pemeriksaan kesehatan umum',
        'Kesehatan ibu dan anak',
        'Imunisasi',
        'Pelayanan kesehatan gigi',
      ],
    ),

    // KLINIK
    const Facility(
      name: 'Klinik Pratama Persada Sari',
      type: 'Klinik',
      address: 'Jl. Raya Duri Kosambi No. 8, Cengkareng',
      distance: 'Belum diketahui',
      icon: Icons.medical_services,
      latitude: -6.177471467084248,
      longitude: 106.72225104661776,
      services: ['Konsultasi kesehatan', 'Pemeriksaan kesehatan umum'],
    ),
    const Facility(
      name: 'Klinik Utama Panmedika Medical Centre',
      type: 'Klinik',
      address: 'Green Ville Blok AW No. 34, Duri Kepa',
      distance: 'Belum diketahui',
      icon: Icons.medical_services,
      latitude: -6.167595126721317,
      longitude: 106.77422035485506,
      services: ['Konsultasi kesehatan', 'Pemeriksaan kesehatan'],
    ),
    const Facility(
      name: 'Klinik Pratama Sinar Keluarga',
      type: 'Klinik',
      address: 'Utan Jati, Pegadungan, Kalideres',
      distance: 'Belum diketahui',
      icon: Icons.medical_services,
      latitude: -6.150341968196938,
      longitude: 106.70269319947199,
      services: ['Konsultasi kesehatan', 'Pemeriksaan kesehatan umum'],
    ),
    const Facility(
      name: 'Klinik Berkah',
      type: 'Klinik',
      address: 'Jl. Jelambar Selatan No. 1, Grogol Petamburan',
      distance: 'Belum diketahui',
      icon: Icons.medical_services,
      latitude: -6.154991074431215,
      longitude: 106.78810520691225,
      services: ['Konsultasi kesehatan', 'Pemeriksaan kesehatan umum'],
    ),
    const Facility(
      name: 'Klinik Pratama Cindy Clinique',
      type: 'Klinik',
      address: 'Sedayu Business Park, Cengkareng Barat',
      distance: 'Belum diketahui',
      icon: Icons.medical_services,
      latitude: -6.139791,
      longitude: 106.727539,
      services: ['Konsultasi kesehatan', 'Pemeriksaan kesehatan umum'],
    ),
    const Facility(
      name: 'Klinik Utama Raycare',
      type: 'Klinik',
      address: 'Jl. Peta Selatan No. 6, Kalideres',
      distance: 'Belum diketahui',
      icon: Icons.medical_services,
      latitude: -6.1451024,
      longitude: 106.7003112,
      services: ['Konsultasi kesehatan', 'Pemeriksaan kesehatan umum'],
    ),
  ];

  List<Facility> get _filteredFacilities {
    final searchText = _searchController.text.toLowerCase();

    final filtered = _facilities
        .where((facility) {
          final matchesSearch =
              facility.name.toLowerCase().contains(searchText) ||
              facility.address.toLowerCase().contains(searchText) ||
              facility.services.any(
                (service) => service.toLowerCase().contains(searchText),
              );

          final matchesCategory =
              _selectedCategory == 'Semua' ||
              facility.type == _selectedCategory;

          return matchesSearch && matchesCategory;
        })
        .map((facility) {
          String distanceText = 'Lokasi belum aktif';

          if (_currentPosition != null) {
            final distance = Geolocator.distanceBetween(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
              facility.latitude,
              facility.longitude,
            );

            distanceText = distance >= 1000
                ? '${(distance / 1000).toStringAsFixed(2)} km'
                : '${distance.toStringAsFixed(0)} m';
          }

          return Facility(
            name: facility.name,
            type: facility.type,
            address: facility.address,
            distance: distanceText,
            icon: facility.icon,
            latitude: facility.latitude,
            longitude: facility.longitude,
            phone: facility.phone,
            services: facility.services,
          );
        })
        .toList();

    if (_currentPosition != null) {
      filtered.sort((a, b) {
        final distanceA = Geolocator.distanceBetween(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          a.latitude,
          a.longitude,
        );

        final distanceB = Geolocator.distanceBetween(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          b.latitude,
          b.longitude,
        );

        return distanceA.compareTo(distanceB);
      });
    }

    return filtered;
  }

  Future<void> _getCurrentLocation() async {
    if (_isLoadingLocation) return;

    setState(() {
      _isLoadingLocation = true;
    });

    try {
      final position = await _locationService.getCurrentLocation();

      if (!mounted) return;

      setState(() {
        _currentPosition = position;
        _currentLocation =
            '${position.latitude.toStringAsFixed(6)}, '
            '${position.longitude.toStringAsFixed(6)}';
      });

      _checkGeofences(position);
      _startGeofencing();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lokasi berhasil ditemukan!')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  void _startGeofencing() {
    _positionSubscription?.cancel();

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 20,
    );

    _positionSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (Position position) {
            if (!mounted) return;

            setState(() {
              _currentPosition = position;
              _currentLocation =
                  '${position.latitude.toStringAsFixed(6)}, '
                  '${position.longitude.toStringAsFixed(6)}';
            });

            _checkGeofences(position);
          },
          onError: (error) {
            if (!mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Pemantauan lokasi bermasalah: $error')),
            );
          },
        );
  }

  void _checkGeofences(Position position) {
    final Set<String> currentlyInside = {};

    for (final facility in _facilities) {
      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        facility.latitude,
        facility.longitude,
      );

      if (distance <= _geofenceRadius) {
        currentlyInside.add(facility.name);

        if (!_insideGeofences.contains(facility.name)) {
          _showGeofenceNotification(facility, distance);
        }
      }
    }

    _insideGeofences
      ..clear()
      ..addAll(currentlyInside);
  }

  void _showGeofenceNotification(Facility facility, double distance) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 6),
          backgroundColor: const Color(0xFF16856B),
          content: Text(
            'Anda berada dekat ${facility.name} '
            '(${distance.toStringAsFixed(0)} meter).',
          ),
        ),
      );
  }

  Future<void> _openMap() async {
    if (_currentPosition == null) {
      await _getCurrentLocation();
    }

    if (!mounted || _currentPosition == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MapScreen(position: _currentPosition!, facilities: _facilities),
      ),
    );
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final facilities = _filteredFacilities;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Smart Village',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF16856B),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WelcomeCard(),
            const SizedBox(height: 20),

            LocationCard(
              location: _isLoadingLocation
                  ? 'Sedang mencari lokasi...'
                  : _currentLocation,
              onTap: _getCurrentLocation,
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isLoadingLocation ? null : _openMap,
                icon: const Icon(Icons.map),
                label: const Text('Lihat Peta Lokasi'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF16856B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Card(
              elevation: 0,
              color: const Color(0xFFE0F2EC),
              child: const ListTile(
                leading: Icon(Icons.radar, color: Color(0xFF16856B), size: 30),
                title: Text(
                  'Geofencing Aktif',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF126B56),
                  ),
                ),
                subtitle: Text(
                  'Peringatan muncul saat Anda memasuki '
                  'radius 500 meter dari fasilitas kesehatan.',
                ),
              ),
            ),

            const SizedBox(height: 20),

            SearchField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {});
              },
            ),

            const SizedBox(height: 20),

            const Text(
              'Kategori Fasilitas',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            CategoryFilter(
              selectedCategory: _selectedCategory,
              onSelected: (category) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),

            const SizedBox(height: 20),

            Text(
              'Fasilitas Kesehatan Jakarta Barat (${facilities.length})',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            if (facilities.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('Fasilitas tidak ditemukan.'),
                ),
              )
            else
              ...facilities.map(
                (facility) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: FacilityCard(facility: facility),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
