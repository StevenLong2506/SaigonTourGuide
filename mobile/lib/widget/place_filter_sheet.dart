
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saigon_tour_guide/core/api_client.dart';
import 'package:saigon_tour_guide/core/app_labels.dart';
import 'package:saigon_tour_guide/model/category.dart';
import 'package:saigon_tour_guide/model/interest_tag.dart';
import 'package:saigon_tour_guide/model/place_filter.dart';

Future<PlaceFilter?> showPlaceFilterSheet(
  BuildContext context,
  PlaceFilter current,
) {
  return showModalBottomSheet<PlaceFilter>(
    context: context,
    builder: (_) => PlaceFilterSheet(initial: current),
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
  );
}

class PlaceFilterSheet extends StatefulWidget {
  final PlaceFilter initial;
  const PlaceFilterSheet({super.key, required this.initial});

  @override
  State<PlaceFilterSheet> createState() => _PlaceFilterSheetState();
}

class _PlaceFilterSheetState extends State<PlaceFilterSheet> {
  List<Category> _cates = [];
  List<InterestTag> _tags = [];
  List<String> _wards = [];
  bool _loading = true;

  late Set<int> _cateIds;
  late Set<int> _tagIds;
  String? _ward;
  final _priceMinController = TextEditingController();
  final _priceMaxController = TextEditingController();
  late double? _minRating;
  late bool _isFeatured;
  late String _sortBy;

  @override
  void initState() {
    super.initState();
    _cateIds = Set.of(widget.initial.categoryIds);
    _tagIds = Set.of(widget.initial.tagIds);
    _ward = widget.initial.ward;
    _minRating = widget.initial.minRating;
    _isFeatured = widget.initial.isFeatured;
    _sortBy = widget.initial.sortBy;
    if (widget.initial.priceMin != null) {
      _priceMinController.text = widget.initial.priceMin!.toStringAsFixed(0);
    }
    if (widget.initial.priceMax != null) {
      _priceMaxController.text = widget.initial.priceMax!.toStringAsFixed(0);
    }
    _loadOptions();
  }

  @override
  void dispose() {
    _priceMaxController.dispose();
    _priceMinController.dispose();
    super.dispose();
  }

  Future<void> _loadOptions() async {
    try {
      final apiClient = context.read<ApiClient>();
      final res = await Future.wait([
        apiClient.dio.get('/categories/', queryParameters: {'limit': 100}),
        apiClient.dio.get('/tags/', queryParameters: {'limit': 100}),
        apiClient.dio.get('/places/wards'),
      ]);
      final cates = (res[0].data as List)
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList();
      final tags = (res[1].data as List)
          .map((e) => InterestTag.fromJson(e as Map<String, dynamic>))
          .toList();
      final wards = (res[2].data as List)
          .map((e) => (e as Map<String, dynamic>)['ward'] as String)
          .toList();
      if (!mounted) return;
      setState(() {
        _cates = cates;
        _tags = tags;
        _wards = wards;
      });
    } catch (_) {
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _reset() {
    setState(() {
      _cateIds = {};
      _tagIds = {};
      _ward = null;
      _priceMinController.clear();
      _priceMaxController.clear();
      _minRating = null;
      _isFeatured = false;
      _sortBy = 'POPULAR';
    });
  }

  void _apply() {
    Navigator.pop(
      context,
      PlaceFilter(
        categoryIds: _cateIds,
        tagIds: _tagIds,
        ward: _ward,
        priceMin: double.tryParse(_priceMinController.text),
        priceMax: double.tryParse(_priceMaxController.text),
        minRating: _minRating,
        isFeatured: _isFeatured,
        sortBy: _sortBy,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    controller: scrollController,
                    children: [
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Bộ lọc',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          TextButton(
                            onPressed: _reset,
                            child: const Text('Đặt lại'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      Text(
                        'Sắp xếp',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: AppLabels.placeSortBy.entries.map((e) {
                          return ChoiceChip(
                            label: Text(e.value),
                            selected: _sortBy == e.key,
                            onSelected: (_) => setState(() => _sortBy = e.key),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      if (_cates.isNotEmpty) ...[
                        Text(
                          'Danh mục',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _cates.map((c) {
                            final selected = _cateIds.contains(c.id);
                            return FilterChip(
                              label: Text('${c.name} (${c.placeCount})'), 
                              selected: selected,
                              onSelected: (v) => setState(() {
                                if(v) {
                                  _cateIds.add(c.id);
                                }
                                else{
                                  _cateIds.remove(c.id);
                                }
                              }),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                      ],
                      if(_tags.isNotEmpty)...[
                        Text('Sở thích', style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _tags.map((t) {
                            final selected = _tagIds.contains(t.id);
                            return FilterChip(
                              label: Text(t.name), 
                              selected: selected,
                              onSelected: (v) => setState(() {
                                if(v){
                                  _tagIds.add(t.id);
                                }
                                else{
                                  _tagIds.remove(t.id);
                                }
                              }),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20)
                      ],

                      if(_wards.isNotEmpty)...[
                        Text('Phường/Xã', style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          initialValue: _ward,
                          decoration: const InputDecoration(hintText: 'Tất cả'),
                          items: [
                            const DropdownMenuItem(value: null, child: Text('Tất cả')),
                            ..._wards.map((w) => DropdownMenuItem(value: w, child: Text(w)))
                          ],
                          onChanged: (v) => setState(() => _ward=v),
                        ),
                        const SizedBox(height: 20),
                      ],

                      Text('Khoảng giá (VND)', style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _priceMinController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(hintText: 'Từ'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _priceMaxController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(hintText: 'Đến'),
                            )
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      Text(
                        'Đánh giá tối thiểu: ${_minRating == null ? 'Tất cả' : '* ${_minRating!.toStringAsFixed(1)}'}',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Slider(
                        value: _minRating??0, 
                        min: 0,
                        max: 5,
                        divisions: 10,
                        label: _minRating == null ? 'Tất cả' : _minRating!.toStringAsFixed(1),
                        onChanged: (v) => setState(() => _minRating=v==0?null:v)
                      ),

                      const SizedBox(height: 8),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Chỉ hiện địa điểm nổi bật'),
                        value: _isFeatured, 
                        onChanged: (v) => setState(() => _isFeatured=v)
                      ),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: _apply, 
                        child: const Text('Áp dụng')
                      ),
                      const SizedBox(height: 24)
                    ],
                  ),
          ),
        );
      },
    );
  }
}
