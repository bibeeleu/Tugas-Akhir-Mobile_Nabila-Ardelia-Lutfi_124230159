import 'dart:async';
import 'package:flutter/material.dart';
import 'quiz_result_page.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage>
    with SingleTickerProviderStateMixin {
  bool _isStarted = false;
  int _currentQuestion = 0;
  int _score = 0;
  int _timeLeft = 60;
  Timer? _timer;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Kamu lebih suka belajar dengan cara apa?',
      'options': ['Praktik langsung', 'Diskusi kelompok', 'Baca teori', 'Menonton video'],
      'answer': 0,
    },
    {
      'question': 'Apakah kamu suka tantangan baru?',
      'options': ['Kurang', 'Suka', 'Tidak terlalu', 'Tidak suka'],
      'answer': 1,
    },
    {
      'question': 'Kamu lebih nyaman di lingkungan seperti apa?',
      'options': ['Internasional', 'Nasional', 'Santai', 'Formal'],
      'answer': 0,
    },
    {
      'question': 'Kamu lebih suka komunikasi dengan bahasa Inggris?',
      'options': ['Ya banget', 'Sedikit-sedikit', 'Ya Saya sering Berbahasa Inggris', 'Tidak bisa'],
      'answer': 2,
    },
    {
      'question': 'Kamu suka riset dan hal akademik?',
      'options': ['Ya', 'Kadang-kadang', 'Tidak terlalu', 'Tidak suka'],
      'answer': 0,
    },
    {
      'question': 'Kamu lebih suka tinggal jauh dari keluarga?',
      'options': ['Tidak masalah', 'Tergantung', 'Kurang suka', 'Tidak mau'],
      'answer': 0,
    },
    {
      'question': 'Kamu lebih tertarik pada kampus besar?',
      'options': ['Tidak Begitu', 'Ya Tertarik', 'Tidak', 'Tergantung'],
      'answer': 1,
    },
    {
      'question': 'Kamu bisa beradaptasi dengan cepat di tempat baru?',
      'options': ['Ya banget', 'Cukup', 'Kurang', 'Tidak sama sekali'],
      'answer': 0,
    },
    {
      'question': 'Apakah kamu suka kegiatan organisasi atau komunitas kampus?',
      'options': ['Sangat suka', 'Kadang ikut', 'Jarang', 'Tidak tertarik'],
      'answer': 0,
    },
    {
      'question': 'Kalau menghadapi tugas sulit, kamu akan...',
      'options': ['Pasrah', 'Minta bantuan teman', 'Menunda dulu', 'Mencoba sampai bisa'],
      'answer': 3,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // Jadwalkan notifikasi setelah halaman dibuka
    _scheduleReminderNotification();
  }

  // Jadwal notifikasi otomatis setelah 10 detik
  Future<void> _scheduleReminderNotification() async {
    final prefs = await SharedPreferences.getInstance();
    bool hasShown = prefs.getBool('quiz_notification_sent') ?? false;

    if (!hasShown) {
      DateTime now = DateTime.now();
      DateTime scheduleTime = now.add(const Duration(seconds: 10));

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 2,
          channelKey: 'basic_channel',
          title: '🧠 Kamu Keren!',
          body: 'Seleseikan Mini Quiz dan lihat seberapa cocok kamu kuliah di luar negeri!',
          notificationLayout: NotificationLayout.BigText,
        ),
        schedule: NotificationCalendar(
          year: scheduleTime.year,
          month: scheduleTime.month,
          day: scheduleTime.day,
          hour: scheduleTime.hour,
          minute: scheduleTime.minute,
          second: scheduleTime.second,
          millisecond: 0,
          repeats: false,
        ),
      );

      await prefs.setBool('quiz_notification_sent', true);
    }
  }

  void _startQuiz() {
    setState(() {
      _isStarted = true;
      _score = 0;
      _currentQuestion = 0;
      _timeLeft = 60;
    });

    _animationController.forward();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _timeLeft--);
      if (_timeLeft <= 0) _finishQuiz();
    });
  }

  void _answerQuestion(int index) async {
    if (index == _questions[_currentQuestion]['answer']) {
      setState(() => _score += 10);
    }

    if (_currentQuestion < _questions.length - 1) {
      await _animationController.reverse();
      setState(() => _currentQuestion++);
      _animationController.forward();
    } else {
      _finishQuiz();
    }
  }

  void _finishQuiz() {
    _timer?.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuizResultPage(score: _score),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        backgroundColor: Colors.green.shade200,
        title: const Text(
          "Mini Kuis",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: !_isStarted ? _buildStartScreen() : _buildQuizContent(),
    );
  }

  // Tampilan awal kuis
  Widget _buildStartScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('img/1.png', width: 230),
            const SizedBox(height: 30),
            const Text(
              'Tes Kepribadian Dirimu',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 146, 195, 147),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Jawab 10 pertanyaan singkat selama 1 menit untuk mengetahui apakah kamu cocok berkuliah di Luar Negeri!',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _startQuiz,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade300,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                shadowColor: Colors.green.shade200,
                elevation: 5,
              ),
              child: const Text(
                'Mulai Sekarang',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tampilan pertanyaan dan jawaban kuis
  Widget _buildQuizContent() {
    final question = _questions[_currentQuestion];
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Soal ${_currentQuestion + 1}/${_questions.length}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text('Waktu: $_timeLeft dtk', style: const TextStyle(color: Colors.red)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: Text(
                      'Skor: $_score / 100',
                      key: ValueKey<int>(_score),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 88, 153, 89),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: _timeLeft / 60),
                duration: const Duration(milliseconds: 500),
                builder: (context, value, _) => LinearProgressIndicator(
                  value: value,
                  color: Colors.green,
                  backgroundColor: Colors.grey.shade300,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                question['question'],
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ...List.generate(
                question['options'].length,
                (index) => Card(
                  color: Colors.white,
                  elevation: 3,
                  shadowColor: Colors.green.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _answerQuestion(index),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                      child: Row(
                        children: [
                          Icon(Icons.circle_outlined,
                              color: Colors.green.shade400, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              question['options'][index],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
