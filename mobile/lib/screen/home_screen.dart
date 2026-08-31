import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saigon_tour_guide/core/api_client.dart';
import 'package:saigon_tour_guide/model/place.dart';
import 'package:saigon_tour_guide/model/place_filter.dart';
import 'package:saigon_tour_guide/screen/place_detail_screen.dart';
import 'package:saigon_tour_guide/widget/place_card.dart';
import 'package:saigon_tour_guide/widget/place_filter_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<PlaceSummary> _places = [];
  bool _loading = true;
  String? _error;
  PlaceFilter _filter = const PlaceFilter();

  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  void _onSearchChanged() {
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _loadPlaces(query: _searchController.text.trim());
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPlaces();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPlaces({String? query}) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final apiClient = context.read<ApiClient>();
      final res = await apiClient.dio.get(
        '/places/search',
        queryParameters: {
          if (query != null && query.isNotEmpty) 'q': query,
          'limit': 20,
          ..._filter.toQueryParams(),
        },
      );
      final data = res.data as Map<String, dynamic>;
      final items = (data['items'] as List)
          .map((e) => PlaceSummary.fromJson(e as Map<String, dynamic>))
          .toList();
      if (!mounted) return;
      setState(() => _places = items);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = getErrorMessage(e);
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _openFilter() async {
    final result = await showPlaceFilterSheet(context, _filter);
    if (result != null) {
      setState(() => _filter = result);
      _loadPlaces(query: _searchController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Tìm địa điểm...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                onPressed: () => _searchController.clear(),
                                icon: const Icon(Icons.clear),
                              )
                            : null,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton.filledTonal(
                        onPressed: _openFilter,
                        icon: const Icon(Icons.tune),
                      ),
                      if (_filter.isActive)
                        Positioned(
                          right: 4,
                          top: 4,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.error,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () =>
                    _loadPlaces(query: _searchController.text.trim()),
                child: _buildBody(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return ListView(
        children: [
          const SizedBox(height: 120),
          Center(child: Text(_error!)),
        ],
      );
    }

    if (_places.isEmpty) {
      final isSearching =
          _searchController.text.trim().isNotEmpty || _filter.isActive;
      return ListView(
        children: [
          SizedBox(height: 120),
          Center(
            child: Text(
              isSearching
                  ? 'Không tìm thấy địa điểm phù hợp'
                  : 'Chưa có địa điểm nào',
            ),
          ),
        ],
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) => PlaceCard(
        place: _places[index],
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PlaceDetailScreen(placeId: _places[index].id),
          ),
        ),
      ),
      itemCount: _places.length,
    );
  }
}
