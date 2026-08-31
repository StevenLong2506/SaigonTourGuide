import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saigon_tour_guide/core/api_client.dart';
import 'package:saigon_tour_guide/model/interest_tag.dart';
import 'package:saigon_tour_guide/provider/auth_provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final Set<int> _selected = {};
  List<InterestTag> _tags = [];
  bool _loading = true;
  String? _error;
  bool _submitting = false;

  Future<void> _loadTags() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await context.read<ApiClient>().dio.get(
        '/tags/',
        queryParameters: {'limit': 100},
      );
      final items = (res.data as List)
          .map((e) => InterestTag.fromJson(e as Map<String, dynamic>))
          .toList();
      if (!mounted) return;
      setState(() => _tags = items);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = getErrorMessage(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTags();
    final current = context.read<AuthProvider>().user?.interests ?? [];
    _selected.addAll(current.map((i) => i.tagId));
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    try {
      await context.read<AuthProvider>().setInterests(_selected.toList());
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(getErrorMessage(e))));
      }
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }
  
  void _exit(){
    if (Navigator.of(context).canPop()){
      Navigator.of(context).pop();
    }
    else{
      context.read<AuthProvider>().skipOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bạn quan tâm điều gì?'),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: _submitting ? null : _exit,
            child: const Text('Thoát'),
          ),
        ],
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? Center(child: Text(_error!))
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Chọn vài sở thích để chúng tôi gợi ý địa điểm phù hợp với bạn.',
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _tags.map((tag) {
                            final isSelected = _selected.contains(tag.id);
                            return FilterChip(
                              label: Text(tag.name),
                              selected: isSelected,
                              onSelected: (v) => setState(() {
                                if (v) {
                                  _selected.add(tag.id);
                                } else {
                                  _selected.remove(tag.id);
                                }
                              }),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _submitting ? null : _submit,
                      child: _submitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              _selected.isEmpty
                                  ? 'Tiếp tục'
                                  : 'Lưu (${_selected.length}) đã chọn',
                            ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
