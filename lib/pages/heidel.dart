import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class HeidelPage extends StatefulWidget {
  const HeidelPage({super.key});

  @override
  State<HeidelPage> createState() => _HeidelPageState();
}

class _HeidelPageState extends State<HeidelPage> {
  bool showInIDR = false;
  final double tuitionPerYear = 20000; 

  final double exchangeRate = 19180; 

  String formatCurrency(num amount, String currencyCode) {
    switch (currencyCode) {
      case 'EUR':
        return "€${NumberFormat('#,###').format(amount)} EUR";
      case 'IDR':
        return "Rp ${NumberFormat('#,###', 'id_ID').format(amount)}";
      default:
        return amount.toString();
    }
  }

  Future<void> _launchURL() async {
    final uri = Uri.parse(
        'https://www.kompasiana.com/hennietriana/62f2d38a3555e40328262e18/heidelberg-daya-pikat-kota-paling-romantis-di-jerman');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final double perMonth =
    (((tuitionPerYear / 12) / 50).round() * 50).toDouble(); // tetap dibulatkan ke kelipatan 50 untuk EUR

    
    final double tuitionPerYearIDR = tuitionPerYear * exchangeRate;
    final double perMonthIDR = tuitionPerYearIDR / 12;


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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar header
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'img/heidel.jpg',
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),

            // Judul artikel
            const Text(
              "Heidelberg University: Warisan Keilmuan dan Inovasi dari Jantung Eropa",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E4620),
                height: 1.3,
              ),
            ),
            const SizedBox(height: 16),

            // Paragraf artikel
            const Text(
              "Heidelberg University, didirikan pada tahun 1386, adalah universitas tertua di Jerman dan salah satu institusi akademik paling bergengsi di Eropa. "
              "Terletak di kota Heidelberg yang indah di tepi Sungai Neckar, universitas ini telah menjadi pusat keilmuan dan riset selama lebih dari enam abad. "
              "Heidelberg dikenal atas kontribusinya dalam bidang kedokteran, ilmu sosial, filsafat, dan sains alam.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
            const SizedBox(height: 16),

            const Text(
              "Universitas ini memiliki lebih dari 30.000 mahasiswa, dengan sekitar seperempatnya berasal dari luar Jerman. "
              "Lingkungan kampus yang kaya sejarah dipadukan dengan pendekatan riset modern, menjadikan Heidelberg tempat yang ideal bagi mahasiswa yang ingin menggabungkan tradisi akademik dengan inovasi global.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
            const SizedBox(height: 16),

            const Text(
              "Heidelberg University juga terkenal karena pendekatannya yang kolaboratif dalam penelitian lintas disiplin. "
              "Melalui jaringan riset internasional, universitas ini berperan penting dalam pengembangan ilmu pengetahuan global. "
              "Selain itu, kehidupan mahasiswa di Heidelberg sangat dinamis dengan festival budaya, kegiatan seni, dan pemandangan alam yang menakjubkan di sekitar kota tua.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16, height: 1.6),
            ),

            const SizedBox(height: 30),

            // Bagian biaya kuliah
            _buildTuitionSection(
              showInIDR ? tuitionPerYearIDR : tuitionPerYear,
              showInIDR ? perMonthIDR : perMonth,
              showInIDR ? 'IDR' : 'EUR',
            ),

            const SizedBox(height: 25),

            // Tombol konversi
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() => showInIDR = !showInIDR);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade400,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.currency_exchange, color: Colors.white),
                label: Text(
                  showInIDR ? "Show in EUR 🇩🇪" : "Convert to IDR 🇮🇩",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Tombol artikel
            Center(
              child: ElevatedButton.icon(
                onPressed: _launchURL,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade200,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.article_outlined, color: Colors.black87),
                label: const Text(
                  "Kunjungi Artikel Lainnya",
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Section Biaya Kuliah
  Widget _buildTuitionSection(double yearly, double monthly, String currency) {
    return Container(
      key: ValueKey(currency),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.shade100,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Biaya Pendidikan di Heidelberg",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade800,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Sebagai mahasiswa internasional, perkiraan total biaya tahunan di Heidelberg University adalah:",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 6),
          Text(
            "• Per tahun: ${formatCurrency(yearly, currency)}",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800),
          ),
          Text(
            "• Per bulan: ${formatCurrency(monthly, currency)}",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800),
          ),
          const SizedBox(height: 10),
          const Text(
            "Angka ini termasuk biaya kuliah dan biaya hidup di kota Heidelberg. "
            "Meski biaya kuliah universitas negeri di Jerman relatif rendah, "
            "pengeluaran utama mahasiswa biasanya berasal dari akomodasi, transportasi, dan kebutuhan sehari-hari.",
            style: TextStyle(fontSize: 15, height: 1.5),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
