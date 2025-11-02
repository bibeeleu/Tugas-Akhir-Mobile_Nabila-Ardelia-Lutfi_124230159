import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart';
import 'services/session_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🛎️ Inisialisasi Awesome Notifications
  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        channelDescription: 'Notifikasi pengingat kuis UniVerse',
        defaultColor: const Color(0xFF388E3C),
        ledColor: const Color(0xFF81C784),
        importance: NotificationImportance.High,
      ),
    ],
  );


  bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowed) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  runApp(const UniVerseApp());
}

class UniVerseApp extends StatefulWidget {
  const UniVerseApp({super.key});

  @override
  State<UniVerseApp> createState() => _UniVerseAppState();
}

class _UniVerseAppState extends State<UniVerseApp> {
  String _locationMessage = "📍 Mengambil lokasi...";
  bool _loadingLocation = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // Ambil izin + lokasi saat aplikasi dibuka
  Future<void> _getCurrentLocation() async {
    try {
      // Minta izin lokasi
      var status = await Permission.location.request();
      if (!status.isGranted) {
        setState(() {
          _locationMessage = "❌ Izin lokasi ditolak pengguna.";
          _loadingLocation = false;
        });
        return;
      }

      // Pastikan GPS aktif
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationMessage = "⚠️ GPS belum aktif. Aktifkan layanan lokasi.";
          _loadingLocation = false;
        });
        return;
      }

      // Ambil posisi GPS
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Ubah koordinat jadi alamat
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        setState(() {
          _locationMessage =
              "📍 ${place.subAdministrativeArea}, ${place.locality}, ${place.administrativeArea}";
        });
      } else {
        setState(() {
          _locationMessage = "⚠️ Gagal mendapatkan alamat.";
        });
      }
    } catch (e) {
      setState(() {
        _locationMessage = "⚠️ Error: $e";
      });
    }

    setState(() {
      _loadingLocation = false;
    });
  }

  ///  Menampilkan isi tabel 'users' dari database 
  Future<void> printUsers() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'universe_new.db');
      final db = await openDatabase(path);

      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='users';",
      );

      if (tables.isEmpty) {
        print('⚠️ Tabel "users" belum ada di database.');
        await db.close();
        return;
      }

      final result = await db.query('users');
      print('\n================== DATA USER DARI DATABASE ==================');

      if (result.isEmpty) {
        print('Belum ada data user tersimpan.');
      } else {
        print(
            '+----+-----------------+--------------------------+------------------------------------------+');
        print(
            '| ID | USERNAME        | EMAIL                    | PASSWORD HASH                            |');
        print(
            '+----+-----------------+--------------------------+------------------------------------------+');

        for (var row in result) {
          final id = row['id'].toString().padRight(2);
          final username = (row['username'] ?? '').toString().padRight(15);
          final email = (row['email'] ?? '').toString().padRight(24);
          final password = (row['password'] ?? '').toString();

          final shortHash =
              password.length > 40 ? password.substring(0, 40) + '...' : password;

          print('| ${id.padRight(2)} | $username | $email | $shortHash |');
        }

        print(
            '+----+-----------------+--------------------------+------------------------------------------+');
        print('Total user: ${result.length}');
      }

      print('================================================================\n');
      await db.close();
    } catch (e) {
      print('❌ Gagal membaca database: $e');
    }
  }

  
  Future<Widget> _getInitialPage() async {
    final session = await SessionService.getUserSession();
    await printUsers();
    return session != null ? const HomePage() : const LoginPage();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _getInitialPage(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'UniVerse',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
            useMaterial3: true,
          ),
          home: Scaffold(
            body: Column(
              children: [
                // 🌍 Lokasi tampil di atas halaman
                Container(
                  width: double.infinity,
                  color: Colors.greenAccent.withOpacity(0.2),
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    _loadingLocation
                        ? "⏳ Mengambil lokasi..."
                        : _locationMessage,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(child: snapshot.data!),
              ],
            ),
          ),
          routes: {
            '/login': (context) => const LoginPage(),
            '/register': (context) => const RegisterPage(),
            '/home': (context) => const HomePage(),
          },
        );
      },
    );
  }
}
