import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:saigon_tour_guide/core/api_client.dart';
import 'package:saigon_tour_guide/core/app_labels.dart';
import 'package:saigon_tour_guide/core/date_formats.dart';
import 'package:saigon_tour_guide/provider/auth_provider.dart';
import 'package:saigon_tour_guide/screen/change_password_screen.dart';
import 'package:saigon_tour_guide/screen/edit_profile_screen.dart';
import 'package:saigon_tour_guide/screen/itinerary_list_screen.dart';
import 'package:saigon_tour_guide/screen/onboarding_screen.dart';
import 'package:saigon_tour_guide/screen/travel_profile_screen.dart';
import 'package:saigon_tour_guide/screen/visited_place_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _uploadingAvatar = false;

  Future<void> _pickAndUploadAvatar() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked == null) return;
    if(!mounted) return;
    setState(() => _uploadingAvatar = true);
    try {
      await context.read<AuthProvider>().uploadAvatar(picked.path);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(getErrorMessage(e))));
      }
    } finally {
      if (mounted) {
        setState(() => _uploadingAvatar = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    return Scaffold(
      appBar: AppBar(title: const Text('Hồ sơ')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: user?.avatar != null
                      ? CachedNetworkImageProvider(user!.avatar!)
                      : null,
                  child: user?.avatar == null
                      ? const Icon(Icons.person, size: 40)
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: _uploadingAvatar ? null : _pickAndUploadAvatar,
                    borderRadius: BorderRadius.circular(16),
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: _uploadingAvatar
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(
                              Icons.camera_alt,
                              size: 14,
                              color: Colors.white,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              user?.name ?? '',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Center(
            child: Text(
              '@${user?.username ?? ''}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text('Email'),
            subtitle: Text(user?.email ?? ''),
          ),
          ListTile(
            leading: const Icon(Icons.phone_outlined),
            title: const Text('Số điện thoại'),
            subtitle: Text(user?.phone ?? ''),
          ),
          ListTile(
            leading: const Icon(Icons.cake_outlined),
            title: const Text('Ngày sinh'),
            subtitle: Text(user != null ? AppDateFormat.display.format(user.dob) : ''),
          ),
          ListTile(
            leading: const Icon(Icons.wc_outlined),
            title: const Text('Giới tính'),
            subtitle: Text(user != null ? AppLabels.gender[user.gender] ?? 'Khác' : ''),
          ),
          ListTile(
            leading: const Icon(Icons.event_available_outlined),
            title: const Text('Ngày đăng ký'),
            subtitle: Text(
              user != null ? AppDateFormat.display.format(user.createdAt) : '',
            ),
          ),
          ListTile(
            leading: const Icon(Icons.card_travel_outlined),
            title: const Text('Hồ sơ du lịch'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TravelProfileScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.map_outlined),
            title: const Text('Lịch trình của tôi'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ItineraryListScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: const Text('Chỉnh sửa hồ sơ'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EditProfileScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.check_circle_outline),
            title: const Text('Đã ghé thăm'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const VisitedPlaceScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.favorite_outline),
            title: const Text('Sở thích của tôi'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OnboardingScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Đổi mật khẩu'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
            ),
          ),
          const Divider(),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => context.read<AuthProvider>().logout(),
            icon: const Icon(Icons.logout),
            label: const Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }
}
