import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:saigon_tour_guide/core/api_client.dart';
import 'package:saigon_tour_guide/model/itinerary.dart';
import 'package:saigon_tour_guide/screen/generate_itinerary_screen.dart';
import 'package:saigon_tour_guide/screen/itinerary_detail_screen.dart';
import 'package:saigon_tour_guide/screen/shared_itinerary_screen.dart';

class ItineraryListScreen extends StatefulWidget {
  const ItineraryListScreen({super.key});
  @override
  State<ItineraryListScreen> createState() => _ItineraryListScreenState();
}

class _ItineraryListScreenState extends State<ItineraryListScreen> {
  List<Itinerary> _itineraries = [];
  bool _loading = true;
  String? _error;
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await context.read<ApiClient>().dio.get('/itineraries');
      final items = (res.data as List)
          .map((e) => Itinerary.fromJson(e as Map<String, dynamic>))
          .toList();
      if (!mounted) return;
      setState(() => _itineraries = items);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = getErrorMessage(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openGenerate() async {
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const GenerateItineraryScreen()),
    );
    if (created == true) _load();
  }

  Future<void> _openShareCodeDialog() async {
    final controller = TextEditingController();
    final code = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nhập mã chia sẻ'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'VD: aiWfvbF98'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Xem'),
          ),
        ],
      ),
    );

    if (code != null && code.isNotEmpty && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SharedItineraryScreen(shareCode: code),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch trình của tôi'),
        actions: [
          IconButton(
            onPressed: _openShareCodeDialog,
            icon: const Icon(Icons.key_outlined),
            tooltip: 'Nhập mã chia sẻ',
          ),
          IconButton(onPressed: _openGenerate, icon: const Icon(Icons.add)),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!))
          : _itineraries.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.map_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 12),
                  const Text('Chưa có lịch trình nào'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: _openGenerate,
                    child: const Text('Tạo lịch trình mới'),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.separated(
                padding: const EdgeInsets.all(12),
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemCount: _itineraries.length,
                itemBuilder: (context, idx) {
                  final it = _itineraries[idx];
                  return ListTile(
                    leading: const Icon(Icons.map_outlined),
                    title: Text(it.title),
                    subtitle: Text('${it.items.length} địa điểm'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ItineraryDetailScreen(itineraryId: it.id),
                        ),
                      );
                      _load();
                    },
                  );
                },
              ),
            ),
    );
  }
}
