class PlaceFilter {
  final Set<int> categoryIds;
  final Set<int> tagIds;
  final String? ward;
  final double? priceMin;
  final double? priceMax;
  final double? minRating;
  final bool isFeatured;
  final String sortBy;

  const PlaceFilter({
    this.categoryIds = const {},
    this.tagIds = const {},
    this.ward,
    this.priceMax,
    this.priceMin,
    this.minRating,
    this.isFeatured = false,
    this.sortBy = 'POPULAR',
  });

  bool get isActive =>
      categoryIds.isNotEmpty ||
      tagIds.isNotEmpty ||
      ward != null ||
      priceMin != null ||
      priceMax != null ||
      minRating != null ||
      isFeatured ||
      sortBy != 'POPULAR';

  Map<String, dynamic> toQueryParams(){
    return {
      if (categoryIds.isNotEmpty) 'category_ids': categoryIds.toList(),
      if (tagIds.isNotEmpty) 'tag_ids': tagIds.toList(),
      if (ward != null) 'ward': ward,
      if (priceMin != null) 'price_min': priceMin,
      if (priceMax != null) 'price_max': priceMax,
      if (minRating != null) 'min_rating': minRating,
      if (isFeatured) 'is_featured': true,
      'sort_by': sortBy,
    };
  }
}
