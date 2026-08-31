import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:saigon_tour_guide/core/api_client.dart';
import 'package:saigon_tour_guide/core/date_formats.dart';
import 'package:saigon_tour_guide/model/place_detail.dart';
import 'package:saigon_tour_guide/model/review.dart';
import 'package:saigon_tour_guide/provider/auth_provider.dart';
import 'package:saigon_tour_guide/provider/favorites_provider.dart';
import 'package:saigon_tour_guide/provider/visited_places_provider.dart';
import 'package:saigon_tour_guide/screen/write_review_screen.dart';
import 'package:saigon_tour_guide/widget/review_list_item.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceDetailScreen extends StatefulWidget {
  final int placeId;
  const PlaceDetailScreen({super.key, required this.placeId});

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailState();
}

class _PlaceDetailState extends State<PlaceDetailScreen> {
  static final _currencyFormat = NumberFormat.decimalPattern('vi-VN');

  PlaceDetail? _place;
  bool _loading = true;
  String? _error;

  List<Review>? _reviews;
  bool _reviewsLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPlace();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<FavoritesProvider>().ensureLoaded();
        context.read<VisitedPlacesProvider>().ensureLoaded();
      }
    });
  }

  Future<void> _toggleFavorite(int placeId) async {
    try {
      await context.read<FavoritesProvider>().toggle(placeId);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(getErrorMessage(e))));
      }
    }
  }

  Future<void> _loadPlace() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await context.read<ApiClient>().dio.get(
        '/places/${widget.placeId}',
      );
      if (!mounted) return;
      setState(
        () => _place = PlaceDetail.fromJson(res.data as Map<String, dynamic>),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = getErrorMessage(e));
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _loadReviews() async {
    setState(() => _reviewsLoading = true);
    try {
      final res = await context.read<ApiClient>().dio.get(
        '/reviews/place/${widget.placeId}',
      );
      if (!mounted) return;
      final items = (res.data as List)
          .map((e) => Review.fromJson(e as Map<String, dynamic>))
          .toList();
      setState(() => _reviews = items);
    } catch (_) {
    } finally {
      if (mounted) setState(() => _reviewsLoading = false);
    }
  }

  Future<void> _openMap(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openWriteReview() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => WriteReviewScreen(placeId: widget.placeId),
      ),
    );

    if (result == true) {
      _loadReviews();
    }
  }

  Future<void> _editReview(Review review) async {
    final res = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            WriteReviewScreen(placeId: widget.placeId, existingReview: review),
      ),
    );
    if (res == true) _loadReviews();
  }

  Future<void> _deleteReview(int reviewId) async{
    final confirm = await showDialog<bool>(
      context: context, 
      builder: (_) => AlertDialog(
        title: Text('Xóa đánh giá'),
        content: Text('Bạn không thể hoàn tác sau khi xóa'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context,false), child: Text('Hủy')),
          TextButton(onPressed: () => Navigator.pop(context,true), child: Text('Xóa')),
        ],
      )
    );
    
    if(confirm != true) return;
    if(!mounted) return;

    try{
      await context.read<ApiClient>().dio.delete('/reviews/$reviewId');
      _loadReviews();
    }catch(e){
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getErrorMessage(e))));
      }
    }
  }

  Future<void> _toggleVisited(int placeId, bool currentlyVisited) async {
    try {
      if (currentlyVisited) {
        await context.read<VisitedPlacesProvider>().removeVisited(placeId);
      } else {
        await context.read<VisitedPlacesProvider>().markVisited(placeId);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(getErrorMessage(e))));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null || _place == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(_error ?? 'Không tìm thấy địa điểm')),
      );
    }

    final place = _place!;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 260,
            actions: [
              Consumer<VisitedPlacesProvider>(
                builder: (context, visited, _) => IconButton(
                  tooltip: 'Đánh dấu đã ghé thăm',
                  onPressed: () =>
                      _toggleVisited(place.id, visited.isVisited(place.id)),
                  icon: Icon(
                    visited.isVisited(place.id)
                        ? Icons.check_circle
                        : Icons.check_circle_outline,
                    color: visited.isVisited(place.id)
                        ? Colors.greenAccent
                        : Colors.white,
                  ),
                ),
              ),
              Consumer<FavoritesProvider>(
                builder: (context, favoritres, _) => IconButton(
                  onPressed: () => _toggleFavorite(place.id),
                  icon: Icon(
                    favoritres.isFavorite(place.id)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: favoritres.isFavorite(place.id)
                        ? Colors.redAccent
                        : Colors.white,
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: place.primaryImage != null
                  ? CachedNetworkImage(
                      imageUrl: place.primaryImage!,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                    ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  place.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '${place.averageRating.toStringAsFixed(1)} (${place.totalReviews} đánh giá)',
                    ),
                    const SizedBox(width: 4),
                    Text('${place.totalViews} lượt xem'),
                  ],
                ),
                const SizedBox(height: 16),
                Text(place.description),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.place_outlined),
                  title: Text(place.address),
                  subtitle: Text(place.ward),
                  trailing: TextButton.icon(
                    onPressed: () => _openMap(place.linkGoogleMap),
                    label: const Text('Mở bản đồ'),
                    icon: const Icon(Icons.map_outlined),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.payment_outlined),
                  title: Text(
                    place.priceMin == 0 && place.priceMax == 0
                        ? 'Miễn phí'
                        : '${_currencyFormat.format(place.priceMin)} - ${_currencyFormat.format(place.priceMax)} VND',
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.access_time),
                  title: Text(
                    '${AppDateFormat.hm(place.openingTime)} - ${AppDateFormat.hm(place.closingTime)}',
                  ),
                  subtitle: Text(place.openDays),
                ),
                if (place.categories.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: place.categories
                        .map((c) => Chip(label: Text(c.name)))
                        .toList(),
                  ),
                ],

                if (place.tags.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: place.tags
                        .map(
                          (t) => Chip(
                            label: Text(t.tagName),
                            backgroundColor: Colors.transparent,
                            side: BorderSide(
                              color: Theme.of(
                                context,
                              ).colorScheme.outlineVariant,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
                const Divider(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Đánh giá (${place.totalReviews})',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    TextButton(
                      onPressed: _openWriteReview,
                      child: const Text('Viết đánh giá'),
                    ),
                  ],
                ),

                const SizedBox(height: 8),
                if (_reviews == null)
                  Center(
                    child: _reviewsLoading
                        ? const CircularProgressIndicator()
                        : OutlinedButton(
                            onPressed: _loadReviews,
                            child: const Text('Xem đánh giá'),
                          ),
                  )
                else if (_reviews!.isEmpty)
                  const Text('Chưa có đánh giá nào')
                else
                  ..._reviews!.map((r) {
                    final myUserId = context.read<AuthProvider>().user?.id;
                    final isOwn = r.userId==myUserId;
                    return ReviewListItem(
                      review: r,
                      isOwn: isOwn,
                      onDelete: isOwn?() => _deleteReview(r.id): null,
                      onEdit: isOwn ? () => _editReview(r): null,
                    );
                  }),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
