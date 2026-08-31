import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saigon_tour_guide/core/api_client.dart';
import 'package:saigon_tour_guide/core/date_formats.dart';
import 'package:saigon_tour_guide/model/itinerary.dart';
import 'package:saigon_tour_guide/screen/place_detail_screen.dart';

class SharedItineraryScreen extends StatefulWidget {
  final String shareCode;
  const SharedItineraryScreen({super.key, required this.shareCode});
  @override
  State<SharedItineraryScreen> createState() => _SharedItineraryScreenState();
}

class _SharedItineraryScreenState extends State<SharedItineraryScreen> {
  Itinerary? _itinerary;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await context.read<ApiClient>().dio.get(
        '/itineraries/shared/${widget.shareCode}',
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
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null || _itinerary == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Lịch trình chia sẻ')),
        body: Center(
          child: Text(
            _error ?? 'Không tìm thấy lịch trình (mã sai hoặc mã hết hạn)',
          ),
        ),
      );
    }

    final itinerary = _itinerary!;
    final byDay = itinerary.itemsByDay;
    final days = byDay.keys.toList()..sort();
    return Scaffold(
      appBar: AppBar(title: Text(itinerary.title)),
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
                      : const CircleAvatar(child: Icon(Icons.place_outlined)),
                  title: Text(item.place?.name ?? 'Địa điểm đã bị xóa'),
                  subtitle: Text(
                    [
                      if (item.startTime != null) AppDateFormat.hm(item.startTime!),
                      if (item.transportMode != null) item.transportMode!,
                      if (item.note != null) item.note!,
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
                )
              ),
            ),
            const SizedBox(height: 16)
          ],
        ],
      ),
    );
  }
}
