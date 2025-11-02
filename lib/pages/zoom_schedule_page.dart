import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/time_converter.dart';

class ZoomSchedulePage extends StatefulWidget {
  const ZoomSchedulePage({super.key});

  @override
  State<ZoomSchedulePage> createState() => _ZoomSchedulePageState();
}

class _ZoomSchedulePageState extends State<ZoomSchedulePage> {
  String selectedZone = 'WIB';
  late String _currentTime;

  final List<Map<String, dynamic>> schedules = [
    {
      'title': 'Tes TOEFL Online 🇬🇧 ',
      'tutor': 'Mr. Smith 22 April 2025',
      'time': {'hour': 15, 'minute': 0},
      'zone': 'London',
    },
    {
      'title': 'Kelas IELTS Persiapan 🇬🇧 ',
      'tutor': 'Ms. Elizabeth 28 Mei 2025',
      'time': {'hour': 10, 'minute': 30},
      'zone': 'London',
    },
    {
      'title': 'Simulasi Beasiswa Jepang 🇯🇵 ',
      'tutor': 'Mr. Tanaka 10 June 2025',
      'time': {'hour': 19, 'minute': 0},
      'zone': 'Jepang',
    },
    {
      'title': 'Workshop Motivation Study Abroad 🇬🇧 ',
      'tutor': 'Dr. John 30 July 2025',
      'time': {'hour': 20, 'minute': 15},
      'zone': 'London',
    },
  ];

  String getDetailedZoneLabel(String zone) {
    switch (zone) {
      case 'WIB':
        return 'WIB';
      case 'WITA':
        return 'WITA';
      case 'WIT':
        return 'WIT';
      case 'Jepang':
      case 'Tokyo':
        return 'JST';
      case 'London':
        return 'GMT';
      default:
        return zone;
    }
  }

  @override
  void initState() {
    super.initState();
    _currentTime = _getFormattedTime();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = _getFormattedTime();
      });
    });
  }

  String _getFormattedTime() {
    final now = DateTime.now().toUtc().add(const Duration(hours: 7)); // WIB = UTC+7
    return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        backgroundColor: Colors.green.shade200,
        title: const Text(
          "Zoom Internasional",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // CARD JAM REALTIME WIB
            Card(
              elevation: 5,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              shadowColor: Colors.green.shade100,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Column(
                  children: [
                    const Text(
                      "Time Now WIB :",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 500),
                      style: TextStyle(
                        fontSize: 38,
                        fontFamily: 'monospace',
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                      child: Text(_currentTime),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 4,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.green.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Dropdown zona waktu
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.green.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Pilih Zona Waktu :",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  DropdownButton<String>(
                    value: selectedZone,
                    underline: const SizedBox(),
                    items: ['WIB', 'WITA', 'WIT', 'London', 'Jepang']
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (val) {
                      setState(() => selectedZone = val!);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Daftar jadwal + card lokasi di bawahnya
            Expanded(
              child: ListView(
                children: [
                  for (var schedule in schedules)
                    Builder(
                      builder: (context) {
                        final tutorTime = DateTime(
                          2025,
                          1,
                          1,
                          schedule['time']['hour'],
                          schedule['time']['minute'],
                        );
                        final converted = convertTime(
                          fromZone: schedule['zone'],
                          toZone: selectedZone,
                          hour: tutorTime.hour,
                          minute: tutorTime.minute,
                        );

                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  schedule['title'],
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 8),
                                Text(schedule['tutor'],
                                    style: const TextStyle(color: Colors.black54)),
                                const SizedBox(height: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Time: ${formatTime(tutorTime)} • ${getDetailedZoneLabel(schedule['zone'])}",
                                        style:
                                            const TextStyle(color: Colors.black87),
                                      ),
                                      Text(
                                        "Kamu: ${formatTime(converted)} • ${getDetailedZoneLabel(selectedZone)}",
                                        style: TextStyle(
                                          color: Colors.green.shade700,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
