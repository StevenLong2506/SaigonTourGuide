import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:saigon_tour_guide/core/api_client.dart';
import 'package:saigon_tour_guide/core/date_formats.dart';
import 'package:saigon_tour_guide/model/review.dart';

class WriteReviewScreen extends StatefulWidget {
  final int placeId;
  final Review? existingReview;
  const WriteReviewScreen({
    super.key,
    required this.placeId,
    this.existingReview,
  });

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {

  int _rating = 0;
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  DateTime? _visitDate;
  final List<XFile> _pickedImages = [];
  bool _submitting = false;
  String? _error;

  bool get _isEditing => widget.existingReview != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingReview;
    if (existing != null) {
      _rating = existing.rating;
      _titleController.text = existing.title ?? '';
      _contentController.text = existing.content ?? '';
      _visitDate = existing.visitDate;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final picked = await ImagePicker().pickMultiImage(imageQuality: 80);
    if (picked.isEmpty) return;
    setState(() => _pickedImages.addAll(picked));
  }

  Future<void> _pickVisitDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: now,
      initialDate: now,
    );
    if (picked != null) setState(() => _visitDate = picked);
  }

  Future<void> _submit() async {
    if (_rating == 0) {
      setState(() => _error = 'Vui lòng chọn số sao đánh giá');
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final apiClient = context.read<ApiClient>();
      if (_isEditing) {
        await apiClient.dio.patch(
          '/reviews/${widget.existingReview!.id}',
          data: {
            'rating': _rating,
            'title': _titleController.text.trim().isNotEmpty
                ? _titleController.text.trim()
                : null,
            'content': _contentController.text.trim().isNotEmpty
                ? _contentController.text.trim()
                : null,
            if (_visitDate != null)
              'visit_date': AppDateFormat.api.format(_visitDate!),
          },
        );
      } else {
        final formData = FormData.fromMap({
          'place_id': widget.placeId,
          'rating': _rating,
          if (_titleController.text.trim().isNotEmpty)
            'title': _titleController.text.trim(),
          if (_contentController.text.trim().isNotEmpty)
            'content': _contentController.text.trim(),
          if (_visitDate != null)
            'visit_date': AppDateFormat.api.format(_visitDate!),
          'files': [
            for (final f in _pickedImages)
              await MultipartFile.fromFile(f.path, filename: f.name),
          ],
        });
        await apiClient.dio.post('/reviews/', data: formData);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if(mounted) setState(() => _error = getErrorMessage(e));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Sửa đánh giá' : 'Viết đánh giá'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                    (i) => IconButton(
                      onPressed: () => setState(() => _rating = i + 1),
                      icon: Icon(
                        i < _rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Tiêu đề (không bắt buộc)',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Nội dung (không bắt buộc)',
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _pickVisitDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Ngày ghé thăm (không bắt buộc)',
                  ),
                  child: Text(
                    _visitDate == null
                        ? 'Chọn ngày'
                        : AppDateFormat.display.format(_visitDate!),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (_isEditing) ...[
                if (widget.existingReview!.images.isNotEmpty) ...[
                  Text(
                    'Ảnh đã đăng (không thể chỉnh sửa)',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 80,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.existingReview!.images.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, idx) => ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          widget.existingReview!.images[idx],
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ] else ...[
                TextButton.icon(
                  onPressed: _pickImages,
                  icon: const Icon(Icons.add_photo_alternate_outlined),
                  label: const Text('Thêm ảnh'),
                ),
                if (_pickedImages.isNotEmpty)
                  SizedBox(
                    height: 80,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _pickedImages.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, idx) => Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(_pickedImages[idx].path),
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () =>
                                  setState(() => _pickedImages.removeAt(idx)),
                              child: const CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.black54,
                                child: Icon(
                                  Icons.close,
                                  size: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(_isEditing ? 'Cập nhật' : 'Gửi đánh giá'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
