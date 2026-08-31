import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saigon_tour_guide/core/api_client.dart';
import 'package:saigon_tour_guide/core/app_labels.dart';
import 'package:saigon_tour_guide/core/date_formats.dart';
import 'package:saigon_tour_guide/provider/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  DateTime? _dob;
  String _gender = 'MALE';
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _pickDOB() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: now,
      initialDate: DateTime(now.year - 20, now.month, now.day),
    );

    if (picked != null) {
      setState(() => _dob = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_dob == null) {
      setState(() => _error = 'Vui lòng chọn ngày sinh');
      return;
    }

    if (_passwordController.text != _confirmController.text) {
      setState(() => _error = 'Mật khẩu xác nhận không đúng');
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
    });

    try {
      await context.read<AuthProvider>().register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        dob: AppDateFormat.api.format(_dob!),
        gender: _gender,
        username: _usernameController.text.trim(),
        password: _passwordController.text,
      );
      if (mounted) {
        Navigator.of(context).pop(_usernameController.text.trim());
      }
    } catch (e) {
      if (mounted) setState(() => _error = getErrorMessage(e));
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng ký')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Họ và tên'),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Vui lòng nhập họ tên' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => (v == null || !v.contains('@'))
                      ? 'Email không hợp lệ'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Số điện thoại'),
                  keyboardType: TextInputType.phone,
                  validator: (v) => (v == null || v.length < 10)
                      ? 'Số điện thoại tối thiểu 10 số'
                      : null,
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: _pickDOB,
                  child: InputDecorator(
                    decoration: const InputDecoration(labelText: 'Ngày sinh'),
                    child: Text(
                      _dob == null
                          ? 'Chọn ngày sinh'
                          : AppDateFormat.display.format(_dob!),
                    ),
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
                const SizedBox(height: 12),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Tên đăng nhập'),
                  validator: (v) =>
                      (v == null || v.length < 6) ? 'Tối thiểu 6 ký tự' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Mật khẩu'),
                  obscureText: true,
                  validator: (v) =>
                      (v == null || v.length < 6) ? 'Tối thiểu 6 ký tự' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _confirmController,
                  decoration: const InputDecoration(
                    labelText: 'Xác nhận mật khẩu',
                  ),
                  obscureText: true,
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'Vui lòng xác nhận lại mật khẩu'
                      : null,
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
                      : const Text('Đăng ký'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
