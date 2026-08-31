import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saigon_tour_guide/core/api_client.dart';

class GenerateItineraryScreen extends StatefulWidget {
  const GenerateItineraryScreen({super.key});
  @override
  State<GenerateItineraryScreen> createState() =>
      _GenerateItineraryScreenState();
}

class _GenerateItineraryScreenState extends State<GenerateItineraryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _queryController = TextEditingController();
  int _durationDay = 1;
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await context.read<ApiClient>().dio.post(
        '/itineraries/generate',
        data: {
          'raw_query': _queryController.text.trim(),
          'duration_day': _durationDay,
        },
      );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) setState(() => _error = getErrorMessage(e));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tạo lịch trình bằng AI')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _queryController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Bạn muốn đi đâu?',
                    hintText:
                        'VD: Thích ăn uống và tham quan lịch sử, ngân sách vừa phải, đi cùng gia đình',
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Vui lòng nhập yêu cầu'
                      : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Số ngày:'),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Slider(
                        value: _durationDay.toDouble(),
                        min: 1,
                        max: 7,
                        divisions: 6,
                        label: '$_durationDay ngày',
                        onChanged: _submitting
                            ? null
                            : (v) => setState(() => _durationDay = v.round()),
                      ),
                    ),
                    Text('$_durationDay ngày'),
                  ],
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _submitting ? null : _submit, 
                  child: _submitting
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Text(
                            'AI đang tạo lịch trình... (có thể mất chút thời gian)',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    )
                    : const Text('Tạo lịch trình')
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
