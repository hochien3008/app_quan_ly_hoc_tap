import 'package:flutter/material.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({super.key});

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  String _selectedSubject = 'All';
  final List<String> _subjects = [
    'All',
    'Math',
    'English',
    'Physics',
    'Chemistry',
  ];
  final List<Map<String, String>> _documents = [
    {
      'title': 'Math Notes - Algebra',
      'subject': 'Math',
      'type': 'pdf',
      'preview': '',
    },
    {
      'title': 'English Vocabulary',
      'subject': 'English',
      'type': 'word',
      'preview': '',
    },
    {
      'title': 'Physics Lab Report',
      'subject': 'Physics',
      'type': 'image',
      'preview': '',
    },
    {
      'title': 'Chemistry Formulas',
      'subject': 'Chemistry',
      'type': 'pdf',
      'preview': '',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredDocs =
        _selectedSubject == 'All'
            ? _documents
            : _documents
                .where((doc) => doc['subject'] == _selectedSubject)
                .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Documents'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: () {
              // TODO: upload document
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter theo môn học
            Row(
              children: [
                const Text(
                  'Filter by subject:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: _selectedSubject,
                  items:
                      _subjects
                          .map(
                            (subject) => DropdownMenuItem(
                              value: subject,
                              child: Text(subject),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _selectedSubject = value);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Grid/list tài liệu
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: filteredDocs.length,
                itemBuilder: (context, index) {
                  final doc = filteredDocs[index];
                  return _buildDocumentCard(doc);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: upload document
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDocumentCard(Map<String, String> doc) {
    final icon = _getDocIcon(doc['type'] ?? '');
    final color = _getSubjectColor(doc['subject'] ?? '');
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 3,
      color: color.withOpacity(0.12),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          // TODO: preview document/ocr/note
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: Text(doc['title'] ?? ''),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(icon, color: color),
                          const SizedBox(width: 8),
                          Text(doc['type']?.toUpperCase() ?? ''),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text('Subject: ${doc['subject']}'),
                      const SizedBox(height: 12),
                      const Text(
                        'Preview/OCR/Note: (coming soon)',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: color,
                radius: 28,
                child: Icon(icon, color: Colors.white, size: 32),
              ),
              const SizedBox(height: 14),
              Text(
                doc['title'] ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Chip(
                label: Text(doc['subject'] ?? ''),
                backgroundColor: color.withOpacity(0.18),
                labelStyle: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getDocIcon(String type) {
    switch (type) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'word':
        return Icons.description;
      case 'image':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getSubjectColor(String subject) {
    switch (subject.toLowerCase()) {
      case 'math':
        return const Color(0xFF4A90E2);
      case 'english':
        return const Color(0xFFF5A623);
      case 'physics':
        return const Color(0xFF7ED6DF);
      case 'chemistry':
        return const Color(0xFF27AE60);
      default:
        return Colors.grey;
    }
  }
}
