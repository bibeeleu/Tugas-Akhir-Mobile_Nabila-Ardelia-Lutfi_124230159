import 'package:flutter/material.dart';
import 'quiz_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class QuizResultPage extends StatefulWidget {
  final int score;
  const QuizResultPage({super.key, required this.score});

  @override
  State<QuizResultPage> createState() => _QuizResultPageState();
}

class _QuizResultPageState extends State<QuizResultPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<double> _scaleIn;

  String _getResultText() {
    if (widget.score >= 80) {
      return "Kamu cocok kuliah di luar negeri 🌍";
    } else if (widget.score >= 50) {
      return "Kamu lebih cocok kuliah di dalam negeri 🎓";
    } else {
      return "Kamu cocok rebahan di rumah saja 🏠";
    }
  }

  String _getImagePath() {
    if (widget.score >= 80) return 'img/1.png';
    if (widget.score >= 50) return 'img/2.png';
    return 'img/3.png';
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scaleIn = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _controller.forward();
    });

    // Tandai bahwa user sudah menyelesaikan quiz
    _markQuizAsCompleted();
  }

  Future<void> _markQuizAsCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('quiz_notification_sent', true);

    await AwesomeNotifications().cancel(2);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        backgroundColor: Colors.green.shade200,
        title: const Text(
          "Hasil Kuis",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: FadeTransition(
          opacity: _fadeIn,
          child: ScaleTransition(
            scale: _scaleIn,
            child: SingleChildScrollView(
              child: Card(
                elevation: 8,
                shadowColor: Colors.green.shade100,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                margin:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.score >= 80)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            3,
                            (i) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Icon(
                                Icons.star_rounded,
                                color: Colors.yellow.shade600,
                                size: 36,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 10),

                      Image.asset(
                        _getImagePath(),
                        width: 240,
                        height: 240,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 28),

                      Text(
                        "Skor Kamu: ${widget.score}",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                      const SizedBox(height: 14),

                      Text(
                        _getResultText(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 36),

                      ElevatedButton.icon(
                        onPressed: () async {
                          // Reset supaya notifikasi bisa muncul lagi kalau user mau ulang quiz
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('quiz_notification_sent', false);

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const QuizPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade300,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          shadowColor: Colors.green.shade200,
                          elevation: 4,
                        ),
                        icon: const Icon(Icons.refresh, color: Colors.black87),
                        label: const Text(
                          'Coba Lagi',
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
