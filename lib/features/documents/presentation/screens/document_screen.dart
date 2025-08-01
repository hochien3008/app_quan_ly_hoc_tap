import 'package:flutter/material.dart';

import '../../../../routes/route_names.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({super.key});

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen>
    with TickerProviderStateMixin {
  String _selectedSubject = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<String> _subjects = [
    'All',
    'Math',
    'English',
    'Physics',
    'Chemistry',
  ];

  final List<Map<String, dynamic>> _documents = [
    {
      'id': '1',
      'title': 'Math Notes - Algebra',
      'subject': 'Math',
      'type': 'pdf',
      'size': '2.3 MB',
      'uploadDate': '2024-01-15',
      'preview': 'Algebra fundamentals and quadratic equations...',
      'notes': 'Important for exam preparation',
    },
    {
      'id': '2',
      'title': 'English Vocabulary',
      'subject': 'English',
      'type': 'word',
      'size': '1.8 MB',
      'uploadDate': '2024-01-14',
      'preview': 'Advanced vocabulary list with definitions...',
      'notes': 'Review before speaking test',
    },
    {
      'id': '3',
      'title': 'Physics Lab Report',
      'subject': 'Physics',
      'type': 'image',
      'size': '3.1 MB',
      'uploadDate': '2024-01-13',
      'preview': 'Lab experiment results and analysis...',
      'notes': 'Submit by Friday',
    },
    {
      'id': '4',
      'title': 'Chemistry Formulas',
      'subject': 'Chemistry',
      'type': 'pdf',
      'size': '1.5 MB',
      'uploadDate': '2024-01-12',
      'preview': 'Chemical formulas and reactions...',
      'notes': 'Memorize key formulas',
    },
    {
      'id': '5',
      'title': 'Math Practice Problems',
      'subject': 'Math',
      'type': 'pdf',
      'size': '4.2 MB',
      'uploadDate': '2024-01-11',
      'preview': 'Practice problems with solutions...',
      'notes': 'Complete by next week',
    },
    {
      'id': '6',
      'title': 'English Essay Template',
      'subject': 'English',
      'type': 'word',
      'size': '0.8 MB',
      'uploadDate': '2024-01-10',
      'preview': 'Essay structure and guidelines...',
      'notes': 'Use for final essay',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredDocs = _getFilteredDocuments();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.background,
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: 120,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: const Text(
                    'Documents',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.primary.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () => _showSearchDialog(),
                ),
                IconButton(
                  icon: const Icon(Icons.upload, color: Colors.white),
                  onPressed: () => _showUploadOptions(),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(RouteNames.profile);
                    },
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildSearchBar(),
                      const SizedBox(height: 20),
                      _buildSubjectFilter(),
                      const SizedBox(height: 20),
                      if (filteredDocs.isEmpty)
                        _buildEmptyState()
                      else
                        _buildDocumentsList(filteredDocs),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showUploadOptions(),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Upload'),
        elevation: 8,
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredDocuments() {
    var filtered = _documents;

    // Filter by subject
    if (_selectedSubject != 'All') {
      filtered =
          filtered.where((doc) => doc['subject'] == _selectedSubject).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered =
          filtered.where((doc) {
            final title = doc['title'].toString().toLowerCase();
            final subject = doc['subject'].toString().toLowerCase();
            final notes = doc['notes'].toString().toLowerCase();
            final query = _searchQuery.toLowerCase();

            return title.contains(query) ||
                subject.contains(query) ||
                notes.contains(query);
          }).toList();
    }

    return filtered;
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey[600], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search documents...',
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              style: const TextStyle(fontSize: 16),
            ),
          ),
          if (_searchQuery.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                });
              },
              child: Icon(Icons.clear, color: Colors.grey[600], size: 20),
            ),
        ],
      ),
    );
  }

  Widget _buildSubjectFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.filter_list,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Filter by Subject',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              _subjects.map((subject) {
                final isSelected = _selectedSubject == subject;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedSubject = subject;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color:
                            isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      subject,
                      style: TextStyle(
                        color:
                            isSelected
                                ? Colors.white
                                : Theme.of(context).colorScheme.primary,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(Icons.folder_open, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No documents found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Upload your first document to get started',
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => _showUploadOptions(),
            icon: const Icon(Icons.upload),
            label: const Text('Upload Document'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsList(List<Map<String, dynamic>> documents) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.description,
                color: Colors.blue,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Documents (${documents.length})',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...documents.map((doc) => _buildDocumentCard(doc)),
      ],
    );
  }

  Widget _buildDocumentCard(Map<String, dynamic> document) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: _getFileTypeColor(document['type']).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            _getFileTypeIcon(document['type']),
            color: _getFileTypeColor(document['type']),
            size: 24,
          ),
        ),
        title: Text(
          document['title'],
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getSubjectColor(
                      document['subject'],
                    ).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    document['subject'],
                    style: TextStyle(
                      color: _getSubjectColor(document['subject']),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  document['size'],
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              document['preview'],
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (document['notes'] != null && document['notes'].isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.note, size: 14, color: Colors.orange[600]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      document['notes'],
                      style: TextStyle(
                        color: Colors.orange[600],
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            switch (value) {
              case 'preview':
                _previewDocument(document);
                break;
              case 'ocr':
                _performOCR(document);
                break;
              case 'edit':
                _editDocument(document);
                break;
              case 'download':
                _downloadDocument(document);
                break;
              case 'share':
                _shareDocument(document);
                break;
              case 'delete':
                _deleteDocument(document);
                break;
            }
          },
          itemBuilder:
              (context) => [
                const PopupMenuItem(
                  value: 'preview',
                  child: Row(
                    children: [
                      Icon(Icons.visibility, size: 20),
                      SizedBox(width: 8),
                      Text('Preview'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'ocr',
                  child: Row(
                    children: [
                      Icon(Icons.text_fields, size: 20),
                      SizedBox(width: 8),
                      Text('OCR Text'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 20),
                      SizedBox(width: 8),
                      Text('Edit Notes'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'download',
                  child: Row(
                    children: [
                      Icon(Icons.download, size: 20),
                      SizedBox(width: 8),
                      Text('Download'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'share',
                  child: Row(
                    children: [
                      Icon(Icons.share, size: 20),
                      SizedBox(width: 8),
                      Text('Share'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 20, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
        ),
        onTap: () => _previewDocument(document),
        onLongPress: () => _showDocumentActions(document),
      ),
    );
  }

  Color _getFileTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Colors.red;
      case 'word':
      case 'doc':
      case 'docx':
        return Colors.blue;
      case 'image':
      case 'jpg':
      case 'png':
        return Colors.green;
      case 'excel':
      case 'xlsx':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getFileTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'word':
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'image':
      case 'jpg':
      case 'png':
        return Icons.image;
      case 'excel':
      case 'xlsx':
        return Icons.table_chart;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getSubjectColor(String subject) {
    switch (subject.toLowerCase()) {
      case 'math':
        return Colors.blue;
      case 'english':
        return Colors.green;
      case 'physics':
        return Colors.orange;
      case 'chemistry':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  void _showDocumentDetails(Map<String, dynamic> doc) {
    final color = _getSubjectColor(doc['subject'] ?? '');

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                Icon(_getDocIcon(doc['type'] ?? ''), color: color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    doc['title'] ?? '',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Subject', doc['subject'] ?? ''),
                _buildDetailRow('Type', doc['type']?.toUpperCase() ?? ''),
                _buildDetailRow('Size', doc['size'] ?? ''),
                _buildDetailRow('Upload Date', doc['uploadDate'] ?? ''),
                const SizedBox(height: 12),
                const Text(
                  'Preview:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  doc['preview'] ?? 'No preview available',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                if (doc['notes']?.isNotEmpty == true) ...[
                  const SizedBox(height: 12),
                  const Text(
                    'Notes:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    doc['notes'] ?? '',
                    style: TextStyle(color: color, fontStyle: FontStyle.italic),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _previewDocument(doc);
                },
                child: const Text('Preview'),
              ),
            ],
          ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showDocumentActions(Map<String, dynamic> document) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.preview),
                  title: const Text('Preview Document'),
                  onTap: () {
                    Navigator.pop(context);
                    _previewDocument(document);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.text_fields),
                  title: const Text('Extract Text (OCR)'),
                  onTap: () {
                    Navigator.pop(context);
                    _performOCR(document);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.edit_note),
                  title: const Text('Add/Edit Notes'),
                  onTap: () {
                    Navigator.pop(context);
                    _editDocument(document);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.download),
                  title: const Text('Download'),
                  onTap: () {
                    Navigator.pop(context);
                    _downloadDocument(document);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.share),
                  title: const Text('Share'),
                  onTap: () {
                    Navigator.pop(context);
                    _shareDocument(document);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _deleteDocument(document);
                  },
                ),
              ],
            ),
          ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Search Documents'),
            content: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search by title, subject, or notes...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              autofocus: true,
              onSubmitted: (value) {
                setState(() {
                  _searchQuery = value;
                });
                Navigator.pop(context);
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _searchQuery = _searchController.text;
                  });
                  Navigator.pop(context);
                },
                child: const Text('Search'),
              ),
            ],
          ),
    );
  }

  void _showUploadOptions() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Upload Document',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.folder_open),
                  title: const Text('Choose from Files'),
                  subtitle: const Text('Select existing document'),
                  onTap: () {
                    Navigator.pop(context);
                    _uploadFromFiles();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Take Photo'),
                  subtitle: const Text('Capture document with camera'),
                  onTap: () {
                    Navigator.pop(context);
                    _takePhoto();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.scanner),
                  title: const Text('Scan Document'),
                  subtitle: const Text('Use document scanner'),
                  onTap: () {
                    Navigator.pop(context);
                    _scanDocument();
                  },
                ),
              ],
            ),
          ),
    );
  }

  void _performOCR(Map<String, dynamic> document) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('OCR Processing'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text('Extracting text from ${document['title']}...'),
              ],
            ),
          ),
    );

    // Simulate OCR processing
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      _showOCRResult(document);
    });
  }

  void _showOCRResult(Map<String, dynamic> document) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('OCR Result - ${document['title']}'),
            content: const SingleChildScrollView(
              child: Text(
                'This is the extracted text from the document. You can copy, edit, or save this text for further use.',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: Copy to clipboard
                },
                child: const Text('Copy Text'),
              ),
            ],
          ),
    );
  }

  void _editDocument(Map<String, dynamic> document) {
    final TextEditingController controller = TextEditingController(
      text: document['notes'] ?? '',
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Edit Notes - ${document['title']}'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Notes',
                border: OutlineInputBorder(),
                hintText: 'Add your notes here...',
              ),
              maxLines: 3,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    document['notes'] = controller.text;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Notes updated successfully!'),
                    ),
                  );
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  void _previewDocument(Map<String, dynamic> document) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(document['title']),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Subject: ${document['subject']}'),
                Text('Type: ${document['type']}'),
                Text('Size: ${document['size']}'),
                Text('Upload Date: ${document['uploadDate']}'),
                const SizedBox(height: 8),
                Text('Preview: ${document['preview']}'),
                if (document['notes'] != null &&
                    document['notes'].isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text('Notes: ${document['notes']}'),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _downloadDocument(document);
                },
                child: const Text('Download'),
              ),
            ],
          ),
    );
  }

  void _downloadDocument(Map<String, dynamic> document) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading ${document['title']}...'),
        action: SnackBarAction(
          label: 'View',
          onPressed: () {
            // TODO: Open downloads folder
          },
        ),
      ),
    );
  }

  void _shareDocument(Map<String, dynamic> document) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${document['title']}...'),
        action: SnackBarAction(
          label: 'Share',
          onPressed: () {
            // TODO: Implement share functionality
          },
        ),
      ),
    );
  }

  void _deleteDocument(Map<String, dynamic> document) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Document'),
            content: Text(
              'Are you sure you want to delete "${document['title']}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _documents.removeWhere(
                      (doc) => doc['id'] == document['id'],
                    );
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${document['title']} deleted successfully!',
                      ),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          setState(() {
                            _documents.add(document);
                          });
                        },
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  void _uploadFromFiles() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Opening file picker...')));
  }

  void _takePhoto() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Opening camera...')));
  }

  void _scanDocument() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening document scanner...')),
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
}
