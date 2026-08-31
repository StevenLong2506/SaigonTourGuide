import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saigon_tour_guide/core/api_client.dart';
import 'package:saigon_tour_guide/core/app_labels.dart';
import 'package:saigon_tour_guide/provider/auth_provider.dart';

class TravelProfileScreen extends StatefulWidget {
  const TravelProfileScreen({super.key});
  @override
  State<TravelProfileScreen> createState() => _TravelProfileScreenState();
}

class _TravelProfileScreenState extends State<TravelProfileScreen> {
  String? _travelStyle;
  String? _budgetLevel;
  bool _withChildren = false;
  bool _withElderly = false;
  bool _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final profile = context.read<AuthProvider>().user?.travelProfile;
    if (profile != null) {
      _travelStyle = profile.travelStyle;
      _budgetLevel = profile.budgetLevel;
      _withChildren = profile.withChildren ?? false;
      _withElderly = profile.withElderly ?? false;
    }
  }

  Future<void> _submit() async {
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await context.read<AuthProvider>().setTravelProfile(
        travelStyle: _travelStyle,
        budgetLevel: _budgetLevel,
        withChildren: _withChildren,
        withElderly: _withElderly,
      );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if(mounted) setState(() => _error = getErrorMessage(e));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hồ sơ du lịch')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Bạn thường đi du lịch với ai?',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AppLabels.travelStyle.entries.map((e) {
                  return ChoiceChip(
                    label: Text(e.value),
                    selected: _travelStyle == e.key,
                    onSelected: (_) => setState(
                      () => _travelStyle = _travelStyle == e.key ? null : e.key,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Text(
                'Ngân sách thường dùng?',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AppLabels.budgetLevel.entries.map((e) {
                  return ChoiceChip(
                    label: Text(e.value),
                    selected: _budgetLevel == e.key,
                    onSelected: (_) => setState(
                      () => _budgetLevel = _budgetLevel == e.key ? null : e.key,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Thường đi cùng trẻ em'),
                value: _withChildren,
                onChanged: (v) => setState(() => _withChildren = v),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Thường đi cùng người lớn tuổi'),
                value: _withElderly,
                onChanged: (v) => setState(() => _withElderly = v),
              ),
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
                        child: CircularProgressIndicator(),
                      )
                    : const Text('Lưu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
