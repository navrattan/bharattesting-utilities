import 'package:flutter/material.dart';

void main() {
  runApp(const SimpleBharatTestingApp());
}

class SimpleBharatTestingApp extends StatelessWidget {
  const SimpleBharatTestingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BharatTesting Utilities',
      theme: ThemeData.dark(useMaterial3: true),
      home: const SimpleHomeScreen(),
    );
  }
}

class SimpleHomeScreen extends StatelessWidget {
  const SimpleHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BharatTesting Utilities'),
        backgroundColor: const Color(0xFF0D1117),
      ),
      backgroundColor: const Color(0xFF0D1117),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // BT Logo
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF58A6FF), Color(0xFF0969DA)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Center(
                    child: Text(
                      'BT',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // App Title
                Text(
                  'BharatTesting Utilities',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                Text(
                  '5 free, privacy-first, offline developer tools',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color(0xFF7D8590),
                      ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 48),

                // Tool Grid
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: [
                    _buildToolCard(context, 'Indian Data Faker', 'Generate PAN, GSTIN, Aadhaar', Icons.account_circle, 'Live'),
                    _buildToolCard(context, 'JSON Converter', 'Auto-repair JSON/CSV/YAML', Icons.code, 'Live'),
                    _buildToolCard(context, 'Image Reducer', 'Compress & resize images', Icons.photo_size_select_large, 'Soon'),
                    _buildToolCard(context, 'PDF Merger', 'Merge & protect PDFs', Icons.picture_as_pdf, 'Soon'),
                    _buildToolCard(context, 'Document Scanner', 'OCR → Searchable PDF', Icons.document_scanner, 'Soon'),
                    _buildToolCard(context, 'About', 'Learn more', Icons.info, 'Info'),
                  ],
                ),

                const SizedBox(height: 48),

                // Status
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3FB950).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF3FB950)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, color: Color(0xFF3FB950)),
                      SizedBox(width: 12),
                      Text(
                        'App Successfully Deployed on bharattesting.com',
                        style: TextStyle(
                          color: Color(0xFF3FB950),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToolCard(BuildContext context, String title, String description, IconData icon, String status) {
    final isLive = status == 'Live';
    final color = isLive ? const Color(0xFF3FB950) : const Color(0xFF7D8590);

    return Card(
      color: const Color(0xFF21262D),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: const Color(0xFF58A6FF)),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(
                color: Color(0xFF7D8590),
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: color, width: 1),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}