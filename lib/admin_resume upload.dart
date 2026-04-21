import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:xml/xml.dart';

import 'candidate_dashboard.dart';

class AdminResumeUpload extends StatefulWidget {
  const AdminResumeUpload({super.key});

  @override
  State<AdminResumeUpload> createState() => _AdminResumeUploadState();
}

class _AdminResumeUploadState extends State<AdminResumeUpload> {
  static const int _shortlistScoreThreshold = 95;

  final TextEditingController _keywordController = TextEditingController(
    text: 'flutter, dart, api, sql, communication',
  );

  final List<_ResumeMatchResult> _results = [];
  bool _isProcessing = false;

  @override
  void dispose() {
    _keywordController.dispose();
    super.dispose();
  }

  Future<void> _pickAndAnalyzeResumes() async {
    final pickedFiles = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
      withData: true,
    );

    if (pickedFiles == null || pickedFiles.files.isEmpty) {
      return;
    }

    final requiredKeywords = _parseKeywords(_keywordController.text);
    if (requiredKeywords.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter required keywords first.')),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    final analyzedResults = <_ResumeMatchResult>[];

    for (final file in pickedFiles.files) {
      final result = await _analyzeFile(file, requiredKeywords);
      analyzedResults.add(result);
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _results
        ..clear()
        ..addAll(analyzedResults);
      _isProcessing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Analyzed ${analyzedResults.length} resume(s).'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<_ResumeMatchResult> _analyzeFile(
    PlatformFile file,
    List<String> requiredKeywords,
  ) async {
    final fileName = file.name;
    final extension = (file.extension ?? '').toLowerCase();
    String extractedText = '';

    try {
      if (file.bytes != null) {
        extractedText = await _extractTextFromBytes(file.bytes!, extension);
      }
    } catch (_) {
      extractedText = '';
    }

    final sourceText = extractedText.isNotEmpty
        ? extractedText.toLowerCase()
        : fileName.toLowerCase();

    final matchedKeywords = requiredKeywords
        .where((keyword) => sourceText.contains(keyword.toLowerCase()))
        .toList();

    final score = requiredKeywords.isEmpty
        ? 0
        : ((matchedKeywords.length / requiredKeywords.length) * 100).round();

    return _ResumeMatchResult(
      fileName: fileName,
      score: score,
      matchedKeywords: matchedKeywords,
    );
  }

  Future<String> _extractTextFromBytes(
      List<int> bytes, String extension) async {
    switch (extension) {
      case 'pdf':
        final document = PdfDocument(inputBytes: bytes);
        final extractor = PdfTextExtractor(document);
        final text = extractor.extractText();
        document.dispose();
        return text;
      case 'docx':
        final archive = ZipDecoder().decodeBytes(bytes);
        final documentFile = archive.files.firstWhere(
          (file) => file.name == 'word/document.xml',
          orElse: () => ArchiveFile('word/document.xml', 0, const <int>[]),
        );

        if (documentFile.content is! List<int>) {
          return '';
        }

        final xmlText = utf8.decode(documentFile.content as List<int>);
        final xmlDocument = XmlDocument.parse(xmlText);
        return xmlDocument
            .findAllElements('w:t')
            .map((element) => element.innerText)
            .join(' ')
            .trim();
      case 'txt':
        return utf8.decode(bytes);
      default:
        return '';
    }
  }

  List<String> _parseKeywords(String value) {
    return value
        .split(RegExp(r'[,\n]'))
        .map((keyword) => keyword.trim())
        .where((keyword) => keyword.isNotEmpty)
        .toList();
  }

  bool _isShortlisted(int score) => score >= _shortlistScoreThreshold;

  String _statusLabelForScore(int score) {
    if (_isShortlisted(score)) {
      return 'SHORTLISTED';
    }
    if (score >= 70) {
      return 'REVIEW';
    }
    return 'NOT MATCHED';
  }

  Color _colorForScore(int score) {
    if (_isShortlisted(score)) {
      return Colors.green;
    }
    if (score >= 70) {
      return Colors.orange;
    }
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Bulk Resume Upload',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Admin Portal • Smart Hire',
              style: TextStyle(color: Colors.grey, fontSize: 10),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Import Talent',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add multiple candidates instantly',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _keywordController,
              decoration: InputDecoration(
                labelText: 'Required keywords',
                hintText: 'flutter, dart, api',
                prefixIcon: const Icon(Icons.psychology_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              minLines: 1,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Text(
              'Score is based on how many required keywords are found in each resume.',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
            ),
            const SizedBox(height: 22),
            Expanded(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _isProcessing ? null : _pickAndAnalyzeResumes,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _isProcessing
                              ? const SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: CircularProgressIndicator(),
                                )
                              : const Icon(Icons.cloud_upload_outlined,
                                  size: 50, color: Colors.blue),
                          const SizedBox(height: 20),
                          const Text(
                            'Tap to upload resumes',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'PDF, DOC, DOCX, TXT • Bulk upload supported',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 14),
                          ),
                          const SizedBox(height: 12),
                          TextButton.icon(
                            onPressed:
                                _isProcessing ? null : _pickAndAnalyzeResumes,
                            icon: const Icon(Icons.upload_file),
                            label: const Text('Upload Resume'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_results.isNotEmpty) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CandidateDashboard(isAdminView: true),
                            ),
                          );
                        },
                        icon: const Icon(Icons.dashboard_customize_outlined),
                        label: Text(
                          _results
                                  .where((item) => _isShortlisted(item.score))
                                  .isNotEmpty
                              ? 'Open Candidate Dashboard (Shortlisted Found)'
                              : 'Open Candidate Dashboard',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E6AFB),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Expanded(
                    child: _results.isEmpty
                        ? Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Center(
                              child: Text(
                                'Upload resumes to see AI match scores here.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          )
                        : ListView.separated(
                            itemCount: _results.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final result = _results[index];
                              final color = _colorForScore(result.score);
                              final status = _statusLabelForScore(result.score);

                              return Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      color: color.withOpacity(0.15)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.description_outlined,
                                            color: Colors.blue),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            result.fileName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: color.withOpacity(0.12),
                                            borderRadius:
                                                BorderRadius.circular(999),
                                          ),
                                          child: Text(
                                            '${result.score}% match',
                                            style: TextStyle(
                                              color: color,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Status: $status',
                                      style: TextStyle(
                                        color: color,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    LinearProgressIndicator(
                                      value: result.score / 100,
                                      minHeight: 8,
                                      backgroundColor: Colors.grey.shade200,
                                      color: color,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      result.matchedKeywords.isEmpty
                                          ? 'No required keywords found.'
                                          : 'Matched keywords:',
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: result.matchedKeywords.isEmpty
                                          ? [
                                              Chip(
                                                label: const Text('No matches'),
                                                backgroundColor:
                                                    Colors.grey.shade100,
                                              )
                                            ]
                                          : result.matchedKeywords
                                              .map(
                                                (keyword) => Chip(
                                                  label: Text(keyword),
                                                  backgroundColor:
                                                      Colors.blue.shade50,
                                                ),
                                              )
                                              .toList(),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResumeMatchResult {
  const _ResumeMatchResult({
    required this.fileName,
    required this.score,
    required this.matchedKeywords,
  });

  final String fileName;
  final int score;
  final List<String> matchedKeywords;
}
