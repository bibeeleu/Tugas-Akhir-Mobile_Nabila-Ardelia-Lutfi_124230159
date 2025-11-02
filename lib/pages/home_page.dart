import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../models/university_model.dart';
import '../services/university_data_source.dart';
import 'profile_page.dart';
import 'top_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  List<University> _searchResults = [];
  List<String> _searchHistory = [];
  bool _isLoading = false;
  int _selectedIndex = 0;
  bool _hasSearched = false;

  // Variabel lokasi
  String _currentAddress = "📍 Mendapatkan lokasi...";
  bool _isLocationLoading = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
    _getCurrentLocation();


    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // fungsi lokasi
  Future<void> _getCurrentLocation() async {
    setState(() => _isLocationLoading = true);

    try {
      var status = await Permission.location.request();
      if (!status.isGranted) {
        setState(() {
          _currentAddress = "❌ Izin lokasi ditolak pengguna.";
          _isLocationLoading = false;
        });
        return;
      }

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _currentAddress = "⚠️ GPS belum aktif. Aktifkan layanan lokasi.";
          _isLocationLoading = false;
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks.first;
      String detailAlamat =
          "${place.street}, ${place.subLocality}, ${place.locality}, ${place.subAdministrativeArea}";

      setState(() {
        _currentAddress = "📍 $detailAlamat";
        _isLocationLoading = false;
      });

      _animController.forward(from: 0); 
    } catch (e) {
      setState(() {
        _currentAddress = "⚠️ Gagal memuat lokasi: $e";
        _isLocationLoading = false;
      });
    }
  }
  

  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchHistory = prefs.getStringList('search_history') ?? [];
    });
  }

  Future<void> _addToHistory(String name) async {
    final prefs = await SharedPreferences.getInstance();
    _searchHistory.remove(name);
    _searchHistory.insert(0, name);
    if (_searchHistory.length > 5) _searchHistory = _searchHistory.sublist(0, 5);
    await prefs.setStringList('search_history', _searchHistory);
    setState(() {});
  }

  Future<void> _searchUniversity() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    try {
      final results = await UniversityDataSource.searchUniversities(query);
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memuat data universitas')),
      );
    }

    setState(() => _isLoading = false);
  }

  Future<void> _launchUrl(String url, String name) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      _addToHistory(name);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat membuka link universitas')),
      );
    }
  }

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        _hasSearched = false;
        _searchResults.clear();
        _searchController.clear();
      }
    });
  }

  // Tampilan lokasi
  Widget _buildLocationCard() {
    return FadeTransition(
      opacity: _fadeAnim,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Lokasi Anda Saat Ini",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _isLocationLoading
                ? const CircularProgressIndicator()
                : Text(
                    _currentAddress,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.my_location),
              label: const Text("Perbarui Lokasi"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade300,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                elevation: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Cari universitas impianmu...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                onPressed: _searchUniversity,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onSubmitted: (_) => _searchUniversity(),
          ),
          const SizedBox(height: 20),
          _buildLocationCard(),
          const SizedBox(height: 20),

          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_hasSearched)
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final u = _searchResults[index];
                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(u.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(u.country),
                      trailing: const Icon(Icons.open_in_new),
                      onTap: () => _launchUrl(u.webPages.first, u.name),
                    ),
                  );
                },
              ),
            )
          else
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      color: Colors.green.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: const [
                            Text(
                              "Yuk Cari Tahu Kampus Dunia 🌍",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Temukan informasi universitas impian kamu dari seluruh dunia. "
                              "Jelajahi dan akses website resmi universitas langsung pada search bar di atas!",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_searchHistory.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Riwayat pencarian:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _searchHistory.length,
                            itemBuilder: (context, index) {
                              final name = _searchHistory[index];
                              return ListTile(
                                leading: const Icon(Icons.history),
                                title: Text(name),
                              );
                            },
                          ),
                        ],
                      )
                    else
                      const Text(
                        'Belum ada riwayat pencarian',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHomeContent(),
      const TopPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        backgroundColor: Colors.green.shade200,
        elevation: 4,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Image.asset(
            'img/logouniverse.png',
            height: 100,
            fit: BoxFit.contain,
          ),
        ),
      ),
      body: SafeArea( 
        child: pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
        selectedItemColor: Colors.green.shade400,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Universe'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
