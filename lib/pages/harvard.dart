import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class HarvardPage extends StatefulWidget {
  const HarvardPage({super.key});

  @override
  State<HarvardPage> createState() => _HarvardPageState();
}

class _HarvardPageState extends State<HarvardPage> {
  bool showInIDR = false;
  final double tuitionPerYear = 55000; 
  final double usdToIdr = 16650; 

  String formatCurrency(num amount, String currencyCode) {
    switch (currencyCode) {
      case 'USD':
        return "\$${NumberFormat('#,###').format(amount)} USD";
      case 'IDR':
        return "Rp ${NumberFormat('#,###', 'id_ID').format(amount)}";
      default:
        return amount.toString();
    }
  }

  Future<void> _launchURL() async {
    final uri =
        Uri.parse('https://www.liputan6.com/tag/harvard-university/text');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final double perMonthUSD =
    (((tuitionPerYear / 12) / 100).round() * 100).toDouble(); 
    final double tuitionPerYearIDR = tuitionPerYear * usdToIdr;
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
                'img/harvard.jpg',
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),

            // Judul 
            const Text(
              "Harvard University: Perjalanan Panjang Menuju Keunggulan Akademik Dunia",
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
              "Didirikan pada tahun 1636, Harvard University adalah universitas tertua di Amerika Serikat dan salah satu institusi paling bergengsi di dunia. "
              "Awalnya bernama New College sebelum akhirnya diganti menjadi Harvard College pada tahun 1639 sebagai penghormatan kepada John Harvard, "
              "seorang pendeta muda yang menyumbangkan perpustakaan serta sebagian besar hartanya untuk mendukung pendidikan di koloni Massachusetts Bay.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
            const SizedBox(height: 16),

            const Text(
              "Kini, Harvard berkembang menjadi universitas riset global dengan 12 fakultas, termasuk Harvard Law School, Business School, dan Medical School. "
              "Universitas ini menempati kawasan luas di Cambridge, Massachusetts, dengan arsitektur klasik yang memadukan nilai sejarah dan modernitas. "
              "Lebih dari 20.000 mahasiswa dari seluruh dunia menempuh pendidikan di Harvard setiap tahunnya.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
            const SizedBox(height: 16),

            const Text(
              "Selain prestasi akademik, Harvard dikenal dengan jaringan alumninya yang luar biasa — termasuk delapan Presiden Amerika Serikat, "
              "puluhan penerima Nobel, dan berbagai tokoh berpengaruh di bidang teknologi, ekonomi, dan kemanusiaan. "
              "Dengan reputasinya yang mendunia, Harvard terus menjadi simbol pendidikan berkualitas tinggi dan riset inovatif yang berdampak besar bagi dunia.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
            const SizedBox(height: 30),

            // Bagian biaya kuliah
            _buildTuitionSection(
              showInIDR ? tuitionPerYearIDR : tuitionPerYear,
              showInIDR ? perMonthIDR : perMonthUSD,
              showInIDR ? 'IDR' : 'USD',
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
                      borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.currency_exchange, color: Colors.white),
                label: Text(
                  showInIDR ? "Show in USD 🇺🇸" : "Convert to IDR 🇮🇩",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Tombol kunjungi artikel
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

  // Bagian biaya kuliah
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
            "Biaya Pendidikan di Harvard ",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade800,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Rata-rata biaya kuliah di Harvard mencapai:",
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
            "Biaya ini belum termasuk tempat tinggal, makanan, dan kebutuhan pribadi. "
            "Harvard juga menyediakan berbagai beasiswa penuh dan bantuan finansial untuk mahasiswa internasional berbakat.",
            style: TextStyle(fontSize: 15, height: 1.5),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
