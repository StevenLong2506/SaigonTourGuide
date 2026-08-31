import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saigon_tour_guide/core/api_client.dart';
import 'package:saigon_tour_guide/core/date_formats.dart';
import 'package:saigon_tour_guide/model/itinerary.dart';
import 'package:saigon_tour_guide/screen/place_detail_screen.dart';

class ItineraryDetailScreen extends StatefulWidget {
  final int itineraryId;
  const ItineraryDetailScreen({super.key, required this.itineraryId});
  @override
  State<ItineraryDetailScreen> createState() => _ItineraryDetailScreenState();
}

class _ItineraryDetailScreenState extends State<ItineraryDetailScreen> {
  Itinerary? _itinerary;
  bool _loading = true;
  String? _error;
  bool _sharing = false;
  bool _deleting = false;

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await context.read<ApiClient>().dio.get(
        '/itineraries/${widget.itineraryId}',
      );
      if (!mounted) return;
      setState(
        () => _itinerary = Itinerary.fromJson(res.data as Map<String, dynamic>),
      );
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
    _load();
  }

  Future<void> _share() async {
    setState(() => _sharing = true);
    try {
      final res = await context.read<ApiClient>().dio.post(
        '/itineraries/${widget.itineraryId}/share',
      );
      final code = (res.data as Map<String, dynamic>)['share_code'] as String;
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Mã chia sẽ: $code')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Chia sẻ thất bại! Vui lòng thử lại sau.')),
        );
      }
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  Future<void> _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xóa lịch trình'),
        content: const Text('Bạn không thể hoàn tác sau khi xóa.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirm != true) return;
    if (!mounted) return;

    setState(() => _deleting = true);
    try {
      await context.read<ApiClient>().dio.delete(
        '/itineraries/${widget.itineraryId}',
      );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Xóa thất bại!')));
        setState(() => _deleting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_error != null || _itinerary == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(_error ?? 'Không tìm thấy lịch trình')),
      );
    }

    final itinerary = _itinerary!;
    final byDay = itinerary.itemsByDay;
    final days = byDay.keys.toList()..sort();

    return Scaffold(
      appBar: AppBar(
        title: Text(itinerary.title),
        actions: [
          IconButton(
            onPressed: _sharing ? null : _share,
            icon: _sharing
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(),
                  )
                : const Icon(Icons.share_outlined),
          ),
          IconButton(
            onPressed: _deleting ? null : _delete,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (itinerary.description != null) ...[
            Text(itinerary.description!),
            const SizedBox(height: 16),
          ],
          for (final day in days) ...[
            Text('Ngày $day', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...byDay[day]!.map(
              (item) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: item.place?.primaryImage != null
                      ? CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                            item.place!.primaryImage!,
                          ),
                        )
                      : CircleAvatar(child: Icon(Icons.place_outlined)),
                  title: Text(item.place?.name ?? 'Địa điểm đã bị xóa'),
                  subtitle: Text(
                    [
                      if (item.startTime != null)
                        AppDateFormat.hm(item.startTime!),
                      if (item.transportMode != null) item.transportMode!,
                      if (item.note != null) item.note,
                    ].join(' - '),
                  ),
                  onTap: item.place == null
                      ? null
                      : () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                PlaceDetailScreen(placeId: item.place!.id),
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}
