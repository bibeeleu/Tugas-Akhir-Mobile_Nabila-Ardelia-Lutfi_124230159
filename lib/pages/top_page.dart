import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'quiz_page.dart';
import 'harvard.dart';
import 'nus.dart';
import 'heidel.dart';

class TopPage extends StatefulWidget {
  const TopPage({super.key});

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  Timer? _notifTimer; 

  final List<Map<String, String>> topUniversities = const [
    {
      'name': 'Harvard University',
      'country': 'Amerika Serikat',
      'image': 'img/harvard.jpg',
      'page': 'harvard',
      'description':
          'Harvard menawarkan pendidikan unggul dengan tradisi akademik yang kuat dan alumni berpengaruh.'
    },
    {
      'name': 'National University of Singapore (NUS)',
      'country': 'Singapore',
      'image': 'img/nus.jpg',
      'page': 'nus',
      'description':
          'NUS adalah universitas riset publik terkemuka di Asia, dikenal akan keunggulan akademik dan inovasi global.'
    },
    {
      'name': 'Heidelberg University',
      'country': 'Germany',
      'image': 'img/heidel.jpg',
      'page': 'heidel',
      'description':
          'Universitas tertua di Jerman yang unggul dalam riset ilmiah dan reputasi akademik internasional.'
    },
  ];

  @override
  void initState() {
    super.initState();
    _checkAndScheduleNotification();
  }

  /// Mengecek apakah user sudah pernah mengikuti kuis
  Future<void> _checkAndScheduleNotification() async {
    final prefs = await SharedPreferences.getInstance();
    bool hasDoneQuiz = prefs.getBool('has_done_quiz') ?? false;

    if (!hasDoneQuiz) {
      // Jadwalkan notifikasi setelah 10 detik
      _notifTimer = Timer(const Duration(seconds: 10), () {
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 1,
            channelKey: 'basic_channel',
            title: '🎯 Yuk Ikuti Mini Quiz!',
            body:
                'Sudah siap tahu seberapa cocok kamu kuliah di luar negeri? Coba Mini Quiz 1 menit sekarang!',
            notificationLayout: NotificationLayout.BigText,
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _notifTimer?.cancel(); // Batalkan timer saat user keluar halaman
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header
          Card(
            color: Colors.green.shade100,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: const [
                  Text(
                    "Top Universitas Dunia 🌎",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Kenali universitas terbaik dunia melalui artikel berikut. Klik Baca Selengkapnya untuk informasi lebih lengkap!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Card Menu Mini Quiz
          GestureDetector(
            onTap: () async {
              _notifTimer?.cancel(); // Tambahan: hentikan timer sebelum buka kuis

              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('has_done_quiz', true); // Tandai sudah kuis

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QuizPage()),
              );
            },
            child: Card(
              elevation: 5,
              color: Colors.green.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'img/quiz.png',
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
                            "Mini Quiz ",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 9, 9, 9)),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "Yuk Coba Tes singkat 1 menit untuk tahu apakah kamu cocok berkuliah di Luar Negeri!",
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

          const SizedBox(height: 16),

          // List Artikel Universitas
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: topUniversities.length,
            itemBuilder: (context, index) {
              final uni = topUniversities[index];
              return Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.asset(
                        uni['image']!,
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            uni['name']!,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            uni['country']!,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            uni['description']!,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () {
                                if (uni['page'] == 'harvard') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HarvardPage()),
                                  );
                                } else if (uni['page'] == 'nus') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const NusPage()),
                                  );
                                } else if (uni['page'] == 'heidel') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HeidelPage()),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 170, 186, 203),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Baca Selengkapnya',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 2, 60, 132)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
