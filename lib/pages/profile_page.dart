import 'package:flutter/material.dart';
import '../services/session_service.dart';
import 'zoom_schedule_page.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await SessionService.getUserSession();
    setState(() {
      _userData = user;
    });
  }

  Future<void> _logout() async {
    await SessionService.clearSession();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: _userData == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  // Foto Profil 
                  Center(
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: const Color.fromARGB(255, 172, 190, 213),
                      backgroundImage: const AssetImage('img/profile.jpg'),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Nama, Username & Email
                  Text(
                    _userData!["name"] ?? 'Akun Pengguna',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _userData!["username"] ?? '',
                    style:
                        const TextStyle(color: Color.fromARGB(255, 65, 59, 59)),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _userData!["email"] ?? '',
                    style: const TextStyle(
                        color: Color.fromARGB(255, 153, 152, 152)),
                  ),

                  const SizedBox(height: 30),
                  const Divider(thickness: 1),
                  const SizedBox(height: 16),

                  // Card Zoom Gratis Internasional
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ZoomSchedulePage()),
                      );
                    },
                    child: Card(
                      elevation: 5,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      shadowColor: Colors.green.shade200,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'img/zoom.png',
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "Zoom Gratis Internasional",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 12, 58, 20),
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    "Ikuti sesi Zoom gratis bersama tutor luar negeri! "
                                    "Tingkatkan kemampuan bahasa dan wawasan internasionalmu.",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black87),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios,
                                color: Color.fromARGB(255, 114, 122, 137)),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Card Saran
                  Card(
                    color: Colors.green.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Saran Mata Kuliah:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Mata kuliah Pemrograman Aplikasi Mobile sangat bermanfaat. '
                            'Akan lebih menarik jika di semester berikutnya dikasih project yang lebih menantang.',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Card Kesan
                  Card(
                    color: const Color.fromARGB(255, 164, 186, 210),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Kesan Mata Kuliah:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Belajar mobile membuat aplikasi nyata dengan Flutter membuat pengalaman kuliah menjadi menyenangkan '
                            'mahasiswa jadi terlatih berkreasi dan berinovasi di bidang teknologi.',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Tentang Aplikasi
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('Tentang Aplikasi'),
                    subtitle: const Text(
                        'UniVerse by Nabila Ardelia Lutfi - 124230159'),
                  ),

                  // Logout
                  ListTile(
                    leading:
                        const Icon(Icons.logout, color: Colors.red),
                    title: const Text('Logout'),
                    onTap: _logout,
                  ),
                ],
              ),
            ),
    );
  }
}
