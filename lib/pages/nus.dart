import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class NusPage extends StatefulWidget {
  const NusPage({super.key});

  @override
  State<NusPage> createState() => _NusPageState();
}

class _NusPageState extends State<NusPage> {
  bool showInIDR = false;
  final double tuitionPerYear = 30000; // SGD

  final double exchangeRate = 12790; 

  String formatCurrency(num amount, String currencyCode) {
    switch (currencyCode) {
      case 'SGD':
        return "S\$${NumberFormat('#,###').format(amount)} SGD";
      case 'IDR':
        return "Rp ${NumberFormat('#,###', 'id_ID').format(amount)}";
      default:
        return amount.toString();
    }
  }

  Future<void> _launchURL() async {
    final uri = Uri.parse(
        'https://www.kompas.id/artikel/nus-business-school-dan-ilmu-yang-menjawab-zaman');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final double perMonth =
    (((tuitionPerYear / 12) / 10).round() * 10).toDouble(); 
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
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'img/nus.jpg',
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),

            // Judul Artikel
            const Text(
              "National University of Singapore (NUS): Inovasi, Riset, dan Pendidikan Kelas Dunia di Asia",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E4620),
                height: 1.3,
              ),
            ),
            const SizedBox(height: 16),

            // Paragraf Artikel
            const Text(
              "National University of Singapore (NUS) merupakan universitas riset publik ternama di Asia dan dunia. "
              "Didirikan pada tahun 1905 dengan nama Straits Settlements and Federated Malay States Government Medical School, "
              "kampus ini telah berkembang menjadi lembaga pendidikan tinggi yang berpengaruh secara global. "
              "NUS dikenal atas komitmennya terhadap inovasi, riset interdisipliner, dan pengembangan solusi untuk tantangan masa depan.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
            const SizedBox(height: 16),

            const Text(
              "Terletak di Singapura, NUS memiliki lebih dari 40.000 mahasiswa dari seluruh dunia dan menawarkan berbagai program "
              "di bidang teknik, bisnis, ilmu sosial, hukum, hingga teknologi. "
              "Dengan reputasi yang kuat di dunia riset dan kolaborasi industri, NUS secara konsisten menempati peringkat teratas universitas terbaik di Asia menurut QS World University Rankings.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
            const SizedBox(height: 16),

            const Text(
              "Fasilitas di NUS dirancang dengan teknologi canggih — mulai dari laboratorium riset modern, inkubator startup, hingga pusat inovasi AI. "
              "Mahasiswa di NUS juga aktif dalam kegiatan sosial dan kompetisi internasional, menjadikan kampus ini rumah bagi individu berbakat yang siap bersaing di panggung global.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16, height: 1.6),
            ),

            const SizedBox(height: 30),

            // Bagian Biaya Kuliah
            _buildTuitionSection(
              showInIDR ? tuitionPerYearIDR : tuitionPerYear,
              showInIDR ? perMonthIDR : perMonth,
              showInIDR ? 'IDR' : 'SGD',
            ),

            const SizedBox(height: 25),

            // Tombol Convert
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
                      borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.currency_exchange, color: Colors.white),
                label: Text(
                  showInIDR ? "Show in SGD 🇸🇬" : "Convert to IDR 🇮🇩",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Tombol Kunjungi Artikel
            Center(
              child: ElevatedButton.icon(
                onPressed: _launchURL,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade200,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                icon:
                    const Icon(Icons.article_outlined, color: Colors.black87),
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

  // Biaya Kuliah Card
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
            "Biaya Pendidikan di NUS",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade800,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Rata-rata biaya kuliah di National University of Singapore (NUS) adalah:",
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
            "Biaya ini mencakup biaya akademik standar dan belum termasuk akomodasi serta kebutuhan hidup mahasiswa. "
            "Namun, NUS menyediakan berbagai program beasiswa bagi mahasiswa internasional berprestasi, termasuk dukungan finansial berbasis riset.",
            style: TextStyle(fontSize: 15, height: 1.5),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
