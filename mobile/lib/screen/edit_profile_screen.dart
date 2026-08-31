import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saigon_tour_guide/core/api_client.dart';
import 'package:saigon_tour_guide/core/app_labels.dart';
import 'package:saigon_tour_guide/core/date_formats.dart';
import 'package:saigon_tour_guide/provider/auth_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameControllor;
  late final TextEditingController _emailControllor;
  late final TextEditingController _phoneControllor;
  late DateTime _dob;
  late String _gender;
  bool _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    if (user == null) {
      _nameControllor = TextEditingController();
      _emailControllor = TextEditingController();
      _phoneControllor = TextEditingController();
      _dob = DateTime.now();
      _gender = 'MALE';
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.of(context).pop();
      });
      return;
    }
    _nameControllor = TextEditingController(text: user.name);
    _emailControllor = TextEditingController(text: user.email);
    _phoneControllor = TextEditingController(text: user.phone);
    _dob = user.dob;
    _gender = user.gender;
  }

  @override
  void dispose() {
    _nameControllor.dispose();
    _emailControllor.dispose();
    _phoneControllor.dispose();
    super.dispose();
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: now,
      initialDate: _dob,
    );
    if (picked != null) setState(() => _dob = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await context.read<AuthProvider>().updateProfile(
        name: _nameControllor.text.trim(),
        email: _emailControllor.text.trim(),
        phone: _phoneControllor.text.trim(),
        dob: AppDateFormat.api.format(_dob),
        gender: _gender,
      );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) setState(() => _error = getErrorMessage(e));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chỉnh sửa hồ sơ')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameControllor,
                  decoration: const InputDecoration(labelText: 'Họ và tên'),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Vui lòng nhập họ tên' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailControllor,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (v) => (v == null || !v.contains('@'))
                      ? 'Email không hợp lệ'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phoneControllor,
                  decoration: const InputDecoration(labelText: 'Số điện thoại'),
                  validator: (v) => (v == null || v.length < 10)
                      ? 'Số điện thoại tối thiểu 10 số'
                      : null,
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: _pickDob,
                  child: InputDecorator(
                    decoration: const InputDecoration(labelText: 'Ngày sinh'),
                    child: Text(AppDateFormat.display.format(_dob)),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _gender,
                  decoration: const InputDecoration(labelText: 'Giới tính'),
                  items: AppLabels.gender.entries
                      .map(
                        (e) => DropdownMenuItem(
                          value: e.key,
                          child: Text(e.value),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _gender = v ?? 'MALE'),
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
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Lưu thay đổi'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
